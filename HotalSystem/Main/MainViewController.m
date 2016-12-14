//
//  MainViewController.m
//  HotalSystem
//
//  Created by Podul on 2016/11/14.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import "MainViewController.h"
#import <SWRevealViewController.h>

@interface MainViewController ()

@property (nonatomic,strong)NSArray *icons;
@property (nonatomic,strong)NSArray *selectedIcons;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //创建子控制器
    [self createViewControllers];
    //自定义工具栏
    [self createTabBar];
    //左按钮
//    [self ctrateLeftBtnItem];
}


#pragma mark -- 懒加载图片
- (NSArray *)icons{
    if (_icons == nil) {
        _icons = @[@"home",@"order",@"preferential",@"setting"];
    }
    return _icons;
}

- (NSArray *)icons_selected{
    if (_selectedIcons == nil) {
        _selectedIcons = @[@"home_selected",@"order_selected",@"preferential_selected",@"setting_selected"];
    }
    return _selectedIcons;
}

#pragma mark - 创建子控制器
- (void)createViewControllers{
    // 通过 Storyboard 加载
    // 1、定义各个 Storyboard 的名字
    NSArray * storyNames = @[@"Home",@"Order",@"Preferential",@"Setting"];
    NSMutableArray * viewControllers = [NSMutableArray array];
    // 循环创建 Storyboard 对象
    [storyNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:obj bundle:nil];
        
        // 加载 Storyboard
        // instantiateInitialViewController 加载带箭头指向的 Storyboard
        UINavigationController *nav = [storyboard instantiateInitialViewController];
        [viewControllers addObject:nav];
    }];
    [self setViewControllers:viewControllers];
}

#pragma mark - 自定义工具栏
- (void)createTabBar{
    //设置导航栏颜色
//    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:18.0/255.0 green:183.0/255.0 blue:245.0/255.0 alpha:0]];
     
    //按钮的宽度
    CGFloat itemWidth = kWidth / self.icons.count;
    for (int i=0; i<self.icons.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(itemWidth * i, 0, itemWidth, 49);
        [btn setImage:[UIImage imageNamed:self.icons[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:self.icons_selected[i]] forState: UIControlStateSelected];
        btn.tag = 100 + i;
        
        //默认选中首页
        if (i == 0) {
            btn.selected = YES;
        }
        
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBar addSubview:btn];
    }
    
}

- (void)btnAction:(UIButton *)sender{
    self.selectedIndex = sender.tag - 100;
    for (int i=0; i<self.icons.count; i++) {
        UIButton *btn = [self.view viewWithTag:100+i];
        btn.selected = NO;
        if (sender.tag == 100 + i) {
            btn.selected = YES;
        }
    }
}


- (void)viewWillLayoutSubviews{
    for (UIView * view in self.tabBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [view removeFromSuperview];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
