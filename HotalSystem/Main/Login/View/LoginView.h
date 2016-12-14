//
//  LoginView.h
//  HotalSystem
//
//  Created by Podul on 2016/11/22.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginView : UIView
@property (nonatomic,strong) UITextField *accountField;     //账号
@property (nonatomic,strong) UITextField *passwordField;    //密码
@property (nonatomic,strong) UIButton *loginBtn;            //登录
@property (nonatomic,strong) UIImageView *icon;             //头像
@property (nonatomic,strong) UISwipeGestureRecognizer *rightSGR;    //右滑手势

- (void)createLoginView:(id)object;
@end
