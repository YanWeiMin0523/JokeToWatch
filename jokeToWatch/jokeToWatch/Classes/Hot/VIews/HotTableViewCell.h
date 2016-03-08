//
//  HotTableViewCell.h
//  jokeToWatch
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotModel.h"
//代理传button的tag值
@protocol cellButtonTargetDelegate <NSObject>

- (void)buttonTarget:(UIButton *)btn;

@end
@interface HotTableViewCell : UITableViewCell

@property(nonatomic, strong) HotModel *hotModel;
@property(nonatomic, assign) id<cellButtonTargetDelegate>delegate;


//获取整个cell的高度
+ (CGFloat)getCellHeightWith:(HotModel *)model;

@end
