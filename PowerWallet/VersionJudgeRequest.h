//
//  VersionJudgeRequest.h
//  PowerWallet
//
//  Created by 清阳 on 2018/1/17.
//  Copyright © 2018年 peijunjinrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionJudgeRequest : NSObject

- (void)getVersionSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb;


@end
