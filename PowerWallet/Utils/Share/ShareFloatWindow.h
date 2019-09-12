//
//  ShareFloatWindow.h
//  KDLC
//
//  Created by haoran on 15/10/26.
//  Copyright © 2015年 llyt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareFloatWindow : UIView
//初始化
+ (ShareFloatWindow *)makeText:(NSString *)str;
//展示
- (void)show;
@end
