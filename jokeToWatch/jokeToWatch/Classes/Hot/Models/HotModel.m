//
//  HotModel.m
//  jokeToWatch
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "HotModel.h"

@implementation HotModel

- (instancetype)initWithJokeDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        NSDictionary *userDic = dic[@"user"];
        if (![userDic isEqual:[NSNull null]]) {
        self.title = userDic[@"login"];
        }
        NSString *imageStr = dic[@"image"];
        if ([imageStr isEqual:nil]) {
            NSString *newImageStr = [NSString stringWithFormat:@"http://img.qiushibaike.com/system/pictures/%@/small/%@", self.jokeID, imageStr];
            self.headImage = newImageStr;
        }
        
        self.apprise = dic[@"allow_comment"];
        self.time = dic[@"share_count"];
        self.plain = dic[@"content"];
        self.jokeID = dic[@"id"];
        
        NSDictionary *voteDic = dic[@"votes"];
        self.votesN = voteDic[@"down"];
        self.votesY = voteDic[@"up"];
    }
    return self;
}

@end
