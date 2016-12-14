//
//  HomeTableViewCell.h
//  HotalSystem
//
//  Created by Podul on 2016/11/17.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell

@property (nonatomic) CGFloat height;                   //单元格高度
@property (nonatomic,strong) UIImageView *foodImage;    //菜图
@property (nonatomic,strong) UILabel *foodLabel;        //菜名
@property (nonatomic,strong) UILabel *introdLabel;      //介绍
@property (nonatomic,strong) UILabel *priceLabel;       //价格
@property (nonatomic,strong) UIButton *addBtn;          //添加
@property (nonatomic,strong) UILabel *countLabel;   //计数
@property (nonatomic,strong) UIButton *reduceBtn;       //减少

@end
