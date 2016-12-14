//
//  LeftView.m
//  HotalSystem
//
//  Created by Podul on 2016/12/2.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import "LeftView.h"

@implementation LeftView
- (NSArray *)menus{
    if (_menus == nil) {
        _menus = [NSArray array];
    }
    return _menus;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, kWidth*0.75, kHeight-20) style:UITableViewStylePlain];
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        [self addSubview:_tableView];
    }
    return _tableView;
}


- (void)createLeftView:(id)object{
    [self setBackgroundColor:[UIColor whiteColor]];
    self.tableView.delegate = object;
    self.tableView.dataSource = object;
}
@end
