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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
