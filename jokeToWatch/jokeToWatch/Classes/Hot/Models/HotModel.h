//
//  HotModel.h
//  jokeToWatch
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotModel : NSObject

@property(nonatomic, copy) NSString *headImage;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *time;
@property(nonatomic, copy) NSString *plain;
@property(nonatomic, copy) NSString *votesY;
@property(nonatomic, copy) NSString *votesN;
@property(nonatomic, copy) NSString *apprise;
@property(nonatomic, copy) NSString *jokeID;
@property(nonatomic, copy) NSString *imageID;
@property(nonatomic, copy) NSString *icon;

- (instancetype)initWithJokeDictionary:(NSDictionary *)dic;

+ (instancetype)hotModelWithHeadImage:(NSString *)image title:(NSString *)title time:(NSString *)time plain:(NSString *)plain down:(NSString *)down up:(NSString *)up apprise:(NSString *)apprise;

@end
