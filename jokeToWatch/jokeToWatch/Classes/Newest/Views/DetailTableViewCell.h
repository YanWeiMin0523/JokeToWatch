//
//  DetailTableViewCell.h
//  jokeToWatch
//
//  Created by scjy on 16/3/7.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"
@interface DetailTableViewCell : UITableViewCell

@property(nonatomic, strong) CommentModel *commentModel;

//获取整个cell的高度
+ (CGFloat)getCellHeightWith:(CommentModel *)model;

@end
