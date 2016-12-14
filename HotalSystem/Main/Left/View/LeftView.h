//
//  LeftView.h
//  HotalSystem
//
//  Created by Podul on 2016/12/2.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftView : UIView


@property (nonatomic,strong) NSArray *menus;    //菜单数组
@property (nonatomic,strong) UITableView *tableView;

- (void)createLeftView:(id)object;

@end
