//
//  HotTableViewCell.h
//  jokeToWatch
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotModel.h"
@interface HotTableViewCell : UITableViewCell

@property(nonatomic, strong) HotModel *hotModel;


//获取整个cell的高度
+ (CGFloat)getCellHeightWith:(HotModel *)model;

@end
