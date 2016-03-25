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
#import <BmobSDK/Bmob.h>
#import "LoginViewController.h"
@interface DetaiViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, PullingRefreshTableViewDelegate>
{
    NSInteger _pageCount;
}

@property(nonatomic, strong) PullingRefreshTableView *tableView;
@property(nonatomic, strong) UITextField *commentText;
@property(nonatomic, strong) NSMutableArray *commentArray;
@property(nonatomic, strong) UIButton *publishBtn;
@property(nonatomic, assign) BOOL refreshing;
@property(nonatomic, strong) UIButton *button;

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
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = CGRectMake(kWidth - 40, 0, 30, 30);
    CollectModel *mangerM = [CollectModel collectManger];
    NSMutableArray *array  = [mangerM selectDataHot];
    if (array.count == 0) {
        [self.button setImage:[UIImage imageNamed:@"pc_menu_03"] forState:UIControlStateNormal];
        self.button.tag = 11;
    }else{
        for (NSDictionary *dic in array) {
            NSString *content = dic[@"content"];
            if ([content isEqualToString:self.detailModel.plain]) {
                [self.button setImage:[UIImage imageNamed:@"pc_menu_collect_normal_ic"] forState:UIControlStateNormal];
                self.button.tag = 10;
            }else{
                 [_button setBackgroundImage:[UIImage imageNamed:@"ipc_menu_03"] forState:UIControlStateNormal];
                self.button.tag = 11;
            }
            
        }
    }
   
    [_button addTarget:self action:@selector(pulblishThink:) forControlEvents:UIControlEventTouchUpInside];
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //分享
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:_button];
    
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

- (void)pulblishThink:(UIButton *)btn{
    
    CollectModel *dataManger = [CollectModel collectManger];
    
    if (btn.tag == 10) {
        [dataManger deleteData:self.detailModel.plain];
        [self.button setImage:[UIImage imageNamed:@"pc_menu_03"] forState:UIControlStateNormal];
        self.button.tag = 11;
        [ProgressHUD showSuccess:@"取消收藏"];
    }else if (btn.tag == 11){
        BmobUser *user = [BmobUser getCurrentUser];
        if (user.objectId == nil) {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"😊，你还没有登陆哦!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cencel = [UIAlertAction actionWithTitle:@"不了/(ㄒoㄒ)/~~" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"我要登陆:-D" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIStoryboard *story = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
                LoginViewController *loginVC = [story instantiateViewControllerWithIdentifier:@"LoginID"];
                [self.navigationController pushViewController:loginVC animated:YES];
                
            }];
            [alertC addAction:cencel];
            [alertC addAction:sure];
            [self presentViewController:alertC animated:YES completion:nil];
        }else{
            [self.button setImage:[UIImage imageNamed:@"pc_menu_collect_normal_ic"] forState:UIControlStateNormal];
            self.button.tag = 10;
            [dataManger insertTntoDataHot:self.detailModel];
            [ProgressHUD showSuccess:@"收藏成功"];

        }
        
    }
    
}

- (void)goToShare{
    ShareView *shareView = [[ShareView alloc] init];
    shareView.model = self.detailModel;
    [self.view addSubview:shareView];
    
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
