//
//  WCOtherLoginViewController.m
//  WeChat
//
//  Created by hu on 15/11/6.
//  Copyright © 2015年 redye. All rights reserved.
//

#import "WCOtherLoginViewController.h"
#import "AppDelegate.h"

@interface WCOtherLoginViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightContraint;
@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *passwordFeild;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;


@end

@implementation WCOtherLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //判断当前设备的类型，改变左右两边约束的距离
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        self.leftContraint.constant = 28.0;
        self.rightContraint.constant = 28.0;
    }
    
    //设置 textField 的背景图片
    self.userField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    self.passwordFeild.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    [self.loginButton setBackgroundImage:[UIImage stretchedImageWithName:@"fts_green_btn"] forState:UIControlStateNormal];
    [self.loginButton setBackgroundImage:[UIImage stretchedImageWithName:@"fts_green_btn_HL"] forState:UIControlStateHighlighted];
}

- (IBAction)loginButtonClick:(UIButton *)sender {
    
    NSString *userName = self.userField.text;
    NSString *password = self.passwordFeild.text;
    
//    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"user"];
//    [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    WCUser *user = [WCUser sharedWCUser];
    user.name = userName;
    user.password = password;
    
    //登录之前提示：正在登录
    [MBProgressHUD showMessage:@"正在登录中..." toView:self.view];  //加上 toView, 否则是将 其添加到 window 上，window 上是没有方向之分的，而 试图控制器是有方向的，所以要加上 toView
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    __weak typeof(self) safeSelf = self;
    [app xmppUserLogin:^(XMPPResultType type) {
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
        }
    });
}

- (void)enterMainPage
{
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

- (IBAction)cancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc
{
    NSLog(@"登录界面释放 %s", __FUNCTION__);  //存在内存泄露问题
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
