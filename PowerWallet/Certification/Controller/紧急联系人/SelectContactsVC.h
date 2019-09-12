//
//  SelectContactsVC.h
//  PowerWallet
//
//  Created by PowerWallet on 2017/2/16.
//  Copyright © 2017年 Krisc.Zampono. All rights reserved.
//

#import "SecondLevelViewController.h"

@interface SelectContactsModel : NSObject
@property (nonatomic, copy) NSString * phone;
@property (nonatomic, copy) NSString * name;
@end

@interface SelectContactsVC : SecondLevelViewController
@property (nonatomic, retain) NSArray *titleArr;//索引 arr
@property (nonatomic, retain) NSMutableArray *cellData;//展示cell arr
@property (nonatomic, copy) void (^selectBlock)(SelectContactsModel * model);
@end
