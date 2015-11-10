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

//文本内容发生变化时调用
- (IBAction)textChange {
    WCLog(@"%@", self.userField.text);
    
    //设置注册按钮的可用状态
    BOOL enable = self.userField.text.length != 0 && self.passwordField.text.length != 0;
    self.registerButton.enabled = enable;
    
}


- (IBAction)registerButtonClick:(id)sender {
    //判断用户输入的是否为手机号码
    if (![self.userField isTelphoneNum]) {
        [MBProgressHUD showError:@"请输入正确的手机号码" toView:self.view];
        return;
    }
    [self.view endEditing:YES];
    //将用户数据保存到单例
    [WCUser sharedWCUser].registerName = self.userField.text;
    [WCUser sharedWCUser].registerPassword = self.passwordField.text;
    
    //调用 appDelegate 用户注册的方法
    [WCXMPPTool sharedWCXMPPTool].registerOperation = YES;
    
    [MBProgressHUD showMessage:@"正在注册中..." toView:self.view];
    __weak typeof(self) safeSelf = self;
    [[WCXMPPTool sharedWCXMPPTool] xmppUserRegister:^(XMPPResultType type) {
        [safeSelf handleResultType:type];
    }];
}

/**
 *  处理注册的结果
 *
 *  @param type 注册的结果
 */
- (void)handleResultType:(XMPPResultType)type
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view];
        switch (type) {
            case XMPPResultTypeRegisterSuccess:
            {
                //注册成功，回到上个控制器
                [MBProgressHUD showError:@"注册成功" toView:self.view];
                if (self.delegate && [self.delegate respondsToSelector:@selector(registerViewControllerDidSuccessRegister:)]) {
                    [self.delegate registerViewControllerDidSuccessRegister:self];
                }
            }
                break;
                
            case XMPPResultTypeRegisterFailre:
                [MBProgressHUD showError:@"注册失败，用户名重复" toView:self.view];
                break;
                
            case XMPPResultTypeNetError:
                [MBProgressHUD showError:@"网络不给力" toView:self.view];
                break;
                
            default:
                break;
        }
    });
}

@end
