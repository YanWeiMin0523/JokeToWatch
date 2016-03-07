//
//  DetaiViewController.h
//  jokeToWatch
//
//  Created by scjy on 16/3/6.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotModel.h"
@interface DetaiViewController : UIViewController

@property(nonatomic, strong) NSString *detailID;
//cell整个传到详情页面
@property(nonatomic, strong) HotModel *detailModel;

@end
