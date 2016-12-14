//
//  MenuTableViewCell.m
//  HotalSystem
//
//  Created by Podul on 2016/12/10.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import "MenuTableViewCell.h"

@implementation MenuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (UILabel *)priceLabel{
    if (_priceLabel == nil) {
        _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth - 50, 10, 60, 30)];
        [_priceLabel setTextColor:[UIColor redColor]];
        [_priceLabel setFont:[UIFont systemFontOfSize:12.0]];
        [self.contentView addSubview:_priceLabel];
    }
    return _priceLabel;
}
//菜图
- (UIImageView *)foodImage{
    if (_foodImage == nil) {
        _foodImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, kWidth/5, kWidth/5)];
        [self.contentView addSubview:_foodImage];
    }
    return _foodImage;
}
//菜名
- (UILabel *)foodLabel{
    if (_foodLabel == nil) {
        _foodLabel = [[UILabel alloc]initWithFrame:CGRectMake((kWidth/5) + 20, 10, kWidth - kWidth/5 - 100, 30)];
        [_foodLabel setFont:[UIFont systemFontOfSize:16.0]];
        [self.contentView addSubview:_foodLabel];
    }
    return _foodLabel;
}

- (UILabel *)introdLabel{
    if (_introdLabel == nil) {
        //介绍
        _introdLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth/5 + 20, 40, kWidth - kWidth/5 - 80, kWidth/5 - 40)];
        [_introdLabel setFont:[UIFont systemFontOfSize:12.0]];
        [self.introdLabel setNumberOfLines:0];
        [self.contentView addSubview:_introdLabel];
    }
    return _introdLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //菜图高度
        CGFloat iconHeight = self.foodImage.frame.origin.y + self.foodImage.frame.size.height;
        //菜名高度不考虑
        //计算单元格高度
        self.height = iconHeight + 10;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
