//
//  WCUser.m
//  WeChat
//
//  Created by hu on 15/11/8.
//  Copyright © 2015年 redye. All rights reserved.
//

#import "WCUser.h"

NSString *const kUserKey = @"user";
NSString *const kPassKey = @"password";
NSString *const kLoginStatus = @"loginStatus";

@implementation WCUser

singleton_implementation(WCUser)

//用户登录成功后，将用户信息保存到沙河
- (void)saveUserToSandbox
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.name forKey:kUserKey];
    [userDefaults setObject:self.password forKey:kPassKey];
    [userDefaults setBool:self.loginStatus forKey:kLoginStatus];
    [userDefaults synchronize];
}

- (void)loadUserFromSandbox
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.name = [userDefaults objectForKey:kUserKey];
    self.password = [userDefaults objectForKey:kPassKey];
    self.loginStatus = [userDefaults boolForKey:kLoginStatus];
}

- (NSString *)jid
{
    return [NSString stringWithFormat:@"%@@%@", self.name, kDomain];
}

@end
