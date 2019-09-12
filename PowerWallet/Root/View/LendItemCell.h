//
//  LendItemCell.h
//  PowerWallet
//
//  Created by Krisc.Zampono on 2017/8/10.
//  Copyright © 2017年 Jueling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PartnerInfoModel.h"
@interface LendItemCell : UITableViewCell
+(LendItemCell *)initCellWithTableView:(UITableView *)tableView;
- (void)configCellWithDict:(PartnerInfoModel *)mode indexPath:(NSIndexPath*)indexPath;
@end
