//
//  TimeHander.m
//  EDP
//
//  Created by xcy on 14-6-9.
//  Copyright (c) 2014年 weiyuli. All rights reserved.
//

#import "TimeHander.h"

@implementation TimeHander
//返回分割时间
+(NSString *)ChangeStringToNumberWithString:(NSString *)InputStr  objectIndexID:(int)aId{
    NSString *separateStr= [[InputStr componentsSeparatedByString:@"-"]objectAtIndex:aId];
    return separateStr;
}
+(NSString *)ChangeSeparWithString:(NSString *)InputStr{
    NSString *ouStr=nil;
    if (InputStr.length>0) {
        NSArray *separateStr= [InputStr componentsSeparatedByString:@" "];
        NSString *str1 = [separateStr objectAtIndex:1];
        NSArray *splTime=[str1 componentsSeparatedByString:@":"];
        NSString *str2 = [splTime  objectAtIndex:0];
        NSString *str3 = [splTime  objectAtIndex:1];
        ouStr = [NSString stringWithFormat:@"%@:%@",str2,str3];
    }
    return ouStr;
}
//与当前日期比较时间大小
+(int)compareOneDay:(NSString *)oneDay withAnotherDay:(NSString *)anotherDay
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateA = [dateFormatter dateFromString:oneDay];
    NSDate *dateB = [dateFormatter dateFromString:anotherDay];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        NSLog(@"Date1  is in the future 以前");
        return 1;
    }
    else if (result == NSOrderedAscending){
        NSLog(@"Date1 is in the past 以后");
        return -1;
    }
    NSLog(@"Both dates are the same 相同");
    return 0;
    
}
//比较日期 dateString1以前时间  dateString2当前时间  返回据当前几天
+(NSString *)intervalFromLastDate: (NSString *) dateString1  toTheDate:(NSString *) dateString2
{
    NSLog(@"%@.....%@",dateString1,dateString2);
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *d2=[date dateFromString:dateString2];
    
    NSTimeInterval late2=[d2 timeIntervalSince1970]*1;
    
    NSDate *d1=[date dateFromString:dateString1];
    
    NSTimeInterval late1=[d1 timeIntervalSince1970]*1;
    
    NSTimeInterval cha=late2-late1;
    NSString *timeString=@"";
    NSString *day = @"";
    NSString *house=@"";
    NSString *min=@"";
    NSString *sen=@"";
    
    sen = [NSString stringWithFormat:@"%d", (int)cha%60];
    //    秒
    sen=[NSString stringWithFormat:@"%@", sen];
    
    min = [NSString stringWithFormat:@"%d", (int)cha/60%60];
    //    分
    min=[NSString stringWithFormat:@"%@", min];
    
    //    小时
    house = [NSString stringWithFormat:@"%d", (int)cha/3600];
    house=[NSString stringWithFormat:@"%@", house];
    
    //天
    day = [NSString stringWithFormat:@"%d",(int)cha/3600/24];
    
    timeString=[NSString stringWithFormat:@"%@:%@:%@",house,min,sen];
    
    return day;
}

//返回系统当前时间 yyyyMMdd
+(NSString *)nowDateTime
{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyyMMddhhmmss"];
    NSDate *currentDate=[NSDate date];
    NSString  *selectTimeDay= [dateFormatter stringFromDate:currentDate];
    
    
    return selectTimeDay;
}
//返回系统当前时间  yyyy-MM-dd
+(NSString *)currentDateTime
{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *currentDate=[NSDate date];
    NSString  *selectTimeDay= [dateFormatter stringFromDate:currentDate];
    

    return selectTimeDay;
}
//返回系统当前时间  yyyy年MM月dd日
+(NSString *)currentDateTimeChina
{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate *currentDate=[NSDate date];
    NSString  *selectTimeDay= [dateFormatter stringFromDate:currentDate];
    
    
    return selectTimeDay;
}
//返回系统当前－－yyyy
+(NSString *)currentDateObjectYear
{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy"];
    NSDate *currentDate=[NSDate date];
    NSString  *selectTimeDay= [dateFormatter stringFromDate:currentDate];
    
    
    return selectTimeDay;
}
//返回系统当前－－MM
+(NSString *)currentDateObjectMonth
{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"MM"];
    NSDate *currentDate=[NSDate date];
    NSString  *selectTimeDay= [dateFormatter stringFromDate:currentDate];
    
    
    return selectTimeDay;
}
//返回系统当前－－dd
+(NSString *)currentDateObjectDay
{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"dd"];
    NSDate *currentDate=[NSDate date];
    NSString  *selectTimeDay= [dateFormatter stringFromDate:currentDate];
    
    
    return selectTimeDay;
}
//返回系统当前－－HH:mm
+(NSString *)currentMonthAndDate
{

    NSDate *  date=[NSDate date];
    NSDateFormatter  *dateformatter3=[[NSDateFormatter alloc] init];
    [dateformatter3 setDateFormat:@"HH:mm"];
    NSString * locationString = [dateformatter3 stringFromDate:date];
    return locationString;
}
//返回系统当前时间 格式yyyy-MM-dd hh:mm:ss
+(NSString *)currentDateAndHoursTime
{
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    NSString  *selectTimeDay= [format stringFromDate:[NSDate date]];
    return selectTimeDay;
}
/**
 *  用于uidate，picker。。
 *
 *  @param uiDate 传入nsstring
 *
 *  @return 转换成NSDate
 */

