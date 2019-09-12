//
//  SubmitCardRequest.h
//  PowerWallet
//
//  Created by 清阳 on 2017/12/26.
//  Copyright © 2017年 peijunjinrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubmitCardRequest : NSObject


/**
提交用户银行卡信息
*/
- (void)submitCardInfoWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb;

@end
