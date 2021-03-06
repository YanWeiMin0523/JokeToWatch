//
//  HotViewController.m
//  jokeToWatch
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "HotViewController.h"
#import "PullingRefreshTableView.h"
#import "HotTableViewCell.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "ProgressHUD.h"
#import "HotModel.h"
#import "DetaiViewController.h"
#import "ZMYNetManager.h"
#import "Reachability.h"
@interface HotViewController ()<PullingRefreshTableViewDelegate, UITableViewDataSource, UITableViewDelegate, cellButtonTargetDelegate>
{
    NSInteger _pageCount;
}
@property(nonatomic, strong) PullingRefreshTableView *tableVIew;
@property(nonatomic, assign) BOOL cenRefresh;
@property(nonatomic, strong) NSMutableArray *allItemsArray;

@end

@implementation HotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _pageCount = 1;
    [self.view addSubview:self.tableVIew];
    //网络请求
    [self hotTitleToRequest];
    [self.tableVIew launchRefreshing];
    
}
//实现代理方法
- (void)buttonTarget:(UIButton *)btn{
    if (btn.tag == 12) {
        //判断点击的是那个cell上的button
        HotTableViewCell *cell = (HotTableViewCell *)[[btn superview] superview];
        NSIndexPath *path = [self.tableVIew indexPathForCell:cell];
        DetaiViewController *detailVC = [[DetaiViewController alloc] init];
        HotModel *model = self.allItemsArray[path.row] ;
            detailVC.detailID = model.jokeID;
            detailVC.detailModel = model;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
}
#pragma mark -------------- UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *hotIden = @"hotCell";
    HotTableViewCell *hotCell = [tableView dequeueReusableCellWithIdentifier:hotIden];
    if (!hotCell) {
        hotCell = [[HotTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:hotIden];
    }
    
    self.tableVIew.separatorColor = [UIColor clearColor];
   
    if (self.allItemsArray.count > indexPath.row) {
        HotModel *hotModel = self.allItemsArray[indexPath.row];
        hotCell.hotModel = hotModel;
    }
    hotCell.delegate = self;

    hotCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return hotCell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.allItemsArray.count;
}

#pragma mark ---------- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetaiViewController *detailVC = [[DetaiViewController alloc] init];
    HotModel *hotModel = self.allItemsArray[indexPath.row];
    detailVC.detailID = hotModel.jokeID;
    detailVC.detailModel = hotModel;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ProgressHUD dismiss];
}

//返回每一行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HotModel *model = self.allItemsArray[indexPath.row];
    CGFloat cellHegiht = [HotTableViewCell getCellHeightWith:model];

    return cellHegiht + 5;
}

#pragma mark ----------- PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    _pageCount += 1;
    self.cenRefresh = NO;
    [self performSelector:@selector(hotTitleToRequest) withObject:nil afterDelay:1.0];
}

- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    _pageCount = 1;
    self.cenRefresh = YES;
    [self performSelector:@selector(hotTitleToRequest) withObject:nil afterDelay:1.0];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableVIew tableViewDidScroll:scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableVIew tableViewDidEndDragging:scrollView];
}

- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [TimeTools getNowDate];
}

#pragma mark ------------ CustomMethod
- (void)hotTitleToRequest{
    if (![ZMYNetManager shareZMYNetManager]) {
        [ProgressHUD show:@"当前网络不可用"];
        return;
    }
    AFHTTPSessionManager *hotManager = [AFHTTPSessionManager manager];
    hotManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    [ProgressHUD show:@"正在加载"];
    [hotManager GET:[NSString stringWithFormat:@"%@&page=%lu", kHotPort, (long)_pageCount] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"加载成功"];
        NSDictionary *successDic = responseObject;
        NSInteger count = [successDic[@"count"] integerValue];
        NSInteger error = [successDic[@"err"] integerValue];
        if (count > 0 && error == 0) {
            NSArray *itemsArray = successDic[@"items"];
            if (self.cenRefresh) {
            if (self.allItemsArray.count > 0) {
                [self.allItemsArray removeAllObjects];
            }
            }
            for (NSDictionary *dict in itemsArray) {
                HotModel *model = [[HotModel alloc] initWithJokeDictionary:dict];
                [self.allItemsArray addObject:model];
            }
        }else{
            
        }
        [self.tableVIew reloadData];
        [self.tableVIew tableViewDidFinishedLoading];
        self.tableVIew.reachedTheEnd = NO;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:@"加载失败"];
//        YWMLog(@"%@", error);
    }];
    
}

#pragma mark ---------- LazyLodaing
- (PullingRefreshTableView *)tableVIew{
    if (!_tableVIew) {
        self.tableVIew = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight - 120) pullingDelegate:self];
        self.tableVIew.delegate = self;
        self.tableVIew.dataSource = self;
    }
    return _tableVIew;
}

- (NSMutableArray *)allItemsArray{
    if (!_allItemsArray) {
        self.allItemsArray = [NSMutableArray new];
    }
    return _allItemsArray;
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
