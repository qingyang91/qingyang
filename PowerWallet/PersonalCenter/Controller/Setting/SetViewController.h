//
//  SetViewController.h
//  PowerWallet
//
//  Created by 清阳 on 2018/1/9.
//  Copyright © 2018年 peijunjinrong. All rights reserved.
//

#import "SecondLevelViewController.h"
#import "MeModel.h"

@interface SetViewController : SecondLevelViewController

@property (nonatomic, assign) NSInteger real_verify_status;
@property (nonatomic, assign) NSInteger real_pay_pwd_status;
@property (nonatomic,strong) MeModel *meModel;
@property (nonatomic, assign) NSInteger payWord;
@end

