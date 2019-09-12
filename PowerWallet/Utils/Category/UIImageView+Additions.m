//
//  UIImageView+Additions.m
//  KDLC
//
//  Created by 曹晓丽 on 16/3/24.
//  Copyright © 2016年 llyt. All rights reserved.
//

#import "UIImageView+Additions.h"
#import <SDWebImage/SDImageCache.h>

@implementation UIImageView (Additions)

+ (UIImage *)cacheImageWithURL:(id)url
{
    if ([UIImageView validURL:url]) {
        url = [url stringByReplacingOccurrencesOfString:@" " withString:@""];
        url = [NSURL URLWithString:url];
        NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:url];
        UIImage *tempImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
        if (tempImage) {
            return tempImage;
        }
    }
    return nil;
}

+ (void)downLoadImageWithURL:(id)url complate:(SDInternalCompletionBlock)complate
{
    if ([UIImageView validURL:url]) {
        url = [url stringByReplacingOccurrencesOfString:@" " withString:@""];
        url = [NSURL URLWithString:url];
        [[SDWebImageManager sharedManager] loadImageWithURL:url options:SDWebImageAllowInvalidSSLCertificates|SDWebImageRetryFailed progress:nil completed:complate];
    }
}

+ (BOOL)validURL:(id)url
{
    if ([url isKindOfClass:[NSString class]]) {
        url = [NSURL URLWithString:url];
    }
    
    if (![url isKindOfClass:[NSURL class]]) {
        return NO;
    }
    return YES;
}

@end
