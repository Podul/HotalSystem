//
//  OrderView.h
//  HotalSystem
//
//  Created by Podul on 2016/12/2.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderView : UIView

@property (nonatomic,strong) UITableView *tableView;

- (void)createOrderView:(id)object;
@end
