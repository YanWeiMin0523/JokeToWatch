//
//  CommentModel.h
//  jokeToWatch
//
//  Created by scjy on 16/3/7.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *headImage;
@property(nonatomic, copy) NSString *userID;
@property(nonatomic, copy) NSString *useIcon;

- (instancetype)initWithCommentDictionary:(NSDictionary *)dict;
@end
