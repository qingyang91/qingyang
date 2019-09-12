//
//  RootItemMode.m
//  PowerWallet
//
//  Created by Krisc.Zampono on 2017/8/8.
//  Copyright © 2017年 Jueling. All rights reserved.
//

#import "HomeModel.h"
@implementation RollModel

@end

@implementation HomeModel


/**
 Description

 @param dict dict description
 @return return value description   
 */
+ (instancetype)homeWithDict:(NSDictionary *)dict{
    HomeModel *model = [HomeModel mj_objectWithKeyValues:dict];
    return model;
}


/**
 Description

 @return return value description
 */
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"banner" : @"BannerModel",
             @"list" : @"PartnerInfoModel"
             };
}

@end
