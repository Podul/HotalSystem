//
//  FoodViewController.m
//  HotalSystem
//
//  Created by Podul on 2016/11/21.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import "FoodViewController.h"
#import "FoodView.h"

@interface FoodViewController ()
@property (nonatomic,strong) FoodView *foodView;
@end

@implementation FoodViewController

- (FoodView *)foodView{
    if (_foodView == nil) {
        _foodView = [[FoodView alloc]initWithFrame:self.view.frame];
        [self.view addSubview:_foodView];
    }
    return _foodView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.foodView createFoodView:self];
}

- (void)back:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
