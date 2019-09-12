//
//  MainTabBarVC.h
//  MeiXiang
//
//  Created by Krisc.Zampono on 16/3/25.
//  Copyright © 2016年 Krisc.Zampono. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTabBarVC : UITabBarController<UITabBarControllerDelegate>

//获取当前显示在最前面的页面的vc
- (id)getCurrentViewController;

@end
