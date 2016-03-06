//
//  ClassisModel.m
//  jokeToWatch
//
//  Created by scjy on 16/3/5.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "ClassisModel.h"

@implementation ClassisModel


- (instancetype)initWithClassisDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.time = [NSString stringWithFormat:@"%@", dic[@"passtime"]];
        self.shareImage = dic[@"image"][@"big"][0];
        self.apprise = dic[@"comment"];
        self.plain = dic[@"text"];
        self.headImage = dic[@"u"][@"header"][0];
        self.title = dic[@"u"][@"name"];
        self.jokeID = dic[@"id"];
        self.votesN = dic[@"down"];
        self.votesY = dic[@"up"];
        self.imageHeight = dic[@"image"][@"height"];
    }
    
    return self;
}



@end
