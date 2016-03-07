//
//  CommentModel.m
//  jokeToWatch
//
//  Created by scjy on 16/3/7.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel


- (instancetype)initWithCommentDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        NSDictionary *userDic = dict[@"user"];
        if (![userDic isEqual:[NSNull null]]) {
            self.title = userDic[@"login"];
            self.useIcon = userDic[@"icon"];
            self.userID = [NSString stringWithFormat:@"%@", userDic[@"id"]];
        }
        
        NSString *idStr = [self.userID substringToIndex:4];
        self.headImage = [NSString stringWithFormat:@"http://img.qiushibaike.com/system/avtnew/%@/%@/thumb/%@", idStr, self.userID, self.useIcon];
        self.content = dict[@"content"];

    }
    return self;
}


@end
