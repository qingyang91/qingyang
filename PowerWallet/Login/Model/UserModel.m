//
//  UserModel.m
//  MeiXiang
//
//  Created by Krisc.Zampono on 16/6/15.
//  Copyright © 2016年 Krisc.Zampono. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
//+ (NSDictionary *)modelContainerPropertyGenericClass {
//    return @{@"adminServiceList" : [CustomServiceModel class],
//             @"sellerServiceList" : [CustomServiceModel class]};
//}
+(instancetype)userWithDict:(NSDictionary *)dict{
    UserModel * model = [[UserModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}
@end
