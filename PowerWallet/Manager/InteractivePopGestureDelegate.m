//
//  InteractivePopGestureDelegate.m
//  PowerWallet
//
//  Created by Krisc.Zampono on 2017/4/5.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "InteractivePopGestureDelegate.h"

@interface UINavigationController (RetainPopDelegate)

@property (strong, nonatomic) id popDelegate;

@end

@implementation UINavigationController (RetainPopDelegate)

- (void)setPopDelegate:(id)popDelegate {
    objc_setAssociatedObject(self, @selector(popDelegate), popDelegate, OBJC_ASSOCIATION_RETAIN);
}
- (id)popDelegate {
    return objc_getAssociatedObject(self, _cmd);
}

@end

@interface InteractivePopGestureDelegate ()

@property (weak, nonatomic) UINavigationController *navigationViewController;

@end

@implementation InteractivePopGestureDelegate


/**
 Description

 @param navigationViewController
 @return
 */
+ (instancetype)interactivePopGestureDelegateWithNavigationViewController:(UINavigationController *)navigationViewController {
    
    return [[[self class] alloc] initWithNavigationViewController:navigationViewController];
}


/**
 Description

 @param navigationViewController
 @return 
 */
- (instancetype)initWithNavigationViewController:(UINavigationController *)navigationViewController {
    
    if (self = [super init]) {
        _navigationViewController = navigationViewController;
        _navigationViewController.popDelegate = self; //利用Navigation保持代理不被释放
    }
    return self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if ([self.navigationViewController.transitionCoordinator isAnimated] || (self.navigationViewController.viewControllers.count < 2)) {
        return NO;
    } else {
        return YES;
    }
}
//***************************************no use**************************************************
//***************************************no use**************************************************
//no use
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
