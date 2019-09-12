//
//  LoginViewController.h
//  PowerWallet
//
//  Created by 清阳 on 2018/1/9.
//  Copyright © 2018年 peijunjinrong. All rights reserved.
//

#import "SecondLevelViewController.h"

@interface LoginViewController : SecondLevelViewController<UITextFieldDelegate>
@property (nonatomic, copy) void (^reLoginSetUserName)(NSString *userName,NSString *tipStr);
@end
