//
//  PersonalInformationModel.m
//  PowerWallet
//
//  Created by Krisc.Zampono on 2017/2/17.
//  Copyright © 2017年 Krisc.Zampono. All rights reserved.
//

#import "PersonalInformationModel.h"

@implementation DegreesModel


/**
 Description

 @param dict dict description
 @return return value description
 */
+(instancetype)degressWithDict:(NSDictionary *)dict{
    DegreesModel *model = [DegreesModel mj_objectWithKeyValues:dict];
    return model;
}
@end


/**
 Description
 */
@implementation LiveTimeTypeModel
+(instancetype)liveTimeTypeWithDict:(NSDictionary *)dict{
    LiveTimeTypeModel *model = [LiveTimeTypeModel mj_objectWithKeyValues:dict];
    return model;
}
@end


/**
 Description
 */
@implementation MarriageModel
+(instancetype)marriageWithDict:(NSDictionary *)dict{
    MarriageModel *model = [MarriageModel mj_objectWithKeyValues:dict];
    return model;
}
@end
@implementation PersonalInformationModel


/**
 Description

 @return return value description
 */
- (BOOL)informationIsComplete {
    
    return 0 != self.address.length && 0 != self.address_distinct.length;
}


/**
 Description

 @return return value description
 */
- (NSString *)lackOfInformationDescription {
    if (0 == self.address_distinct.length) {
        return @"请填写现居地址";
    }
    if (0 == self.address.length) {
        return @"请填写详细地址";
    }
    return @"信息不全，请完善信息";
}


/**
 Description

 @param dict dict description
 @return return value description
 */
+(instancetype)personalInfoWithDict:(NSDictionary *)dict{
    PersonalInformationModel *model = [PersonalInformationModel mj_objectWithKeyValues:dict];
    return model;
}

/**
 Description

 @return return value description
 */
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"degrees_all" : @"DegreesModel",
             @"live_time_type_all" : @"LiveTimeTypeModel",
             @"marriage_all" : @"MarriageModel"
             };
}
@end
