//
//  FindPayPassWordVC.h
//  PowerWallet
//
//  Created by 清阳 on 2017/12/29.
//  Copyright © 2017年 peijunjinrong. All rights reserved.
//

#import "SecondLevelViewController.h"
typedef enum {
    loginPay,
    payPay
}ForgetPayType;

@interface FindPayPassWordVC : SecondLevelViewController

@property(nonatomic,assign)ForgetPayType forgetType;
@property(nonatomic,retain)NSString* phoneNumber;
@property(nonatomic,retain)NSString* isRealName;

@end
