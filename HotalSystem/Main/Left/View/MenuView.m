//
//  MenuView.m
//  HotalSystem
//
//  Created by Podul on 2016/12/2.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import "MenuView.h"

@implementation MenuView
//手势
- (UISwipeGestureRecognizer *)rightSGR{
    if (_rightSGR == nil) {
        _rightSGR = [[UISwipeGestureRecognizer alloc]init];
        _rightSGR.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:_rightSGR];
    }
    return _rightSGR;
}
//tableView
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64) style:UITableViewStylePlain];
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        [self addSubview:_tableView];
    }
    return _tableView;
}
//navBar
- (UINavigationBar *)navBar{
    if (_navBar == nil) {
        _navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
        [_navBar setBackgroundColor:[UIColor whiteColor]];
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

- (UIBarButtonItem *)managerItem{
    if (_managerItem == nil) {
        _managerItem = [[UIBarButtonItem alloc]init];
    }
    return _managerItem;
}
- (MBProgressHUD *)proHUD{
    if (_proHUD == nil) {
        _proHUD = [[MBProgressHUD alloc]initWithView:self];
        _proHUD.contentColor = [UIColor whiteColor];
        _proHUD.detailsLabel.textColor = [UIColor whiteColor];
        _proHUD.label.textColor = [UIColor whiteColor];
        [_proHUD.bezelView setBackgroundColor:[UIColor blackColor]];
        [self addSubview:_proHUD];
    }
    return _proHUD;
}

- (void)createMenuView:(id)object{
    [self.rightSGR addTarget:object action:@selector(back:)];
    self.tableView.delegate = object;
    self.tableView.dataSource = object;
    [self.backItem setLeftBarButtonItem:[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:object action:@selector(back:)]];
    
    self.managerItem.title = @"管理";
    [self.managerItem setTarget:object];
    [self.managerItem setAction:@selector(manager:)];
    [self.backItem setRightBarButtonItem:self.managerItem];
    
    [self.navBar setItems:@[self.backItem]];
}

@end
