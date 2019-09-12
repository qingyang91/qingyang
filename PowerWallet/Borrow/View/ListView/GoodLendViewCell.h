//
//  GoodLendViewCell.h
//  PowerWallet
//
//  Created by 清阳 on 2017/12/23.
//  Copyright © 2017年 peijunjinrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodLendViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *day;
@property (weak, nonatomic) IBOutlet UILabel *moneyCount;
@property (weak, nonatomic) IBOutlet UILabel *lendDay;
@property (weak, nonatomic) IBOutlet UILabel *yearRateService;

@property (weak, nonatomic) IBOutlet UIView *findView;

@end
