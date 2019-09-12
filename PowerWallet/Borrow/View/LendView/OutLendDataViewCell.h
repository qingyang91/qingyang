//
//  OutLendDataViewCell.h
//  PowerWallet
//
//  Created by 清阳 on 2018/1/16.
//  Copyright © 2018年 peijunjinrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OutLendDataViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *shouMaoney;
@property (weak, nonatomic) IBOutlet UILabel *repayMoney;
@property (weak, nonatomic) IBOutlet UILabel *outLendID;
@property (weak, nonatomic) IBOutlet UILabel *detail;
@property (weak, nonatomic) IBOutlet UILabel *lendRate;
@property (weak, nonatomic) IBOutlet UILabel *repayWay;
@property (weak, nonatomic) IBOutlet UILabel *reapyTime;
@property (weak, nonatomic) IBOutlet UIButton *findBtn;
@property (weak, nonatomic) IBOutlet UILabel *lendName;
@end
