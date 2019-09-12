//
//  SecondLevelViewController.h
//  RongTeng
//
//  Created by Krisc.Zampono on 16/1/18.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "BaseViewController.h"
#import "NoNetReloadView.h"

typedef void(^showHandler)(NSInteger statusCode);

@interface SecondLevelViewController : BaseViewController
@property (nonatomic, strong) NoNetReloadView *vNoNet;
- (void)loadData;
//点击空白处隐藏键盘
- (void)viewAddEndEditingGesture;
- (void)backArrowSet;
- (void)dismiss;
@end
