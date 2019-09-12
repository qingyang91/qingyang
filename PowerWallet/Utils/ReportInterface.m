//
//  ReportInterfaceDelegate.m
//  PowerWallet
//
//  Created by PowerWallet on 2017/2/6.
//  Copyright © 2017年 Krisc.Zampono. All rights reserved.
//

#import "ReportInterface.h"
#import "UtilRequest.h"
#import "UserManager.h"
#import <AdSupport/AdSupport.h>
#import "DSUtils.h"
#import "GetContactsBook.h"
#import "LoginOrRegistRequest.h"
#import "NetworkSingleton.h"
#import <sys/utsname.h>
@interface ReportInterface ()

@property (nonatomic, strong) UtilRequest * request;
@property (nonatomic, strong) LoginOrRegistRequest *logotRequest;
@end

@implementation ReportInterface

static ReportInterface * _shareReportReport = nil;
+ (ReportInterface *)shareMasterReport {
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        if (!_shareReportReport) {
            _shareReportReport = [[self alloc] init];
        }
    });
    return _shareReportReport;
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)responceContent:(BOOL)status {
    NSString * uid = @"";
    NSString * userName = @"";
    NSString * deviceID = @"";
    NSString * installTime = @"";
    NSString * appmarket = @"AppStore";
    NSString * adId = [self deviceVersion];
    
    if ([UserManager sharedUserManager].userInfo.uid != 0) {
        uid = [UserManager sharedUserManager].userInfo.uid;
    }
    if ([UserManager sharedUserManager].userInfo.username != 0) {
        userName = [UserManager sharedUserManager].userInfo.username;
    }
    deviceID = [DSUtils getUUIDString];
    
    installTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"installTime"];
    
    if (status) {
        NSDate * today = [NSDate date];
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyy-MM-dd HH:mm:ss"];
        NSString *timeStr = [formatter stringFromDate:today];
        if (installTime.length == 0 || installTime == nil) {
            [[NSUserDefaults standardUserDefaults] setObject:timeStr forKey:@"installTime"];
            installTime = timeStr;
        }
    }
    
    [[NetworkSingleton sharedManager] reachabilityStatus:^(NSString *status){
        
        if (![status isEqualToString:@"WiFi"]) {
            status = [self getNetworkType];
        }
        NSDictionary * parm = [NSDictionary dictionaryWithObjectsAndKeys:adId,@"IdentifierId",appmarket,@"appMarket",deviceID, @"device_id", installTime, @"installed_time",uid,@"uid",userName,@"username",status,@"net_type", nil];
        [self.request appDeviceReportWithDict:parm onSuccess:^(NSDictionary *dictResult) {
            
            NSLog(@"上报信息成功");
            
        } andFailed:^(NSInteger code, NSString *errorMsg) {
            NSLog(@"requestFailed %@",errorMsg);
            NSLog(@"上报信息失败");
            
        }];
    }];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"repayDate"];
        [self.logotRequest LoginOutWihtDict:nil onSuccess:^(NSDictionary *dictResult) {
            
        } andFailed:^(NSInteger code, NSString *errorMsg) {
            
        }];
    }else{
        NSLog(@"不是第一次启动");
    }
}

- (void)upLoadAddressBook {
    [[GetContactsBook shareControl] upLoadAddressBook];
}

//获取网络状态
//获取网络状态
- (NSString *)getNetworkType{
    // 状态栏是由当前app控制的，首先获取当前app
    UIApplication *app = [UIApplication sharedApplication];
    
    NSData *statusData = [NSData dataWithBytes:(unsigned char []){115,116,97,116,117,115,66,97,114} length:9];
    NSString *startusViewBar = [[NSString alloc] initWithData:statusData encoding:NSASCIIStringEncoding];
    
    NSData *fgViewData = [NSData dataWithBytes:(unsigned char []){102,111,114,101,103,114,111,117,110,100,86,105,101,119} length:14];
    NSString *fgViewStr = [[NSString alloc] initWithData:fgViewData encoding:NSASCIIStringEncoding];
    
    NSData *itemData = [NSData dataWithBytes:(unsigned char []){85,73,83,116,97,116,117,115,66,97,114,68,97,116,97,78,101,116,119,111,114,107,73,116,101,109,86,105,101,119} length:30];
    NSString *itemStr = [[NSString alloc] initWithData:itemData encoding:NSASCIIStringEncoding];
    
    NSData *networkTypeData = [NSData dataWithBytes:(unsigned char []){100,97,116,97,78,101,116,119,111,114,107,84,121,112,101} length:15];
    NSString *networkTypeStr = [[NSString alloc] initWithData:networkTypeData encoding:NSASCIIStringEncoding];
    
    NSData *modern = [NSData dataWithBytes:(unsigned char []){85,73,83,116,97,116,117,115,66,97,114,95,77,111,100,101,114,110} length:18];
    NSString *modernStr = [[NSString alloc] initWithData:modern encoding:NSASCIIStringEncoding];
    
    NSArray *children;
    if ([[app valueForKeyPath:startusViewBar] isKindOfClass:NSClassFromString(modernStr)]) {
        children = [[[[app valueForKeyPath:startusViewBar] valueForKeyPath:startusViewBar] valueForKeyPath:fgViewStr] subviews];
    } else {
        children = [[[app valueForKeyPath:startusViewBar] valueForKeyPath:fgViewStr] subviews];
    }
    
    int type = 0;
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(itemStr)]) {
            type = [[child valueForKeyPath:networkTypeStr] intValue];
        }
    }
    switch (type) {
        case 1:
            return @"2G";
            break;
        case 2:
            return @"3G";
        case 3:
            return @"4G";
        case 5:
            return @"WIFI";
        default:
            return @"NO-WIFI";//代表未知网络
            break;
    }
}

- (UtilRequest *)request {
    if (!_request) {
        _request = [[UtilRequest alloc] init];
    }
    return _request;
}

-(LoginOrRegistRequest *)logotRequest{
    if (!_logotRequest) {
        _logotRequest = [[LoginOrRegistRequest alloc] init];
    }
    return _logotRequest;
}

//手机型号
//记得导入#import "sys/utsname.h"
- (NSString*)deviceVersion
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])
        return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])
        return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])
        return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])
        return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])
        return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])
        return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])
        return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])
        return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])
        return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])
        return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])
        return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])
        return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])
        return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])
        return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])
        return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])
        return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone9,1"] || [deviceString isEqualToString:@"iPhone9,3"])
        return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"] || [deviceString isEqualToString:@"iPhone9,4"])
        return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"] || [deviceString isEqualToString:@"iPhone10,4"])
        return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"] || [deviceString isEqualToString:@"iPhone10,5"])
        return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"] || [deviceString isEqualToString:@"iPhone10,6"])
        return @"iPhone X";
    
    return deviceString;
}

@end
