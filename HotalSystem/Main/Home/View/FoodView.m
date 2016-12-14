//
//  FoodView.m
//  HotalSystem
//
//  Created by Podul on 2016/11/21.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import "FoodView.h"

@implementation FoodView

//手势
- (UISwipeGestureRecognizer *)rightSGR{
    if (_rightSGR == nil) {
        _rightSGR = [[UISwipeGestureRecognizer alloc]init];
        _rightSGR.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:_rightSGR];
    }
    return _rightSGR;
}

//navBar
- (UINavigationBar *)navBar{
    if (_navBar == nil) {
        _navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
        [self addSubview:_navBar];
    }
    return _navBar;
}

- (UINavigationItem *)backItem{
    if (_backItem == nil) {
        _backItem = [[UINavigationItem alloc]init];
    }
    return _backItem;
}

- (void)createFoodView:(id)object{
    [self setBackgroundColor:[UIColor whiteColor]];
    [self.rightSGR addTarget:object action:@selector(back:)];
    [self lunbo];
    
    [self.backItem setLeftBarButtonItem:[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:object action:@selector(back:)]];
    
    [self.navBar setItems:@[self.backItem]];
//    self.backItem
}

- (void)lunbo{
    //网络加载图片
    //采用网络图片实现
    NSArray *imagesURLStrings = @[
                                  @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf=425,260,50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                                  @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf=425,260,50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                                  @"http://c.hiphotos.baidu.com/image/w=400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
                                  ];
    
    //网络加载 --- 创建带标题的图片轮播器
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 64, kWidth, kWidth/(1.5)) delegate:self placeholderImage:[UIImage imageNamed:@"lunbo_03"]];
    //小圆点偏右
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;

    //3秒轮播一次
    cycleScrollView.autoScrollTimeInterval = 3.0;
    cycleScrollView.imageURLStringsGroup = imagesURLStrings;
    
    [self addSubview:cycleScrollView];
}

@end
