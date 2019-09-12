//
//  RegularMethod.h
//  NetAddressList
//
//  Created by myl on 15/6/10.
//  Copyright (c) 2015年 com.hn3l. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegularMethod : NSObject

//判断手机号
+(BOOL) checkPhoneNumWithPhone:(NSString *)phone;

//纯数字
+ (BOOL) validateNum:(NSString *)numa;

//座机电话
+ (BOOL) validateTel:(NSString *)tel;

//邮箱
+ (BOOL) validateEmail:(NSString *)email;

//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile;

//车牌号验证
+ (BOOL) validateCarNo:(NSString *)carNo;

//车型
+ (BOOL) validateCarType:(NSString *)CarType;

//用户名
+ (BOOL) validateUserName:(NSString *)name;

//密码
+ (BOOL) validatePassword:(NSString *)passWord;

//昵称
+ (BOOL) validateNickname:(NSString *)nickname;

//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard;

//银行卡
+ (BOOL) validateBankCardNumber: (NSString *)bankCardNumber;

//银行卡后四位
+ (BOOL) validateBankCardLastNumber: (NSString *)bankCardNumber;

//CVN
+ (BOOL) validateCVNCode: (NSString *)cvnCode;

//month
+ (BOOL) validateMonth: (NSString *)month;

//month
+ (BOOL) validateYear: (NSString *)year;

//verifyCode
+ (BOOL) validateVerifyCode: (NSString *)verifyCode;

@end
