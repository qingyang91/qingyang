//
//  LendListModel.h
//  PowerWallet
//
//  Created by 清阳 on 2017/12/25.
//  Copyright © 2017年 peijunjinrong. All rights reserved.
//

#import "JSONModel.h"


@protocol LendItemModel


@end

@interface LendItemModel : JSONModel

@property (nonatomic,retain) NSString *borrow_money;
@property (nonatomic,retain) NSString *borrow_time;
@property (nonatomic,retain) NSString *service_money;
@property (nonatomic,retain) NSString *service_rate;
@property (nonatomic,retain) NSString *year_rate;
@property (nonatomic,retain) NSString *lendID;
@property (nonatomic,assign) NSInteger to_confirm;
@property (nonatomic,retain) NSString *active_borrow_money;
@property (nonatomic,retain) NSArray *tags;
@end

@interface LendListModel : JSONModel

@property (nonatomic, strong) NSMutableArray <LendItemModel *> *items;
+(instancetype)helpLendWithDict:(NSDictionary *)dict;
@end




