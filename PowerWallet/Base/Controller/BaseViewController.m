//
//  BaseViewController.m
//  Demo
//
//  Created by Krisc.Zampono on 15/5/28.
//  Copyright (c) 2015年 Krisc.Zampono. All rights reserved.
//

#import "BaseViewController.h"
#import "UserManager.h"

#define kBtnChoosePictureHeight         50

#define Font_Choose_PictureItem         FontSystem(17.0f)
#define Color_Moments_ChooseBg          UIColorFromRGB(0xe5e5e5)

@interface BaseViewController () {
    BOOL isNotShowStatusBar;
    UIImageView *navBarHairlineImageView;
}

@property (strong, nonatomic) MBProgressHUD             *progressHud;
@property (assign, nonatomic) BOOL                      isHeadQuarter;
@property (strong, nonatomic) MBProgressHUD *loadingHud;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
}

- (void)configUI{
    
    //设置UINavigationbar
    if([self respondsToSelector:@selector(edgesForExtendedLayout)])
        [self setEdgesForExtendedLayout:UIRectEdgeBottom];
    self.navigationController.navigationBar.translucent = NO;
    _progressHud = [[MBProgressHUD alloc] initWithView:self.view];
    self.progressHud.bezelView.alpha = 0.5;
    
    self.isRequestProcessing = NO;
}

//找到UINavigationBar下面的线
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //设置title颜色和大小
    [NotificationCenter addObserver:self selector:@selector(showLogin) name:kNotificationNeedLogin object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [NotificationCenter removeObserver:self name:kNotificationNeedLogin object:nil];
    [super viewWillDisappear:animated];
}

- (void)showLogin{
    [[UserManager sharedUserManager] showLoginPage:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)showMessage:(NSString *)msg{
    if ([msg isEqualToString:@""]) {
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.animationType = MBProgressHUDAnimationZoomOut;
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text = msg;
    hud.detailsLabel.font = FONT(18);
    hud.margin = 15;
    hud.backgroundView.alpha = 0.8;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2.0];
}

- (void)showLoading:(NSString *)msg{
    
    self.loadingHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    self.loadingHud.label.text = @"加载中...";
    self.loadingHud.backgroundView.alpha = 0.8;
}

- (void)hideLoading{
    [self.loadingHud hideAnimated:YES];
}

#pragma --mark 页面基本设置
/**
 *  页面基本设置,页面背景颜色、页面是否包含返回按钮、对返回按钮做相应的处理
 *
 *  @param gobackType 页面返回类型
 */
- (void)baseSetup:(PageGobackType)gobackType{
    
    //设置页面背景
    self.view.backgroundColor = Color_Background;
    
    //设置返回按钮
    if (gobackType != PageGobackTypeNone) {
        UIButton *btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        
        [btnLeft setTitle:@"" forState:UIControlStateNormal];
        //        [btnLeft setBackgroundImage:ImageNamed(@"navigationBar_popBack") forState:UIControlStateNormal];
        [btnLeft setImage:ImageNamed(@"navigationBar_popBack") forState:UIControlStateNormal];
        btnLeft.contentMode = UIViewContentModeScaleAspectFit;
        //        btnLeft.backgroundColor = [UIColor redColor];
        [btnLeft setImageEdgeInsets:UIEdgeInsetsMake(5,5,5,5)];
        
        if (gobackType == PageGobackTypePop) {
            [btnLeft addTarget:self action:@selector(popVC) forControlEvents:UIControlEventTouchUpInside];
        }else if (gobackType == PageGobackTypeDismiss){
            [btnLeft addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
        }else if (gobackType == PageGobackTypeRoot){
            [btnLeft addTarget:self action:@selector(popToRoot) forControlEvents:UIControlEventTouchUpInside];
        }
        
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
        
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -5;
        (self.navigationItem).leftBarButtonItems = @[negativeSpacer,leftItem];
    }else{
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:[UIView new]];
        (self.navigationItem).leftBarButtonItem = leftItem;
    }
}

/**
 *  dimiss页面
 */
- (void)dismissVC{
    [self dismissViewControllerAnimated:YES completion:nil];
    self.tabBarController.tabBar.hidden = NO;
}

/**
 *返回任意一个页面
 */
- (void)popToViewControllerAtIndex:(NSInteger)index{
    if (self.navigationController.viewControllers.count > index) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index] animated:YES];
    }
}

/**
 *popToRoot页面
 */
- (void)popToRoot{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/**
 *  pop页面
 */
- (void)popVC{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dsPushViewController:(UIViewController*)vc animated:(BOOL)animated{
    if (self.navigationController.viewControllers.count == 1) {
        vc.hidesBottomBarWhenPushed = YES;
    }
    [self.navigationController pushViewController:vc animated:animated];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

-(void)umengEvent:(NSString *)eventId attributes:(NSDictionary *)attributes number:(NSNumber *)number {
    NSString *numberKey = @"__ct__";
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:attributes];
    [mutableDictionary setObject:[number stringValue] forKey:numberKey];
}

#if DEBUG
- (void)dealloc {
    
    NSLog(@"%@ class release", NSStringFromClass([self class]));
}
#endif
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
