//
//  PartnerInfoModel.h
//  PowerWallet
//
//  Created by Krisc.Zampono on 2017/8/22.
//  Copyright © 2017年 Jueling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PartnerInfoModel : NSObject
@property (retain, nonatomic)  NSString *pid;
@property (retain, nonatomic)  NSString *pname;

@property (retain, nonatomic)  NSString *order;
@property (retain, nonatomic)  NSString *is_hot;

@property (retain, nonatomic)  NSString *lend_icon;
@property (retain, nonatomic)  NSString *lend_name;
@property (retain, nonatomic)  NSString *lend_money;
@property (retain, nonatomic)  NSString *lend_num;
@property (retain, nonatomic)  NSString *lend_time;
@property (retain, nonatomic)  NSString *lend_rate;
@property (retain, nonatomic)  NSString *lend_desc;
@property (retain, nonatomic)  NSString *success_rate;
@property (retain, nonatomic)  NSString *type;
@property (retain, nonatomic)  NSString *apply_download;
@property (retain, nonatomic)  NSString *apply_h5;
@property (retain, nonatomic)  NSNumber *apply_type;

@property (retain, nonatomic)  NSString *apply_limit;
@property (retain, nonatomic)  NSString *product_desc;

@property (retain, nonatomic)  NSString *apply_ios_download;
@property (retain, nonatomic)  NSString *apply_ios_h5;

+ (instancetype)partnerInfoWithDict:(NSDictionary *)dict;

@end
