//
//  FoodViewController.h
//  HotalSystem
//
//  Created by Podul on 2016/11/21.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^rowAndSectionBlock)(NSInteger row,NSInteger section);
@interface FoodViewController : UIViewController

@property (nonatomic,copy)rowAndSectionBlock block;
@end
