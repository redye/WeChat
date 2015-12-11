//
//  WCHistoryViewController.m
//  WeChat
//
//  Created by hu on 15/12/11.
//  Copyright © 2015年 redye. All rights reserved.
//

#import "WCHistoryViewController.h"

@interface WCHistoryViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@end

@implementation WCHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //监听登录状态的通知
    [self addObservers];
}

- (void)addObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatusChanged:) name:kWCLoginStatusDidChangedNotification object:nil];
}

#pragma mark - 登录状态
- (void)loginStatusChanged:(NSNotification *)notification
{
    NSLog(@"登录状态 %@", notification.userInfo);
    
    //获取登录状态
    XMPPResultType status = [notification.userInfo[kWCLoginStatusKey] integerValue];
    switch (status) {
        case XMPPResultTypeConnecting:
            NSLog(@"正在连接");
            [self startAnimation];
            break;
            
        case XMPPResultTypeLoginSuccess:
            NSLog(@"登录成功");
            [self stopAnimating];
            break;
            
        case XMPPResultTypeLoginFailure:
            NSLog(@"登录失败");
            [self stopAnimating];
            break;
            
        case XMPPResultTypeNetError:
            NSLog(@"连接失败");
            [self stopAnimating];
            break;
            
        default:
            break;
    }
}

- (void)stopAnimating
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.indicatorView stopAnimating];
        self.indicatorView.hidden = YES;
    });
}

- (void)startAnimation
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.indicatorView startAnimating];
        self.indicatorView.hidden = NO;
    });
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
