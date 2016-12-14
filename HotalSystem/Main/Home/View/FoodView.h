//
//  FoodView.h
//  HotalSystem
//
//  Created by Podul on 2016/11/21.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDCycleScrollView.h>

@interface FoodView : UIView<SDCycleScrollViewDelegate>
@property (nonatomic,strong)UISwipeGestureRecognizer *rightSGR;
@property (nonatomic,strong)UINavigationBar *navBar;
@property (nonatomic,strong)UINavigationItem *backItem;

- (void)createFoodView:(id)object;

@end
