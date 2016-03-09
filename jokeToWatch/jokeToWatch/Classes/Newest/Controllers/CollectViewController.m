//
//  CollectViewController.m
//  jokeToWatch
//
//  Created by scjy on 16/3/9.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "CollectViewController.h"
#import "CollectModel.h"
#import "HotTableViewCell.h"

@interface CollectViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *allCollectArray;

@end

@implementation CollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self backToPreviousPageWithImage];
    self.tabBarController.tabBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的收藏";
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}


#pragma mark ---------------- UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cell = @"cellCollect";
    HotTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:cell];
    if (!tableCell) {
        tableCell = [[HotTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cell];
    }
    HotModel *model = [[HotModel alloc] initWithJokeDictionary:self.collectDic];
    tableCell.hotModel = model;
    tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return tableCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    YWMLog(@"%ld", self.collectDic.count);
    return self.collectDic.count;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark ----------- lozyLoading
- (UITableView *)tableView{
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kWidth, kHeight - 64) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 140;
    }
    return _tableView;
}

- (NSMutableArray *)allCollectArray{
    if (!_allCollectArray) {
        self.allCollectArray = [NSMutableArray new];
    }
    return _allCollectArray;
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
