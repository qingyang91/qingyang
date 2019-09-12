//
//  lendDataViewCell.h
//  PowerWallet
//
//  Created by 清阳 on 2018/1/16.
//  Copyright © 2018年 peijunjinrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface lendDataViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lendMoney;
@property (weak, nonatomic) IBOutlet UILabel *lendName;
@property (weak, nonatomic) IBOutlet UILabel *yearRate;
@property (weak, nonatomic) IBOutlet UILabel *repayWay;
@property (weak, nonatomic) IBOutlet UILabel *repayDate;
@property (weak, nonatomic) IBOutlet UILabel *lendUse;
@property (weak, nonatomic) IBOutlet UILabel *extraInfo;
@property (weak, nonatomic) IBOutlet UILabel *lendID;
@property (weak, nonatomic) IBOutlet UILabel *creatTime;
@property (weak, nonatomic) IBOutlet UIButton *findBtn;

@end
