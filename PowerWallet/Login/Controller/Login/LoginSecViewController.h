//
//  LoginSecViewController.h
//  PowerWallet
//
//  Created by 清阳 on 2018/1/9.
//  Copyright © 2018年 peijunjinrong. All rights reserved.
//

#import "SecondLevelViewController.h"
/*
 该VC表示,用户输入的手机号,在平台已经注册
 */
@interface LoginSecViewController : SecondLevelViewController
@property (nonatomic, copy) void (^reLoginSetUserName)(NSString *userName);
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *tipStr;
@end
