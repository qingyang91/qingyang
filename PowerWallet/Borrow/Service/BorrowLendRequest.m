//
//  BorrowLendRequest.m
//  PowerWallet
//
//  Created by 清阳 on 2017/12/26.
//  Copyright © 2017年 peijunjinrong. All rights reserved.
//

#import "BorrowLendRequest.h"

@implementation BorrowLendRequest
-(void)getBorrowYouLendIndexWithDict:(NSDictionary *)paramDict onSuccess:(void (^)(NSDictionary *))successCb andFailed:(void (^)(NSInteger, NSString *))failCb{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",Base_URL1,KGetLendIndex];
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
- (void)getRootLendIndexWithDict:(NSDictionary *)paramDict onSuccess:(void (^)(NSDictionary *))successCb andFailed:(void (^)(NSInteger, NSString *))failCb{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",Base_URL1,KGetRootLendList];
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
- (void)getRootLendOutIndexWithDict:(NSDictionary *)paramDict onSuccess:(void (^)(NSDictionary *))successCb andFailed:(void (^)(NSInteger, NSString *))failCb{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",Base_URL1,KGetRootOutLendList];
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
- (void)getLendOutIndexWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb{
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",Base_URL1,KGetgetBorrowOutList];
    [[NetworkSingleton sharedManager]getDataWithUrl:urlstr successBlock:^(id responseObject, NSInteger statusCode) {
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
- (void)getLendIndexWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb{
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",Base_URL1,KGetBorrowOrderfindList];
    [[NetworkSingleton sharedManager]getDataWithUrl:urlstr successBlock:^(id responseObject, NSInteger statusCode) {
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
- (void)getRootLendDataWithDict:(NSDictionary *)paramDict onSuccess:(void (^)(NSDictionary *))successCb andFailed:(void (^)(NSInteger, NSString *))failCb{
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",Base_URL1,KGetRootLendData];
    [[NetworkSingleton sharedManager]getDataPostWithAddParameters:[paramDict copy] url:urlstr successBlock:^(id responseObject, NSInteger statusCode) {
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
    } failureBlock:^(NSError *e, NSInteger statusCode, NSString *errorMsg) {
        failCb(statusCode,errorMsg);
    }];
}
- (void)getRootLendOutDataWithDict:(NSDictionary *)paramDict onSuccess:(void (^)(NSDictionary *))successCb andFailed:(void (^)(NSInteger, NSString *))failCb{
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",Base_URL1,KGetRootOutListData];
    [[NetworkSingleton sharedManager]getDataPostWithAddParameters:[paramDict copy] url:urlstr successBlock:^(id responseObject, NSInteger statusCode) {
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
    } failureBlock:^(NSError *e, NSInteger statusCode, NSString *errorMsg) {
        failCb(statusCode,errorMsg);
    }];
}
- (void)getLendListWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb{
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",Base_URL1,KGetLendList];
    [[NetworkSingleton sharedManager]getDataPostWithAddParameters:[paramDict copy] url:urlstr successBlock:^(id responseObject, NSInteger statusCode) {
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
    } failureBlock:^(NSError *e, NSInteger statusCode, NSString *errorMsg) {
        failCb(statusCode,errorMsg);
    }];
}
- (void)getLogOutListWithDict:(NSDictionary *)paramDict onSuccess:(void (^)(NSDictionary *))successCb andFailed:(void (^)(NSInteger, NSString *))failCb{
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",Base_URL1,KDeleteLend];
    [[NetworkSingleton sharedManager]getDataPostWithAddParameters:[paramDict copy] url:urlstr successBlock:^(id responseObject, NSInteger statusCode) {
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
    } failureBlock:^(NSError *e, NSInteger statusCode, NSString *errorMsg) {
        failCb(statusCode,errorMsg);
    }];
}
- (void)getAgreeListWithDict:(NSDictionary *)paramDict onSuccess:(void (^)(NSDictionary *))successCb andFailed:(void (^)(NSInteger, NSString *))failCb{
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",Base_URL1,KAgreeLend];
    [[NetworkSingleton sharedManager]getDataPostWithAddParameters:[paramDict copy] url:urlstr successBlock:^(id responseObject, NSInteger statusCode) {
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
    } failureBlock:^(NSError *e, NSInteger statusCode, NSString *errorMsg) {
        failCb(statusCode,errorMsg);
    }];
}

- (void)inquiryRepayProcessWithDict:(NSDictionary *)paramDict onSuccess:(void (^)(NSDictionary *))successCb andFailed:(void (^)(NSInteger, NSString *))failCb{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",Base_URL1,KChaxunRepay];
    [[NetworkSingleton sharedManager]getDataPostWithAddParameters:[paramDict copy] url:urlStr successBlock:^(id responseObject, NSInteger statusCode) {
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
    } failureBlock:^(NSError *e, NSInteger statusCode, NSString *errorMsg) {
        failCb(statusCode,errorMsg);
    }];
}
@end
