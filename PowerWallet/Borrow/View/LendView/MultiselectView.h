//
//  MultiselectView.h
//  Multiselect
//
//  Created by 清阳 on 2017/12/22.
//  Copyright © 2017年 peijunjinrong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultiselectTableViewCell.h"

@interface MultiselectView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableview;

@property (strong, nonatomic) NSMutableArray *dataArr;

@property (strong, nonatomic) NSMutableArray *resultArr;

@property (copy, nonatomic) NSString *heraderStr;

-(void)disMiss;

@property (nonatomic,copy) void(^SelectBlock)(NSMutableArray *selectArr);

@end
