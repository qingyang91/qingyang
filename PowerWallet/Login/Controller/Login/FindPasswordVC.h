//
//  FindPasswordVC.h
//  PowerWallet
//
//  Created by liu xiwang on 2017/2/14.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "SecondLevelViewController.h"

typedef enum {
    login,
    pay
}ForgetType;

@interface FindPasswordVC : SecondLevelViewController

@property(nonatomic,assign) ForgetType forgetType;
@property(nonatomic,retain) NSString    *phoneNumber;
@property(nonatomic,retain) NSString    *captchaUrl;
/**
 是否已发送验证码
 */
@property(nonatomic,assign) BOOL     accessNetwork;
@end
