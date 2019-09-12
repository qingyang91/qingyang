//
//  GetContactsBook.h
//  PowerWallet
//
//  Created by krisc.zampono on 2017/2/16.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <AddressBookUI/AddressBookUI.h>

enum {
    ABHelperCanNotConncetToAddressBook,
    ABHelperExistSpecificContact,
    ABHelperNotExistSpecificContact
};typedef NSUInteger ABHelperCheckExistResultType;

@interface GetContactsBook : NSObject<ABPeoplePickerNavigationControllerDelegate>

//保存排序好的数组index
@property(nonatomic,retain)NSMutableArray*dataArray;
//数组里面保存每个获取Vcard（名片）
@property(nonatomic,retain)NSMutableArray*dataArrayDic;
#pragma mark 获得单例
+ (GetContactsBook*)shareControl;

#pragma mark 获取Vcard
-(NSMutableDictionary*)getPersonInfo;
-(NSArray*)sortMethod;//获取列表

#pragma mark - 判断是否授权通讯录信息
+ (void)CheckAddressBookAuthorization:(void (^)(bool isAuthorized))block;

//上传通讯录
- (void)upLoadAddressBook;
///保存通讯录
-(NSMutableArray *)saveAddressBook:(NSArray *)addressBook;
///过滤手机号
- (NSString *)phoneNumClear:(NSString *)str;
/**
 过滤手机号
 
 @param array 手机号
 @return
 */
- (NSMutableArray *)phoneNumClears:(NSArray *)array;
-(NSMutableArray *)uploadAddress;

@end
