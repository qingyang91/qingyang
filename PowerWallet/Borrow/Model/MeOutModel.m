//
//  MeOutModel.m
//  PowerWallet
//
//  Created by 清阳 on 2017/12/25.
//  Copyright © 2017年 peijunjinrong. All rights reserved.
//

#import "MeOutModel.h"

@implementation LendMoneyCountModel

+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"countid"}];
}

@end

@implementation TypeModel

+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"repayid"}];
}

@end

@implementation LendDayModel

+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"dayID"}];
}

@end

@implementation RateModel

+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"rateid"}];
}

@end

@implementation MustInfoModel

+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"infoid"}];
}

@end

@implementation ProtocolModel


@end


@implementation MeOutModel

@end

@implementation MeOutModelResponse

@end
