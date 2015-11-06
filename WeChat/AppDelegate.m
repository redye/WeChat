//
//  AppDelegate.m
//  WeChat
//
//  Created by hu on 15/11/4.
//  Copyright © 2015年 redye. All rights reserved.
//

#import "AppDelegate.h"
#import "XMPPFramework.h"

@interface AppDelegate ()<XMPPStreamDelegate>
{
    XMPPStream *_xmppStream;
    XMPPResultBlock _resultBlock;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [self connectToHost];
    
    return YES;
}

#pragma mark 初始化 XMPPStream
- (void)setupStream
{
    if (!_xmppStream) {
        _xmppStream = [[XMPPStream alloc] init];
        [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    }
}

#pragma mark 连接服务器
- (void)connectToHost
{
    WCLog(@"连接到服务器");
    if (!_xmppStream) {
        [self setupStream];
    }
    
    //设置登录用户 JID
    
    //从沙盒中获取用户名
    NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    XMPPJID *JID = [XMPPJID jidWithUser:user domain:@"xiaomu.local" resource:@"iPhone"];
    _xmppStream.myJID = JID;
    
    //设置服务器域名
    _xmppStream.hostName = @"xiaomu.local";
    
    //设置端口，如果服务器端口是 5222，可以省略
    _xmppStream.hostPort = 5222;
    
    //连接
    NSError *error = nil;
    if (![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]) {
        WCLog(@"连接错误 %@", error);
    }
}

#pragma mark 连接服务器成功后，发送密码授权
- (void)sendPasswordToHost
{
    WCLog(@"发送密码授权");
    NSError *error = nil;
    
    //从沙盒中获取密码
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    
    [_xmppStream authenticateWithPassword:password error:&error];
    if (error) {
        WCLog(@"授权失败 %@", error);
    }
}

#pragma mark 授权成功后，发送 "在线" 消息
- (void)sendOnlineToHost
{
    WCLog(@"发送 在线 消息");
    XMPPPresence *presence = [XMPPPresence presence];
    WCLog(@"在线消息 %@", presence);
    
    [_xmppStream sendElement:presence];
}

#pragma mark - XMPPStreamDelegate
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    WCLog(@"与主机连接成功");
    //发送密码授权
    [self sendPasswordToHost];
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    WCLog(@"与主机断开连接");
    
    //没有错误，表示人为的断开连接
    
    //有错误，表示
    
    if (error && _resultBlock) {
        _resultBlock(XMPPResultTypeNetError);
    }
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    WCLog(@"授权成功");
    
    [self sendOnlineToHost];
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeLoginSuccess);
    }
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    WCLog(@"授权失败 %@", error);
    
    //断开连接
//    if ([_xmppStream isConnected]) {
//        [sender disconnect];
//    }
    
    [sender disconnect]; //不需要判断，每次连接都是一次新的连接
    
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeLoginFailure);
    }
}

#pragma mark - 退出登录
- (void)logout
{
    //发送离线消息
    XMPPPresence *offline = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:offline];
    
    //与服务器断开连接
    [_xmppStream disconnect];
}

#pragma mark - 登录
- (void)xmppUserLogin:(XMPPResultBlock)resultBlock
{
    //连接主机，成功后发送密码
    [self connectToHost];
    _resultBlock = resultBlock;
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
