//
//  MeOutModel.h
//  PowerWallet
//
//  Created by 清阳 on 2017/12/25.
//  Copyright © 2017年 peijunjinrong. All rights reserved.
//

#import "JSONModel.h"

@protocol MeOutModel


@end

@protocol LendMoneyCountModel


@end

@protocol TypeModel


@end

@protocol LendDayModel


@end

@protocol RateModel


@end

@protocol MustInfoModel


@end

@protocol ProtocolModel


@end

@interface LendMoneyCountModel : JSONModel

@property (nonatomic,copy) NSString<Optional> *countid;
@property (nonatomic,copy) NSString<Optional> *name;

@end

@interface TypeModel : JSONModel

@property (nonatomic,copy) NSString<Optional> *repayid;
@property (nonatomic,copy) NSString<Optional> *name;

@end

@interface LendDayModel : JSONModel

@property (nonatomic,copy) NSString<Optional> *dayID;
@property (nonatomic,copy) NSString<Optional> *name;

@end

@interface RateModel : JSONModel

@property (nonatomic,copy) NSString<Optional> *rateid;
@property (nonatomic,copy) NSString<Optional> *name;

@end

@interface MustInfoModel : JSONModel

@property (nonatomic,copy) NSString<Optional> *infoid;
@property (nonatomic,copy) NSString<Optional> *name;

@end

@interface ProtocolModel : JSONModel

@property (nonatomic,copy) NSString<Optional> *name;
@property (nonatomic,copy) NSString<Optional> *url;

@end

@interface MeOutModel : JSONModel

@property (nonatomic,copy)   NSString<Optional> *tip;
@property (nonatomic,strong) NSMutableArray <LendMoneyCountModel,Optional> *borrow_money_all;
@property (nonatomic,strong) NSMutableArray <TypeModel,Optional> *repayment_type_all;
@property (nonatomic,strong) NSMutableArray <LendDayModel,Optional> *borrow_time_all;
@property (nonatomic,strong) NSMutableArray <RateModel,Optional> *year_rate_all;
@property (nonatomic,strong) NSMutableArray <MustInfoModel,Optional> *must_info_all;
@property (nonatomic,strong) ProtocolModel <Optional> *borrow_protocol;

@end

@interface MeOutModelResponse : JSONModel

@property (nonatomic,strong) MeOutModel<Optional>* data;

@end

