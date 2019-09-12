//
//  TipMessage.m
//  MeiXiang
//
//  Created by Krisc.Zampono on 16/6/19.
//  Copyright © 2016年 Krisc.Zampono. All rights reserved.
//

#import "TipMessage.h"
#import "NSDictionary+JsonFile.h"

@implementation TipMessage

+ (TipMessage*)shared{
    static TipMessage *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TipMessage alloc] init];
        sharedInstance.tipMessage = [TipMessageModel tipMessageModelWithDictionary:[NSDictionary dictionaryWithContentsOfJSONString:@"TipMessage"]];
    });
    return sharedInstance;
}

@end
