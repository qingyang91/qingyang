//
//  BindModel.m
//  PowerWallet
//
//  Created by 清阳 on 2017/12/26.
//  Copyright © 2017年 peijunjinrong. All rights reserved.
//

#import "BindModel.h"

@implementation BindModel

+(instancetype)BindWithDict:(NSDictionary *)dict{
    BindModel *model = [BindModel mj_objectWithKeyValues:dict];
    return model;
}

@end
