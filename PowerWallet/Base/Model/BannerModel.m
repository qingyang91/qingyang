//
//  BannerModel.m
//  PowerWallet
//
//  Created by Krisc.Zampono on 2017/8/22.
//  Copyright © 2017年 Jueling. All rights reserved.
//

#import "BannerModel.h"

@implementation BannerModel


/**
 Description

 @param dict dict description
 @return return value description
 */
+(instancetype)bannerWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

/**
 Description

 @param dict dict description
 @return return value description
 */
-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.img                = dict[@"img"];
        self.banner_type        = [dict[@"banner_type"] intValue];
        self.banner_h5          = dict[@"banner_h5"];
        self.banner_download    = dict[@"banner_download"];
        self.pid                = dict[@"pid"];
        
        self.banner_ios_h5      = dict[@"banner_ios_h5"];
        self.banner_ios_download = dict[@"banner_ios_download"];
    }
    return self;
}
@end
