//
//  MyLendListModel.h
//  PowerWallet
//
//  Created by 清阳 on 2018/1/15.
//  Copyright © 2018年 peijunjinrong. All rights reserved.
//

#import "JSONModel.h"


@protocol MyLendItemModel


@end

@interface MyLendItemModel : JSONModel

@property (nonatomic,retain) NSString *borrowUserName;
@property (nonatomic,retain) NSString *lendUserName;
@property (nonatomic,retain) NSString *borrowMoney;
@property (nonatomic,retain) NSString *yearRate;
@property (nonatomic,retain) NSString *borrowTime;
@property (nonatomic,retain) NSString *lendID;
@property (nonatomic,retain) NSString *borrowPageUrl;
@property (nonatomic,assign) NSInteger logout_status;
@end


@interface MyLendListModel : JSONModel
@property (nonatomic, strong) NSMutableArray <MyLendItemModel *> *items;
+(instancetype)helpLendWithDict:(NSDictionary *)dict;
@end
