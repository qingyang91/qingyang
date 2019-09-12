//
//  BaseVerifyListCell.h
//  PowerWallet
//
//  Created by Krisc.Zampono on 2017/3/30.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VerifyListModel.h"

@interface BaseVerifyListCell : UITableViewCell

@property (copy, nonatomic) void(^selectedIndex)(VerifyListModel *preModel, VerifyListModel *model);

@property (strong, nonatomic) NSArray<VerifyListModel *> *dataArray;
@property (assign, nonatomic) CGFloat progress;

@end
