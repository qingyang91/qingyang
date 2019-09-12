//
//  NSObject+Swizzle.h
//  Demo
//
//  Created by Krisc.Zampono on 12/6/1.
//  Copyright (c) 2012年 Krisc.Zampono. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Swizzle)

+ (void)swizzleInstanceSelector:(SEL)originalSelector
                withNewSelector:(SEL)newSelector;

@end
