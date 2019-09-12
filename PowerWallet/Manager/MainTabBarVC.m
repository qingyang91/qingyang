//
//  MainTabBarVC.m
//  MeiXiang
//
//  Created by Krisc.Zampono on 16/3/25.
//  Copyright © 2016年 Krisc.Zampono. All rights reserved.
//

#import "MainTabBarVC.h"
#import "MeVC.h"
#import "UserManager.h"
#import "RootVC.h"
#import "InteractivePopGestureDelegate.h"

@interface MainTabBarVC ()<UITabBarControllerDelegate>

@property (nonatomic, strong) MeVC              * vcMe;


@end

@implementation MainTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpViewController];
    self.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpTabItem) name:@"loginSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOut) name:@"loginOut" object:nil];
}

- (void)loginOut{
    
    self.selectedIndex = 0;
//    [XGPush unRegisterDevice:^{
//        // 信鸽初始化
//        [UserManager sharedUserManager].userInfo.username = @"";
//        [[MessageManager sharedManager] initXG:nil];
//        //角标清0
//        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:-1];
//    } errorCallback:^{
//        
//    }];
}
- (void)jumpTabItem{
//    self.selectedIndex = 2;
//    [XGPush unRegisterDevice];
    // 信鸽初始化
//    [[MessageManager sharedManager] initXG:nil];
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:-1];
}

- (void)setUpViewController {
    self.view.backgroundColor = Color_Background;
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:Font_Tabbar_Title,
                                                        NSForegroundColorAttributeName:Color_Tabbar_Normal}
                                             forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:Font_Tabbar_Title,
                                                        NSForegroundColorAttributeName:[UIColor blueColor]}
                                             forState:UIControlStateSelected];
    
    //the color for selected icon
//    [[UITabBar appearance] setSelectedImageTintColor:Color_Tabbar_Selected];
    [UITabBar appearance].tintColor = [UIColor blueColor];
    [[UITabBar appearance] setBarTintColor:Color_White];
    _vcMe = [[MeVC alloc] init];
    UINavigationController *navigaitonVCMe = [self createNavigationControllerWithRootViewController:_vcMe title:@"我的" image:ImageNamed(@"tabicon_03") selectImage:ImageNamed(@"icon_menu_more_pressed")];

    self.tabBar.translucent = NO;
    self.viewControllers = @[navigaitonVCMe];
    
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    UIView *vLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    vLine.backgroundColor = Color_Tabbar_LineColor;
    [self.tabBar addSubview:vLine];
}

- (UINavigationController *)createNavigationControllerWithRootViewController:(UIViewController *)viewController title:(NSString *)title image:(UIImage *)image selectImage:(UIImage *)selectImg{
    NSAssert(nil != viewController, @"rootViewController 参数不对");
    
    UINavigationController *result = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    result.tabBarItem.title = title;
    result.tabBarItem.image = image;
    result.tabBarItem.selectedImage = selectImg;
    result.interactivePopGestureRecognizer.enabled = YES;
    result.interactivePopGestureRecognizer.delegate = [InteractivePopGestureDelegate interactivePopGestureDelegateWithNavigationViewController:result];
    
    return result;
}


#pragma mark -- tabBarController delegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    UINavigationController *nav = (UINavigationController *)viewController;
    if(![nav.viewControllers[0] isKindOfClass:[RootVC class]])
    {
        if(![[UserManager sharedUserManager] isLogin])
        {
            
            [[UserManager sharedUserManager]showLoginPage:viewController];
            
            //            __weak typeof(self) weakSelf = self;
            
            return NO;
        }else{
            return YES;
        }
    }
    return YES;
}

//获取当前显示在最前面的页面的vc
- (id)getCurrentViewController
{
    UINavigationController *navNow = [self.viewControllers objectAtIndex:self.selectedIndex];
    return [navNow.viewControllers objectAtIndex:[navNow.viewControllers count] - 1];
}
//***************************************no use**************************************************
//***************************************no use**************************************************
- (void)thisIsUselessForSure{
    UIView  *preview;
    UIView *iconView;
    UIView *toolBarView;
    UILabel *sizeLabel;
    if (preview ) {
        if (!iconView) {
            iconView = [[UIView alloc] init];
            iconView.backgroundColor = [UIColor blackColor];
            iconView.contentMode = UIViewContentModeScaleAspectFit;
            [preview addSubview:iconView];
            [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
        }
        if (!toolBarView) {
            toolBarView = [UIView new];
            toolBarView.backgroundColor = [UIColor whiteColor];
            [preview addSubview:toolBarView];
        }
        if (!sizeLabel) {
            sizeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            sizeLabel.textAlignment = NSTextAlignmentCenter;
            sizeLabel.textColor =  [UIColor whiteColor];
            sizeLabel.font = [UIFont systemFontOfSize:14];
            sizeLabel.text = @"正在下载中...";
            [toolBarView addSubview:sizeLabel];
        }
    }
}
//***************************************no use**************************************************
@end
