//
//  LoginViewController.m
//  HotalSystem
//
//  Created by Podul on 2016/11/22.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>
#import <MBProgressHUD.h>

@interface LoginViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)LoginView *loginView;
@property (nonatomic,strong)MBProgressHUD *proHUD;
@end

@implementation LoginViewController

- (MBProgressHUD *)proHUD{
    if (_proHUD == nil) {
        _proHUD = [[MBProgressHUD alloc]initWithView:self.loginView];
        _proHUD.contentColor = [UIColor whiteColor];
        _proHUD.detailsLabel.textColor = [UIColor whiteColor];
        _proHUD.label.textColor = [UIColor whiteColor];
        [_proHUD.bezelView setBackgroundColor:[UIColor blackColor]];
        [self.loginView addSubview:_proHUD];
    }
    return _proHUD;
}

- (LoginView *)loginView{
    if (_loginView == nil) {
        _loginView = [[LoginView alloc]initWithFrame:self.view.frame];
        [_loginView.icon setImage:[UIImage imageNamed:@"lunbo_01"]];
        [self.view addSubview:_loginView];
    }
    return _loginView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.loginView createLoginView:self];
}

- (void)loginInfo{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{
                                 @"action":@"login",
                                 @"name":self.loginView.accountField.text,
                                 @"psd":self.loginView.passwordField.text
                                 };
    [manager POST:@"https://www.podul.com.cn/api/account.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
        if ([responseObject[@"login_result"] isEqual:@0]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.proHUD setMode:MBProgressHUDModeText];
                self.proHUD.label.text = @"登陆失败";
            });
        }else{
            if ([responseObject[@"is_login"] isEqual:@"1"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.proHUD setMode:MBProgressHUDModeText];
                    self.proHUD.label.text = @"该账号已登录！";
                });
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    //发送登陆成功的通知
                    NSDictionary *dict = @{
                                           @"account_id":responseObject[@"account_id"],
                                           @"isLogin":@"1",
                                           @"userName":responseObject[@"user_name"],
                                           @"iconURL":responseObject[@"icon_url"],
                                           @"signature":responseObject[@"signature"],
                                           @"isAdmin":responseObject[@"is_admin"]
                                           };
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"loginSuccess" object:@"Podul" userInfo:dict];
                    //登陆成功
                    [self.proHUD hideAnimated:YES];
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
            }
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.proHUD setMode:MBProgressHUDModeText];
            self.proHUD.label.text = @"登陆失败";
        });
    }];
}

- (void)iconInfo:(NSString *)str{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{
                                 @"action":@"icon",
                                 @"name":str
                                 };
    [manager POST:@"https://www.podul.com.cn/api/account.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject[@"result"]);
        if ([responseObject[@"result"] isEqual:@1]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.loginView.icon sd_setImageWithURL:[NSURL URLWithString:responseObject[@"icon_url"]]];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.loginView.icon setImage:[UIImage imageNamed:@"lunbo_01"]];
            });
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark -- 各种动作
- (void)loginAction:(UIButton *)sender{
    self.proHUD.mode = MBProgressHUDModeIndeterminate;
    self.proHUD.label.text = @"登录中...";
    [self.proHUD showAnimated:YES];
    [self loginInfo];
}

- (void)textDidChange:(UITextField *)textField{
    [self iconInfo:textField.text];
}

- (void)rightSGR:(UISwipeGestureRecognizer *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)regAction:(UIButton *)sender{
    NSLog(@"注册");
}

- (void)forgetAction:(UIButton *)sender{
    NSLog(@"找回密码");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //隐藏键盘
    [self.loginView endEditing:YES];
    if (self.proHUD.mode == MBProgressHUDModeText) {
        [self.proHUD hideAnimated:YES];
    }
}

//按回车键，切换文本框的输入焦点
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.loginView.accountField) {
        [self.loginView.passwordField becomeFirstResponder];   //切换到password
        
    }else if (textField == self.loginView.passwordField){
        [self loginAction:nil];
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
