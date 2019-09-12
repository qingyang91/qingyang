//
//  CardListViewCell.h
//  PowerWallet
//
//  Created by 清阳 on 2017/12/26.
//  Copyright © 2017年 peijunjinrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardListViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *bind;
@property (weak, nonatomic) IBOutlet UILabel *cardName;
@property (weak, nonatomic) IBOutlet UILabel *cardID;

@end
