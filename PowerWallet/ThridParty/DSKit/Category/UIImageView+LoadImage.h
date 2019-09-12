//
//  UIImageView+LoadImage.h
//  PowerWallet
//
//  Created by Krisc.Zampono on 10/02/2017.
//  Copyright © 2017 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (LoadImage)

- (void)loadImageWithImagePath:(NSString *)imagePath;
- (void)loadImageWithImagePath:(NSString *)imagePath placeholderImage:(UIImage *)image;

@end
