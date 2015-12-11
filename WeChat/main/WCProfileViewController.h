//
//  WCProfileViewController.h
//  WeChat
//
//  Created by hu on 15/12/5.
//  Copyright © 2015年 redye. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WCProfileViewController;

@protocol WCProfileViewControllerDelegate <NSObject>

@optional
- (void)profileViewController:(WCProfileViewController *)profileViewController didChangeHeaderImage:(UIImage *)headerImage;

@end

@interface WCProfileViewController : UITableViewController

@property (nonatomic, assign) id<WCProfileViewControllerDelegate> delegate;

@end
