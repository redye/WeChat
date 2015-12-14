//
//  AppDelegate.m
//  WeChat
//
//  Created by hu on 15/11/4.
//  Copyright © 2015年 redye. All rights reserved.
//

#import "AppDelegate.h"
#import "XMPPFramework.h"
#import "WCNavigationController.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "DDASLLogger.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"%@", path);
    
    //打开XMPP的日志
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    //设置导航栏背景
    [WCNavigationController setupNavigationTheme];
    
    //从沙盒里加载用户的数据到单例
    [[WCUser sharedWCUser] loadUserFromSandbox];
    
    //判断用户的登录状态， YES直接来到主界面
    if ([WCUser sharedWCUser].loginStatus) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.window.rootViewController = storyboard.instantiateInitialViewController;
        
        //自动登录服务
#warning 一般情况写都不会马上连接，会稍微等等
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[WCXMPPTool sharedWCXMPPTool] xmppUserLogin:nil];
        });
        
    }
    
    //注册应用接收通知
    // 在 iOS8 以后需要注册本地通知
    // 在 iOS8 以前（不包括 iOS8），socket 是不支持后台运行的，当程序推到后台后，被挂起，接收不到本地通知
    // 在 iOS7 要做配置 info.plist 文件，添加 VOIP，是得 socket 在后台运行， 同时设置 socket 支持后台运行， 即  _xmppStream.enableBackgroundingOnSocket = YES;
    // iOS7 以前在模拟器上不支持后台运行
    
    //当用户将程序 kill 掉得时候，想要收到发送的信息，需要远程通知
    if ([[UIDevice currentDevice].systemVersion floatValue] > 8.0) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
    return YES;
}

#pragma mark - 远程通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