+(NSDate*) convertDateFromString:(NSString*)uiDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy年MM月dd日"];
 //    [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[formatter dateFromString:uiDate];
    
    return date;
}
+(NSString *)convertTimeFromString:(NSString*)uiDate
{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
//    
//    [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
//    NSDate *date=[formatter dateFromString:uiDate];
//    NSString  *selectTimeDay= [formatter stringFromDate:date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
  //  [formatter setDateFormat:@"yyyy-MM-dd HH:MM:ss"];
     [formatter setDateFormat:@"yyyyMMddHHMMSS"];
    NSDate *date = [formatter dateFromString:uiDate];
     NSString  *selectTimeDay= [formatter stringFromDate:date];
    return selectTimeDay;
}
/**
 * 20110826134106 转换成 2011-08-26
 */
+(NSDate *)dateFromStringTime:(NSString *)time
{
    /*
    NSDateFormatter *inputFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [inputFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];
    [inputFormatter setDateFormat:@"yyyyMMddHHmmss"];
     NSDate* inputDate = [inputFormatter dateFromString:time];
   
    NSLog(@"date = %@", inputDate);

    return inputDate;
    */
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyyMMddHHMM"];
    NSDate *date = [formatter dateFromString:time];
    NSLog(@"date1:%@",date);
    
    return date;
}
/**
 *  NSDate转换成NSString
 */
+ (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];

    NSString *destDateString = [dateFormatter stringFromDate:date];
  
    
    
    return destDateString;
    
}


//利用时间戳来准确计算某个时间点具现在的时间差
+(NSString *)intervalSinceNow: (NSString *) theDate
{
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDate];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha=now-late;
    
    if (cha/3600<1) {
        //显示时间格式 **分钟前
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
        
    }
    if (cha/3600>1&&cha/86400<1) {
        //显示时间格式 **小时前
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
        ///////
        /*
         //显示时间格式 今天HH:mm
         NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
         [dateformatter setDateFormat:@"HH:mm"];
         timeString = [NSString stringWithFormat:@"今天 %@",[dateformatter stringFromDate:d]];
         [dateformatter release];
         */
    }
    if (cha/86400>1)
    {
        /*     //显示时间格式 **天前
         timeString = [NSString stringWithFormat:@"%f", cha/86400];
         timeString = [timeString substringToIndex:timeString.length-7];
         timeString=[NSString stringWithFormat:@"%@天前", timeString];*/
        //显示时间格式 MM月dd日 HH:mm
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"MM月dd日 HH:mm"];
        timeString = [NSString stringWithFormat:@"%@",[dateformatter stringFromDate:d]];
        
        
        
    }
    NSLog(@"intervalSinceNow  %@,%lf,%@",theDate,late,timeString);
    
    return timeString;
}

//利用时间戳来准确计算某个时间点具现在的时间差,具体时间到HH:mm:ss zzz
+(NSString *)intervalSinceNowSeconds: (NSString *) theDate
{
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    NSDate *d=[date dateFromString:theDate];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
   
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha=now-late;
    
    if (cha/3600<1) {
        //显示时间格式 **分钟前
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
        
    }
    if (cha/3600>1&&cha/86400<1) {
        //显示时间格式 **小时前
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
        ///////
        /*
         //显示时间格式 今天HH:mm
         NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
         [dateformatter setDateFormat:@"HH:mm"];
         timeString = [NSString stringWithFormat:@"今天 %@",[dateformatter stringFromDate:d]];
         [dateformatter release];
         */
    }
    if (cha/86400>1)
    {
        /*     //显示时间格式 **天前
         timeString = [NSString stringWithFormat:@"%f", cha/86400];
         timeString = [timeString substringToIndex:timeString.length-7];
         timeString=[NSString stringWithFormat:@"%@天前", timeString];*/
        //显示时间格式 MM月dd日 HH:mm
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"yyyy-MM-dd"];
        timeString = [NSString stringWithFormat:@"%@",[dateformatter stringFromDate:d]];
        
        
        
    }
     NSLog(@"intervalSinceNow  %@,%lf,%@",theDate,late,timeString);
    
    return timeString;
}

@end
