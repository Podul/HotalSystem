//
//  SettingTableViewCell.m
//  HotalSystem
//
//  Created by Podul on 2016/11/18.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import "SettingTableViewCell.h"

@implementation SettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (UILabel *)loginLabel{
    if (_loginLabel == nil) {
        _loginLabel = [[UILabel alloc]initWithFrame:CGRectMake(100.0, 5.0, kWidth - 100.0, 30.0)];
        [_loginLabel setFont:[UIFont systemFontOfSize:18.0]];
        [_loginLabel setTextColor:[UIColor blackColor]];
        [self.contentView addSubview:_loginLabel];
    }
    return _loginLabel;
}

- (UILabel *)signLabel{
    if (_signLabel == nil) {
        _signLabel = [[UILabel alloc]initWithFrame:CGRectMake(100.0, 40.0, kWidth - 100.0, 20.0)];
        [_signLabel setFont:[UIFont systemFontOfSize:12.0]];
        [_signLabel setTextColor:[UIColor blackColor]];
        [self.contentView addSubview:_signLabel];
    }
    return _signLabel;
}

- (UIImageView *)icon{
    if (_icon == nil) {
        //头像
        _icon = [[UIImageView alloc]initWithFrame:CGRectMake(5.0, 5.0, 60.0, 60.0)];
        //设置头像为圆形
        _icon.layer.masksToBounds = YES;
        _icon.layer.cornerRadius = 30.0;
        [self.contentView addSubview:_icon];
    }
    return _icon;
}

- (UILabel *)settingLabel{
    if (_settingLabel == nil) {
        _settingLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, kWidth - 60, 30)];
        _settingLabel.textColor = [UIColor blackColor];
        [self addSubview:_settingLabel];
        
    }
    return _settingLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        if ([reuseIdentifier isEqualToString:@"userCell"]) {
            //头像高度
            CGFloat iconHeight = self.icon.frame.size.height + (self.icon.frame.origin.y * 2);
            //计算单元格高度
            self.height = iconHeight;
        }
        if ([reuseIdentifier isEqualToString:@"settingCell"]) {
            self.height = 50;
            self.cacheLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth - 100, 5, 50, 45)];
            [self.cacheLabel setTextAlignment:NSTextAlignmentRight];
            [self.cacheLabel setTextColor:[UIColor blackColor]];
            [self.contentView addSubview:self.cacheLabel];
            [self.cacheLabel setFont:[UIFont systemFontOfSize:12.0]];
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
