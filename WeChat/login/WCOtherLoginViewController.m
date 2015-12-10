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
    
    //直接调用父类的方法
    [super login];
    
}
- (IBAction)cancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc
{
    NSLog(@"登录界面释放 %s", __FUNCTION__);  //存在内存泄露问题
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
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
