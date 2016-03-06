//
//  TimeTools.h
//  jokeToWatch
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeTools : NSObject

#pragma mark ----------- 时间转换

+ (NSString *)getDateString:(NSString *)timeStamp;
//获取当前系统的时间
+ (NSDate *)getNowDate;

#pragma mark ----------- 计算文本高度
+ (CGFloat)getTextHeightWithText:(NSString *)text;

@end
