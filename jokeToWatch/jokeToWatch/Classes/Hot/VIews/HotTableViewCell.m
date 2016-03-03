//
//  HotTableViewCell.m
//  jokeToWatch
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "HotTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface HotTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *plainLabel;
@property (weak, nonatomic) IBOutlet UIButton *appraiseBtn;
@property (weak, nonatomic) IBOutlet UIButton *votesNBtn;
@property (weak, nonatomic) IBOutlet UIButton *votesYBtn;

@end

@implementation HotTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)setHotModel:(HotModel *)hotModel{
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:hotModel.headImage] placeholderImage:nil];
    self.headImage.layer.cornerRadius = 20;
    self.headImage.clipsToBounds = YES;
    self.timeLabel.text = hotModel.time;
    self.titleLable.text = hotModel.title;
    self.plainLabel.text = hotModel.plain;
    [self.votesNBtn setTitle:hotModel.votesN forState:UIControlStateNormal];
    [self.votesYBtn setTitle:hotModel.votesY forState:UIControlStateNormal];
    [self.appraiseBtn setTitle:hotModel.apprise forState:UIControlStateNormal];
    
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
