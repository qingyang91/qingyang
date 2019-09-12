//
//  CreditDataCell.m
//  PowerWallet
//
//  Created by 清阳 on 2017/12/22.
//  Copyright © 2017年 peijunjinrong. All rights reserved.
//

#import "CreditDataCell.h"

@implementation CreditDataCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCreditDataCell:(NSIndexPath *)indexPath{
    self.creait.text = @"必备信用材料";
    self.choose.text = @"选择必备信用材料";
}

@end
