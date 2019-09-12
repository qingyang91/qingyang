//
//  SliderContentViewController.m
//  YJSliderView
//
//  Created by 清阳 on 2017/12/25.
//  Copyright © 2017年 peijunjinrong. All rights reserved.
//

#import "SliderContentViewController.h"

@interface SliderContentViewController ()

@end

@implementation SliderContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"打印出来执行");
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        self.view.backgroundColor = [UIColor redColor];
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self show];
}

- (void)show {
    NSLog(@"jake");
}

@end
