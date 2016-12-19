//
//  LoginViewController.m
//  HotalSystem
//
//  Created by Podul on 2016/11/22.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"
#import "LoginModel.h"
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
        [_loginView.icon setImage:[UIImage imageNamed:@"noIcon"]];
        [self.view addSubview:_loginView];
    }
    return _loginView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.loginView createLoginView:self];
    
    //通知
    [self createNotif];
}
#pragma mark - 接收通知
- (void)createNotif{
    //用户名存在
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(nameExist:) name:@"nameExist" object:@"Podul"];
    //注册成功
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(regSuccess:) name:@"regSuccess" object:@"Podul"];
    //注册失败
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(regError:) name:@"regError" object:@"Podul"];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - 用户名已存在
- (void)nameExist:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.proHUD.mode = MBProgressHUDModeText;
        self.proHUD.label.text = @"用户名已存在";
    });
}
#pragma mark - 注册成功
- (void)regSuccess:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.proHUD.mode = MBProgressHUDModeText;
        self.proHUD.label.text = @"注册成功";
    });
}
#pragma mark - 注册失败
- (void)regError:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.proHUD.mode = MBProgressHUDModeText;
        self.proHUD.label.text = @"注册失败";
    });
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
                [self.loginView.icon setImage:[UIImage imageNamed:@"noIcon"]];
            });
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark -- 登陆
- (void)loginAction:(UIButton *)sender{
    if (self.loginView.accountField.text.length ==0 || self.loginView.passwordField.text.length == 0) {
        self.proHUD.mode = MBProgressHUDModeText;
        self.proHUD.label.text = @"请输入账号和密码";
        [self.proHUD showAnimated:YES];
    }else{
        self.proHUD.mode = MBProgressHUDModeIndeterminate;
        self.proHUD.label.text = @"登录中...";
        [self.proHUD showAnimated:YES];
        [self loginInfo];
    }
    
}

- (void)textDidChange:(UITextField *)textField{
    [self iconInfo:textField.text];
}

- (void)rightSGR:(UISwipeGestureRecognizer *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 注册
- (void)regAction:(UIButton *)sender{
//    NSLog(@"注册");
    UIAlertController *regAlertC = [UIAlertController alertControllerWithTitle:@"注册" message:@"请填写您的信息" preferredStyle:UIAlertControllerStyleAlert];
    //添加几个文本框
    //账号
    [regAlertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入用户名";
    }];
    //密码
    [regAlertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入密码";
        textField.secureTextEntry = YES;
    }];
    //确认密码
    [regAlertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请再次输入密码";
        textField.secureTextEntry = YES;
    }];
    //电话
    [regAlertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入电话";
    }];
    for (UITextField *textField in regAlertC.textFields) {
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }
    
    
    UIAlertAction *regAction = [UIAlertAction actionWithTitle:@"注册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (regAlertC.textFields[0].text.length != 0 && regAlertC.textFields[1].text.length != 0 ) {
            if (![regAlertC.textFields[1].text isEqualToString:regAlertC.textFields[2].text]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.proHUD.mode = MBProgressHUDModeText;
                    self.proHUD.label.text = @"两次密码不一致";
                    [self.proHUD showAnimated:YES];
                });
            }else{
                //执行注册
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.proHUD.mode = MBProgressHUDModeIndeterminate;
                    self.proHUD.label.text = @"注册中...";
                    [self.proHUD showAnimated:YES];
                    [LoginModel regWithName:regAlertC.textFields[0].text andPassword:regAlertC.textFields[1].text andTel:regAlertC.textFields[3].text];
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.proHUD.mode = MBProgressHUDModeText;
                self.proHUD.label.text = @"账号和密码不能为空";
                [self.proHUD showAnimated:YES];
            });
        }
        
    }];
    [regAction setValue:[UIColor redColor] forKey:@"_titleTextColor"];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [regAlertC addAction:regAction];
    [regAlertC addAction:cancelAction];
    [self presentViewController:regAlertC animated:YES completion:nil];
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
