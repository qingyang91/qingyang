//
//  FirstLevelViewController.h
//  RongTeng
//
//  Created by Krisc.Zampono on 16/1/18.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "BaseViewController.h"
#import "NoNetReloadView.h"
@interface FirstLevelViewController : BaseViewController
@property (nonatomic, strong) NoNetReloadView               * vNoNet;
- (void)loadData;
@end
