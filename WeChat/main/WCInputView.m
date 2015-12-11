//
//  WCInputView.m
//  WeChat
//
//  Created by hu on 15/12/9.
//  Copyright © 2015年 redye. All rights reserved.
//

#import "WCInputView.h"

@implementation WCInputView

+ (instancetype)inputView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"WCInputView" owner:nil options:nil] lastObject];
}

- (UITextView *)textView
{
    if (!_textView) {
        NSArray *subViews = self.subviews;
        for (UIView *view in subViews) {
            if ([view isKindOfClass:[UITextView class]]) {
                _textView = (UITextView *)view;
                break;
            }
        }
    }
    return _textView;
}

- (UIButton *)addButton
{
    if (!_addButton) {
        NSArray *subViews = self.subviews;
        for (UIView *view in subViews) {
            if ([view isKindOfClass:[UIButton class]]) {
                _addButton = (UIButton *)view;;
                break;
            }
        }
    }
    
    return _addButton;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
