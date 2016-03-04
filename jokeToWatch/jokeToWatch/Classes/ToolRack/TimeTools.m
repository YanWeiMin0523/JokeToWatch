//
//  TimeTools.m
//  jokeToWatch
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "TimeTools.h"

@implementation TimeTools

#pragma mark ----------- 时间转换

+ (NSString *)getDateString:(NSString *)timeStamp{
    NSTimeInterval time = [timeStamp doubleValue];
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    NSString *timeStr = [formatter stringFromDate:date];
    return timeStr;
}
//获取当前系统的时间
+ (NSDate *)getNowDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy.MM.dd HH:mm";
    NSString *dateStr = [formatter stringFromDate:[NSDate new]];
    NSDate *date = [formatter dateFromString:dateStr];
    return date;
}

#pragma mark ----------- 计算文本高度
+ (CGFloat)getTextHeight:(NSString *)text bigestSize:(CGSize)bigSize Font:(CGFloat)font{
    CGRect textRect = [text boundingRectWithSize:bigSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    
    return textRect.size.height;
}

@end
