//
//  ClassisTableViewCell.m
//  jokeToWatch
//
//  Created by scjy on 16/3/5.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "ClassisTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface ClassisTableViewCell ()
{
    CGFloat _imageBottomHeight;
}
@property (strong, nonatomic)  UIImageView *headImage;
@property (strong, nonatomic)  UILabel *titleLable;
@property (strong, nonatomic)  UILabel *timeLabel;
@property (strong, nonatomic)  UILabel *plainLabel;
@property (strong, nonatomic)  UIImageView *shareImage;
@property (strong, nonatomic)  UIButton *appraiseBtn;
@property (strong, nonatomic)  UIButton *votesNBtn;
@property (strong, nonatomic)  UIButton *votesYBtn;
@property(strong, nonatomic) UILabel *lineLabel;
@end

@implementation ClassisTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configViewToLabel];
    }
    return self;
}

- (void)configViewToLabel{
    self.headImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 3, kWidth / 8, kWidth / 8)];
    [self.contentView addSubview:self.headImage];
    self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(kWidth / 8 + 15, 5, kWidth /2, kWidth / 4 / 4)];
    [self.contentView addSubview:self.titleLable];
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth * 5 / 8, 5, kWidth * 3/ 8, kWidth / 16)];
    self.timeLabel.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:self.timeLabel];
    
    self.plainLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, kWidth / 8 + 10, kWidth - 20, kWidth / 4 )];
    self.plainLabel.numberOfLines = 0;
    self.plainLabel.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:self.plainLabel];
    self.shareImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, kWidth * 3 / 8 + 20, kWidth - 20, kWidth / 2)];
    [self.contentView addSubview:self.shareImage];
    
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
    
    self.lineLabel = [[UILabel alloc] init];
    self.lineLabel.backgroundColor = [UIColor grayColor];
    self.lineLabel.alpha = 0.2;
    [self.contentView addSubview:self.lineLabel];

}

- (void)setClassModel:(ClassisModel *)classModel{
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:classModel.headImage] placeholderImage:nil];
    self.headImage.layer.cornerRadius = 10;
    self.headImage.clipsToBounds = YES;
    self.titleLable.text = classModel.title;
    self.timeLabel.text = [NSString stringWithFormat:@"%@", classModel.time];
    self.plainLabel.text = classModel.plain;
    //自定义高度之后重新设定frame
    CGFloat textHeight = [TimeTools getTextHeightWithText:classModel.plain];
    CGRect frame = self.plainLabel.frame;
    frame.size.height = textHeight;
    self.plainLabel.frame = frame;
    
    CGFloat labelHeight = frame.size.height + kWidth / 8;
    if (classModel.shareImage == nil) {
        self.votesYBtn.frame = CGRectMake(10, labelHeight + 15, 100, 30);
        self.votesNBtn.frame = CGRectMake(kWidth / 4 + 50, labelHeight + 15, 100, 30);
        self.appraiseBtn.frame = CGRectMake(kWidth * 3 / 8 + 120, labelHeight + 15, 100, 30);
    }
    CGFloat imageH = [classModel.imageHeight integerValue];
    _imageBottomHeight = labelHeight + imageH/ 4 + kWidth / 8 - 20;
    self.shareImage.frame = CGRectMake(10, labelHeight + 15, kWidth - 20, imageH / 4);
    [self.shareImage sd_setImageWithURL:[NSURL URLWithString:classModel.shareImage] placeholderImage:nil];
    [self.appraiseBtn setTitle:[NSString stringWithFormat:@"%@", classModel.apprise] forState:UIControlStateNormal];
    [self.votesYBtn setTitle:[NSString stringWithFormat:@"%@", classModel.votesY] forState:UIControlStateNormal];
    [self.votesNBtn setTitle:[NSString stringWithFormat:@"%@", classModel.votesN] forState:UIControlStateNormal];
    
    self.votesYBtn.frame = CGRectMake(10, _imageBottomHeight, 100, 30);
    self.votesNBtn.frame = CGRectMake(kWidth / 4 + 50, _imageBottomHeight, 100, 30);
    self.appraiseBtn.frame = CGRectMake(kWidth * 3 / 8 + 120, _imageBottomHeight, 100, 30);
    self.lineLabel.frame = CGRectMake(0, _imageBottomHeight + 30, kWidth, 10);
    

}

+ (CGFloat)getTextHeightWith:(ClassisModel *)model{
    CGFloat textHeight = [TimeTools getTextHeightWithText:model.plain];
    if (model.shareImage != nil) {
        return textHeight + [model.imageHeight integerValue]/4 + kWidth / 8 + 60;
    }
    return textHeight + kWidth / 8 + 70;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
