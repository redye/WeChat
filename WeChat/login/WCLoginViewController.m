//
//  WCLoginViewController.m
//  WeChat
//
//  Created by hu on 15/11/8.
//  Copyright © 2015年 redye. All rights reserved.
//

#import "WCLoginViewController.h"
#import "WCRegisterViewController.h"
#import "WCNavigationController.h"

@interface WCLoginViewController ()<WCRegisterViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *avtarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;


@end

@implementation WCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置 textField 的样式
    self.passwordField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    [self.passwordField addLeftViewWithImage:@"Card_Lock"];
    
    //设置 登录按钮的样式
    [self.loginButton setResizeN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];
    
    //设置用户名为上次登录的用户名
    self.userLabel.text = [WCUser sharedWCUser].name;
}

- (IBAction)loginButtonClick:(id)sender {
    //保存数据到单例
    [WCUser sharedWCUser].name = self.userLabel.text;
    [WCUser sharedWCUser].password = self.passwordField.text;
    
    //调用父类的登录
    [super login];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //获取注册控制器
    id destinationViewController = [segue destinationViewController];
    if ([destinationViewController isKindOfClass:[WCNavigationController class]]) {
        WCNavigationController *navigation = (WCNavigationController *)destinationViewController;
        if ([navigation.topViewController isKindOfClass:[WCRegisterViewController class]]) {
            WCRegisterViewController *registerViewController = (WCRegisterViewController *)[((WCNavigationController *)destinationViewController) topViewController];
            //设置注册控制的代理
            registerViewController.delegate = self;
        }
    }
}

#pragma mark - WCRegisterViewControllerDelegate
- (void)registerViewControllerDidSuccessRegister:(WCRegisterViewController *)registerViewController
{
    //成功注册后，用户名更新为新注册的用户民
    [WCUser sharedWCUser].name = [WCUser sharedWCUser].registerName;
    self.userLabel.text = [WCUser sharedWCUser].name;
    [registerViewController dismissViewControllerAnimated:YES completion:nil];
    
    //给个提示，输入密码登录
    [MBProgressHUD showSuccess:@"请重新输入密码登录" toView:self.view];
}


@end
