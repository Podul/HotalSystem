//
//  HomeView.m
//  HotalSystem
//
//  Created by Podul on 2016/11/16.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import "HomeView.h"
#import "HomeViewController.h"
#import "FoodViewController.h"

@implementation HomeView
- (id)initWithFrame:(CGRect)frame andNavItem:(UINavigationItem *)navItem{
    if (self = [super initWithFrame:frame]) {
        [navItem setRightBarButtonItem:self.manageBtn animated:YES];
        [navItem setLeftBarButtonItem:self.revealBtn animated:YES];
    }
    return self;
}

//单元格
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight - 64 - 49) style:UITableViewStylePlain];
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        [self addSubview:_tableView];
    }
    return _tableView;
}

//图片链接
- (NSMutableArray<NSString *> *)imagesURLStrings{
    if (_images == nil) {
        _images = [NSMutableArray array];
        
        //采用网络图片实现
        [_images addObjectsFromArray:@[
                                                     @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf=425,260,50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                                                     @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf=425,260,50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                                                     @"http://c.hiphotos.baidu.com/image/w=400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
                                                     ]];
    }
    return _images;
}

//图片介绍
- (NSMutableArray<NSString *> *)titles{
    if (_titles == nil) {
        _titles = [NSMutableArray array];
        [_titles addObjectsFromArray:@[
                                           @"图片1",
                                           @"图片2",
                                           @"图片3"
                                           ]];
    }
    return _titles;
}

- (UIBarButtonItem *)manageBtn{
    if (_manageBtn == nil) {
        _manageBtn = [[UIBarButtonItem alloc]init];
        [_manageBtn setTitle:@"管理"];
    }
    return _manageBtn;
}

- (UIBarButtonItem *)revealBtn{
    if (_revealBtn == nil) {
        _revealBtn = [[UIBarButtonItem alloc]init];
        [_revealBtn setTitle:@"菜单"];
    }
    return _revealBtn;
}

- (UIView *)submitView{
    if (_submitView == nil) {
        _submitView = [[UIView alloc]initWithFrame:CGRectMake(0, kHeight - 64 - 49 - 50, kWidth, 50)];
        [_submitView setBackgroundColor:[UIColor whiteColor]];
        [self.tableView addSubview:_submitView];
    }
    return _submitView;
}
- (UILabel *)priceLabel{
    if (_priceLabel == nil) {
        _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, kWidth - 110, 50)];
        [_priceLabel setTextColor:[UIColor redColor]];
        [self.submitView addSubview:_priceLabel];
    }
    return _priceLabel;
}

- (UIButton *)submitBtn{
    if (_submitBtn == nil) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitBtn setFrame:CGRectMake(kWidth - 80, 0, 80, 50)];
        [_submitBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [_submitBtn setTitle:@"提交订单" forState:UIControlStateNormal];
        [_submitBtn setBackgroundColor:[UIColor redColor]];
        [self.submitView addSubview:_submitBtn];
    }
    return _submitBtn;
}

- (void)createHomeView:(id)object{
    [self.manageBtn setTarget:object];
    [self.manageBtn setAction:@selector(management:)];
    [self.submitBtn addTarget:object action:@selector(submitOrder:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.delegate = object;
    self.tableView.dataSource = object;
    //监听tableview的滚动
    [self.tableView addObserver:object forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    //轮播图
    [self lunbo:object];
}

#pragma mark -- 创建轮播图
- (void)lunbo : (id)object{
    //网络加载图片
    CGFloat height;
    //适应屏幕--图片宽高比为3:1
    if (IS_IPhone6_6S){
        height = 125;
    }else if (IS_IPhone6_6s_plus){
        height = 138.0;
    }else{
        height = 106.67;
    }
    
    //网络加载 --- 创建带标题的图片轮播器
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kWidth, height) delegate:object placeholderImage:[UIImage imageNamed:@"lunbo_03"]];
    self.cycleScrollView.imageURLStringsGroup = self.imagesURLStrings;
    //小圆点偏右
    self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    //设置文字
    self.cycleScrollView.titlesGroup = self.titles;
    //3秒轮播一次
    self.cycleScrollView.autoScrollTimeInterval = 3.0;
}

@end
