//
//  WCRegisterViewController.h
//  WeChat
//
//  Created by hu on 15/11/8.
//  Copyright © 2015年 redye. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WCRegisterViewController;

@protocol WCRegisterViewControllerDelegate <NSObject>

@optional
- (void)registerViewControllerDidSuccessRegister:(WCRegisterViewController *)registerViewController;

@end

@interface WCRegisterViewController : UIViewController

@property (nonatomic, assign) id<WCRegisterViewControllerDelegate> delegate;

@end
