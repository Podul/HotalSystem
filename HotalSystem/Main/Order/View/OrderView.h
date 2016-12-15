//
//  OrderView.h
//  HotalSystem
//
//  Created by Podul on 2016/12/2.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>

@interface OrderView : UIView

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) MBProgressHUD *proHUD;

- (void)createOrderView:(id)object;
@end
