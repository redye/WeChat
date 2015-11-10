//
//  WCXMPPTool.h
//  WeChat
//
//  Created by hu on 15/11/9.
//  Copyright © 2015年 redye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

typedef NS_ENUM(NSInteger, XMPPResultType) {
    XMPPResultTypeLoginSuccess, //登录成功
    XMPPResultTypeLoginFailure, //登录失败
    XMPPResultTypeNetError,
    XMPPResultTypeRegisterSuccess, //注册成功
    XMPPResultTypeRegisterFailre //注册失败
};

typedef void(^XMPPResultBlock)(XMPPResultType type);  //xmpp请求结果的 block

@interface WCXMPPTool : NSObject

singleton_interface(WCXMPPTool)

@property (copy, nonatomic) XMPPResultBlock resultBlock;
/**
 *  注册的标识，YES 代表注册，NO 代表登录
 */
@property (assign, nonatomic, getter=isRegisterOperation) BOOL registerOperation;  //标识注册操作

/**
 *  用户登录
 *
 *  @param resultBlock 登录结果
 */
- (void)xmppUserLogin:(XMPPResultBlock)resultBlock;

/**
 *  退出登录
 */
- (void)xmppUserlogout;

/**
 *  用户注册
 *
 *  @param resultBlock 用户注册的结果
 */
- (void)xmppUserRegister:(XMPPResultBlock)resultBlock;

@end
