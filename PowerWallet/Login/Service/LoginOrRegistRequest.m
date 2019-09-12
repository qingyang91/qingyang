//
//  LoginOrRegistRequest.m
//  PowerWallet
//
//  Created by Krisc.Zampono on 2017/2/9.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "LoginOrRegistRequest.h"

@implementation LoginOrRegistRequest



/**
 Description

 @param paramDict paramDict description
 @param successCb successCb description
 @param failCb failCb description
 */
- (void)checkPhoneNumberWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb{

    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Base_URL,KUserRegGetCode];
    [[NetworkSingleton sharedManager] getDataPostWithAddParameters:[paramDict copy] url:strUrl successBlock:^(id responseObject, NSInteger statusCode){
        if (statusCode == 200) {
            NSDictionary *dictResult = responseObject;
            if ([DSStringValue(dictResult[@"code"]) isEqualToString:@"0"]) {
                successCb(dictResult[@"data"]);
            }else{
                if ([DSStringValue(dictResult[@"code"]) isEqualToString:@"1000"]) {
                    failCb(1000,DSStringValue(dictResult[@"message"]));
                }else{
                    failCb(statusCode,DSStringValue(dictResult[@"message"]));
                }

            }
        }else{
            failCb(statusCode,kErrorUnknown);
        }
    } failureBlock:^(NSError *e, NSInteger statusCode, NSString *errorMsg){
        failCb(statusCode, errorMsg);
    }];

}

- (void)LoginOutWihtDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb{
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Base_URL,kKDLogoutKey];
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


- (void)LoginWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Base_URL,kKDLoginKey];
    paramDict = [[NetworkSingleton sharedManager] setParamsToDic:paramDict];
    [[NetworkSingleton sharedManager] getDataPost:paramDict url:strUrl successBlock:^(id responseObject, NSInteger statusCode){
        if (statusCode == 200) {
            NSDictionary *dictResult = responseObject;
            if ([DSStringValue(dictResult[@"code"]) isEqualToString:@"0"]) {
                successCb(dictResult[@"data"]);
            }else{
                if ([DSStringValue(dictResult[@"code"]) isEqualToString:@"1000"]) {
                    failCb(1000,DSStringValue(dictResult[@"message"]));
                }else{
                    failCb(statusCode,DSStringValue(dictResult[@"message"]));
                }
                
            }
        }else{
            failCb(statusCode,kErrorUnknown);
        }
    } failureBlock:^(NSError *e, NSInteger statusCode, NSString *errorMsg){
        failCb(statusCode, errorMsg);
    }];
    
}

- (void)getRegisterWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb{

    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Base_URL,KUserRegGetCode];
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

- (void)commitRegisterWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb{
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Base_URL,kKDZhuceKey];
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
