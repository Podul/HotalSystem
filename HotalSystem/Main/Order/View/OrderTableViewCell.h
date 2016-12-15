//
//  OrderTableViewCell.h
//  HotalSystem
//
//  Created by Podul on 2016/12/2.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTableViewCell : UITableViewCell

@property (nonatomic ,strong) UIImageView  *smallIcon;      //菜的小图标
@property (nonatomic ,strong) UILabel      *nameLabel;      //用户名
@property (nonatomic ,strong) UILabel      *priceLabel;     //价格
@property (nonatomic ,strong) UIButton     *confirmBtn;     //确认按钮
@property (nonatomic ,strong) UIButton     *cancelBtn;      //取消按钮
@property (nonatomic ,assign) CGFloat       height;         //高度
//@property (nonatomic ,strong) UILabel      *buyerLabel;     //购买者
@property (nonatomic ,strong) UILabel      *foodNameLabel;  //
@end
