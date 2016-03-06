//
//  UIViewController+BackPage.m
//  jokeToWatch
//
//  Created by scjy on 16/3/5.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "UIViewController+BackPage.h"

@implementation UIViewController (BackPage)

- (void)backToPreviousPageWithImage{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"search_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToPreviousPage:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBar;
    
}

- (void)backToPreviousPage:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
