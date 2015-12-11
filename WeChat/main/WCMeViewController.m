//
//  WCMeViewController.m
//  WeChat
//
//  Created by hu on 15/11/8.
//  Copyright © 2015年 redye. All rights reserved.
//

#import "WCMeViewController.h"
#import "AppDelegate.h"
#import "XMPPvCardTemp.h"
#import "WCProfileViewController.h"

@interface WCMeViewController ()<WCProfileViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *avtarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *weChatNumberLabel;

@end

@implementation WCMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    //显示当前用户个人信息
    // 1.上下文
    
    //2. fetchRequest
    
    //3.设置过滤和排序
    
    //4.执行请求获取数据
    
    XMPPvCardTemp *myVCardTemp = [WCXMPPTool sharedWCXMPPTool].vCard.myvCardTemp;
    
    //设置头像
    if (myVCardTemp.photo) {
        self.avtarImageView.image = [UIImage imageWithData:myVCardTemp.photo];
    }
    
    //设置昵称
    self.nickNameLabel.text = myVCardTemp.nickname;
    
    //设置微信号
    NSString *user = [WCUser sharedWCUser].name;
    self.weChatNumberLabel.text = [NSString stringWithFormat:@"微信号:%@", user];
    
}

//注销登录
- (IBAction)logout:(UIButton *)sender {
    [[WCXMPPTool sharedWCXMPPTool] xmppUserlogout];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    id destionationViewController = segue.destinationViewController;
    if ([destionationViewController isKindOfClass:[WCProfileViewController class]]) {
        WCProfileViewController *profileViewController = destionationViewController;
        profileViewController.delegate = self;
    }
}

#pragma mark - WCProfileViewControllerDelegate
- (void)profileViewController:(WCProfileViewController *)profileViewController didChangeHeaderImage:(UIImage *)headerImage
{
    self.avtarImageView.image = headerImage;
}


@end
