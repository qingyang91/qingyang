//
//  UIImageView+Additions.h
//  KDLC
//
//  Created by 曹晓丽 on 16/3/24.
//  Copyright © 2016年 llyt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface UIImageView (Additions)

+ (BOOL)validURL:(id)url;

+ (UIImage *)cacheImageWithURL:(id)url;

+ (void)downLoadImageWithURL:(id)url complate:(SDInternalCompletionBlock)complate;

@end
