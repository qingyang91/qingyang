//
//  MainViewController.m
//  PowerWallet
//
//  Created by 清阳 on 2018/1/9.
//  Copyright © 2018年 peijunjinrong. All rights reserved.
//

#import "MainViewController.h"

#import "MeViewController.h"
#import "UserManager.h"
#import "RootVC.h"
#import "BorrowLendVC.h"

#import "InteractivePopGestureDelegate.h"

@interface MainViewController ()<UITabBarControllerDelegate>

@property (nonatomic, strong) RootVC            * rootVc;
@property (nonatomic, strong) MeViewController              * vcMe;
@property (nonatomic, strong) BorrowLendVC      * vcLend;

@end

@implementation MainViewController

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
    self.selectedIndex = 2;
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
                                                        NSForegroundColorAttributeName:[UIColor orangeColor]}
                                             forState:UIControlStateSelected];
    
    //the color for selected icon
    //    [[UITabBar appearance] setSelectedImageTintColor:Color_Tabbar_Selected];
    [UITabBar appearance].tintColor = [UIColor orangeColor];
    [[UITabBar appearance] setBarTintColor:Color_White];
    
    _rootVc = [[RootVC alloc] init];
    UINavigationController *navigaitonVCHome = [self createNavigationControllerWithRootViewController:_rootVc title:@"贷款" image:ImageNamed(@"tabicon_01") selectImage:ImageNamed(@"icon_menu_helpulend_pressed")];
    
    _vcLend = [[BorrowLendVC alloc] init];
    UINavigationController *navigaitonVCLend = [self createNavigationControllerWithRootViewController:_vcLend title:@"借条" image:ImageNamed(@"icon_menu_helpulend_normal") selectImage:ImageNamed(@"icon_menu_helpulend_pressed")];
    
    _vcMe = [[MeViewController alloc] init];
    UINavigationController *navigaitonVCMe = [self createNavigationControllerWithRootViewController:_vcMe title:@"我的" image:ImageNamed(@"tabicon_03") selectImage:ImageNamed(@"icon_menu_more_pressed")];
    
    self.tabBar.translucent = NO;
    self.viewControllers = @[navigaitonVCLend,navigaitonVCHome,/**navigaitonVCMoments,*/navigaitonVCMe];
    
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
    if(![nav.viewControllers[0] isKindOfClass:[BorrowLendVC class]])
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
