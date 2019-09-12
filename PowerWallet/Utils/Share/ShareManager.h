//
//  ShareManager.h
//  KDLC
//
//  Created by haoran on 16/6/2.
//  Copyright © 2016年 llyt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShareEntity.h"
@interface ShareManager : NSObject

//分享单例
+ (instancetype)shareManager;

/**
 *  分享API
 *
 *  @param entity 分享参数
 */
- (void)showWithShareEntity:(ShareEntity *)entity;


@end
