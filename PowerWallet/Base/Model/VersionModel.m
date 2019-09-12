//
//  VersionModel.m
//  PowerWallet
//
//  Created by 清阳 on 2018/1/18.
//  Copyright © 2018年 peijunjinrong. All rights reserved.
//

#import "VersionModel.h"

@implementation VersionModel
+ (instancetype)versionWithDict:(NSDictionary *)dict{
    VersionModel *model = [VersionModel mj_objectWithKeyValues:dict];
    return model;
}
@end
