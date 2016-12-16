//
//  UserViewController.m
//  HotalSystem
//
//  Created by mac-mini on 2016/12/16.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import "UserViewController.h"

@interface UserViewController (){
    BOOL isAdmin;
}
@property (nonatomic ,strong) NSArray *userInfo;
@end

@implementation UserViewController
- (NSArray *)userInfo{
    if (_userInfo == nil) {
        _userInfo = [NSArray arrayWithContentsOfFile:SPATH];
    }
    return _userInfo;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.userInfo[0][0][@"isAdmin"] isEqualToString:@"1"]) {
        isAdmin = YES;
    }else{
        isAdmin = NO;
    }
    UILabel *label = [[UILabel alloc]init];
    [label setTextColor:[UIColor blackColor]];
    [self.view addSubview:label];
    if (isAdmin) {
        label.text = @"您是管理员";
    }else{
        label.text = @"您是普通用户";
    }
    [label sizeToFit];
    [label setCenter:self.view.center];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.userInfo = nil;
}

- (void)back:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UISwipeGestureRecognizer *sgr = [[UISwipeGestureRecognizer alloc]init];
    sgr.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:sgr];
    [sgr addTarget:self action:@selector(back:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
