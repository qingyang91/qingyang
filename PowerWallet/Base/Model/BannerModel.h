//
//  BannerModel.h
//  PowerWallet
//
//  Created by Krisc.Zampono on 2017/8/22.
//  Copyright © 2017年 Jueling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BannerModel : NSObject
@property (retain, nonatomic)  NSString *img;
@property (assign, nonatomic)  int banner_type;
@property (retain, nonatomic)  NSString *banner_h5;
@property (retain, nonatomic)  NSString *banner_download;
@property (retain, nonatomic)  NSString *pid;
@property (retain, nonatomic)  NSString *AppleAppId;

@property (retain, nonatomic)  NSString *banner_ios_h5;
@property (retain, nonatomic)  NSString *banner_ios_download;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)bannerWithDict:(NSDictionary *)dict;
@end
