//
//  AsteriskTool.m
//  PowerWallet
//
//  Created by krisc.zampono on 2017/5/3.
//  Copyright © 2017年 krisc.zampono. All rights reserved.
//

#import "AsteriskTool.h"

@implementation AsteriskTool
+(NSString *)phoneNumToAsterisk:(NSString*)phoneNum
{
    if(phoneNum.length>0){
        return [phoneNum stringByReplacingCharactersInRange:NSMakeRange(3,4) withString:@"****"];
    }else{
        return @"请登录";
    }
}
+(NSString*)idCardToAsterisk:(NSString *)idCardNum
{
    return [idCardNum stringByReplacingCharactersInRange:NSMakeRange(4, 10) withString:@"**********"];
}
@end
