//
//  ClassicsViewController.m
//  jokeToWatch
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "ClassicsViewController.h"
#import "PullingRefreshTableView.h"
#import "ProgressHUD.h"
#import "ClassisTableViewCell.h"
#import "ClassisModel.h"
#import <AFHTTPSessionManager.h>
#import "PictureViewController.h"
#import "ZMYNetManager.h"
#import "Reachability.h"
@interface ClassicsViewController ()<UITableViewDataSource, UITableViewDelegate, PullingRefreshTableViewDelegate>
{
    NSInteger _pageCount;
}

@property(nonatomic, strong) PullingRefreshTableView *tableView;
@property(nonatomic, strong) NSMutableArray *allTextArray;
@property(nonatomic, assign) BOOL canRefresh;

@end

@implementation ClassicsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _pageCount = 1;
    [self.view addSubview:self.tableView];
    
    [self classisRequest];



}


#pragma mark ------------- UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cell = @"cell";
    ClassisTableViewCell *classisCell = [tableView dequeueReusableCellWithIdentifier:cell];
    if (classisCell == nil) {
        classisCell = [[ClassisTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cell];
    }
    if (indexPath.row < self.allTextArray.count) {
        ClassisModel *model = self.allTextArray[indexPath.row];
        classisCell.classModel = model;
    }    
    classisCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return classisCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PictureViewController *pictureVC = [[PictureViewController alloc] init];
    pictureVC.model = self.allTextArray[indexPath.row];
    if (pictureVC.model.shareImage != nil) {
        [self.navigationController pushViewController:pictureVC animated:YES];
    }
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allTextArray.count;
}

#pragma mark ------------- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ClassisModel *model = self.allTextArray[indexPath.row];
    CGFloat height = [ClassisTableViewCell getTextHeightWith:model];
    return height;
}

#pragma mark --------------- CustomMethod
- (void)classisRequest{
    if (![ZMYNetManager shareZMYNetManager]) {
        [ProgressHUD show:@"当前网络不可用"];
        return;
    }
    AFHTTPSessionManager *classisManager = [AFHTTPSessionManager manager];
    classisManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    [ProgressHUD show:@"正在加载"];
    [classisManager GET:[NSString stringWithFormat:@"%@&page=%ld", kClassisPort, _pageCount] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"加载成功"];
        NSDictionary *classisDic = responseObject;
        NSArray *successArray = classisDic[@"list"];
        if (self.canRefresh) {
        if (self.allTextArray.count > 0) {
            [self.allTextArray removeAllObjects];
        }
        }
        for (NSDictionary *dict in successArray) {
            ClassisModel *model = [[ClassisModel alloc] initWithClassisDictionary:dict];
            [self.allTextArray addObject:model];
            
            
        }
        self.tableView.reachedTheEnd = NO;;
        [self.tableView reloadData];
        [self.tableView tableViewDidFinishedLoading];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showSuccess:@"数据加载失败"];
        YWMLog(@"%@", error);
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ProgressHUD dismiss];
}

- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    _pageCount += 1;
    self.canRefresh = YES;
    [self performSelector:@selector(classisRequest) withObject:nil afterDelay:1.0];
    
}

- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    _pageCount = 1;
    self.canRefresh = NO;
    [self performSelector:@selector(classisRequest) withObject:nil afterDelay:1.0];
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidEndDragging:scrollView];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView tableViewDidScroll:scrollView];
}
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [TimeTools getNowDate];
}

#pragma mark ------------- LazyLoading
- (PullingRefreshTableView *)tableView{
    if (!_tableView) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight - 124) pullingDelegate:self];
        self.tableView.delegate= self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = kWidth;
        
    }
    return _tableView;
}

- (NSMutableArray *)allTextArray{
    if (!_allTextArray) {
        self.allTextArray = [NSMutableArray new];
    }
    return _allTextArray;
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
