//
//  UtilRequest.m
//  PowerWallet
//
//  Created by krisc.zampono on 2017/2/6.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "UtilRequest.h"
#import "NetworkSingleton.h"

@implementation UtilRequest


/**
 Description

 @param paramDict paramDict description
 @param successCb successCb description
 @param failCb failCb description
 */
- (void)appDeviceReportWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb {
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Base_URL,kReportKey];
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

- (void)uploadLocationWithDict:(NSDictionary *)paramDict onSuccess:(void (^)(NSDictionary *dictResult))successCb andFailed:(void (^)(NSInteger code, NSString *errorMsg))failCb {
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Base_URL,KUserLocation];
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

-(void)contrastVersionWithDict:(NSString *)code onSuccess:(void (^)(NSDictionary *))successCb andFailed:(void (^)(NSInteger, NSString *))failCb{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@?versionNumber=%@",Base_URL,KContrastVersion,code];
    [[NetworkSingleton sharedManager] getDataPost:nil url:strUrl successBlock:^(id responseObject, NSInteger statusCode) {
        if (statusCode == 200) {
            NSDictionary *dictResult = responseObject;
            //            if ([DSStringValue(dictResult[@"code"]) isEqualToString:@"0"]) {
            successCb(dictResult);
            //            }else{
            //                failCb(statusCode,DSStringValue(dictResult[@"message"]));
            //            }
        }else{
            failCb(statusCode,kErrorUnknown);
        }
    }  failureBlock:^(NSError *e, NSInteger statusCode, NSString *errorMsg) {
        failCb(statusCode,errorMsg);
    }];
}


@end
