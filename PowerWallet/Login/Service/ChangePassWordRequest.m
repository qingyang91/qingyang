//
//  ChangePassWordRequest.m
//  PowerWallet
//
//  Created by liu xiwang on 2017/2/15.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "ChangePassWordRequest.h"

@implementation ChangePassWordRequest


/**
 Description
 
 @param paramDict paramDict description
 @param successCb successCb description
 @param failCb failCb description
 */
- (void)changePassWordWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb isLoginPassWord:(NSString *)isLoginPassWord{
    
    NSString *strUrl;
    if ([isLoginPassWord isEqualToString:@"1"]) {
        strUrl = [NSString stringWithFormat:@"%@%@",Base_URL,KModifyLoginPassWord];
    }else if ([isLoginPassWord isEqualToString:@"0"]){
        strUrl = [NSString stringWithFormat:@"%@%@",Base_URL,kUserChangePaypassword];
    }
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
