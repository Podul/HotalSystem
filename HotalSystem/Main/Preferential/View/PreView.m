//
//  PreView.m
//  HotalSystem
//
//  Created by mac-mini on 2016/12/16.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import "PreView.h"

@implementation PreView
- (instancetype)initWithFrame:(CGRect)frame andNavItem:(UINavigationItem *)navItem{
    if (self = [super initWithFrame:frame]) {
        [navItem setRightBarButtonItem:self.addBarItem];
    }
    return self;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 49) style:UITableViewStylePlain];
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        [self addSubview:_tableView];
    }
    return _tableView;
}

- (UIBarButtonItem *)addBarItem{
    if (_addBarItem == nil) {
        _addBarItem = [[UIBarButtonItem alloc]init];
        [_addBarItem setTitle:@"添加"];
    }
    return _addBarItem;
}

- (UILabel *)noInfoLabel{
    if (_noInfoLabel == nil) {
        _noInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 30)];
        _noInfoLabel.textColor = [UIColor colorWithRed:96.0/255.0 green:96.0/255.0 blue:96.0/255.0 alpha:1.0];
        [_noInfoLabel setCenter:self.center];
        [_noInfoLabel setTextAlignment:NSTextAlignmentCenter];
        [_noInfoLabel setHidden:YES];
        [self addSubview:_noInfoLabel];
    }
    return _noInfoLabel;
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

- (void)createPreView:(id)object{
    self.tableView.delegate = object;
    self.tableView.dataSource = object;
    
    [self.addBarItem setTarget:object];
    [self.addBarItem setAction:@selector(addPre:)];
}
@end
