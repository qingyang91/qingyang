//
//  MainViewController.h
//  PowerWallet
//
//  Created by 清阳 on 2018/1/9.
//  Copyright © 2018年 peijunjinrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UITabBarController<UITabBarControllerDelegate>
//获取当前显示在最前面的页面的vc
- (id)getCurrentViewController;

@end
