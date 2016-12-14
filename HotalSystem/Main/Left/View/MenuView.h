//
//  MenuView.h
//  HotalSystem
//
//  Created by Podul on 2016/12/2.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>

@interface MenuView : UIView
@property (nonatomic,strong)UISwipeGestureRecognizer *rightSGR;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UINavigationBar *navBar;
@property (nonatomic,strong)UINavigationItem *backItem;
@property (nonatomic,strong)UIBarButtonItem *managerItem;
@property (nonatomic,strong)MBProgressHUD *proHUD;

- (void)createMenuView:(id)object;
@end
