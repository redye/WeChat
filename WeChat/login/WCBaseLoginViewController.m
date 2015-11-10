//
//  WCBaseLoginViewController.m
//  WeChat
//
//  Created by hu on 15/11/8.
//  Copyright © 2015年 redye. All rights reserved.
//

#import "WCBaseLoginViewController.h"
#import "AppDelegate.h"

@interface WCBaseLoginViewController ()

@end

@implementation WCBaseLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)login
{
    //登录之前提示：正在登录
    [MBProgressHUD showMessage:@"正在登录中..." toView:self.view];  //加上 toView, 否则是将 其添加到 window 上，window 上是没有方向之分的，而 试图控制器是有方向的，所以要加上 toView
    [WCXMPPTool sharedWCXMPPTool].registerOperation = NO;
    
    __weak typeof(self) safeSelf = self;
    [[WCXMPPTool sharedWCXMPPTool] xmppUserLogin:^(XMPPResultType type) {
        [safeSelf handleResultType:type];  //这里会将 self 的引用计数 加1
    }];
}

- (void)handleResultType:(XMPPResultType)type
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //登录结果知道后，隐藏提示信息
        [MBProgressHUD hideHUDForView:self.view];
        switch (type) {
            case XMPPResultTypeLoginSuccess:  //登录成功
                NSLog(@"登录成功");
                [self enterMainPage];
                break;
                
            case XMPPResultTypeLoginFailure:  //登录失败
                NSLog(@"登录失败");
                [MBProgressHUD showError:@"用户名或密码不正确" toView:self.view];
                break;
                
            case XMPPResultTypeNetError:
                NSLog(@"网络超时");
                [MBProgressHUD showError:@"网络不给力" toView:self.view];
                break;
                
            default:
                break;
        }
    });
}

- (void)enterMainPage
{
    //更新用户的登录状态为 YES
    [WCUser sharedWCUser].loginStatus = YES;
    
    //把用户登录成功的数据保存到沙河
    [[WCUser sharedWCUser] saveUserToSandbox];
    
    //隐藏模态窗口，因为登录界面是以模态方式弹出，引用计数也会加1
    [self dismissViewControllerAnimated:NO completion:nil];
    
    //登录成功来到主界面
    //代理方法在子线程调用，所以要到主线程舒心UI
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.window.rootViewController = storyboard.instantiateInitialViewController;
}

@end
