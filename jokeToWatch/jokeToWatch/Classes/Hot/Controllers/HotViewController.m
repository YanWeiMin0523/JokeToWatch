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
#import "DetailViewController.h"
@interface HotViewController ()<PullingRefreshTableViewDelegate, UITableViewDataSource, UITableViewDelegate>
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
    //注册cell
    [self.tableVIew registerNib:[UINib nibWithNibName:@"HotTableViewCell" bundle:nil] forCellReuseIdentifier:@"HotCell"];
    //网络请求
    [self hotTitleToRequest];
    [self.tableVIew launchRefreshing];
}

#pragma mark -------------- UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HotTableViewCell *hotCell = [tableView dequeueReusableCellWithIdentifier:@"HotCell" forIndexPath:indexPath];
    HotModel *model = self.allItemsArray[indexPath.row];
    hotCell.hotModel = model;
    hotCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return hotCell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    YWMLog(@"%lu", self.allItemsArray.count);
    return self.allItemsArray.count;
}

#pragma mark ---------- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

#pragma mark ------------ CustomMethod
- (void)hotTitleToRequest{
    AFHTTPSessionManager *hotManager = [AFHTTPSessionManager manager];
    hotManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    [ProgressHUD show:@"正在加载"];
    [hotManager GET:[NSString stringWithFormat:@"%@&page=%lu", kHotPort, _pageCount] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"加载成功"];
        NSDictionary *successDic = responseObject;
        NSInteger count = [successDic[@"count"] integerValue];
        NSInteger error = [successDic[@"err"] integerValue];
        if (count == 30 && error == 0) {
            NSMutableArray *itemsArray = successDic[@"items"];
            for (NSDictionary *dict in itemsArray) {
                [self.allItemsArray setValuesForKeysWithDictionary:dict];
            }
            
        }
        [self.tableVIew reloadData];
        [self.tableVIew tableViewDidFinishedLoading];
        self.tableVIew.reachedTheEnd = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:@"加载失败"];
        YWMLog(@"%@", error);
    }];
    
}

#pragma mark ---------- LazyLodaing
- (PullingRefreshTableView *)tableVIew{
    if (!_tableVIew) {
        self.tableVIew = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 60) style:UITableViewStylePlain];
        self.tableVIew.delegate = self;
        self.tableVIew.dataSource = self;
        self.tableVIew.rowHeight = 100;
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
