//
//  CollectModel.h
//  jokeToWatch
//
//  Created by scjy on 16/3/9.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HotModel.h"
@interface CollectModel : NSObject
//使用单例创建数据库对象
+ (CollectModel *)collectManger;
//1.创建数据库
- (void)creatDataBase;
//创建数据库表
- (void)creatDataBaseTable;
//打开数据库
- (void)openDataBase;
//关闭
- (void)closeDataBase;

//插入数据
- (void)insertTntoDataHot:(HotModel *)insertHotData;

//查
- (NSMutableArray *)selectDataHot;

@end
