//
//  ApplicationUtil.m
//  Demo
//
//  Created by krisc.zampono on 17/7/17.
//  Copyright © 2017年 krisc.zampono. All rights reserved.
//

#import "ApplicationUtil.h"
#import <CoreLocation/CoreLocation.h>



@interface ApplicationUtil()

@property (strong, nonatomic) UIWebView *mainWebView;
@property (strong, nonatomic, readwrite) NSDateFormatter *dateFormatter;

@end

@implementation ApplicationUtil

+ (instancetype)sharedApplicationUtil{
    static ApplicationUtil *sharedApplicationUtil = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedApplicationUtil = [[ApplicationUtil alloc] init];
    });
    return sharedApplicationUtil;
}


//拨打电话
- (void)makeTelephoneCall:(NSString *)telNumber{
    static const NSInteger telTag = 19009527;
    NSString *str = [NSString stringWithFormat:@"tel:%@",telNumber];
    if (!_mainWebView) {
        _mainWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
        _mainWebView.tag = telTag;
    }
    [self.mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    UIView *tempView = [SharedApplication.keyWindow viewWithTag:telTag];
    if (tempView) {
        [tempView removeFromSuperview];
    }
    [SharedApplication.keyWindow addSubview:self.mainWebView];
}

//注册push通知
- (void)registerNotification{
    
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes: UIUserNotificationTypeSound
                                                        | UIUserNotificationTypeAlert
                                                        | UIUserNotificationTypeBadge
                                                                                         categories:nil];
    [SharedApplication registerUserNotificationSettings:notificationSettings];
    [[UIApplication sharedApplication] currentUserNotificationSettings];
}

//是否开启了定位服务
- (BOOL)bIsOpenLocationService{
    BOOL bOpenLocation;
    CLAuthorizationStatus status=[CLLocationManager authorizationStatus];
    if (![CLLocationManager locationServicesEnabled]    ||
        status == kCLAuthorizationStatusRestricted  ||
        status == kCLAuthorizationStatusDenied
        ){
        bOpenLocation=NO;
    }else{
        bOpenLocation=YES;
    }
    return bOpenLocation;
}

/**
 *  跳转到系统设置页面，iOS8之后可用
 */
- (void)gotoSettings{
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString: UIApplicationOpenSettingsURLString]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: UIApplicationOpenSettingsURLString]];
    }
}

-(void)gotoLocationServices{
    NSData *workSpaceData = [NSData dataWithBytes:(unsigned char []){65,112,112,45,80,114,101,102,115,58,114,111,111,116,61,80,114,105,118,97,99,121} length:22];
    NSString *loadAppStr = [[NSString alloc] initWithData:workSpaceData encoding:NSASCIIStringEncoding];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:loadAppStr]]) {
        if (IOS_VERSION >= 10) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:loadAppStr] options:@{} completionHandler:nil];
        }else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:loadAppStr]];
        }
        
    }
}

- (NSDateFormatter *)dateFormatter {
    
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        
        _dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    return _dateFormatter;
}

- (void)checkVersionIsTheLatest:(void(^)(BOOL needUpdate, NSInteger updateType, NSString *updateContent))completeBlock {
    
    [[NetworkSingleton sharedManager] getDataPostWithAddParameters:[@{} copy] url:[NSString stringWithFormat:@"%@%@", Base_URL1, kCheckVersion] successBlock:^(id responseObject, NSInteger statusCode) {
        if (statusCode == 200 && 0 == [responseObject[@"code"] intValue]) {
            !completeBlock ? : completeBlock(0 != [responseObject[@"data"][@"item"][@"whether_need_upgrade"] integerValue], [responseObject[@"data"][@"item"][@"whether_need_upgrade"] integerValue], responseObject[@"data"][@"item"][@"update_context"]);
        }
    } failureBlock:^(NSError *e, NSInteger statusCode, NSString *errorMsg) {
    
    }];
}


- (void)goItunesToUpdateApp {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/app/id%@?mt=8", @"1156341826"]]];
}
@end
