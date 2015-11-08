//
//  WCLoginViewController.m
//  WeChat
//
//  Created by hu on 15/11/8.
//  Copyright © 2015年 redye. All rights reserved.
//

#import "WCLoginViewController.h"

@interface WCLoginViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *avtarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;


@end

@implementation WCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置用户名为上次登录的用户名
    self.userLabel.text = [WCUser sharedWCUser].name;
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
