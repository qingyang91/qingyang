//
//  NSNumber+ChineseNumber.h
//  Demo
//
//  Created by Krisc.Zampono on 12/6/1.
//  Copyright (c) 2012年 Krisc.Zampono. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (ChineseNumber)

/**
 *	@brief	数字转换成中文数字
 *
 *	@param 	_i 	要转换的数字
 *
 *	@return	数字转换成的中文
 */
+(NSString *)NumberToChineseNumber:(NSInteger)_i;

@end
