//
//  PreView.h
//  HotalSystem
//
//  Created by mac-mini on 2016/12/16.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>

@interface PreView : UIView
@property (nonatomic ,strong) UILabel *noInfoLabel;
@property (nonatomic ,strong) UIBarButtonItem *addBarItem;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) MBProgressHUD *proHUD;

- (instancetype)initWithFrame:(CGRect)frame andNavItem:(UINavigationItem *)navItem;
- (void)createPreView:(id)object;
@end
