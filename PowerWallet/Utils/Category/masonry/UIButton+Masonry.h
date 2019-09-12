//
//  UIButton+Masonry.h
//  KDLC
//
//  Created by Krisc.Zampono on 16/6/6.
//  Copyright © 2016年 llyt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Masonry)

+(void)startRunSecond:(UIButton *)btn stringFormat:(NSString *)str finishBlock:(dispatch_block_t)finish;

+ (UIButton *)rightArrowCustom;

@end
