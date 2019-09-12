//
//  AsteriskTool.h
//  PowerWallet
//
//  Created by krisc.zampono on 2017/5/3.
//  Copyright © 2017年 krisc.zampono. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AsteriskTool : NSObject
//把手机号第4-7位变成星号
+(NSString *)phoneNumToAsterisk:(NSString*)phoneNum;
//把身份证第5-14位变成星号
+(NSString *)idCardToAsterisk:(NSString *)idCardNum;
@end
