//
//  MeLendModel.h
//  PowerWallet
//
//  Created by 清阳 on 2017/12/25.
//  Copyright © 2017年 peijunjinrong. All rights reserved.
//

#import "JSONModel.h"

@protocol YearRateMdoel

@end

@protocol BorrowUseMdoel

@end

@protocol MeLendModel


@end

@protocol RepayTypeModel


@end

@protocol ProtocolLendMdoel


@end

@interface RepayTypeModel : JSONModel

@property (nonatomic,copy) NSString<Optional> *typeID;
@property (nonatomic,copy) NSString<Optional> *name;

@end

@interface YearRateMdoel : JSONModel

@property (nonatomic,copy) NSString<Optional> *yearID;
@property (nonatomic,copy) NSString<Optional> *name;

@end
@interface BorrowUseMdoel : JSONModel

@property (nonatomic,copy) NSString<Optional> *userID;
@property (nonatomic,copy) NSString<Optional> *name;

@end

@interface ProtocolLendMdoel : JSONModel

@property (nonatomic,copy) NSString<Optional> *name;
@property (nonatomic,copy) NSString<Optional> *url;

@end

@interface MeLendModel : JSONModel

@property (nonatomic,copy) NSString<Optional> *available_money;
@property (nonatomic,copy) NSString<Optional> *tip;
@property (nonatomic,strong) NSMutableArray<YearRateMdoel,Optional> *year_rate_all;
@property (nonatomic,strong) NSMutableArray<BorrowUseMdoel,Optional> *borrow_use_all;
@property (nonatomic,strong) NSMutableArray<RepayTypeModel,Optional> *repayment_type_all;
@property (nonatomic,strong) ProtocolLendMdoel<Optional> *borrow_protocol;

@end

@interface MeLendModelResponse : JSONModel

@property (nonatomic,strong) MeLendModel<Optional>* data;

@end
