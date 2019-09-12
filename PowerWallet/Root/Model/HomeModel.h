//
//  RootItemMode.h
//  PowerWallet
//
//  Created by Krisc.Zampono on 2017/8/8.
//  Copyright © 2017年 Jueling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BannerModel.h"
#import "PartnerInfoModel.h"

@interface RollModel : NSObject
@property (retain, nonatomic)  NSString *roll_img;
@property (retain, nonatomic)  NSString *roll_title;
@property (retain, nonatomic)  NSArray *roll_desc;

@end


@interface HomeModel : NSObject
@property (retain, nonatomic)  RollModel    *roll;
@property (retain, nonatomic)  NSMutableArray <BannerModel *>   *banner;
@property (retain, nonatomic)  NSMutableArray <PartnerInfoModel *>     *list;

+ (instancetype)homeWithDict:(NSDictionary *)dict;
@end
