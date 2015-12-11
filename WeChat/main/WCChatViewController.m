
//
//  WCChatViewController.m
//  WeChat
//
//  Created by hu on 15/12/9.
//  Copyright © 2015年 redye. All rights reserved.
//

#import "WCChatViewController.h"
#import "WCInputView.h"

@interface WCChatViewController ()<UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    NSFetchedResultsController *_resultController;
}

@property (nonatomic, strong) NSLayoutConstraint *inputViewBottomContraints;
@property (nonatomic, strong) NSLayoutConstraint *inputViewHeightContraints;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation WCChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
    [self addObservers];
    
    [self loadMessage];
}

- (void)setUI
{
    //代码方式实现自动布局 VFL
    //创建一个 tableView 显示数据
    _tableView = [[UITableView alloc] init];
    //代码实现自动约束，要设置自动布局属性为NO
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    //创建输入框
    WCInputView *inputView = [WCInputView inputView];
    inputView.translatesAutoresizingMaskIntoConstraints = NO;
    inputView.textView.delegate = self;
    [inputView.addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:inputView];
    
    //自动布局
    //水平方向
    NSDictionary *views = @{@"tableView":_tableView,
                            @"inputView":inputView};
    NSArray *tableViewHContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:tableViewHContraints];
    
    NSArray *inputViewHContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[inputView]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:inputViewHContraints];
    
    //垂直方向
    NSArray *vContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[tableView]-0-[inputView(50)]-0-|" options:0 metrics:nil views:views];
    self.inputViewBottomContraints = [vContraints lastObject];
    self.inputViewHeightContraints = vContraints[2];
    [self.view addConstraints:vContraints];
    NSLog(@"%@", vContraints);
}

- (void)addButtonClick:(UIButton *)button
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
//    imagePickerController.allowsEditing = YES;
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSLog(@"选择了图片");
    //获取图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    //
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    //获取数据列表的 contentSize
    CGSize contentSize = textView.contentSize;
    NSLog(@"数据列表的高度 %f", contentSize.height);
    if (contentSize.height > 33 && contentSize.height < 68) {
        self.inputViewHeightContraints.constant = contentSize.height;
    }
    
    NSLog(@"%@", textView.text);
    NSString *text = textView.text;
    //换行就等于点击了发送按钮
    if ([text rangeOfString:@"\n"].length != 0) {
        NSLog(@"发送数据");
        textView.text = nil;
        //取出换行字符
        text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [self sendMessageWithText:text];
        self.inputViewHeightContraints.constant = 50;
    } else {
        NSLog(@"%@", text);
    }
}

- (void)sendMessageWithText:(NSString *)text
{
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:self.friendJID];
    
    //添加内容
    [message addBody:text];
    
    [[WCXMPPTool sharedWCXMPPTool].xmppStream sendElement:message];
}

- (void)addObservers
{
    //监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSTimeInterval timeInterval = [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    NSValue *value = userInfo[@"UIKeyboardFrameEndUserInfoKey"];
    CGRect rect = CGRectZero;
    [value getValue:&rect];
    
    CGFloat keyboardHeight = rect.size.height;
    //如果是 iOS7 一下的，但横屏时，键盘的高度是 size.width
    if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0 && UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        keyboardHeight = rect.size.width;
    }
    [UIView animateWithDuration:timeInterval animations:^{
        self.inputViewBottomContraints.constant = keyboardHeight;
    } completion:^(BOOL finished) {
        [self tableViewScrollToBottom];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.inputViewBottomContraints.constant = 0;
    [self tableViewScrollToBottom];
}


- (void)keyboardFrameWillChange:(NSNotification *)notification
{
    NSLog(@"%@", notification.userInfo);
    NSInteger direction = 1;
    if ([notification.name isEqualToString:UIKeyboardWillHideNotification]) {
        direction = -1;
    }
    
    NSDictionary *userInfo = notification.userInfo;
    NSTimeInterval timeInterval = [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    NSValue *value = userInfo[@"UIKeyboardFrameEndUserInfoKey"];
    CGRect rect = CGRectZero;
    [value getValue:&rect];
    CGFloat y = rect.origin.y;
    [UIView animateWithDuration:timeInterval animations:^{
        self.inputViewBottomContraints.constant = [UIScreen mainScreen].bounds.size.height - y;
    }];
}

- (void)loadMessage
{
    //上下文
    NSManagedObjectContext *context = [WCXMPPTool sharedWCXMPPTool].messageStorage.mainThreadManagedObjectContext;
    
    //请求对象
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    
    //过滤、排序
    //当前登录用户的JID
    //好友的就ID
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@ and bareJidStr = %@", [WCUser sharedWCUser].jid, self.friendJID.bare];
    request.predicate =predicate;
    
    //按时间的升序
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    request.sortDescriptors = @[sortDescriptor];
    
    //查询
    _resultController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    _resultController.delegate = self;
    NSError *error = nil;
    [_resultController performFetch:&error];
    if (error) {
        NSLog(@"请求聊天信息出错 %@", error);
    }
    
    [self tableViewScrollToBottom];
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    [self.tableView reloadData];
    [self tableViewScrollToBottom];
}

#pragma mark 数据表滚动到底部
- (void)tableViewScrollToBottom
{
    NSInteger bottomRow = _resultController.fetchedObjects.count-1;
    if (bottomRow < 0) {
        return;
    }
    NSIndexPath *bottomIndexPath = [NSIndexPath indexPathForRow:bottomRow inSection:0];
    [self.tableView scrollToRowAtIndexPath:bottomIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _resultController.fetchedObjects.count;
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kCell = @"ChatCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCell];
    }
    
    //获取聊天消息对象
    XMPPMessageArchiving_Message_CoreDataObject *message = _resultController.fetchedObjects[indexPath.row];
    if ([message.outgoing boolValue]) {
        cell.textLabel.text = [NSString stringWithFormat:@"Me: %@", message.body];
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"Other: %@", message.body];
    }
    
    return cell;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
