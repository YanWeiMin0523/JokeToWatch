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
    
    self.votesNBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.votesNBtn setImage:[UIImage imageNamed:@"btn_praise"] forState:UIControlStateNormal];
    self.votesYBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.votesYBtn setImage:[UIImage imageNamed:@"btn_down"] forState:UIControlStateNormal];
    
    self.appraiseBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.appraiseBtn setImage:[UIImage imageNamed:@"btn_keep"] forState:UIControlStateNormal];
    [[UIButton appearance] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.contentView addSubview:self.votesYBtn];
    [self.contentView addSubview:self.votesNBtn];
    [self.contentView addSubview:self.appraiseBtn];
}

- (void)awakeFromNib {
    // Initialization code
   
}
- (void)setHotModel:(HotModel *)hotModel{
//    [self.headImage sd_setImageWithURL:[NSURL URLWithString:hotModel.headImage] placeholderImage:nil];
    self.headImage.image = [UIImage imageNamed:@"defaultHeadImage"];
    self.headImage.layer.cornerRadius = 10;
    self.headImage.clipsToBounds = YES;
    self.timeLabel.text = [NSString stringWithFormat:@"%@", hotModel.time];
    self.titleLable.text = hotModel.title;
    self.plainLabel.text = hotModel.plain;
    //自定义高度后重新给定frame
    CGFloat height = [[self class] getTextHeightWithText:hotModel.plain];
    CGRect frame = self.plainLabel.frame;
    frame.size.height = height;
    self.plainLabel.frame = frame;
    _lastLabelBottom = frame.size.height + kWidth / 8 + 20;
    self.votesYBtn.frame = CGRectMake(10, _lastLabelBottom, 100, 30);
    self.appraiseBtn.frame = CGRectMake(kWidth * 3 / 8 + 120, _lastLabelBottom, 100, 30);
    self.votesNBtn.frame = CGRectMake(kWidth / 4 + 50, _lastLabelBottom, 100, 30);

    [self.votesNBtn setTitle:[NSString stringWithFormat:@"%@", hotModel.votesN] forState:UIControlStateNormal];
    [self.votesYBtn setTitle:[NSString stringWithFormat:@"%@", hotModel.votesY] forState:UIControlStateNormal];
    [self.appraiseBtn setTitle:[NSString stringWithFormat:@"%@", hotModel.apprise] forState:UIControlStateNormal];
    
}

//返回整个cell的高度
+ (CGFloat)getCellHeightWith:(HotModel *)model{
    CGFloat textHeight = [[self class] getTextHeightWithText:model.plain];
    
    return textHeight + kWidth / 8 + 50;
}

//计算文本高度
+ (CGFloat)getTextHeightWithText:(NSString *)text{
    CGRect textRect = [text boundingRectWithSize:CGSizeMake(kWidth - 30, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0]} context:nil];
    return textRect.size.height;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
