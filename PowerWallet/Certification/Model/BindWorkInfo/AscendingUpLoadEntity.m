//
//  AscendingUpLoadEntity.m
//  
//
//  Created by Krisc.Zampono on 16/5/11.
//  Copyright © 2016年 Krisc.Zampono. All rights reserved.
//

#import "AscendingUpLoadEntity.h"

@implementation KDAscendingUpLoadImgEntity


/**
 Description

 @param key key description
 @return return value description
 */
- (NSString *)setKey:(NSString *)key
{
    if ([key isEqualToString:@"imgId"]) {
        return @"id";
    }
    return key;
}

+(instancetype)ascendingWithDict:(NSDictionary *)dict{
    KDAscendingUpLoadImgEntity *model = [KDAscendingUpLoadImgEntity mj_objectWithKeyValues:dict];
    return model;
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID" : @"id"};
}

@end

@implementation AscendingUpLoadEntity

+(instancetype)ascendingWithDict:(NSDictionary *)dict{
    AscendingUpLoadEntity *model = [AscendingUpLoadEntity mj_objectWithKeyValues:dict];
    return model;
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"data" : @"KDAscendingUpLoadImgEntity"
             };
}
@end
