//
//  DetaiViewController.m
//  jokeToWatch
//
//  Created by scjy on 16/3/6.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "DetaiViewController.h"
#import <AFHTTPSessionManager.h>
@interface DetaiViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UITextField *commentText;
@property(nonatomic, strong) NSMutableArray *commentArray;
@property(nonatomic, strong) UIButton *publishBtn;

@end

@implementation DetaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self backToPreviousPageWithImage];
    self.tabBarController.tabBar.hidden = YES;
   self.title = @"我要评论";
    [self.view addSubview:self.commentText];
    [self.view addSubview:self.tableView];
    
    UIImage *image = [UIImage imageNamed:@"pulish_bg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.publishBtn addSubview:self.view];

//    [self getRequest];
}


#pragma mark ------------ UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cell = @"cell";
    UITableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:cell];
    if (tableCell == nil) {
        tableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell];
    }
    tableCell.textLabel.text = self.commentArray[indexPath.row];
    
    return tableCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentArray.count;
}

#pragma mark ------------- CustomMethod

- (void)getRequest{
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
    [httpManager GET:[NSString stringWithFormat:@"%@/%@/comments?count=50&page=%d", kHotDetailPort1, self.detailID, 1] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YWMLog(@"%@", responseObject);
        NSDictionary *detailDic = responseObject;
        NSInteger count = [detailDic[@"count"] integerValue];
        NSInteger err = [detailDic[@"err"] integerValue];
        if (count > 0 && err == 0) {

            
            
        }else{
        
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        YWMLog(@"%@", error);
    }];
}

#pragma mark ------------ LazyLoading
- (UITableView *)tableView{
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 120) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
    }
    return _tableView;
}

- (UITextField *)commentText{
    if (!_commentText) {
        self.commentText = [[UITextField alloc] initWithFrame:CGRectMake(10, kHeight - 40, kWidth - 50, 40)];
        [self.commentText addTarget:self action:@selector(changeTextPlace) forControlEvents:UIControlEventTouchUpInside];
        self.commentText.delegate = self;
        self.commentText.backgroundColor = [UIColor redColor];
        self.commentText.placeholder = @"这一刻你在想什么";
        self.commentText.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.commentText.clearButtonMode = UITextFieldViewModeAlways;
        [self.commentArray addObject:self.commentText.text];
        
    }
    return _commentText;
}
//
//- (void)changeTextPlace{
//    self.commentText = [[UITextField alloc] initWithFrame:CGRectMake(0, kHeight - 400, kWidth - 60, 40)];
//}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.commentText = [[UITextField alloc] initWithFrame:CGRectMake(10, kHeight - 200, kWidth - 60, 40)];
}

- (NSMutableArray *)commentArray{
    if (!_commentArray) {
        self.commentArray = [NSMutableArray new];
    }
    return _commentArray;
}

- (UIButton *)publishBtn{
    if (!_publishBtn) {
        self.publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.publishBtn.frame = CGRectMake(kWidth-30, kHeight-40, 50, 40);
        [self.publishBtn addTarget:self action:@selector(pulblishThink:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _publishBtn;
}

- (void)pulblishThink:(UIButton *)btn{
    
    
    
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
