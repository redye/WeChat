//
//  WCRegisterViewController.m
//  WeChat
//
//  Created by hu on 15/11/8.
//  Copyright © 2015年 redye. All rights reserved.
//

#import "WCRegisterViewController.h"
#import "AppDelegate.h"

/*
    注册的流程
 */

@interface WCRegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightContraint;

@end

@implementation WCRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //判断当前设备的类型，改变左右两边约束的距离
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        self.leftContraint.constant = 28.0;
        self.rightContraint.constant = 28.0;
    }
    
    self.userField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    self.passwordField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    [self.registerButton setResizeN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];
}

- (IBAction)cancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)registerButtonClick:(id)sender {
    //将用户数据保存到单例
    [WCUser sharedWCUser].registerName = self.userField.text;
    [WCUser sharedWCUser].registerPassword = self.passwordField.text;
    
    //调用 appDelegate 用户注册的方法
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.registerOperation = YES;
    [app xmppUserRegister:^(XMPPResultType type) {
        
    }];
}

@end
