//
//  AlipayRequset.m
//  PowerWallet
//
//  Created by liu xiwang on 2017/2/20.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "AlipayRequset.h"

@implementation AlipayRequset



/**
 Description

 @param paramDict paramDict description
 @param successCb successCb description
 @param failCb failCb description
 */
- (void)alipayLoginSuccessWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Base_URL1,KZFB];
    [[NetworkSingleton sharedManager] getDataPostWithAddParameters:[paramDict copy] url:strUrl successBlock:^(id responseObject, NSInteger statusCode) {
        if (statusCode == 200) {
            NSDictionary *dictResult = responseObject;
            if ([DSStringValue(dictResult[@"code"]) isEqualToString:@"0"]) {
                successCb(dictResult[@"data"]);
            }else{
                failCb([DSStringValue(dictResult[@"code"]) intValue],DSStringValue(dictResult[@"message"]));
            }
        }else{
            failCb(statusCode,kErrorUnknown);
        }
    } failureBlock:^(NSError *e, NSInteger statusCode, NSString *errorMsg) {
        failCb(statusCode,errorMsg);
    }];
}

@end
