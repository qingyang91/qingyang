//
//  TipMessage.h
//  MeiXiang
//
//  Created by Krisc.Zampono on 16/6/19.
//  Copyright © 2016年 Krisc.Zampono. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TipMessageModel.h"

@interface TipMessage : NSObject

@property (nonatomic, strong) TipMessageModel *tipMessage;

+ (TipMessage*)shared;

@end
