//
//  PreferentialViewController.m
//  HotalSystem
//
//  Created by Podul on 2016/11/14.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import "PreferentialViewController.h"
#import "PreView.h"

@interface PreferentialViewController ()
@property (nonatomic,strong)PreView *preView;
@end

@implementation PreferentialViewController
- (PreView *)preView{
    if (_preView == nil) {
        _preView = [[PreView alloc]initWithFrame:self.view.frame];
        [self.view addSubview:_preView];
    }
    return _preView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.preView createPreView:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //如果没有内容
    self.preView.noInfoLabel.text = @"暂无优惠信息";
    [self.preView.noInfoLabel setHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
