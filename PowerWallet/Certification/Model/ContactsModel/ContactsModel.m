//
//  ContactsModel.m
//  PowerWallet
//
//  Created by PowerWallet on 2017/2/16.
//  Copyright © 2017年 Krisc.Zampono. All rights reserved.
//

#import "ContactsModel.h"

@implementation listModel

/**
 Description

 @param dict dict description
 @return return value description
 */
+ (instancetype)listWithDict:(NSDictionary *)dict {
    listModel *model = [listModel mj_objectWithKeyValues:dict];
    return model;
}

@end

@implementation ContactsModel


/**
 Description

 @param dict dict description
 @return return value description
 */
+ (instancetype)contactsWithDict:(NSDictionary *)dict {
    ContactsModel *model = [ContactsModel mj_objectWithKeyValues:dict];
    return model;
}


/**
 Description

 @return return value description
 */
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"lineal_list" : @"listModel",
             @"other_list" : @"listModel"
             };
}

@end
