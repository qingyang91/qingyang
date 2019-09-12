//
//  ConfirmListViewCell.h
//  PowerWallet
//
//  Created by 清阳 on 2018/1/15.
//  Copyright © 2018年 peijunjinrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmListViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *listID;
@property (weak, nonatomic) IBOutlet UILabel *zhaiwuName;
@property (weak, nonatomic) IBOutlet UILabel *lendMoney;
@property (weak, nonatomic) IBOutlet UILabel *lendTime;
@property (weak, nonatomic) IBOutlet UILabel *zhaiquanName;
@property (weak, nonatomic) IBOutlet UILabel *yearRate;
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UIButton *feedBtn;
@property (weak, nonatomic) IBOutlet UIButton *xiaoBtn;

@end
