//
//  BaseTextField.m
//  PowerWallet
//
//  Created by Krisc.Zampono on 2017/10/17.
//  Copyright © 2017年 Jueling. All rights reserved.
//

#import "BaseTextField.h"

@implementation BaseTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    // 禁用粘贴功能
    if (action == @selector(paste:))
        return NO;
    // 禁用选择功能
    if (action == @selector(select:))
        return NO;
    // 禁用全选功能
    if (action == @selector(selectAll:))
        return NO;
    return [super canPerformAction:action withSender:sender];
}

@end
