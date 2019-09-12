//
//  DSCacheManager.h
//  DSDeveloperKit
//
//  Created by Krisc.Zampono on 12/11/30.
//  Copyright (c) 2012年 Krisc.Zampono. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSCacheManager : NSObject

/**
 *  把图片写入沙盒
 *
 *  @param image     图片
 *  @param imageName 图片名称
 */
+ (void)writToFileByImage:(UIImage *)image withImageName:(NSString *)imageName;

/**
 *  从沙盒缓存中获取图片
 *
 *  @param imageName 图片名称
 *
 *  @return 图片
 */
+ (UIImage *)getFileByImage:(NSString *)imageName;

@end
