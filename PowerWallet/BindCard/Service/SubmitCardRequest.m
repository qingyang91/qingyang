//
//  SubmitCardRequest.m
//  PowerWallet
//
//  Created by 清阳 on 2017/12/26.
//  Copyright © 2017年 peijunjinrong. All rights reserved.
//

#import "SubmitCardRequest.h"

@implementation SubmitCardRequest

- (void)submitCardInfoWithDict:(NSDictionary *)paramDict onSuccess:(void (^)(NSDictionary *))successCb andFailed:(void (^)(NSInteger, NSString *))failCb{
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@",Base_URL1,KSubmintBindCard];
//    [[NetworkSingleton sharedManager]getDataPostWithAddParameters:[paramDict copy] url:urlStr successBlock:^(id responseObject, NSInteger statusCode) {
//        if (statusCode == 200) {
//            NSDictionary *dictResult = responseObject;
//            if ([DSStringValue(dictResult[@"code"]) isEqualToString:@"0"]) {
//                successCb(dictResult[@"data"]);
//            }else{
//                failCb([DSStringValue(dictResult[@"code"]) intValue],DSStringValue(dictResult[@"message"]));
//            }
//        }else{
//            failCb(statusCode,kErrorUnknown);
//        }
//    } failureBlock:^(NSError *e, NSInteger statusCode, NSString *errorMsg) {
//        failCb(statusCode,errorMsg);
//    }];
}


@end
