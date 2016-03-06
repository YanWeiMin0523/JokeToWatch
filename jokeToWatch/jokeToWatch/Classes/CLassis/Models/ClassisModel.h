//
//  ClassisModel.h
//  jokeToWatch
//
//  Created by scjy on 16/3/5.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassisModel : NSObject

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *headImage;
@property(nonatomic, copy) NSString *time;
@property(nonatomic, copy) NSString *plain;
@property(nonatomic, copy) NSString *votesY;
@property(nonatomic, copy) NSString *votesN;
@property(nonatomic, copy) NSString *apprise;
@property(nonatomic, copy) NSString *jokeID;
@property(nonatomic, copy) NSString *shareImage;
@property(nonatomic, copy) NSString *imageHeight;

- (instancetype)initWithClassisDictionary:(NSDictionary *)dic;

@end
