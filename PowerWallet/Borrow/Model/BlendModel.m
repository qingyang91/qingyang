//
//  BlendModel.m
//  PowerWallet
//
//  Created by 清阳 on 2017/12/25.
//  Copyright © 2017年 peijunjinrong. All rights reserved.
//

#import "BlendModel.h"

@implementation ImagesModel

@end

@implementation BlendModel

+(instancetype)helpLendWithDict:(NSDictionary *)dict{
    BlendModel *model = [BlendModel mj_objectWithKeyValues:dict];
    return model;
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"banners"      : @"ImagesModel"
             };
    
}
@end

