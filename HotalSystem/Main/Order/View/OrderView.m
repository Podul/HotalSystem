//
//  OrderView.m
//  HotalSystem
//
//  Created by Podul on 2016/12/2.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import "OrderView.h"

@implementation OrderView

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:self.frame style:UITableViewStylePlain];
        [self addSubview:_tableView];
    }
    return _tableView;
}

- (void)createOrderView:(id)object{
    self.tableView.delegate = object;
    self.tableView.dataSource = object;
}
@end
