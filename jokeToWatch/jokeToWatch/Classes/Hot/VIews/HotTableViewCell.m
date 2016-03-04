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
@property (strong, nonatomic)  UIImageView *headImage;
@property (strong, nonatomic)  UILabel *titleLable;
@property (strong, nonatomic)  UILabel *timeLabel;
@property (strong, nonatomic)  UILabel *plainLabel;
@property (strong, nonatomic)  UIButton *appraiseBtn;
@property (strong, nonatomic)  UIButton *votesNBtn;
@property (strong, nonatomic)  UIButton *votesYBtn;


@end

@implementation HotTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addLabelToView];
    }
    return self;
}

- (void)addLabelToView{
    self.headImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 3, kWidth / 8, kWidth / 8)];
    [self.contentView addSubview:self.headImage];
    self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(kWidth / 8 + 15, 5, kWidth * 3 / 4, kWidth / 4 / 4)];
    [self.contentView addSubview:self.titleLable];
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth * 7 / 8, 5, kWidth / 8, kWidth / 16)];
    [self.contentView addSubview:self.timeLabel];
    self.plainLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, kWidth / 8 + 10, kWidth - 20, kWidth / 4 )];
    self.plainLabel.numberOfLines = 0;
    self.plainLabel.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:self.plainLabel];
    
    self.votesNBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.votesNBtn.frame = CGRectMake(10, kWidth * 3 / 8 + 15, 60, 30);
    [self.votesNBtn setImage:[UIImage imageNamed:@"votes_y"] forState:UIControlStateNormal];
    self.votesYBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.votesYBtn.frame = CGRectMake(kWidth / 4 + 30, kWidth * 3 / 8 + 15, 60, 30);
    [self.votesYBtn setImage:[UIImage imageNamed:@"votes_n"] forState:UIControlStateNormal];
    self.appraiseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.appraiseBtn.frame = CGRectMake(kWidth * 5 / 8 + 10, kWidth * 3 / 8 + 15, 60, 30);
    [self.appraiseBtn setTitle:@"123" forState:UIControlStateNormal];
    [self.appraiseBtn setImage:[UIImage imageNamed:@"com"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.votesYBtn];
    [self.contentView addSubview:self.votesNBtn];
    [self.contentView addSubview:self.appraiseBtn];
}

- (void)awakeFromNib {
    // Initialization code
   
}
- (void)setHotModel:(HotModel *)hotModel{
//    [self.headImage sd_setImageWithURL:[NSURL URLWithString:hotModel.headImage] placeholderImage:nil];
    self.headImage.image = [UIImage imageNamed:@"01"];
    self.headImage.layer.cornerRadius = 20;
    self.headImage.clipsToBounds = YES;
    self.timeLabel.text = [NSString stringWithFormat:@"%@", hotModel.time];
    self.titleLable.text = hotModel.title;
    self.plainLabel.text = hotModel.plain;
    [self.votesNBtn setTitle:[NSString stringWithFormat:@"%@", hotModel.votesN] forState:UIControlStateNormal];
    [self.votesYBtn setTitle:[NSString stringWithFormat:@"%@", hotModel.votesY] forState:UIControlStateNormal];
    [self.appraiseBtn setTitle:[NSString stringWithFormat:@"%@", hotModel.apprise] forState:UIControlStateNormal];
    
}

+ (CGFloat)getCellHeightWith:(HotModel *)model{
    CGFloat textHeight = [TimeTools getTextHeight:model.plain bigestSize:CGSizeMake(kWidth -20, 1000) Font:18.0];
    return textHeight + kWidth / 8 + 60;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
