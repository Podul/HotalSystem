//
//  OrderTableViewCell.m
//  HotalSystem
//
//  Created by Podul on 2016/12/2.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import "OrderTableViewCell.h"

@implementation OrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (UIImageView *)smallIcon{
    if (_smallIcon == nil) {
        _smallIcon = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 40, 40)];
        
        [self.contentView addSubview:_smallIcon];
    }
    return _smallIcon;
}

- (UILabel *)nameLabel{
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 5, kWidth - 80, 40)];
        [_nameLabel setFont:[UIFont systemFontOfSize:14.0]];
//        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UILabel *)priceLabel{
    if (_priceLabel == nil) {
        _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 55, kWidth-85, 40)];
//        _priceLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_priceLabel];
    }
    return _priceLabel;
}

- (CGFloat)height{
    CGFloat iconHeight = self.smallIcon.frame.size.height;
    CGFloat priceHeight = self.priceLabel.frame.size.height;
    _height = 5 + iconHeight + 5 + priceHeight + 5;
    return _height;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createBtn];
    }
    return self;
}

- (void)createBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setFrame:CGRectMake(kWidth - 85, 65, 80, 20)];
    // 圆角
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 3.0;
    //边框
    btn.layer.borderWidth = 1.0;
    //边框颜色
    btn.layer.borderColor = [[UIColor blueColor] CGColor];
    
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitle:@"确认订单" forState:UIControlStateNormal];
    
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self.contentView addSubview:btn];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
