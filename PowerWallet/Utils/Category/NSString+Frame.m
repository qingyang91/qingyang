//
//  NSString+Frame.m
//  KDLC
//
//  Created by Krisc.Zampono on 16/3/24.
//  Copyright © 2016年 llyt. All rights reserved.
//

#import "NSString+Frame.h"

@implementation NSString (Frame)

//size
- (CGSize)sizeWithFontSize:(CGFloat)fontSize
{
    return [self sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}];
}

- (CGSize)sizeWithSystemFont:(UIFont *)font
{
    return [self sizeWithAttributes:@{NSFontAttributeName:font}];
}

- (CGSize)sizewithFontSize:(CGFloat)fontSize maxWidth:(CGFloat)width maxHeight:(CGFloat)height
{
    return [self sizewithSystemFont:[UIFont systemFontOfSize:fontSize] maxWidth:width maxHeight:height];
}

- (CGSize)sizewithSystemFont:(UIFont *)font maxWidth:(CGFloat)width maxHeight:(CGFloat)height
{
    CGSize size = CGSizeMake(width, height);
    if (height == 0) {
        size = CGSizeMake(size.width, MAXFLOAT);
    }
    if (width == 0) {
        size = CGSizeMake(MAXFLOAT, size.height);
    }
    
    return [self boundingRectWithSize:size
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName:font}
                              context:nil].size;
}

//height
- (CGFloat)heightWIthFontSize:(CGFloat)fontSize
{
    return [self sizeWithFontSize:fontSize].height;
}
- (CGFloat)heightWIthFontSize:(CGFloat)fontSize maxWidth:(CGFloat)width
{
    return [self sizewithFontSize:fontSize maxWidth:width maxHeight:0].height;
}

//width
- (CGFloat)widthWithFontSize:(CGFloat)fontSize
{
    return [self sizeWithFontSize:fontSize].width;
}

@end
