//
//  ContactsModel.h
//  PowerWallet
//
//  Created by PowerWallet on 2017/2/16.
//  Copyright © 2017年 Krisc.Zampono. All rights reserved.
//



@interface listModel : NSObject
@property (nonatomic, copy) NSString    * name;
@property (nonatomic, copy) NSString    * type;
+ (instancetype)listWithDict:(NSDictionary *)dict;
@end

@interface ContactsModel : NSObject
@property (nonatomic, copy) NSString    * lineal_mobile;
@property (nonatomic, copy) NSString    * other_mobile;
@property (nonatomic, copy) NSString    * lineal_name;
@property (nonatomic, copy) NSString    * other_name;
@property (nonatomic, copy) NSString    * lineal_relation;
@property (nonatomic, copy) NSString    * other_relation;
@property (nonatomic, strong) NSMutableArray    <listModel *>* lineal_list;
@property (nonatomic, strong) NSMutableArray    <listModel *>* other_list;

+ (instancetype)contactsWithDict:(NSDictionary *)dict;

@end
