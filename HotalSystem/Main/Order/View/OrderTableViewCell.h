//
//  OrderTableViewCell.h
//  HotalSystem
//
//  Created by Podul on 2016/12/2.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTableViewCell : UITableViewCell

@property (nonatomic ,strong)UIImageView *smallIcon;        //菜的小图标
@property (nonatomic ,strong)UILabel *nameLabel;            //菜名
@property (nonatomic ,strong)UILabel *priceLabel;           //价格
@property (nonatomic) CGFloat height;
@end
