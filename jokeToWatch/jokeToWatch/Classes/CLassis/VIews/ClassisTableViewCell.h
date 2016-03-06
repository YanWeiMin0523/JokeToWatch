//
//  ClassisTableViewCell.h
//  jokeToWatch
//
//  Created by scjy on 16/3/5.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassisModel.h"
@interface ClassisTableViewCell : UITableViewCell

@property(nonatomic, strong) ClassisModel *classModel;

+ (CGFloat)getTextHeightWith:(ClassisModel *)model;

@end
