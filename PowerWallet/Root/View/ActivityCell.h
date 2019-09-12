//
//  activityCell.h
//  PowerWallet
//
//  Created by Krisc.Zampono on 2017/8/10.
//  Copyright © 2017年 Jueling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
@interface ActivityCell : UITableViewCell
+(ActivityCell *)activityCellWithTableView:(UITableView *)tableView;
- (void)configCellWithDict:(RollModel *)mode indexPath:(NSIndexPath*)indexPath;
@end
