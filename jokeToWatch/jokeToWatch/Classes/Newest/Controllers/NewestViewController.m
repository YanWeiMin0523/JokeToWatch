//
//  NewestViewController.m
//  jokeToWatch
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "NewestViewController.h"
#import <AFHTTPSessionManager.h>
#import "HotTableViewCell.h"
#import "HotModel.h"
#import "ProgressHUD.h"
#import "PullingRefreshTableView.h"
#import "DetaiViewController.h"
#import "ZMYNetManager.h"
#import "Reachability.h"
@interface NewestViewController ()<UITableViewDataSource, UITableViewDelegate, PullingRefreshTableViewDelegate, cellButtonTargetDelegate>
{
    NSInteger _pageCount;
    
}
@property(nonatomic, strong) PullingRefreshTableView *tableView;
@property(nonatomic, assign) BOOL refreshing;
@property(nonatomic, strong) NSMutableArray *allTitleArray;
@end

@implementation NewestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _pageCount = 1;
    [self.view addSubview:self.tableView];
    [self.tableView launchRefreshing];
    [self newestReqestModel];
    
    
}

- (void)newestReqestModel{
    if (![ZMYNetManager shareZMYNetManager]) {
        [ProgressHUD show:@"当前网络不可用"];
        return;
    }
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    [ProgressHUD show:@"正在加载"];
    [httpManager GET:[NSString stringWithFormat:@"%@&page=%ld", kNewestPort, _pageCount] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"加载成功"];
        NSDictionary *itemDic = responseObject;
        NSInteger count = [itemDic[@"count"] integerValue];
        NSInteger err = [itemDic[@"err"] integerValue];
        if (count > 0 && err == 0) {
            NSArray *itemArray = itemDic[@"items"];
            if (self.refreshing) {
                if (self.allTitleArray.count > 0) {
                    [self.allTitleArray removeAllObjects];
                }
            }
            for (NSDictionary *dict in itemArray) {
                HotModel *model = [[HotModel alloc] initWithJokeDictionary:dict];
                [self.allTitleArray addObject:model];
            }
            
        }else{
            
        }
        [self.tableView tableViewDidFinishedLoading];
        [self.tableView reloadData];
        self.tableView.reachedTheEnd = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:@"加载失败"];
        YWMLog(@"%@", error);
    }];
    
    
}

#pragma mark --------------- UITableVIewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetaiViewController *detailVC = [[DetaiViewController alloc] init];
    HotModel *model = self.allTitleArray[indexPath.row];
    detailVC.detailID = model.jokeID;
    detailVC.detailModel = model;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HotModel *newModel = self.allTitleArray[indexPath.row];
    CGFloat cellHeight = [HotTableViewCell getCellHeightWith:newModel];
    return cellHeight + 5;
}

#pragma mark ----------------- UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *newCell = @"cell";
    HotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:newCell];
    if (!cell) {
        cell = [[HotTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:newCell];
        
    }
    if (indexPath.row < self.allTitleArray.count) {
        HotModel *model = self.allTitleArray[indexPath.row];
        cell.hotModel = model;
    }
    cell.delegate = self;
    self.tableView.separatorColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allTitleArray.count;
}

#pragma mark ----------- PullingTableViewDelegate
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    _pageCount += 1;
    self.refreshing = NO;
    [self performSelector:@selector(newestReqestModel) withObject:nil afterDelay:1.0];
}

- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    _pageCount = 1;
    self.refreshing = YES;
    [self performSelector:@selector(newestReqestModel) withObject:nil afterDelay:1.0];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView tableViewDidScroll:scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidEndDragging:scrollView];
}

- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [TimeTools getNowDate];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = NO;
}

//实现代理方法
- (void)buttonTarget:(UIButton *)btn{
    if (btn.tag == 12) {
        HotTableViewCell *cell = (HotTableViewCell *)[[btn superview] superview];
        NSIndexPath *path = [self.tableView indexPathForCell:cell];
        DetaiViewController *detailVC = [[DetaiViewController alloc] init];
        HotModel *model = self.allTitleArray[path.row] ;
        detailVC.detailID = model.jokeID;
        detailVC.detailModel = model;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
}

#pragma mark -------------- lazyLoading
- (PullingRefreshTableView *)tableView{
    if (!_tableView) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight - 124) pullingDelegate:self];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 150;
        
    }
    return _tableView;
}

- (NSMutableArray *)allTitleArray{
    if (!_allTitleArray) {
        self.allTitleArray = [NSMutableArray new];
    }
    return _allTitleArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
