//
//  UITextField+Masonry.m
//  KDLC
//
//  Created by zampono on 17/6/6.
//  Copyright © 2017年 zampono. All rights reserved.
//

#import "UITextField+Masonry.h"

@implementation UITextField (Masonry)

+ (UITextField *)getTextFieldWithFontSize:(NSInteger)size textColorHex:(long)colorHex placeHolder:(NSString *)placeHolder superView:(UIView *)superView masonrySet:(void (^)(UITextField *view,MASConstraintMaker *make))block
{
    UITextField *textfield = [[UITextField alloc] init];
    textfield.font = [UIFont systemFontOfSize:size];
    textfield.textColor = [UIColor colorWithHex:colorHex];
    textfield.placeholder = placeHolder;
    textfield.translatesAutoresizingMaskIntoConstraints = NO;
    [superView addSubview:textfield];
    
    [textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        if (block) {
            block(textfield,make);
        }
    }];
    
    return textfield;
}

@end
