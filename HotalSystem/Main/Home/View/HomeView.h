//
//  HomeView.h
//  HotalSystem
//
//  Created by Podul on 2016/11/16.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDCycleScrollView.h>

@interface HomeView : UIView


@property (nonatomic,strong) NSMutableArray<NSString *> *images;            //图片链接string
@property (nonatomic,strong) NSMutableArray<NSString *> *titles;            //图片文字介绍
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic,strong) UINavigationItem *navItems;  //items
@property (nonatomic,strong) UIBarButtonItem *manageBtn;    //管理按钮
@property (nonatomic,strong) UIBarButtonItem *revealBtn;    //左抽屉按钮
@property (nonatomic,strong) UIView *submitView;
@property (nonatomic,strong) UILabel *priceLabel;   //显示价格
@property (nonatomic,strong) UIButton *submitBtn;   //提交按钮
- (void)createHomeView : (id)object;

- (id)initWithFrame:(CGRect)frame andNavItem:(UINavigationItem *)navItem;
@end
