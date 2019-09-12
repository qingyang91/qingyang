//
//  ForgetPassWordRequest.h
//  PowerWallet
//
//  Created by liu xiwang on 2017/2/15.
//  Copyright © 2017年 lxw. All rights reserved.
//



@interface ForgetPassWordRequest : NSObject

/**
 * 找回密码获取验证码
 *
 *  @param paramDict 参数字典
 *  @param successCb 成功回调
 *  @param failCb    失败回调
 */

- (void)resetPwdCodeWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb;

/**
 * 找回密码验证个人信息
 *
 *  @param paramDict 参数字典
 *  @param successCb 成功回调
 *  @param failCb    失败回调
 */

- (void)forgetPassWordWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb;

/**
 * 找回登录密码设置新密码
 *
 *  @param paramDict 参数字典
 *  @param successCb 成功回调
 *  @param failCb    失败回调
 */

- (void)resetPasswordWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb;

@end
