//
//  WCNavigationController.m
//  WeChat
//
//  Created by hu on 15/11/8.
//  Copyright © 2015年 redye. All rights reserved.
//

#import "WCNavigationController.h"

@interface WCNavigationController ()

@end

@implementation WCNavigationController

+ (void)initialize
{
    [self setupNavigationTheme];
}

+ (void)setupNavigationTheme
{
    //设置导航条样式
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    
    //设置导航条的背景
    //设置背景图片时，高度不会自动拉伸，但宽度会帮我们自动拉伸
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"topbarbg_ios7"] forBarMetrics:UIBarMetricsDefault];
    
    //设置导航条的字体
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:20.0]}];
    
    //设置状态栏颜色
    //xcode5 以上，创建的项目，默认的话，状态栏的样式由控制器决定
    //在 plist 文件里设置，状态栏字体就会变成我们设置的颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

}

//结果：如果控制器是由导航控制器管理的，设置状态栏的样式时，要在导航控制器里设置
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
