//
//  DetailViewController.m
//  jokeToWatch
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *shareLabel;
@property (weak, nonatomic) IBOutlet UIButton *voteUpBtn;
@property (weak, nonatomic) IBOutlet UIButton *voteDownBtn;
@property (weak, nonatomic) IBOutlet UILabel *plainLabel;

@property (weak, nonatomic) IBOutlet UIButton *appriaseBtn;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"糗事详情";
    [self backToPreviousPageWithImage];
    
    self.tabBarController.tabBar.hidden = YES;
    self.scrollView.contentSize = CGSizeMake(kWidth, kHeight);
    UIImage *image = [UIImage imageNamed:@"pulish_bg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    self.scrollView.backgroundColor = [UIColor clearColor];

    self.titleLabel.text = _model.title;
    //重新
    CGFloat hegiht = [[self class] getTextHeightWithText:_model.plain];
    CGRect labelFrame = self.plainLabel.frame;
    labelFrame.size.height = hegiht;
    self.plainLabel.frame = labelFrame;
    self.plainLabel.text = _model.plain;

    self.shareLabel.text = [NSString stringWithFormat:@"分享:%@", _model.time];
    [self.voteDownBtn setTitle:[NSString stringWithFormat:@"%@", _model.votesN] forState:UIControlStateNormal];
    self.voteDownBtn.frame = CGRectMake(10, hegiht + kWidth / 8, 100, 30);
    [self.voteUpBtn setTitle:[NSString stringWithFormat:@"%@", _model.votesY] forState:UIControlStateNormal];
    [self.appriaseBtn setTitle:[NSString stringWithFormat:@"%@", _model.apprise] forState:UIControlStateNormal];
    [[UIButton appearance] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.tabBarController.tabBar.hidden = NO;
}


//计算文本高度
+ (CGFloat)getTextHeightWithText:(NSString *)text{
    CGRect textRect = [text boundingRectWithSize:CGSizeMake(kWidth - 20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.0]} context:nil];
    return textRect.size.height;
    
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
