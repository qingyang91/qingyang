//
//  UIImage+Additions.m
//  MLIPhone
//
//  Created by yakehuang on 5/6/14.
//
//

#import "UIImage+Additions.h"
#import <SDWebImage/SDImageCache.h>
#import <SDWebImageManager.h>
@implementation UIImage (Additions)

+ (UIImage *)cacheImageWithURL:(id)url
{
    if ([UIImage validURL:url]) {
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


+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
