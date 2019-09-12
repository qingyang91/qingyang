//
//  ContactsCell.h
//  PowerWallet
//
//  Created by PowerWallet on 2017/2/16.
//  Copyright © 2017年 Krisc.Zampono. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HightlightCell.h"

@interface ContactsCell : HightlightCell

+ (ContactsCell *)contactsCellWithtableView:(UITableView *)tableView;
- (void)FillCellWithName:(NSString *)name;

@end
