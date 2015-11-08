//
//  WCUser.h
//  WeChat
//
//  Created by hu on 15/11/8.
//  Copyright © 2015年 redye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface WCUser : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, assign) BOOL loginStatus;  //登录的状态
@property (nonatomic, copy) NSString *registerName; //用户注册的用户名
@property (nonatomic, copy) NSString *registerPassword; //用户注册的密码

singleton_interface(WCUser)

- (void)saveUserToSandbox;
- (void)loadUserFromSandbox;

@end
