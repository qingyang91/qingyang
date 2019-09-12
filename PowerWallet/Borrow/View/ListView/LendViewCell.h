//
//  LendViewCell.h
//  PowerWallet
//
//  Created by 清阳 on 2017/12/22.
//  Copyright © 2017年 peijunjinrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LendViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lendID;
@property (weak, nonatomic) IBOutlet UILabel *seeCount;
@property (weak, nonatomic) IBOutlet UILabel *lendDay;
@property (weak, nonatomic) IBOutlet UILabel *yearRate;
@property (weak, nonatomic) IBOutlet UILabel *moneycount;
@property (weak, nonatomic) IBOutlet UIButton *fankuiBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end
