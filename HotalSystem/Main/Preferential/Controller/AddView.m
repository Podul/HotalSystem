//
//  AddView.m
//  HotalSystem
//
//  Created by mac-mini on 2016/12/19.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import "AddView.h"

@implementation AddView

- (UINavigationItem *)navItem{
    if (_navItem == nil) {
        _navItem = [[UINavigationItem alloc]initWithTitle:@"选择"];
        [_navItem setLeftBarButtonItem:self.cancelItem];
        [_navItem setRightBarButtonItem:self.nextItem];
    }
    return _navItem;
}

- (UIBarButtonItem *)cancelItem{
    if (_cancelItem == nil) {
        _cancelItem = [[UIBarButtonItem alloc]init];
    }
    return _cancelItem;
}

- (UIBarButtonItem *)nextItem{
    if (_nextItem == nil) {
        _nextItem = [[UIBarButtonItem alloc]init];
    }
    return _nextItem;
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight - 64) style:UITableViewStylePlain];
        [self addSubview:_tableView];
    }
    return _tableView;
}

- (void)createAddView:(id)object{
    UINavigationBar *navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    [self addSubview:navBar];
    [navBar setItems:@[self.navItem]];
    [self.nextItem setTitle:@"下一步"];
    [self.nextItem setTarget:object];
    [self.nextItem setAction:@selector(nextStep:)];
    
    [self.cancelItem setTitle:@"取消"];
    [self.cancelItem setTarget:object];
    [self.cancelItem setAction:@selector(cancel:)];
    
    self.tableView.delegate = object;
    self.tableView.dataSource = object;
}

@end
