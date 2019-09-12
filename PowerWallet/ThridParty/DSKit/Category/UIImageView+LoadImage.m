//
//  UIImageView+LoadImage.m
//  PowerWallet
//
//  Created by Krisc.Zampono on 10/02/2017.
//  Copyright © 2017 lxw. All rights reserved.
//

#import "UIImageView+LoadImage.h"

#import "UIImageView+WebCache.h"

@implementation UIImageView (LoadImage)

- (void)loadImageWithImagePath:(NSString *)imagePath {
    
    [self loadImageWithImagePath:imagePath placeholderImage:ImageNamed(@"ascending_icon_normal")];
}

- (void)loadImageWithImagePath:(NSString *)imagePath placeholderImage:(UIImage *)image {
    
    [self sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:image options:SDWebImageAllowInvalidSSLCertificates|SDWebImageRetryFailed completed:^(UIImage *_Nullable image,NSError * _Nullable error,SDImageCacheType cacheType,NSURL * _Nullable imageURL){
    
    }];
}

@end
