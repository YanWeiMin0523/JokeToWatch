//
//  PictureViewController.m
//  jokeToWatch
//
//  Created by scjy on 16/3/8.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "PictureViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ProgressHUD.h"
@interface PictureViewController ()
@property(nonatomic, strong) UIImageView *imageView;
@end

@implementation PictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self backToPreviousPageWithImage];
    self.tabBarController.tabBar.hidden = YES;
    self.title = @"查看图片";
    self.view.backgroundColor = [UIColor whiteColor];
    NSInteger imageH = [self.model.imageHeight integerValue];
    UIScrollView *pictureScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    pictureScroll.contentSize = CGSizeMake(kWidth, imageH);
    [self.view addSubview:pictureScroll];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, imageH)];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.model.shareImage] placeholderImage:nil];
    [pictureScroll addSubview:self.imageView];

    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(kWidth - 40, 0, 44, 44);
    [button setBackgroundImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(LoadingPicture) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    
    
    
}

//收藏图片
- (void)LoadingPicture{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否保存图片" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *alertSure = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        
    }];
    [alertC addAction:alertCancel];
    [alertC addAction:alertSure];
    [self presentViewController:alertC animated:YES completion:nil];
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error != NULL){
        [ProgressHUD showError:@"下载失败"];
    }else{
        [ProgressHUD showSuccess:@"保存成功"];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
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
