//
//  VersionModel.h
//  PowerWallet
//
//  Created by 清阳 on 2018/1/18.
//  Copyright © 2018年 peijunjinrong. All rights reserved.
//

#import "JSONModel.h"

@interface VersionModel : JSONModel
@property (nonatomic,retain) NSString *approve_version;
+(instancetype)versionWithDict:(NSDictionary *)dict;
@end
