//
//  AppDelegate.m
//  PowerWallet
//
//  Created by krisc.zampono on 17/7/17.
//  Copyright © 2017年 krisc.zampono. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarVC.h"
#import "GDLocationManager.h"
#import "QQShareManager.h"
#import "WXShareManager.h"
#import "KDShareHeader.h"
#import "DSNetWorkStatus.h"
#import "GetContactsBook.h"
#import <MGLivenessDetection/MGLivenessDetection.h>
#import "APPList.h"
#import "UserManager.h"
#import "KDAlertView.h"
#import <Bugly/Bugly.h>
#import "UtilRequest.h"
#import <AdSupport/AdSupport.h>
#import "ReportInterface.h"
#import "GetContactsBook.h"
#import "LoginVC.h"
#import "VersionModel.h"
#import "MainViewController.h"
#import "LoginViewController.h"
#import "YBBKeychain.h"
//#import "WQPermissionRequest.h"
@interface AppDelegate ()<BuglyDelegate>
//{
//    UtilRequest *uti;
//}
//@property (nonatomic,  strong)VersionModel *model;
//@property (nonatomic , strong)VersionJudgeRequest *request;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //监听网络状态
//    [DSNetWorkStatus sharedNetWorkStatus];
//    [self setBugly];
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor clearColor];
     [GDLocationManager registerGD];
    // nabigationBar阴影
    [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    // navigationBar是否半透明模糊处理，此项设置将影响有navigationBar的ViewController的布局
    [UINavigationBar appearance].translucent = NO;
    // 背景颜色
    [UINavigationBar appearance].barTintColor = Color_Nav;
    // 导航栏中间标题样式
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor whiteColor], NSForegroundColorAttributeName,
                                                          Font_Navigationbar_Title, NSFontAttributeName, nil]];
    UIViewController *vc = [[UIViewController alloc]initWithNibName:nil bundle:nil];
    self.window.rootViewController = vc;
    [Bugly startWithAppId:BuglyID];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [[ReportInterface shareMasterReport] responceContent:YES];
////        [[ReportInterface shareMasterReport] upLoadAddressBook];
//        [WXShareManager resigterWXApp:wxAppid];
//
//        // 信鸽初始化
////        [[MessageManager sharedManager] initXG:launchOptions];
//        //注册face++
//        [MGLicenseManager licenseForNetWokrFinish:^(bool License) {
//            NSLog(@"SDK 授权【%@】", License ? @"成功" : @"失败");
//        }];
//    });
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:-1];
    [APPList getAppsInfo];
    [self AppHao];
//以下是AB版逻辑
//#ifndef SIMULATOR_TEST
//    NSString *saveVersion = [UserDefaults objectForKey:@"version"];
//    if (![CurrentAppVersion isEqualToString:saveVersion]) {
//        [UserDefaults setObject:CurrentAppVersion forKey:@"version"];
//        if ([SINGLETONREQUEST determinePermission:WQNetwork] == NO) {
//            UITableViewController* myvc = [[UITableViewController alloc] initWithNibName:nil bundle:nil];
//            myvc.tableView.backgroundColor = [UIColor whiteColor];
//            myvc.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//            myvc.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(judgeVersion)];
//            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:myvc];
//            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(80, 64, SCREEN_WIDTH-160, 20)];
//            label.text = @"下拉刷新";
//            label.font = [UIFont systemFontOfSize:19];
//            label.textColor = [UIColor orangeColor];
//            label.textAlignment = NSTextAlignmentCenter;
//            myvc.tableView.tableHeaderView = label;
//            self.window.rootViewController = nav;
//        }
//    }else{
//        [self judgeVersion];
//    }
    
//#else
//    [self judgeVersion];
//#endif
    [self goToVersionB];
    [self.window makeKeyAndVisible];
//    [self VersonUpdate];
    return YES;
}
- (VersionModel *)model{
    if (!_model) {
        _model = [[VersionModel alloc]init];
    }
    return _model;
}

-(VersionJudgeRequest *)request {
    if (!_request) {
        _request = [[VersionJudgeRequest alloc] init];
    }
    return _request;
}

- (void)judgeVersion {
    [self.request getVersionSuccess:^(NSDictionary *dictResult) {
        _model = [VersionModel versionWithDict:dictResult];
        if ([_model.approve_version isEqualToString:@"0"]) {
            [self goToVersionB];
        }
        else {
            [self goToVersionA];
        }
    } andFailed:^(NSInteger code, NSString *errorMsg) {
        [self goToVersionA];
    }];
}

- (void)goToVersionA {
    //计算器记事本等审核版本逻辑
        if ([[UserManager sharedUserManager] isLogin] == NO) {
            LoginVC *vc = [[LoginVC alloc]init];
            UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:vc];
            self.window.rootViewController = navVC;
        }else{
             [self gotoPingtiaoTabbarController];
        }
}

