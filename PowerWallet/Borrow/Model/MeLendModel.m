//
//  MeLendModel.m
//  PowerWallet
//
//  Created by 清阳 on 2017/12/25.
//  Copyright © 2017年 peijunjinrong. All rights reserved.
//

#import "MeLendModel.h"

@implementation RepayTypeModel

+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"typeID"}];
}


@end

@implementation BorrowUseMdoel

+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"userID"}];
}

@end

@implementation YearRateMdoel

+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"yearID"}];
}

@end

@implementation ProtocolLendMdoel

@end

@implementation MeLendModel

@end

@implementation MeLendModelResponse

@end
