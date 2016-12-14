//
//  SettingTableViewCell.h
//  HotalSystem
//
//  Created by Podul on 2016/11/18.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *icon;         //头像
@property (nonatomic,strong) UILabel *loginLabel;       //登录后显示
@property (nonatomic,strong) UILabel *signLabel;        //签名
@property (nonatomic,strong) UILabel *settingLabel;     //
@property (nonatomic) CGFloat height;                   //单元格高度

@end
