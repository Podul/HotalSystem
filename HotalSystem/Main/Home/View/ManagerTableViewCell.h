//
//  ManagerTableViewCell.h
//  HotalSystem
//
//  Created by Podul on 2016/12/9.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManagerTableViewCell : UITableViewCell
@property (nonatomic,strong) UITapGestureRecognizer *nameTap;  //手势
@property (nonatomic,strong) UITapGestureRecognizer *commentTap;  //手势
@property (nonatomic,strong) UITapGestureRecognizer *priceTap;  //手势

@property (nonatomic,strong) UILabel *nameLabel;            //菜名
@property (nonatomic,strong) UILabel *commentLabel;         //简介
@property (nonatomic,strong) UILabel *priceLabel;           //价格
@property (nonatomic) CGFloat height;                      //高度

@end
