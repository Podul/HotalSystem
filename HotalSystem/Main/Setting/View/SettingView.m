//
//  SettingView.m
//  HotalSystem
//
//  Created by Podul on 2016/11/18.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import "SettingView.h"

@implementation SettingView

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStyleGrouped];
        _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 0.1)];
        _tableView.sectionHeaderHeight = 0.1;
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

- (void)createSettingView:(id)object{
    self.tableView.delegate = object;
    self.tableView.dataSource = object;
}

@end

