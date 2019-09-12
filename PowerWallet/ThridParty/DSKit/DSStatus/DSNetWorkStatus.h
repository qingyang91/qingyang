//
//  DSNetWorkStatus.h
//  DSDeveloperKit
//
//  Created by Krisc.Zampono on 12/7/25.
//  Copyright (c) 2012年 Krisc.Zampono. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSReachability.h"

@interface DSNetWorkStatus : NSObject

@property (nonatomic) NetworkStatus netWorkStatus;

+ (instancetype)sharedNetWorkStatus;

@end
