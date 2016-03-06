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
- (void)setHotModel:(HotModel *)hotModel{
    if ([hotModel.headImage isEqual:nil]) {
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
