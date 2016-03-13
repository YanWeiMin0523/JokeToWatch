//
//  CollectModel.m
//  jokeToWatch
//
//  Created by scjy on 16/3/9.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "CollectModel.h"
#import <sqlite3.h>
@interface CollectModel ()
{
    NSString *dataBasePath;
}

@end

@implementation CollectModel
//静态单例对象
static CollectModel *dbManger = nil;

//实现单例方法
+ (CollectModel *)collectManger{
    if (dbManger == nil) {
        dbManger = [[CollectModel alloc] init];
    }
    return dbManger;
}

//创建数据库
static sqlite3 *dataBase = nil;
- (void)creatDataBase{
    //获取沙盒路径
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    //创建数据库路径
    dataBasePath = [document stringByAppendingPathComponent:@"/mango.sqlite"];
//    YWMLog(@"%@", dataBasePath);
    
}

- (void)openDataBase{
    if (dataBase != nil) {
        return;
    }
    [self creatDataBase];
    int result = sqlite3_open([dataBasePath UTF8String], &dataBase);
    if (result == SQLITE_OK) {
        [self creatDataBaseTable];
    }else{
//        YWMLog(@"数据库打开失败");
    }
}

- (void)creatDataBaseTable{
   NSString *sql = @"CREATE TABLE HotModel (number INTEGER PRIMARY KEY AUTOINCREMENT, headImage TEXT, title TEXT, time TEXT, plain TEXT, down TEXT, up TEXT, apprise TEXT, imageID, TEXT)";
    char *err = nil;
    sqlite3_exec(dataBase, [sql UTF8String], NULL, NULL, &err);
    
    
}

- (void)closeDataBase{
    
    int result = sqlite3_close(dataBase);
    if (result == SQLITE_OK) {
        dataBase = nil;
    }else{
//        YWMLog(@"数据库关闭失败");
    }
}

//数据库方法
- (void)insertTntoDataHot:(HotModel *)insertHotData{
    [self openDataBase];
    sqlite3_stmt *stmt = nil;
    NSString *sql = @"INSERT INTO HotModel(headImage, title, time, plain, down, up, apprise, imageID) VALUES(?,?,?,?,?,?,?,?)";
    //验证语句
    int result = sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, nil);
    if (result == SQLITE_OK) {
        //绑定
        sqlite3_bind_text(stmt, 1, [insertHotData.headImage UTF8String], -1, nil);
        if (insertHotData.title == nil) {
            insertHotData.title = @"匿名用户";
            sqlite3_bind_text(stmt, 2, [insertHotData.title UTF8String], -1, nil);
        }else{
        sqlite3_bind_text(stmt, 2, [insertHotData.title UTF8String], -1, nil);
        }
        NSString *time = [NSString stringWithFormat:@"%@", insertHotData.time];
         sqlite3_bind_text(stmt, 3, [time UTF8String], -1, NULL);
         sqlite3_bind_text(stmt, 4, [insertHotData.plain UTF8String], -1, nil);
        
        NSString *down = [NSString stringWithFormat:@"%@", insertHotData.votesN];
         sqlite3_bind_text(stmt, 5, [down UTF8String], -1, NULL);
        NSString *up = [NSString stringWithFormat:@"%@", insertHotData.votesY];
         sqlite3_bind_text(stmt, 6, [up UTF8String], -1, NULL);
        NSString *apprise = [NSString stringWithFormat:@"%@", insertHotData.apprise];
         sqlite3_bind_text(stmt, 7, [apprise UTF8String], -1, NULL);
        NSString *imageID = [NSString stringWithFormat:@"%@", insertHotData.imageID];
        sqlite3_bind_text(stmt, 8, [imageID UTF8String], -1, NULL);
        
        //执行
        sqlite3_step(stmt);
    }else{
//        YWMLog(@"SQL语句有问题");
    }
    //删除释放
    sqlite3_finalize(stmt);
    
}

//查找
- (NSMutableArray *)selectDataHot{
    [self openDataBase];
    sqlite3_stmt *stmt = nil;
    NSString *sql = @"SELECT * FROM HotModel";
    //验证语句
    int result = sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, nil);
    NSMutableArray *collectArray = [NSMutableArray new];
    if (result == SQLITE_OK) {
//        YWMLog(@"语句通过");
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            NSMutableDictionary *selectDic = [NSMutableDictionary new];
            NSMutableDictionary *userDic = [NSMutableDictionary new];
            NSMutableDictionary *voteDic = [NSMutableDictionary new];

            NSString *headImage = [NSString stringWithUTF8String:(const char *) sqlite3_column_text(stmt, 1)];
            NSString *title = [NSString stringWithUTF8String:(const char *) sqlite3_column_text(stmt, 2)];
            NSString *time = [NSString stringWithUTF8String:(const char *) sqlite3_column_text(stmt, 3)];
            NSString *plain = [NSString stringWithUTF8String:(const char *) sqlite3_column_text(stmt, 4)];
            NSString *down = [NSString stringWithUTF8String:(const char *) sqlite3_column_text(stmt, 5)];
            NSString *up = [NSString stringWithUTF8String:(const char *) sqlite3_column_text(stmt, 6)];
            NSString *apprise = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 7)];
            NSString *imageID = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(stmt, 8)];
            
            [userDic setValue:headImage forKey:@"image"];
            [userDic setValue:title forKey:@"login"];
            [selectDic setValue:userDic forKey:@"user"];
            
            [selectDic setValue:time forKey:@"created_at"];
            [selectDic setValue:plain forKey:@"content"];
            [voteDic setValue:down forKey:@"down"];
            [voteDic setValue:up forKey:@"up"];
            [selectDic setValue:voteDic forKey:@"votes"];
            
            [selectDic setValue:apprise forKey:@"allow_comment"];
            [userDic setValue:imageID forKey:@"imageID"];
            
            [collectArray addObject:selectDic];
        }
    }
    sqlite3_finalize(stmt);
    return collectArray;
}

- (void)deleteData:(NSString *)plain{
    [self openDataBase];
    sqlite3_stmt *stmt = nil;
    NSString *sql = @"DELETE FROM HotModel WHERE plain = ?";
    //验证语句
    int result = sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, nil);
    if (result == SQLITE_OK) {
        //绑定
        sqlite3_bind_text(stmt, 1, [plain UTF8String], -1, nil);
        sqlite3_step(stmt);
    
    }else{
//        YWMLog(@"删除语句有问题");
    }
    sqlite3_finalize(stmt);
}

@end
