//
//  DetailTableViewCell.m
//  jokeToWatch
//
//  Created by scjy on 16/3/7.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "DetailTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface DetailTableViewCell ()
{
    CGFloat _labelTOBottom;
}
@property (strong, nonatomic) UIImageView *headImage;
@property (strong, nonatomic) UILabel *titleLable;
@property (strong, nonatomic) UILabel *plainLabel;
@property (strong, nonatomic) UILabel *lineLabel;
@end

@implementation DetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configViewToLabel];
    }
    return self;
}

- (void)configViewToLabel{
    self.headImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, kWidth / 8, kWidth / 8)];
    self.headImage.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"defaultHeadImage"]];
    self.headImage.layer.cornerRadius = 10;
    self.headImage.clipsToBounds = YES;
    [self.contentView addSubview:self.headImage];
    self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(kWidth / 8 + 15, 15, kWidth * 3 / 4, kWidth / 4 / 4)];
    [self.contentView addSubview:self.titleLable];
    self.plainLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, kWidth / 8 + 10, kWidth - 20, kWidth / 8 )];
    self.plainLabel.numberOfLines = 0;
    self.plainLabel.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:self.plainLabel];
    
    self.lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _labelTOBottom  , kWidth, 5)];
    self.lineLabel.backgroundColor = [UIColor grayColor];
    self.lineLabel.alpha = 0.3;
    [self.contentView addSubview:self.lineLabel];
    
}

- (void)setCommentModel:(CommentModel *)commentModel{
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:commentModel.headImage] placeholderImage:nil];
    self.titleLable.text = commentModel.title;
    //自定义高度后重新给定frame
    CGFloat height = [TimeTools getTextHeightWithText:commentModel.content];
    CGRect frame = self.plainLabel.frame;
    frame.size.height = height;
    self.plainLabel.frame = frame;
    _labelTOBottom = frame.size.height + kWidth / 8 + 5;
    self.plainLabel.text = commentModel.content;
}

+ (CGFloat)getCellHeightWith:(CommentModel *)model{
    CGFloat cell = [TimeTools getTextHeightWithText:model.content];
    return cell + kWidth/8 + 20;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
