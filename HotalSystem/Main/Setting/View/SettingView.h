//
//  SettingView.h
//  HotalSystem
//
//  Created by Podul on 2016/11/18.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>

@interface SettingView : UIView

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) MBProgressHUD *proHUD;

- (void)createSettingView:(id)object;
@end
