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
@interface SetViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *titleArray;
@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(kWidth - 44, 0, 44, 44);
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(goToLogin) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:loginBtn];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    //cell
    self.titleArray = [NSMutableArray arrayWithObjects:@"清理图片缓存", @"当前版本",@"评分" ,nil];
    
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
        {
            NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
            
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

- (UITableView *)tableView{
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 60;
    }
    return _tableView;
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
