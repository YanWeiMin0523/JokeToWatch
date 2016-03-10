//
//  SetViewController.m
//  jokeToWatch
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "SetViewController.h"
#import "ProgressHUD.h"
#import <SDWebImage/SDImageCache.h>
#import "LoginViewController.h"
#import "LPLevelView.h"
#import "CollectViewController.h"
#import "CollectModel.h"
@interface SetViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *titleArray;
@property(nonatomic, strong) UIButton *loginBtn;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) LPLevelView *leveView;
@property(nonatomic, strong) UIView *levelV;

@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    
    //cell
    self.titleArray = [NSMutableArray arrayWithObjects:@"清理图片缓存", @"当前版本",@"评分", @"我的收藏",nil];
    //头部
    [self headImageView];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
}

- (void)headImageView{
    UIView *headView =[[UIView alloc] initWithFrame:CGRectMake(0, 5, kWidth, 150)];
    headView.backgroundColor =[UIColor colorWithRed:255.0/255.0 green:194/255.0 blue:90/255.0 alpha:1.0];
    self.tableView.tableHeaderView = headView;
    [headView addSubview:self.loginBtn];
    [headView addSubview:self.nameLabel];
    
}

//button点击登录
- (void)goToLogin{
    UIStoryboard *loginStory = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    LoginViewController *loginVC = [loginStory instantiateViewControllerWithIdentifier:@"LoginID"];
    [self.navigationController pushViewController:loginVC animated:YES];
}

//计算图片缓存
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    NSInteger cacheSize = [imageCache getSize];
    NSString *cacheStr = [NSString stringWithFormat:@"清除图片缓存(%.02fM)", (float)cacheSize/1024/1024];
    [self.titleArray replaceObjectAtIndex:0 withObject:cacheStr];
    NSIndexPath *dePath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[dePath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cell = @"cell";
    UITableViewCell *setCell = [tableView dequeueReusableCellWithIdentifier:cell];
    if (setCell == nil) {
   setCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cell];
    }
    
    setCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    setCell.textLabel.text = self.titleArray[indexPath.row];
    setCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return setCell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            [self clearImage];
            break;
            
        case 1:
        {
            [ProgressHUD show:@"正在为你检测"];
            [self performSelector:@selector(checkVersions) withObject:nil afterDelay:1.0];
            
        }
            break;
        case 2:
            
            [self gradeToApp];
            
            break;
        case 3:
            //推出收藏界面
            [self pushCollectVC];
            
            break;
            
        default:
            break;
    }
    
    
}

- (void)clearImage{
    [ProgressHUD showSuccess:@"已为你清场"];
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache clearDisk];
    [self.titleArray replaceObjectAtIndex:0 withObject:@"清理图片缓存"];
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (void)checkVersions{
    [ProgressHUD showSuccess:@"已是当前最新版本"];
}
//评分
- (void)gradeToApp{
    self.tabBarController.tabBar.hidden = YES;
    //初始化一个视图作画布
    self.levelV = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight - 300, kWidth, 250)];
    self.levelV.backgroundColor = [UIColor whiteColor];
    self.levelV.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.levelV.layer.borderWidth = 0.5;
    [self.view addSubview:self.levelV];
    
    UIButton *removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    removeBtn.frame = CGRectMake(50, 150, kWidth-100, 30);
    removeBtn.backgroundColor = [UIColor redColor];
    [removeBtn setTitle:@"确定评分" forState:UIControlStateNormal];
    [removeBtn addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    [self.levelV addSubview:removeBtn];
    
    LPLevelView *lView = [LPLevelView new];
    lView.frame = CGRectMake(120, 80, 150, 44 );
    lView.iconColor = [UIColor orangeColor];
    lView.iconSize = CGSizeMake(20, 20);
    lView.canScore = YES;
    lView.animated = YES;
    lView.level = 2.5;
    [lView setScoreBlock:^(float level) {
        NSLog(@"打分：%.02f", level);
        NSString *gradeStr = [NSString stringWithFormat:@"评分(%.02f分)", level];
        [self.titleArray replaceObjectAtIndex:2 withObject:gradeStr];
        NSIndexPath *dePath = [NSIndexPath indexPathForRow:2 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[dePath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        
    }];
    [self.levelV addSubview:lView];
    
}
//我的收藏
- (void)pushCollectVC{
    CollectViewController *collectVC = [[CollectViewController alloc] init];
    CollectModel *collectManger = [CollectModel collectManger];
    [collectManger openDataBase];
    NSMutableArray *collectDic = [collectManger selectDataHot];
    collectVC.collectArray = collectDic;
    [self.navigationController pushViewController:collectVC animated:YES];
    
}

-(void)removeView{
    [self.levelV removeFromSuperview];
    self.tabBarController.tabBar.hidden = NO;
    
}
#pragma mark ------------------ LazyLoading
- (UITableView *)tableView{
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 60;
    }
    return _tableView;
}

- (UIButton *)loginBtn{
    if (!_loginBtn) {
        self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.loginBtn.frame = CGRectMake(20, 20, 120, 120);
        self.loginBtn.layer.cornerRadius = 60;
        self.loginBtn.clipsToBounds = YES;
        [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
        [self.loginBtn addTarget:self action:@selector(goToLogin) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 60, kWidth-150, 30)];
        self.nameLabel.numberOfLines = 0;
        self.nameLabel.text = @"爆笑看点,让你看到笑爆！";
        self.nameLabel.textColor = [UIColor whiteColor];
        self.nameLabel.font = [UIFont systemFontOfSize:19.0];
    }
    return _nameLabel;
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
