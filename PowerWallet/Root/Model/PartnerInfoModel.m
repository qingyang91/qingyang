//
//  PartnerInfoModel.m
//  PowerWallet
//
//  Created by Krisc.Zampono on 2017/8/22.
//  Copyright © 2017年 Jueling. All rights reserved.
//

#import "PartnerInfoModel.h"

@implementation PartnerInfoModel


/**
 Description

 @param dict dict description
 @return return value description
 */
+ (instancetype)partnerInfoWithDict:(NSDictionary *)dict{
    PartnerInfoModel *model = [PartnerInfoModel mj_objectWithKeyValues:dict];
    
    NSArray *limits     = dict[@"apply_limits"];
    for (int i=0; i<limits.count; i++) {
        NSDictionary *dic = limits[i];
        int j = 0;
        for (NSString *key in dic) {
            if (i>0) {
                if (j == 0) {
                    model.apply_limit = [NSString stringWithFormat:@"%@\n%@",model.apply_limit,dic[key]];
                }else{
                    model.apply_limit = [NSString stringWithFormat:@"%@：%@",model.apply_limit,dic[key]];
                }
                j++;
            }else{
                if (j == 0) {
                    model.apply_limit = [NSString stringWithFormat:@"%@",dic[key]];
                }else{
                    model.apply_limit = [NSString stringWithFormat:@"%@：%@",model.apply_limit,dic[key]];
                }
                j++;
            }
        }
    }
    
    NSArray *desc = dict[@"product_desc"];
    
    for (int i=0; i<desc.count; i++) {
        NSDictionary *dic = desc[i];
        int j = 0;
        for (NSString *key in dic) {
            if (i>0) {
                if (j == 0) {
                    model.product_desc = [NSString stringWithFormat:@"%@\n%@",model.product_desc,dic[key]];
                }else{
                    model.product_desc = [NSString stringWithFormat:@"%@：%@",model.product_desc,dic[key]];
                }
                j++;
            }else{
                if (j == 0) {
                    model.product_desc = [NSString stringWithFormat:@"%@",dic[key]];
                }else{
                    model.product_desc = [NSString stringWithFormat:@"%@：%@",model.product_desc,dic[key]];
                }
                j++;
            }
        }
    }

    return model;
}
@end