- (void)goToVersionB {
    //现有逻辑
    [self gotoJietiaoTabbarController];
}
//创建tabbarVC
- (void)gotoPingtiaoTabbarController {
    MainTabBarVC *vcMainTabbar = [[MainTabBarVC alloc] init];
    self.window.rootViewController = vcMainTabbar;
    self.window.backgroundColor = [UIColor whiteColor];
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
- (void)gotoJietiaoTabbarController{
    MainViewController *vcMainTabbar = [[MainViewController alloc]init];
    self.window.rootViewController = vcMainTabbar;
    self.window.backgroundColor = [UIColor whiteColor];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSString * UrlStr = [url absoluteString];
    if([UrlStr hasPrefix:@"wx"])
    {
        return [WXShareManager wxHandleOpenURL:url delegate:(id)[WXShareManager shareInstance]];
    }else if([UrlStr hasPrefix:@"LYBiOSqqZone"])
    {
        return [QQShareManager qqHandleOpenURL:url delegate:(id)[QQShareManager shareInstance]];
    }
    return  YES;
}

#pragma mark - 推送回调函数
// 想苹果注册推送，在调用 registerForRemoteNotificationTypes “成功”后会触发这个回调函数
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
//    [[MessageManager sharedManager] registerDeviceToken:deviceToken];
}

// 想苹果注册推送，在调用 registerForRemoteNotificationTypes “失败”后会触发这个回调函数
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError is %@",error);
    NSLog(@"Failed to register for remote notifications: %@", [error description]);
}
// 消息推送: 消息推送时应用正在运行，会进入到这里，
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"didReceiveRemoteNotification is %@",userInfo);
//    [[MessageManager sharedManager] handleReceiveNotification:userInfo withVC:vc];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"didReceiveLocalNotification received message is %@",notification);
//    [[MessageManager sharedManager] jumpToWhereWithLocalNotification:notification];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self AppHao];
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//    if ([UserManager sharedUserManager].isLogin) {
//        [GetContactsBook CheckAddressBookAuthorization:^(bool isAuthorized) {
//            if (isAuthorized) {
//                [[GetContactsBook shareControl] upLoadAddressBook];
//            }
//        }];
//    }
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    

}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)AppHao{
    if (uti == nil){
        uti = [[UtilRequest alloc] init];
    }
    [uti contrastVersionWithDict:@"102" onSuccess:^(NSDictionary *dictResult){
        int code = [dictResult[@"code"] intValue];
        if(code!=0){
            
            NSString *msg = dictResult[@"msg"];
            msg = msg.length>0 ? msg : [NSString stringWithFormat:@"版本过低，需要升级到最新版本"];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"升级提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"现在升级" style:UIAlertActionStyleDestructive handler:^(UIAlertAction*action) {
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/%E9%9B%B6%E7%94%A8%E7%AE%A1%E5%AE%B6/id1329657656?l=zh&ls=1&mt=8"]];
                [[UIApplication sharedApplication]openURL:url];
            }];
            [alertController addAction:otherAction];
            [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
        }
        
    } andFailed:^(NSInteger code,NSString *errorMsg){
        
    }];
}

-(void)setBugly{
    
    [Bugly startWithAppId:BuglyID config:^{
        BuglyConfig *config = [[BuglyConfig alloc] init];
        config.blockMonitorEnable = YES;
        config.blockMonitorTimeout = 2;
        config.consolelogEnable = YES;
        config.delegate = self;
        return config;
    }()];
}

-(NSString *)attachmentForException:(NSException *)exception{
    return @"卡顿";
}

-(void)VersonUpdate{
    
    //定义app地址
    NSString *urld = [NSString  stringWithFormat:@"http://itunes.apple.com/cn/lookup?id=%@",appstoreID];
    urld = [urld stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urld];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"%@",response);
        
        NSMutableDictionary *receiveStatusDic = [[NSMutableDictionary alloc]init];
        
        if (data) {
            
            NSDictionary *receiveDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if ([[receiveDic valueForKey:@"resultCount"] intValue] > 0) {
                
                [receiveStatusDic setObject:@"1" forKey:@"status"];
                
                [receiveStatusDic setObject:[[[receiveDic valueForKey:@"results"] objectAtIndex:0] valueForKey:@"version"]  forKey:@"version"];
                
                [self performSelectorOnMainThread:@selector(receiveData:) withObject:receiveStatusDic waitUntilDone:NO];
                
                
            }else{
                
                [receiveStatusDic setValue:@"1" forKey:@"status"];
                
                
            }
        }else{
            
            
            [receiveStatusDic setValue:@"-1" forKey:@"status"];
        }
        
        
    }];
    
    [task resume];
    
}
-(void)receiveData:(id)sender
{
    //获取APP自身版本号
    NSString *localVersion = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    
    NSArray *localArray = [localVersion componentsSeparatedByString:@"."];//1.0
    NSArray *versionArray = [sender[@"version"] componentsSeparatedByString:@"."];//3 2.1.1
    
    if ([localArray[0] intValue] < [versionArray[0] intValue]) {
        
        [self updateVersion];
        
    }else if ([localArray[0] intValue] == [versionArray[0] intValue]){
        if (versionArray.count > 2) {
            if ([localArray[1] intValue] < [versionArray[1] intValue]) {
                [self updateVersion];
                
            }else if ([localArray[1] intValue] == [versionArray[1] intValue]){
                if (versionArray.count > 1) {
                    if ([localArray[2] intValue] < [versionArray[2] intValue]) {
                        [self updateVersion];
                    }
                }
            }
        }
        
    }
}

-(void)updateVersion{
    
    NSString *msg = [NSString stringWithFormat:@"版本过低，需要升级到最新版本"];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"升级提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"现在升级" style:UIAlertActionStyleDestructive handler:^(UIAlertAction*action) {
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/%E9%9B%B6%E7%94%A8%E7%AE%A1%E5%AE%B6/id1329657656?l=zh&ls=1&mt=8"]];
        [[UIApplication sharedApplication]openURL:url];
    }];
    [alertController addAction:otherAction];
    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
    
}

@end
