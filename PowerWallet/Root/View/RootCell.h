//
//  RootCell.h
//  PowerWallet
//
//  Created by Krisc.Zampono on 2017/8/8.
//  Copyright © 2017年 Jueling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PartnerInfoModel.h"

@interface RootCell : UITableViewCell
+(RootCell *)rootCellWithTableView:(UITableView *)tableView;
- (void)configCellWithDict:(PartnerInfoModel *)mode indexPath:(NSIndexPath*)indexPath;
@end
