//
//  MeCell.h
//  PowerWallet
//
//  Created by Krisc.Zampono on 2017/2/8.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "KDBaseTableViewCellNew.h"

@interface MeCell : UITableViewCell

//-(void)configUI;
- (void)updateTableViewCellWithdata:(NSArray *)entity index:(NSIndexPath *)indexPath;
@end
