//
//  HomeRequest.h
//  PowerWallet
//
//  Created by Krisc.Zampono on 2017/8/9.
//  Copyright © 2017年 Jueling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeRequest : NSObject
- (void)upAppsInfoWithDictionary:(NSDictionary *)paramDict success:(void(^)(NSDictionary *dictResult))successCb failed:(void(^)(NSInteger code,NSString *errorMsg))failCb;
/**
 首页

 @param paramDict 传参数
 @param successCb 成功操作
 @param failCb 失败操作
 */
- (void)getHomeDataWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb;
/**
 获取首页贷商详情

 @param paramDict 传参列表
 @param successCb 成功操作
 @param failCb 失败操作
 */
-(void)getLendDescWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb;
/**
 上报三方被点击信息

 @param paramDict 参数
 @param successCb 成功
 @param failCb 失败
 */
-(void)reportStatisticsWithDict:(NSDictionary *)paramDict onSuccess:(void (^)(NSDictionary *))successCb andFailed:(void (^)(NSInteger, NSString *))failCb;
@end
