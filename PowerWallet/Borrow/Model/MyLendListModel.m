//
//  MyLendListModel.m
//  PowerWallet
//
//  Created by 清阳 on 2018/1/15.
//  Copyright © 2018年 peijunjinrong. All rights reserved.
//

#import "MyLendListModel.h"

@implementation MyLendItemModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"lendID" : @"id"};
}
@end

@implementation MyLendListModel
+(instancetype)helpLendWithDict:(NSDictionary *)dict{
    MyLendListModel *model = [MyLendListModel mj_objectWithKeyValues:dict];
    return model;
}
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"items"    : @"MyLendItemModel"
             };
}
@end
