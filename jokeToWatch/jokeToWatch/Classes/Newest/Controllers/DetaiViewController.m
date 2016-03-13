//
//  DetaiViewController.m
//  jokeToWatch
//
//  Created by scjy on 16/3/6.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "DetaiViewController.h"
#import <AFHTTPSessionManager.h>
#import "HotTableViewCell.h"
#import "CommentModel.h"
#import "DetailTableViewCell.h"
#import "PullingRefreshTableView.h"
#import "ZMYNetManager.h"
#import "Reachability.h"
#import "ProgressHUD.h"
#import "CollectModel.h"
#import "ShareView.h"
@interface DetaiViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, PullingRefreshTableViewDelegate>
{
    NSInteger _pageCount;
}

@property(nonatomic, strong) PullingRefreshTableView *tableView;
@property(nonatomic, strong) UITextField *commentText;
@property(nonatomic, strong) NSMutableArray *commentArray;
@property(nonatomic, strong) UIButton *publishBtn;
@property(nonatomic, assign) BOOL refreshing;

@end

@implementation DetaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _pageCount = 1;
    [self.tableView launchRefreshing];
    [self backToPreviousPageWithImage];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
    self.title = @"爆笑详情";
    [self.view addSubview:self.tableView];
      //收藏
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(kWidth - 40, 0, 30, 30);
    [button setBackgroundImage:[UIImage imageNamed:@"icon_post_enable"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pulblishThink) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //分享
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
    shareBtn.frame = CGRectMake(kWidth - 10, 0, 30, 30);

    [shareBtn addTarget:self action:@selector(goToShare) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIBarButtonItem *shareBar = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    self.navigationItem.rightBarButtonItems = @[shareBar, rightBtn];
    
    
    
    [self getRequest];
    
}

#pragma mark ------------ UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
    static NSString *cell = @"cell";
    HotTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:cell];
    if (tableCell == nil) {
        tableCell = [[HotTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell];
    }
        
        tableCell.hotModel = self.detailModel;
        return tableCell;
    }else{
        static NSString *cell = @"commentCell";
        DetailTableViewCell *detailCell = [tableView dequeueReusableCellWithIdentifier:cell];
        if (detailCell == nil) {
            detailCell = [[DetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell];
        }
        if (indexPath.row < self.commentArray.count) {
            CommentModel *model = self.commentArray[indexPath.row];
            detailCell.commentModel = model;
        }
        self.tableView.separatorColor = [UIColor clearColor];
        detailCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return detailCell;
    }
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return self.commentArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 5, kWidth, 30)];
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, kWidth - 10, 30)];
    if (section == 1) {
        numLabel.text = [NSString stringWithFormat:@"%lu条评论", (unsigned long)self.commentArray.count];
        view.backgroundColor = [UIColor grayColor];
        view.alpha = 0.3;
        [view addSubview:numLabel];
    }
    return view;
    
}
//区头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
    return 30;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
    CGFloat cellHeight = [HotTableViewCell getCellHeightWith:self.detailModel];
    return cellHeight + 5;
    }
    CommentModel *model = self.commentArray[indexPath.row];
    CGFloat cellComment = [DetailTableViewCell getCellHeightWith:model];
    return cellComment + 5;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.tabBarController.tabBar.hidden = NO;
    [ProgressHUD dismiss];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

#pragma mark ------------- CustomMethod

- (void)getRequest{
    if (![ZMYNetManager shareZMYNetManager]) {
        [ProgressHUD show:@"当前网络不可用"];
        return;
    }
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
    [httpManager GET:[NSString stringWithFormat:@"%@/%@/comments?count=50&page=%ld", kHotDetailPort1, self.detailID, (long)_pageCount] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *detailDic = responseObject;
        NSInteger count = [detailDic[@"count"] integerValue];
        NSInteger err = [detailDic[@"err"] integerValue];
        if (count > 0 && err == 0) {
            NSArray *array = detailDic[@"items"];
            if (self.refreshing) {
                if (self.commentArray.count>0) {
                    [self.commentArray removeAllObjects];
                }
            }
            for (NSDictionary *dic in array) {
                CommentModel *model = [[CommentModel alloc] initWithCommentDictionary:dic];
                [self.commentArray addObject:model];
            }
            
        }else{
        
        }
        
        [self.tableView tableViewDidFinishedLoading];
        [self.tableView reloadData];
        self.tableView.reachedTheEnd = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        YWMLog(@"%@", error);
    }];
}

#pragma mark -----------PullingTableViewDelegate
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    _pageCount = +1;
    self.refreshing = NO;
    [self performSelector:@selector(getRequest) withObject:nil afterDelay:1.0];
}
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    _pageCount = 1;
    self.refreshing = YES;
    [self performSelector:@selector(getRequest) withObject:nil afterDelay:1.0];
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


#pragma mark ------------ LazyLoading
- (PullingRefreshTableView *)tableView{
    if (!_tableView) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight - 64) pullingDelegate:self];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)commentArray{
    if (!_commentArray) {
        self.commentArray = [NSMutableArray new];
    }
    return _commentArray;
}

- (void)pulblishThink{
    CollectModel *dataManger = [CollectModel collectManger];
    [dataManger insertTntoDataHot:self.detailModel];
    [ProgressHUD showSuccess:@"收藏成功"];
}

- (void)goToShare{
    ShareView *shareView = [[ShareView alloc] init];
    shareView.model = self.detailModel;
    [self.view addSubview:shareView];
    
}

//回收键盘
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
