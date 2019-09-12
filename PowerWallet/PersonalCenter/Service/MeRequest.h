//
//  MeRequest.h
//  PowerWallet
//
//  Created by Krisc.Zampono on 2017/2/10.
//  Copyright © 2017年 lxw. All rights reserved.
//



@interface MeRequest : NSObject
/**
 获取我的页面数据
 
 @param paramDict 参数字典
 @param successCb 成功回调
 @param failCb 失败回调
 */
- (void) getUserInfoWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb;
/**
 * 意见反馈
 *
 *  @param paramDict 参数字典
 *  @param successCb 成功回调
 *  @param failCb    失败回调
 */

- (void)feedBackWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb;
/**
 * 借条意见反馈
 *
 *  @param paramDict 参数字典
 *  @param successCb 成功回调
 *  @param failCb    失败回调
 */
- (void)feedLendBackWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb;
@end
