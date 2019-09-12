//
//  CreditDataCell.h
//  PowerWallet
//
//  Created by 清阳 on 2017/12/22.
//  Copyright © 2017年 peijunjinrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreditDataCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *creait;
@property (weak, nonatomic) IBOutlet UILabel *choose;

- (void)setCreditDataCell:(NSIndexPath *)indexPath;
@end
