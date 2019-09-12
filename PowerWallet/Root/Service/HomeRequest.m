//
//  HomeRequest.m
//  PowerWallet
//
//  Created by Krisc.Zampono on 2017/8/9.
//  Copyright © 2017年 Jueling. All rights reserved.
//

#import "HomeRequest.h"
#import "NetworkSingleton.h"

@implementation HomeRequest



/**
 Description

 @param paramDict paramDict description
 @param successCb successCb description
 @param failCb failCb description
 */
- (void)upAppsInfoWithDictionary:(NSDictionary *)paramDict success:(void(^)(NSDictionary *dictResult))successCb failed:(void(^)(NSInteger code,NSString *errorMsg))failCb {
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", Base_URL, KUserAppInfo];
    [[NetworkSingleton sharedManager] getDataPostWithAddParameters:[paramDict copy] url:strUrl successBlock:^(id responseObject, NSInteger statusCode){
        if (statusCode == 200) {
            NSDictionary *dictResult = responseObject;
            if ([DSStringValue([dictResult[@"code"] description]) isEqualToString:@"0"]) {
                successCb(dictResult[@"data"]);
            }else{
                failCb([DSStringValue(dictResult[@"code"]) intValue],DSStringValue(dictResult[@"message"]));
            }
        }else{
            failCb(statusCode,kErrorUnknown);
        }
    } failureBlock:^(NSError *e, NSInteger statusCode, NSString *errorMsg){
        failCb(statusCode, errorMsg);
    }];
}
/**
 首页
 
 @param paramDict 传参数
 @param successCb 成功操作
 @param failCb 失败操作
 */
- (void)getHomeDataWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb{
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@%@",Base_URL,KGetIndex];
    [[NetworkSingleton sharedManager] getDataPostWithAddParameters:[paramDict copy] url:urlStr successBlock:^(id responseObject, NSInteger statusCode) {
        if (statusCode == 200) {
            NSDictionary *dictResult = responseObject;
            if ([[DSStringValue(dictResult[@"code"]) description] isEqualToString:@"0"]) {
                successCb(dictResult[@"data"]);
            }else{
                failCb([DSStringValue(dictResult[@"code"]) intValue],DSStringValue(dictResult[@"message"]));
            }
        }else{
            failCb(statusCode,kErrorUnknown);
        }
    } failureBlock:^(NSError *e, NSInteger statusCode, NSString *errorMsg) {
        failCb(statusCode, errorMsg);
    }];
}

-(void)getLendDescWithDict:(NSDictionary *)paramDict onSuccess:(void (^)(NSDictionary *))successCb andFailed:(void (^)(NSInteger, NSString *))failCb{
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@%@",Base_URL,KGetLendDesc];
    [[NetworkSingleton sharedManager] getDataPostWithAddParameters:[paramDict copy] url:urlStr successBlock:^(id responseObject, NSInteger statusCode) {
        if (statusCode == 200) {
            NSDictionary *dictResult = responseObject;
            if ([[DSStringValue(dictResult[@"code"]) description] isEqualToString:@"0"]) {
                successCb(dictResult[@"data"]);
            }else{
                failCb(statusCode,DSStringValue(dictResult[@"msg"]));
            }
        }else{
            failCb(statusCode,kErrorUnknown);
        }
    } failureBlock:^(NSError *e, NSInteger statusCode, NSString *errorMsg) {
        failCb(statusCode, errorMsg);
    }];
}

-(void)reportStatisticsWithDict:(NSDictionary *)paramDict onSuccess:(void (^)(NSDictionary *))successCb andFailed:(void (^)(NSInteger, NSString *))failCb{
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@%@",Base_URL,ReportStatistics];
    [[NetworkSingleton sharedManager] getDataPostWithAddParameters:[paramDict copy] url:urlStr successBlock:^(id responseObject, NSInteger statusCode) {
        if (statusCode == 200) {
            NSDictionary *dictResult = responseObject;
            if ([[DSStringValue(dictResult[@"code"]) description] isEqualToString:@"0"]) {
                successCb(dictResult[@"data"]);
            }else{
                failCb(statusCode,DSStringValue(dictResult[@"msg"]));
            }
        }else{
            failCb(statusCode,kErrorUnknown);
        }
    } failureBlock:^(NSError *e, NSInteger statusCode, NSString *errorMsg) {
        failCb(statusCode, errorMsg);
    }];
}
@end
