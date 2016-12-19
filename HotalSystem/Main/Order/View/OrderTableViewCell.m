//
//  OrderTableViewCell.m
//  HotalSystem
//
//  Created by Podul on 2016/12/2.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import "OrderTableViewCell.h"

@implementation OrderTableViewCell
- (void)layoutSubviews{
    [super layoutSubviews];
    [self dealDeleteButton];
}

- (void)dealDeleteButton{
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")]) {
            subView.backgroundColor = [UIColor blueColor];
            for (UIButton *button in subView.subviews) {
                if ([button isKindOfClass:[UIButton class]]) {
                    button.backgroundColor = [UIColor blueColor];
                    button.titleLabel.font = [UIFont systemFontOfSize:11.0];
                }
            }
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (UIImageView *)smallIcon{
    if (_smallIcon == nil) {
        _smallIcon = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 60, 60)];
        
        [self.contentView addSubview:_smallIcon];
    }
    return _smallIcon;
}

- (UILabel *)nameLabel{
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(95, 5, kWidth/2, 30)];
        [_nameLabel setFont:[UIFont systemFontOfSize:16.0]];
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UILabel *)foodNameLabel{
    if (_foodNameLabel == nil) {
        _foodNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(95, 35, kWidth/2, 40)];
        [_foodNameLabel setFont:[UIFont systemFontOfSize:12.0]];
        [_foodNameLabel setTextColor:[UIColor blackColor]];
        [self.contentView addSubview:_foodNameLabel];
    }
        return _foodNameLabel;
}

- (UILabel *)priceLabel{
    if (_priceLabel == nil) {
        _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth/2 + 70, 5, kWidth/2 - 80, 40)];
        [_priceLabel setTextColor:[UIColor blackColor]];
        _priceLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_priceLabel];
    }
    return _priceLabel;
}
#pragma mark - 订单号
- (UILabel *)orderLabel{
    if (_orderLabel == nil) {
        _orderLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 80, 150, 20)];
        _orderLabel.textColor = [UIColor colorWithRed:96.0/255.0 green:96.0/255.0 blue:96.0/255.0 alpha:1.0];
        [_orderLabel setFont:[UIFont systemFontOfSize:14.0]];
        [self.contentView addSubview:_orderLabel];
    }
    return _orderLabel;
}

- (UILabel *)cancelOrConfirm{
    if (_cancelOrConfirm == nil) {
        _cancelOrConfirm = [[UILabel alloc]initWithFrame:CGRectMake(kWidth - 170, 80, 160, 20)];
        [_cancelOrConfirm setTextColor:[UIColor redColor]];
        [_cancelOrConfirm setTextAlignment:NSTextAlignmentRight];
        [_cancelOrConfirm setFont:[UIFont systemFontOfSize:14.0]];
        [_cancelOrConfirm setTextColor:[UIColor colorWithRed:96.0/255.0 green:96.0/255.0 blue:96.0/255.0 alpha:1.0]];
        [_cancelOrConfirm setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_cancelOrConfirm];
    }
    return _cancelOrConfirm;
}
#pragma mark - 确认按钮
- (UIButton *)confirmBtn{
    if (_confirmBtn == nil) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setFrame:CGRectMake(kWidth - 85, 80, 80, 20)];
        // 圆角
        _confirmBtn.layer.masksToBounds = YES;
        _confirmBtn.layer.cornerRadius = 3.0;
        //边框
        _confirmBtn.layer.borderWidth = 1.0;
        //边框颜色
        _confirmBtn.layer.borderColor = [[UIColor redColor] CGColor];
        
        [_confirmBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        [_confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [self.contentView addSubview:_confirmBtn];
    }
    return _confirmBtn;
}
#pragma mark - 取消按钮
- (UIButton *)cancelBtn{
    if (_cancelBtn == nil) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setFrame:CGRectMake(kWidth - 170, 80, 80, 20)];
        // 圆角
        _cancelBtn.layer.masksToBounds = YES;
        _cancelBtn.layer.cornerRadius = 3.0;
        //边框
        _cancelBtn.layer.borderWidth = 1.0;
        //边框颜色
        _cancelBtn.layer.borderColor = [[UIColor colorWithRed:96.0/255.0 green:96.0/255.0 blue:96.0/255.0 alpha:1.0] CGColor];
        
        [_cancelBtn setTitleColor:[UIColor colorWithRed:96.0/255.0 green:96.0/255.0 blue:96.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        [_cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [self.contentView addSubview:_cancelBtn];
    }
    return _cancelBtn;
}

- (CGFloat)height{
    //计算高度
    CGFloat iconHeight = self.smallIcon.frame.size.height;
    CGFloat priceHeight = self.priceLabel.frame.size.height;
    _height = 5 + iconHeight + 5 + priceHeight + 5;
    return _height;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
