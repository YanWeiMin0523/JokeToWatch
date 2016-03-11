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
@property(nonatomic, strong) HotModel *model;

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
    CollectModel *collectManger = [CollectModel collectManger];
    self.collectArray = [NSMutableArray new];
    self.collectArray = [collectManger selectDataHot];
    for (NSDictionary *dic in self.collectArray) {
        self.model = [[HotModel alloc] initWithJokeDictionary:dic];
        [self.allCollectArray addObject:self.model];
        
    }
   
}



#pragma mark ---------------- UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cell = @"cellCollect";
    HotTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:cell];
    if (!tableCell) {
        tableCell = [[HotTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cell];
    }
    tableCell.hotModel = self.allCollectArray[indexPath.row];
    tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return tableCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allCollectArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HotModel *model = self.allCollectArray[indexPath.row];
    CGFloat cellHeight = [HotTableViewCell getCellHeightWith:model];
    return cellHeight + 5;
}
//cell的删除
- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [self.tableView setEditing:YES animated:animated];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    HotModel *model = self.allCollectArray[indexPath.row];
    CollectModel *manger = [CollectModel collectManger];
    [manger deleteData:model.plain];
    [self.allCollectArray removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewAutomaticDimension];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}


#pragma mark ----------- lozyLoading
- (UITableView *)tableView{
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, kWidth, kHeight) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
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
