//
//  UIView+GenerateCheckCode.h
//  Demo
//
//  Created by Krisc.Zampono on 12/6/2.
//  Copyright (c) 2012年 Krisc.Zampono. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GenerateCheckCode)

/**
 *  生成随机验证码，使用时须先初始化一个UIView对象，并设定Frame
 */
- (void)generateCheckCode;

- (void)setCheckCode:(NSString *) _checkCode;

- (NSString *)getCheckCode;

@end
