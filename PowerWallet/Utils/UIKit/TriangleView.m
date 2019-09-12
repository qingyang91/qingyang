//
//  TriangleView.m
//  PowerWallet
//
//  Created by Krisc.Zampono on 2017/8/9.
//  Copyright © 2017年 Jueling. All rights reserved.
//

#import "TriangleView.h"

@implementation TriangleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-
(void)drawRect:(CGRect)rect

{
    [[UIColor whiteColor]set];
    UIRectFill([self bounds]);
    //定义画图的path
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    //path移动到开始画图的位置
    [path moveToPoint:CGPointMake(rect.origin.x, rect.origin.y)];
    
    [path addLineToPoint:CGPointMake(rect.origin.x, rect.size.height)];
//    [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y)];
    
    [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height/2)];
//    [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width/2, rect.origin.y + rect.size.height)];
    
    //关闭path
    [path closePath];
    
    //三角形内填充颜色
    [self.fillColor setFill];
    
    [path fill];

}

@end
