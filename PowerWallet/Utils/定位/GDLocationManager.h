//
//  GDLocationManager.h
//  PowerWallet
//
//  Created by krisc.zampono on 2017/2/6.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

static NSString *APIKey = @"dd85e38defaf7e20e810a2f88b54fcd5";

typedef void(^locationSucceedBlock)(AMapLocationReGeocode *regeoCode,NSString *errorStr);
typedef void(^locationSucceedUploadBlock)(AMapLocationReGeocode *regeoCode,NSString *errorStr,CLLocation *location);

@interface GDLocationManager : NSObject

+ (instancetype) shareInstance;
/**
 *  注册高的地图
 *
 */
+ (void)registerGD;
//开始定位
- (void) startLocation;
//判断是否开启定位
- (BOOL)isOpenLocationServices;
/**
 *  定位成功回调block
 */
@property (nonatomic, copy) locationSucceedBlock locationSuccessBlock;
/**
 *  上报block
 */
@property (nonatomic, copy) locationSucceedUploadBlock locationUploadBlock;

@end
