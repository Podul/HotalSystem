//
//  AddView.h
//  HotalSystem
//
//  Created by mac-mini on 2016/12/19.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>

@interface AddView : UIView
@property (nonatomic ,strong) UINavigationItem *navItem;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) UIBarButtonItem *nextItem;
@property (nonatomic ,strong) UIBarButtonItem *cancelItem;
@property (nonatomic ,strong) MBProgressHUD *proHUD;
//@property (nonatomic ,strong) UIView *preInfoView;
//@property (nonatomic ,strong) UITextView *desTextView;      //设置描述
//@property (nonatomic ,strong) UITextField *priceTextField;  //设置价格

- (void)createAddView:(id)object;
@end
