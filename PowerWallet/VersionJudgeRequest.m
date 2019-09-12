//
//  VersionJudgeRequest.m
//  PowerWallet
//
//  Created by 清阳 on 2018/1/17.
//  Copyright © 2018年 peijunjinrong. All rights reserved.
//

#import "VersionJudgeRequest.h"

@implementation VersionJudgeRequest

- (void)getVersionSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb {
    NSString *urlStr = [NSString stringWithFormat:Base_Url2,CurrentAppVersion];
        [[NetworkSingleton sharedManager]getDataWithUrl:urlStr successBlock:^(id responseObject, NSInteger statusCode) {
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


@end
