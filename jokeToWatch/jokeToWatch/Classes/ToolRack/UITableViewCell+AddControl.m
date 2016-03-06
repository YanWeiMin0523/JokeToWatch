//
//  UITableViewCell+AddControl.m
//  jokeToWatch
//
//  Created by scjy on 16/3/6.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "UITableViewCell+AddControl.h"

@interface UITableViewCell ()
@property (strong, nonatomic)  UIImageView *headImage;
@property (strong, nonatomic)  UILabel *titleLable;
@property (strong, nonatomic)  UILabel *timeLabel;
@property (strong, nonatomic)  UILabel *plainLabel;
@property (strong, nonatomic)  UIButton *appraiseBtn;
@property (strong, nonatomic)  UIButton *votesNBtn;
@property (strong, nonatomic)  UIButton *votesYBtn;
@property (strong, nonatomic)  UILabel *lineLabel;

@end

@implementation UITableViewCell (AddControl)

- (void)addControlToCell{
    self.headImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 3, kWidth / 8, kWidth / 8)];
    [self.contentView addSubview:self.headImage];
    self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(kWidth / 8 + 15, 15, kWidth * 3 / 4, kWidth / 4 / 4)];
    [self.contentView addSubview:self.titleLable];
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth * 7 / 8, 15, kWidth / 8, kWidth / 16)];
    [self.contentView addSubview:self.timeLabel];
    self.plainLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, kWidth / 8 + 10, kWidth - 20, kWidth / 4 )];
    self.plainLabel.numberOfLines = 0;
    self.plainLabel.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:self.plainLabel];
    
    self.votesNBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.votesNBtn setImage:[UIImage imageNamed:@"btn_praise"] forState:UIControlStateNormal];
    [self.votesNBtn addTarget:self action:@selector(addToprise:) forControlEvents:UIControlEventTouchUpInside];
    self.votesNBtn.layer.cornerRadius = 10.0;
    self.votesNBtn.clipsToBounds = YES;
    self.votesNBtn.layer.borderWidth = 1.0;
    self.votesNBtn.tag = 11;
    self.votesYBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.votesYBtn setImage:[UIImage imageNamed:@"btn_down"] forState:UIControlStateNormal];
    [self.votesYBtn addTarget:self action:@selector(addToprise:) forControlEvents:UIControlEventTouchUpInside];
    self.votesYBtn.tag = 10;
    self.votesYBtn.layer.cornerRadius = 10.0;
    self.votesYBtn.clipsToBounds = YES;
    self.votesYBtn.layer.borderWidth = 1.0;
    
    self.appraiseBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.appraiseBtn setImage:[UIImage imageNamed:@"btn_keep"] forState:UIControlStateNormal];
    [self.appraiseBtn addTarget:self action:@selector(addToapprise:) forControlEvents:UIControlEventTouchUpInside];
    self.appraiseBtn.layer.cornerRadius = 10.0;
    self.appraiseBtn.clipsToBounds = YES;
    self.appraiseBtn.layer.borderWidth = 1.0;
    [[UIButton appearance] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.contentView addSubview:self.votesYBtn];
    [self.contentView addSubview:self.votesNBtn];
    [self.contentView addSubview:self.appraiseBtn];
    
    self.lineLabel = [[UILabel alloc] init];
    self.lineLabel.backgroundColor = [UIColor grayColor];
    self.lineLabel.alpha = 0.2;
    [self.contentView addSubview:self.lineLabel];
    
}

//button按钮
- (void)addToprise:(UIButton *)btn{
    if (btn.tag == 10) {
        //点赞
        
    }else{
        //踩
        
    }
    
}
//评论
- (void)addToapprise:(UIButton *)btn{
    
    
}

@end
