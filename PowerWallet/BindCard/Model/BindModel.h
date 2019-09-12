//
//  BindModel.h
//  PowerWallet
//
//  Created by 清阳 on 2017/12/26.
//  Copyright © 2017年 peijunjinrong. All rights reserved.
//

#import "JSONModel.h"

@interface BindModel : JSONModel

@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *cardNo;
@property (nonatomic,retain) NSString *bankName;
@property (nonatomic,retain) NSString *isBind;
+(instancetype)BindWithDict:(NSDictionary *)dict;
@end
