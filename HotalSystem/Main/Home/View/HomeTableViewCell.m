//
//  HomeTableViewCell.m
//  HotalSystem
//
//  Created by Podul on 2016/11/17.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import "HomeTableViewCell.h"

@implementation HomeTableViewCell

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

- (UIButton *)addBtn{
    if (_addBtn == nil) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setFrame:CGRectMake(kWidth - 40, self.height - 40, 28, 28)];
        [_addBtn setBackgroundColor:[UIColor whiteColor]];
        [_addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_addBtn setTitle:@"+" forState:UIControlStateNormal];
        _addBtn.layer.masksToBounds = YES;
        _addBtn.layer.cornerRadius = 14.0;
        _addBtn.layer.borderWidth = 1.0;
        _addBtn.layer.borderColor = [[UIColor blackColor]CGColor];
        [self addSubview:_addBtn];
    }
    return _addBtn;
}

- (UILabel *)countLabel{
    if (_countLabel == nil) {
        _countLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth - 60, self.height - 40, 20, 30)];
        [_countLabel setFont:[UIFont systemFontOfSize:12.0]];
        [_countLabel setTextColor:[UIColor blackColor]];
        
        [_countLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_countLabel];
    }
    return _countLabel;
}

- (UIButton *)reduceBtn{
    if (_reduceBtn == nil) {
        _reduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reduceBtn setFrame:CGRectMake(kWidth - 90, self.height - 40, 28, 28)];
        [_reduceBtn setBackgroundColor:[UIColor whiteColor]];
        [_reduceBtn setTitle:@"-" forState:UIControlStateNormal];
        [_reduceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _reduceBtn.layer.masksToBounds = YES;
        _reduceBtn.layer.borderWidth = 1.0;
        _reduceBtn.layer.borderColor = [[UIColor blackColor]CGColor];
        _reduceBtn.layer.cornerRadius = 14.0;
        [self addSubview:_reduceBtn];
    }
    return _reduceBtn;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        if ([reuseIdentifier isEqualToString:@"homeCell"]) {
            //菜图
            self.foodImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, kWidth/5, kWidth/5)];
            [self.foodImage setBackgroundColor:[UIColor redColor]];
            [self.contentView addSubview:self.foodImage];
            //菜名
            self.foodLabel = [[UILabel alloc]initWithFrame:CGRectMake((kWidth/5) + 20, 10, kWidth - kWidth/5 - 100, 30)];
            [self.foodLabel setFont:[UIFont systemFontOfSize:16.0]];
            [self.contentView addSubview:self.foodLabel];
            
            //介绍
            self.introdLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth/5 + 20, 40, kWidth - kWidth/5 - 80, kWidth/5 - 40)];
            [self.introdLabel setFont:[UIFont systemFontOfSize:12.0]];
            [self.introdLabel setNumberOfLines:0];
            [self.contentView addSubview:self.introdLabel];
            
            //菜图高度
            CGFloat iconHeight = self.foodImage.frame.origin.y + self.foodImage.frame.size.height;
            //菜名高度不考虑
            //计算单元格高度
            self.height = iconHeight + 10;
        }else if ([reuseIdentifier isEqualToString:@"cycleCell"]){
            if (IS_IPhone6_6S){
                self.height = 125.0;
            }else if (IS_IPhone6_6s_plus){
                self.height = 138.0;
            }else{
                self.height = 106.67;
            }
        }else{
            NSLog(@"没有注册该单元格！");
        }
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
