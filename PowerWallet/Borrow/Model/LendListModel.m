//
//  LendListModel.m
//  PowerWallet
//
//  Created by 清阳 on 2017/12/25.
//  Copyright © 2017年 peijunjinrong. All rights reserved.
//

#import "LendListModel.h"

@implementation LendItemModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"lendID" : @"id"};
}
@end

@implementation LendListModel
+(instancetype)helpLendWithDict:(NSDictionary *)dict{
    LendListModel *model = [LendListModel mj_objectWithKeyValues:dict];
    return model;
}
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"items"    : @"LendItemModel"
             };
}

@end

