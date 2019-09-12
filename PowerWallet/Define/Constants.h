//
//  Constants.h
//  EveryDay
//
//  Created by Krisc.Zampono on 15/7/2.
//  Copyright (c) 2015年 Krisc.Zampono. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

//侧边距
extern CGFloat    const kPaddingLeft;
//上边距
extern CGFloat    const kPaddingTop;
//textfield 高度
extern CGFloat    const kTextFieldHeight;
//按钮高度
extern CGFloat    const kButtonHeight;
//分割线高度
extern CGFloat    const kSeparatorHeight;
//view距顶部距离
extern CGFloat    const kViewTop;

//通知
extern NSString * const kNotificationNeedLogin;     //需要用户登录

//错误描述
extern NSString * const kErrorUnknown;

//http请求方式
extern NSString * const kHttpRequestPost;
extern NSString * const kHttpRequestGet;

@end
