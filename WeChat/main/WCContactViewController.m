//
//  WCContactViewControllerTableViewController.m
//  WeChat
//
//  Created by hu on 15/12/8.
//  Copyright © 2015年 redye. All rights reserved.
//

#import "WCContactViewController.h"

@interface WCContactViewController ()<NSFetchedResultsControllerDelegate>
{
    NSFetchedResultsController *_resultsController;
}

//@property (nonatomic, strong) NSArray *friendsArray;

@end

@implementation WCContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadFriends];
}

- (void)loadFriends
{
    //使用 CoreData 获取数据
    //1.上下文[关联到数据库 XMPPRoster.sqlite]
    NSManagedObjectContext *context = [WCXMPPTool sharedWCXMPPTool].rosterStorage.mainThreadManagedObjectContext;
    
    //2.fetchRequest 【查那张表】
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
    
    //3.设置过滤条件和排序
    //过滤当前登录用户的好友
    NSString *jid = [WCUser sharedWCUser].jid;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@", jid];
    request.predicate = predicate;
    
    //排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    request.sortDescriptors = @[sort];
    
    //4.执行请求获取数据
//    self.friendsArray = [context executeFetchRequest:request error:nil];
//    NSLog(@"好友 %@", self.friendsArray);
    
    _resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    _resultsController.delegate = self;
    NSError *error = nil;
    [_resultsController performFetch:&error];
    if (error) {
        NSLog(@"查询结果错误 %@", error);
    }
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    NSLog(@"数据发生改变");
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_resultsController.fetchedObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kCell = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCell forIndexPath:indexPath];
    
    XMPPUserCoreDataStorageObject *friend = _resultsController.fetchedObjects[indexPath.row];
    cell.textLabel.text = friend.jidStr;
    switch ([friend.sectionNum intValue]) {
        case 0:
            cell.detailTextLabel.text = @"在线";
            break;
            
        case 1:
            cell.detailTextLabel.text = @"离开";
            break;
            
        case 2:
            cell.detailTextLabel.text = @"离线";
            break;
            
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"删除好友");
        XMPPUserCoreDataStorageObject *friend = _resultsController.fetchedObjects[indexPath.row];
        XMPPJID *friendJID = friend.jid;
        [[WCXMPPTool sharedWCXMPPTool].roster removeUser:friendJID];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //选中表格进入聊天界面
    [self performSegueWithIdentifier:@"ChatSegue" sender:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
