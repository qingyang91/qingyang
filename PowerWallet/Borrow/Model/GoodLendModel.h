//
//  GoodLendModel.h
//  PowerWallet
//
//  Created by 清阳 on 2018/1/16.
//  Copyright © 2018年 peijunjinrong. All rights reserved.
//

#import "JSONModel.h"

@protocol BorrowUserModel



@end

@protocol GoodItemModel



@end

@interface BorrowUserModel : JSONModel

@property (nonatomic, retain) NSString *uid;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *realname;

@end

@interface GoodItemModel : JSONModel

@property (nonatomic,retain) NSString *borrow_money;
@property (nonatomic,retain) NSString *borrow_time;
@property (nonatomic,retain) NSString *service_money;
@property (nonatomic,retain) NSString *service_rate;
@property (nonatomic,retain) NSString *year_rate;
@property (nonatomic,retain) NSString *lendID;
@property (nonatomic,retain) BorrowUserModel *borrow_user;

@end

@interface GoodLendModel : JSONModel
@property (nonatomic, strong) NSMutableArray <GoodItemModel *> *items;
+(instancetype)helpLendWithDict:(NSDictionary *)dict;
@end
