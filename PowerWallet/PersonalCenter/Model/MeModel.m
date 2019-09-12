//
//  MeModel.m
//  PowerWallet
//
//  Created by Krisc.Zampono on 2017/2/13.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "MeModel.h"


@implementation  CradInfoModel

/**
 Description

 @param dict dict description
 @return return value description
 */
+(instancetype)cradInfoWithDict:(NSDictionary *)dict{
    CradInfoModel *model = [CradInfoModel mj_objectWithKeyValues:dict];
    return model;
}
@end

@implementation VerifyInfoModel


/**
 Description

 @param dict dict description
 @return return value description
 */
+(instancetype)verifyInfoWithDict:(NSDictionary *)dict{
    VerifyInfoModel *model = [VerifyInfoModel mj_objectWithKeyValues:dict];
    return model;
}
@end

@implementation CreditInfoModel

/**
 Description

 @param dict dict description
 @return return value description
 */
+(instancetype)creditInfoWithDict:(NSDictionary *)dict{
    CreditInfoModel *model = [CreditInfoModel mj_objectWithKeyValues:dict];
    return model;
}
@end

@implementation ServiceModel


/**
 Description

 @param dict dict description
 @return return value description
 */
+(instancetype)serviceWithDict:(NSDictionary *)dict{
    ServiceModel * model = [ServiceModel mj_objectWithKeyValues:dict];
    return model;
}
@end

@implementation MeModel

/**
 Description

 @param dict dict description
 @return return value description
 */
+(instancetype)meModelWithDic:(NSDictionary *)dict{
    MeModel *model = [MeModel mj_objectWithKeyValues:dict];
    return model;
}

/**
 Description

 @return return value description
 */
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"card_info" : @"CradInfoModel",
             @"verify_info" : @"VerifyInfoModel",
             @"credit_info" : @"CreditInfoModel",
             @"service" : @"ServiceModel"
             };
}
@end
