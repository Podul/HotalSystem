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
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        [self addSubview:_tableView];
    }
    return _tableView;
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

- (void)createOrderView:(id)object{
    self.tableView.delegate = object;
    self.tableView.dataSource = object;
}
@end
