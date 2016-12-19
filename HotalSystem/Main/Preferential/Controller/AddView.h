//
//  AddView.h
//  HotalSystem
//
//  Created by mac-mini on 2016/12/19.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddView : UIView
@property (nonatomic ,strong) UINavigationItem *navItem;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) UIBarButtonItem *nextItem;
@property (nonatomic ,strong) UIBarButtonItem *cancelItem;

- (void)createAddView:(id)object;
@end
