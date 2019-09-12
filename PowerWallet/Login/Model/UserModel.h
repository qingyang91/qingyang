//
//  UserModel.h
//  MeiXiang
//
//  Created by Krisc.Zampono on 16/6/15.
//  Copyright © 2016年 Krisc.Zampono. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserModel : NSObject

@property (nonatomic, copy) NSString *sessionid;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *realname;
@property (nonatomic, copy) NSString *real_pay_pwd_status;
+(instancetype)userWithDict:(NSDictionary *)dict;
@end
