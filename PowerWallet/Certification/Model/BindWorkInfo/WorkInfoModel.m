//
//  WorkInfoModel.m
//  PowerWallet
//
//  Created by Krisc.Zampono on 2017/2/16.
//  Copyright © 2017年 Krisc.Zampono. All rights reserved.
//

#import "WorkInfoModel.h"



@implementation WorkTimeModel


/**
 Description

 @param dict dict description
 @return return value description
 */
+(instancetype)workTimeWithDictionary:(NSDictionary *)dict{
    WorkTimeModel *model = [WorkTimeModel mj_objectWithKeyValues:dict];
    return model;
}
@end

@implementation WorkInfoModel


/**
 Description

 @param dict dict description
 @return return value description
 */
+(instancetype)workInfoWithDictionary:(NSDictionary *)dict{
    
    WorkInfoModel *model = [WorkInfoModel mj_objectWithKeyValues:dict];
    return model;
}


/**
 Description

 @return return value description
 */
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"company_period_list" : @"WorkTimeModel"
             };
}


@end
