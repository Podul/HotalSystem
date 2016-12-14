//
//  LoginView.m
//  HotalSystem
//
//  Created by Podul on 2016/11/22.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView{
    UIButton *_regBtn;          //注册按钮
    UIButton *_forgetBtn;       //忘记密码
}
//头像
- (UIImageView *)icon{
    if (_icon == nil) {
        CGFloat wh = (kHeight/4 - 59)-20;
        _icon = [[UIImageView alloc]initWithFrame:CGRectMake((kWidth - wh) / 2, 59, wh, wh)];
        _icon.layer.masksToBounds = YES;
        _icon.layer.cornerRadius = wh / 2.0;
        [_icon setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_icon];
    }
    return _icon;
}
//账号
- (UITextField *)accountField{
    if (_accountField == nil) {
        _accountField = [[UITextField alloc]initWithFrame:CGRectMake(0, kHeight/4, kWidth, 40)];
        //居中
        _accountField.textAlignment = NSTextAlignmentCenter;
        //修改键盘
        _accountField.keyboardType = UIKeyboardTypeASCIICapable;
        //关闭自动大写
        _accountField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        //关闭自动改正
        _accountField.autocorrectionType = UITextAutocorrectionTypeNo;
        //当在编辑的时候显示清除按钮
        _accountField.clearButtonMode = UITextFieldViewModeWhileEditing;
        //return样式
        _accountField.returnKeyType = UIReturnKeyNext;
        
        [_accountField setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_accountField];
    }
    return _accountField;
}
//密码
- (UITextField *)passwordField{
    if (_passwordField == nil) {
        _passwordField = [[UITextField alloc]initWithFrame:CGRectMake(0, kHeight/4 + 41, kWidth, 40)];
        //设置居中
        _passwordField.textAlignment = NSTextAlignmentCenter;
        [_passwordField setBackgroundColor:[UIColor whiteColor]];
        //密文
        [_passwordField setSecureTextEntry:YES];
        //当在编辑的时候显示清除按钮
        _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
        //return键样式
        _passwordField.returnKeyType = UIReturnKeyDone;
        
        [self addSubview:_passwordField];
    }
    return _passwordField;
}
//登录按钮
- (UIButton *)loginBtn{
    if (_loginBtn == nil) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginBtn setFrame:CGRectMake(20, kHeight/4 + 100, kWidth - 40, 45)];
        [_loginBtn setBackgroundColor:[UIColor blueColor]];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //圆角
        _loginBtn.layer.masksToBounds = YES;
        _loginBtn.layer.cornerRadius = 5.0;
        
        [self addSubview:_loginBtn];
    }
    return _loginBtn;
}

//手势
- (UISwipeGestureRecognizer *)rightSGR{
    if (_rightSGR == nil) {
        _rightSGR = [[UISwipeGestureRecognizer alloc]init];
        _rightSGR.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:_rightSGR];
    }
    return _rightSGR;
}


#pragma mark - 注册按钮
- (UIButton *)regBtn{
    if (_regBtn == nil) {
        _regBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_regBtn setFrame:CGRectMake(10, kHeight - 40, 100, 25)];
        [_regBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [_regBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self addSubview:_regBtn];
    }
    return _regBtn;
}

#pragma mark - 忘记密码
- (UIButton *)forgetBtn{
    if (_forgetBtn == nil) {
        _forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forgetBtn setFrame:CGRectMake(kWidth - 110, kHeight - 40, 100, 25)];
        [_forgetBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [_forgetBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self addSubview:_forgetBtn];
    }
    return _forgetBtn;
}

- (void)createLoginView:(id)object{
    [self setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]];
    
    [self.icon setTag:10];
    
    self.accountField.placeholder = @"请输入账号";
    self.accountField.delegate = object;
    //监听账号输入当文本控件中编辑结束时发送通知。
//    UIControlEventEditingDidOnExit
    [self.accountField addTarget:object action:@selector(textDidChange:) forControlEvents:UIControlEventEditingDidEnd];
    self.passwordField.placeholder = @"请输入密码";
    self.passwordField.delegate = object;
    
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginBtn addTarget:object action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //手势
    [self.rightSGR addTarget:object action:@selector(rightSGR:)];
    
    //注册按钮
    [self.regBtn setTitle:@"没有账号？" forState:UIControlStateNormal];
    [self.regBtn addTarget:object action:@selector(regAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //忘记密码
    [self.forgetBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [self.forgetBtn addTarget:object action:@selector(forgetAction:) forControlEvents:UIControlEventTouchUpInside];
}

@end
