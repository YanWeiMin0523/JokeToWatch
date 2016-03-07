//
//  HotTableViewCell.m
//  jokeToWatch
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "HotTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DetaiViewController.h"
@interface HotTableViewCell ()
{
    CGFloat _lastLabelBottom;//自定义后label的高度
}
@property (strong, nonatomic)  UIImageView *headImage;
@property (strong, nonatomic)  UILabel *titleLable;
@property (strong, nonatomic)  UILabel *timeLabel;
@property (strong, nonatomic)  UILabel *plainLabel;
@property (strong, nonatomic)  UIButton *appraiseBtn;
@property (strong, nonatomic)  UIButton *votesNBtn;
@property (strong, nonatomic)  UIButton *votesYBtn;
@property (strong, nonatomic)  UILabel *lineLabel;

@end

@implementation HotTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addControlToCell];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

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
    
    self.votesNBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.votesNBtn setImage:[UIImage imageNamed:@"icon_for_bad"] forState:UIControlStateNormal];
    [self.votesNBtn addTarget:self action:@selector(addToprise:) forControlEvents:UIControlEventTouchUpInside];
    self.votesNBtn.layer.cornerRadius = 10.0;
    self.votesNBtn.clipsToBounds = YES;
    self.votesNBtn.layer.borderWidth = 1.0;
    self.votesNBtn.tag = 11;
    self.votesYBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.votesYBtn setImage:[UIImage imageNamed:@"icon_for_good"] forState:UIControlStateNormal];
    [self.votesYBtn addTarget:self action:@selector(addToprise:) forControlEvents:UIControlEventTouchUpInside];
    self.votesYBtn.tag = 10;
    self.votesYBtn.layer.cornerRadius = 10.0;
    self.votesYBtn.clipsToBounds = YES;
    self.votesYBtn.layer.borderWidth = 1.0;
    
    self.appraiseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.appraiseBtn setImage:[UIImage imageNamed:@"icon_for_comment"] forState:UIControlStateNormal];
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


- (void)setHotModel:(HotModel *)hotModel{
    if (hotModel.headImage == nil) {
        [self.headImage setImage:[UIImage imageNamed:@"defaultHeadImage"]];
    }
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:hotModel.headImage] placeholderImage:nil];
    self.headImage.layer.cornerRadius = 10;
    self.headImage.clipsToBounds = YES;
    self.timeLabel.text = [NSString stringWithFormat:@"%@", hotModel.time];
    self.titleLable.text = hotModel.title;
    self.plainLabel.text = hotModel.plain;
    //自定义高度后重新给定frame
    CGFloat height = [TimeTools getTextHeightWithText:hotModel.plain];
    CGRect frame = self.plainLabel.frame;
    frame.size.height = height;
    self.plainLabel.frame = frame;
    _lastLabelBottom = frame.size.height + kWidth / 8 + 20;
    self.votesYBtn.frame = CGRectMake(10, _lastLabelBottom, 100, 30);
    self.appraiseBtn.frame = CGRectMake(kWidth * 3 / 8 + 140, _lastLabelBottom, 80, 30);
    self.votesNBtn.frame = CGRectMake(kWidth / 4 + 50, _lastLabelBottom, 100, 30);

    [self.votesNBtn setTitle:[NSString stringWithFormat:@"%@", hotModel.votesN] forState:UIControlStateNormal];
    [self.votesYBtn setTitle:[NSString stringWithFormat:@"%@", hotModel.votesY] forState:UIControlStateNormal];
    [self.appraiseBtn setTitle:[NSString stringWithFormat:@"%@", hotModel.apprise] forState:UIControlStateNormal];
    self.lineLabel.frame = CGRectMake(0, _lastLabelBottom + 35, kWidth, 10);
    
}

//返回整个cell的高度
+ (CGFloat)getCellHeightWith:(HotModel *)model{
    CGFloat textHeight = [TimeTools getTextHeightWithText:model.plain];
    
    return textHeight + kWidth / 8 + 60;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
