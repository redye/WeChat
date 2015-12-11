//
//  WCInputView.h
//  WeChat
//
//  Created by hu on 15/12/9.
//  Copyright © 2015年 redye. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCInputView : UIView

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

+ (instancetype)inputView;

@end
