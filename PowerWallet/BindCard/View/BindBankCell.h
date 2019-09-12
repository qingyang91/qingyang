//
//  BindBankCell.h
//  PowerWallet
//
//  Created by 清阳 on 2017/12/26.
//  Copyright © 2017年 peijunjinrong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^tfChangedBlock)(NSString * parmKey, NSString * parmValue);

@interface BindBankCell : UITableViewCell
@property (nonatomic, copy) tfChangedBlock changeBlock;
+ (BindBankCell *)bindBankCellWithTableView:(UITableView *)tableView;
- (void)configCellWithDict:(NSDictionary *)dict withIndexPath:(NSIndexPath *)indexPath;

@end

