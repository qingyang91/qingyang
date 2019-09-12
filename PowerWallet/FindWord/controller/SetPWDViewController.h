//
//  SetPWDViewController.h
//  PowerWallet
//
//  Created by 清阳 on 2017/12/28.
//  Copyright © 2017年 peijunjinrong. All rights reserved.
//

#import "SecondLevelViewController.h"

typedef NS_ENUM(NSInteger,KDPayPasswordType)
{
    KDSetPayPassword=0,//设置交易密码
    KDConfirmPayPassword//确认交易密码
};

@interface SetPWDViewController : SecondLevelViewController

//推过来的页面的索引
@property (assign,nonatomic) NSInteger controllIndex;
@property (assign,nonatomic) NSInteger type;
//记录的交易密码
@property (nonatomic, retain) NSString *password;

- (instancetype)initWithType:(KDPayPasswordType)type;

@end
