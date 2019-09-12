//
//  RegistViewController.h
//  PowerWallet
//
//  Created by 清阳 on 2018/1/9.
//  Copyright © 2018年 peijunjinrong. All rights reserved.
//

#import "SecondLevelViewController.h"
typedef NS_ENUM(NSInteger,registerOrForgetPwd){
    registerSec, //注册
    forgetPwd //忘记密码
};
@interface RegistViewController : SecondLevelViewController
@property(nonatomic,retain)NSString* phoneNumber;
@property(nonatomic,retain)NSString* captchaUrl;

- (instancetype)initWithPageType:(registerOrForgetPwd)type;

@end

