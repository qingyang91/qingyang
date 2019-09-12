//
//  TipMessageModel.m
//  MeiXiang
//
//  Created by Krisc.Zampono on 16/6/19.
//  Copyright © 2016年 Krisc.Zampono. All rights reserved.
//

#import "TipMessageModel.h"

@implementation TipMessageModel


/**
 Description

 @param dict dict description
 @return return value description
 */
+ (instancetype)tipMessageModelWithDictionary:(NSDictionary *)dict{
    TipMessageModel * model = [[TipMessageModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}
@end
