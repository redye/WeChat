//
//  WCAddContactViewController.m
//  WeChat
//
//  Created by hu on 15/12/8.
//  Copyright © 2015年 redye. All rights reserved.
//

#import "WCAddContactViewController.h"
#import "UITextField+WF.h"

@interface WCAddContactViewController ()<UITextFieldDelegate>

@end

@implementation WCAddContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //添加好友
    NSString *user = textField.text;
    NSLog(@"好友账号 %@", user);
    if (![textField isTelphoneNum]) {
        [self showMessage:@"请输入正确的手机号" handler:nil];
        return YES;
    }
    
    if ([textField.text isEqualToString:[WCUser sharedWCUser].name]) {
        [self showMessage:@"不能添加自己为好友" handler:nil];
        return YES;
    }
    
    //判断好友是否存在
    NSString *jidStr = [NSString stringWithFormat:@"%@@%@", user, kDomain];
    XMPPJID *friendJID = [XMPPJID jidWithString:jidStr];
    if ([[WCXMPPTool sharedWCXMPPTool].rosterStorage userExistsWithJID:friendJID xmppStream:[WCXMPPTool sharedWCXMPPTool].xmppStream]) {
        [self showMessage:@"当前好友已经存在" handler:nil];
        return YES;
    }
    
    //发送好友添加的请求
    
    [[WCXMPPTool sharedWCXMPPTool].roster subscribePresenceToUser:friendJID];
    
    return YES;
}

- (void)showMessage:(NSString *)message handler:(void (^ __nullable)(UIAlertAction *action))handler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:handler];
    [alertController addAction:alertAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
