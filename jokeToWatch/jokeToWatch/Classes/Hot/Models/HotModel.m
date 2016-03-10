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
            self.imageID =[NSString stringWithFormat:@"%@",userDic[@"id"]] ;
            self.icon = userDic[@"icon"];

        }        
        NSString *str = [self.imageID substringToIndex:4];
        NSString *newImageStr = [NSString stringWithFormat:@"http://img.qiushibaike.com/system/avtnew/%@/%@/thumb/%@",str, _imageID, _icon];
        self.headImage = newImageStr;
        self.time = dic[@"created_at"];
        self.apprise = dic[@"allow_comment"];
        self.plain = dic[@"content"];
        self.jokeID = dic[@"id"];
        
        NSDictionary *voteDic = dic[@"votes"];
        self.votesN = voteDic[@"down"];
        self.votesY = voteDic[@"up"];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{

}



@end
