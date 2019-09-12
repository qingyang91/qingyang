//
//  WorkInfoModel.h
//  PowerWallet
//
//  Created by Krisc.Zampono on 2017/2/16.
//  Copyright © 2017年 Krisc.Zampono. All rights reserved.
//
///入职时长
#import <Foundation/Foundation.h>
@interface WorkTimeModel : NSObject

@property (nonatomic, retain) NSString *entry_time_type;
@property (nonatomic, retain) NSString *name;

+ (instancetype)workTimeWithDictionary:(NSDictionary *)dict;
@end

///工作信息
@interface WorkInfoModel : NSObject

@property (nonatomic, retain) NSString *company_name;
@property (nonatomic, retain) NSString *company_post;
@property (nonatomic, retain) NSString *company_address;
@property (nonatomic, retain) NSString *company_address_distinct;
@property (nonatomic, retain) NSString *work_address;
@property (nonatomic, retain) NSString *company_phone;
@property (nonatomic, retain) NSString *company_period;
@property (nonatomic, retain) NSString *company_salary;
@property (nonatomic, retain) NSString *company_picture;
@property (nonatomic, retain) NSMutableArray<WorkTimeModel *> *company_period_list;

+ (instancetype)workInfoWithDictionary:(NSDictionary *)dict;

@end
