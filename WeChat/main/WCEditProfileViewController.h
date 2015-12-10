//
//  WCEditProfileViewController.h
//  WeChat
//
//  Created by hu on 15/12/5.
//  Copyright © 2015年 redye. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WCEditProfileViewControllerDelegate <NSObject>

- (void)editProfileViewControllerDidSave;

@end

@interface WCEditProfileViewController : UITableViewController

@property (nonatomic, strong) UITableViewCell *cell;
@property (nonatomic, weak) id<WCEditProfileViewControllerDelegate> delegate;

@end
