//
//  GoodLendModel.m
//  PowerWallet
//
//  Created by 清阳 on 2018/1/16.
//  Copyright © 2018年 peijunjinrong. All rights reserved.
//

#import "GoodLendModel.h"

@implementation BorrowUserModel

@end

@implementation GoodItemModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"lendID" : @"id"};
}

@end

@implementation GoodLendModel
+(instancetype)helpLendWithDict:(NSDictionary *)dict{
    GoodLendModel *model = [GoodLendModel mj_objectWithKeyValues:dict];
    return model;
}
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"items"    : @"GoodItemModel"
             };
}
@end
