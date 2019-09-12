//
//  NSDictionary+JsonFile.h
//  MeiXiang
//
//  Created by Krisc.Zampono on 16/5/17.
//  Copyright © 2016年 Krisc.Zampono. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JsonFile)

/**
 *  NSDictionary from json file
 *
 *  @param fileName file name
 *
 *  @return dictionary
 */
+ (NSDictionary*)dictionaryWithContentsOfJSONString:(NSString*)fileName;

@end
