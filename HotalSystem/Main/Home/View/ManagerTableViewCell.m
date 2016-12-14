//
//  ManagerTableViewCell.m
//  HotalSystem
//
//  Created by Podul on 2016/12/9.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import "ManagerTableViewCell.h"

@implementation ManagerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (UITapGestureRecognizer *)nameTap{
    if (_nameTap == nil) {
        _nameTap = [[UITapGestureRecognizer alloc]init];
    }
    return _nameTap;
}
- (UITapGestureRecognizer *)commentTap{
    if (_commentTap == nil) {
        _commentTap = [[UITapGestureRecognizer alloc]init];
    }
    return _commentTap;
}
- (UITapGestureRecognizer *)priceTap{
    if (_priceTap == nil) {
        _priceTap = [[UITapGestureRecognizer alloc]init];
    }
    return _priceTap;
}


//菜名
- (UILabel *)nameLabel{
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 100, 50)];
        [_nameLabel setUserInteractionEnabled:YES];
        [_nameLabel setFont:[UIFont systemFontOfSize:14.0]];
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UILabel *)commentLabel{
    if (_commentLabel == nil) {
        _commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 5, 100, 50)];
        [_commentLabel setUserInteractionEnabled:YES];
        [_commentLabel setFont:[UIFont systemFontOfSize:12.0]];
        _commentLabel.numberOfLines = 0;        //支持换行
        [self.contentView addSubview:_commentLabel];
    }
    return _commentLabel;
}

- (UILabel *)priceLabel{
    if (_priceLabel == nil) {
        _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(215, 5, kWidth - 260, 50)];
        _priceLabel.userInteractionEnabled = YES;
        [_priceLabel setFont:[UIFont systemFontOfSize:14.0]];
        [self.contentView addSubview:_priceLabel];
    }
    return _priceLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //添加手势
        [self.nameLabel addGestureRecognizer:self.nameTap];
        [self.commentLabel addGestureRecognizer:self.commentTap];
        [self.priceLabel addGestureRecognizer:self.priceTap];
        
        self.height = self.nameLabel.frame.size.height + 10.0;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
