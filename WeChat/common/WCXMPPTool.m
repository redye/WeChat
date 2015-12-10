//
//  WCXMPPTool.m
//  WeChat
//
//  Created by hu on 15/11/9.
//  Copyright © 2015年 redye. All rights reserved.
//

#import "WCXMPPTool.h"
#import "WCNavigationController.h"

@interface WCXMPPTool ()<XMPPStreamDelegate>
{
    
    XMPPResultBlock _resultBlock;
    
    XMPPReconnect *_reconnect;
    
    //名片
    XMPPvCardCoreDataStorage *_vCardStorage;
    
    //头像
    XMPPvCardAvatarModule *_vCardAvatar;
    
    
}

@end

@implementation WCXMPPTool

singleton_implementation(WCXMPPTool)

#pragma mark 初始化 XMPPStream
- (void)setupStream
{
    _xmppStream = [[XMPPStream alloc] init];
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
#warning 每一个模块添加后都需要激活
    //添加自动连接模块
    _reconnect = [[XMPPReconnect alloc] init];
    [_reconnect activate:_xmppStream];
    
    //添加电子名片模块
    _vCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    _vCard = [[XMPPvCardTempModule alloc] initWithvCardStorage:_vCardStorage];
    //激活名片
    [_vCard activate:_xmppStream];
    
    //头像模块
    _vCardAvatar = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:_vCard];
    [_vCardAvatar activate:_xmppStream];
    
    //花名册
    _rosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    _roster = [[XMPPRoster alloc] initWithRosterStorage:_rosterStorage];
    [_roster activate:_xmppStream];
    
    //消息
    _messageStorage = [[XMPPMessageArchivingCoreDataStorage alloc] init];
    _messageArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:_messageStorage];
    [_messageArchiving activate:_xmppStream];
    
    //设置代理
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
}

#pragma mark - 销毁 XMPP
- (void)teardownXMPP
{
    //移除代理
    [_xmppStream removeDelegate:self];
    
    //停止模块
    [_reconnect deactivate];
    [_vCard deactivate];
    [_vCardAvatar deactivate];
    [_roster deactivate];
    [_messageArchiving deactivate];
    
    //断开连接
    [_xmppStream disconnect];
    
    //清空资源
    _reconnect = nil;
    _vCard = nil;
    _vCardAvatar = nil;
    _vCardStorage = nil;
    _roster = nil;
    _rosterStorage = nil;
    _messageArchiving = nil;
    _messageStorage = nil;
    _xmppStream = nil;
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
    NSString *user = self.isRegisterOperation ? [WCUser sharedWCUser].registerName : [WCUser sharedWCUser].name;
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
    NSString *password = [WCUser sharedWCUser].password;
    
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
    if (self.isRegisterOperation) {
        //发送注册密码
        [_xmppStream registerWithPassword:[WCUser sharedWCUser].registerPassword error:nil];
    } else {
        [self sendPasswordToHost];
    }
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

#pragma mark 注册成功
- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    WCLog(@"注册成功");
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeRegisterSuccess);
    }
}

#pragma mark 注册失败
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error
{
    WCLog(@"注册失败 %@", error);
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeRegisterFailre);
    }
}

#pragma mark - 退出登录
- (void)xmppUserlogout
{
    //发送离线消息
    XMPPPresence *offline = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:offline];
    
    //与服务器断开连接
    [_xmppStream disconnect];
    
    //回到登录界面
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//    self.window.rootViewController = storyboard.instantiateInitialViewController;
    [UIStoryboard showInitialVCWithName:@"Login"];
    
    //更新用户的登录状态
    [WCUser sharedWCUser].loginStatus = NO;
    [[WCUser sharedWCUser] saveUserToSandbox];
}

#pragma mark - 登录
- (void)xmppUserLogin:(XMPPResultBlock)resultBlock
{
    //如果以前连接过主机，断开
    [_xmppStream disconnect];
    
    //连接主机，成功后发送密码
    [self connectToHost];
    _resultBlock = resultBlock;
}

#pragma mark - 用户注册
- (void)xmppUserRegister:(XMPPResultBlock)resultBlock
{
    _resultBlock = resultBlock;
    
    [_xmppStream disconnect];
    
    //连接主机，成功后发送密码
    [self connectToHost];
}

- (void)dealloc
{
    [self teardownXMPP];
}

@end
