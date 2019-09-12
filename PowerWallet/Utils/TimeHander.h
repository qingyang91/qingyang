//
//  TimeHander.h
//  EDP
//
//  Created by xcy on 14-6-9.
//  Copyright (c) 2014年 weiyuli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeHander : NSObject
//返回分割时间
+(NSString *)ChangeStringToNumberWithString:(NSString *)InputStr  objectIndexID:(int)aId;
+(NSString *)ChangeSeparWithString:(NSString *)InputStr;
//与当前日期比较时间大小
+(int)compareOneDay:(NSString *)oneDay withAnotherDay:(NSString *)anotherDay;
//比较日期 dateString1以前时间  dateString2当前时间  返回据当前几天
+(NSString *)intervalFromLastDate: (NSString *) dateString1  toTheDate:(NSString *) dateString2;
//返回系统当前时间
+(NSString *)currentDateTime;
//返回系统当前时间  yyyy年MM月dd日
+(NSString *)currentDateTimeChina;
//返回系统当前时间 yyyyMMdd
+(NSString *)nowDateTime;
//返回系统当前－－yyyy
+(NSString *)currentDateObjectYear;
//返回系统当前－－MM
+(NSString *)currentDateObjectMonth;
//返回系统当前－－日
+(NSString *)currentDateObjectDay;
//返回系统当前时间 格式yyyy-MM-dd hh:mm:ss
+(NSString *)currentDateAndHoursTime;
//利用时间戳来准确计算某个时间点具现在的时间差
+(NSString *)intervalSinceNow: (NSString *) theDate;
//利用时间戳来准确计算某个时间点具现在的时间差,具体时间到HH:mm:ss zzz
+(NSString *)intervalSinceNowSeconds: (NSString *) theDate;
/**
 *  用于uidate，picker。。
 *
 *  @param uiDate 传入nsstring
 *
 *  @return 转换成NSDate
 */

+(NSDate*) convertDateFromString:(NSString*)uiDate;
+(NSString *)convertTimeFromString:(NSString*)uiDate;
/**
 *  NSDate转换成NSString
 */
+(NSString *)stringFromDate:(NSDate *)date;
/**
 * 20110826134106 转换成 2011-08-26
 */
+(NSDate *)dateFromStringTime:(NSString *)time;
//返回系统当前－－HH:mm
+(NSString *)currentMonthAndDate;
@end
