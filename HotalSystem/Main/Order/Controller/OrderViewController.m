//
//  OrderViewController.m
//  HotalSystem
//
//  Created by Podul on 2016/11/14.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import "OrderViewController.h"
#import "OrderView.h"
#import "OrderModel.h"
#import "OrderTableViewCell.h"
#import "LoginViewController.h"
#import <UIImageView+WebCache.h>
#import <MJRefresh.h>

@interface OrderViewController ()<UITableViewDelegate,UITableViewDataSource>{
    BOOL isLogin;  //是否登录
    BOOL isAdmin;  //是否管理员
}
@property (nonatomic ,strong) OrderView *orderView;
@property (nonatomic ,strong) NSArray *orderInfos;  //订单信息
@property (nonatomic ,strong) UIButton *loginBtn;   //登陆按钮
@property (nonatomic ,strong) NSArray *accountInfos;    //账户信息
@property (nonatomic ,strong) UILabel *noOrderLabel;    //没有订单时显示

@end
static NSString *cellID = @"orderCell";
@implementation OrderViewController

- (OrderView *)orderView{
    if (_orderView == nil) {
        _orderView = [[OrderView alloc]initWithFrame:self.view.frame];
        [_orderView.tableView registerClass:[OrderTableViewCell class] forCellReuseIdentifier:cellID];
        [self.view addSubview:_orderView];
    }
    return _orderView;
}

- (NSArray *)orderInfos{
    if (_orderInfos == nil) {
        _orderInfos = [NSArray array];
    }
    return _orderInfos;
}

- (UIButton *)loginBtn{
    if (_loginBtn == nil) {
        _loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
        [_loginBtn setTitle:@"请先登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_loginBtn setCenter:self.orderView.center];
        [_loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

- (NSArray *)accountInfos{
    if (_accountInfos == nil) {
        _accountInfos = [NSArray array];
    }
    return _accountInfos;
}

- (UILabel *)noOrderLabel{
    if (_noOrderLabel == nil) {
        _noOrderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 30)];
        [_noOrderLabel setTextAlignment:NSTextAlignmentCenter];
        [_noOrderLabel setCenter:self.orderView.center];
        _noOrderLabel.text = @"暂无订单信息";
        [_noOrderLabel setTextColor:[UIColor colorWithRed:96.0/255.0 green:96.0/255.0 blue:96.0/255.0 alpha:1.0]];
        [_noOrderLabel setHidden:YES];  //默认隐藏
        [self.orderView addSubview:_noOrderLabel];
    }
    return _noOrderLabel;
}

#pragma mark - 接收各种通知
- (void)createNotif{
    //查询成功
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(querySuccess:) name:@"querySuccess" object:@"Podul"];
    //查询失败
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(queryError:) name:@"queryError" object:@"Podul"];
    //取消订单成功
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cancelSuccess:) name:@"cancelSuccess" object:@"Podul"];
    //取消订单失败
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cancelError:) name:@"cancelError" object:@"Podul"];
    //提交订单成功
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(confirmSuccess:) name:@"confirmSuccess" object:@"Podul"];
    //提交订单失败
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(confirmError:) name:@"confirmError" object:@"Podul"];
}
#pragma mark - 取消订单成功
- (void)cancelSuccess:(NSNotification *)sender{
    //需要重新获取一次列表
    [OrderModel orderWithQuery:self.accountInfos[0][0][@"account_id"]];
}
#pragma mark - 取消订单失败
- (void)cancelError:(NSNotification *)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.orderView.proHUD.mode = MBProgressHUDModeText;
        [OrderModel orderWithQuery:self.accountInfos[0][0][@"account_id"]];
    });
}
#pragma mark - 提交订单成功
- (void)confirmSuccess:(NSNotification *)sender{
    //需要重新获取一次列表
    [OrderModel orderWithQuery:self.accountInfos[0][0][@"account_id"]];
}
#pragma mark - 提交订单失败
- (void)confirmError:(NSNotification *)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.orderView.proHUD.mode = MBProgressHUDModeText;
        self.orderView.proHUD.label.text = @"提交订单失败";
    });
}

#pragma mark - 查询成功
- (void)querySuccess:(NSNotification *)sender{
    self.orderInfos = sender.userInfo[@"order_info"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.orderView.tableView reloadData];
        [self.orderView.proHUD hideAnimated:YES];
        [self.orderView.tableView.mj_header endRefreshing];
        if (self.orderInfos.count == 0) {
            [self.noOrderLabel setHidden:NO];
        }else{
            [self.noOrderLabel setHidden:YES];
        }
    });
}

#pragma mark - 查询失败
- (void)queryError:(id)sender{
    NSLog(@"queryError");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.orderView.proHUD showAnimated:YES];
        [self.orderView.proHUD setMode:MBProgressHUDModeText];
        [self.orderView.proHUD.label setText:@"加载失败"];
        [self.orderView.tableView.mj_header endRefreshing];
    });
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.orderView.proHUD.mode == MBProgressHUDModeText) {
        [self.orderView.proHUD hideAnimated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //判断是否登陆，是否管理员
    if ([[NSFileManager defaultManager] fileExistsAtPath:SPATH]) {
        self.accountInfos = [NSArray arrayWithContentsOfFile:SPATH];
        isLogin = YES;
        if ([self.accountInfos[0][0][@"isAdmin"] isEqual:@"1"]) {
            //是管理员
            isAdmin = YES;
        }else{
            //不是管理员
            isAdmin = NO;
        }
    }else{
        self.accountInfos = nil;
        //没有登陆
        isLogin = NO;
    }
    //如果登陆了才能加载数据
    if (isLogin) {
        [self.orderView.proHUD showAnimated:YES];
        [self.orderView.proHUD setMode:MBProgressHUDModeIndeterminate];
        [self.orderView.proHUD.label setText:@"加载中..."];
        [OrderModel orderWithQuery:self.accountInfos[0][0][@"account_id"]];
        //下拉刷新
        self.orderView.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [OrderModel orderWithQuery:self.accountInfos[0][0][@"account_id"]];
        }];
        [self.loginBtn removeFromSuperview];
    }else{
        [self.orderView.tableView.mj_header removeFromSuperview];
        self.orderView.tableView.mj_header = nil;
        [self.orderView addSubview:self.loginBtn];
        self.orderInfos = nil;
        [self.orderView.tableView reloadData];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (isLogin) {
        [self.orderView.tableView.mj_header endRefreshing];
        [self.orderView.proHUD hideAnimated:YES];
    }
}

- (void)dealloc{
    //移除所有通知
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //接收各种通知
    [self createNotif];
    [self.orderView createOrderView:self];
}
#pragma mark - 登录
- (void)login:(UIButton *)sender{
    [self presentViewController:[[LoginViewController alloc]init] animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.orderInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    [cell.smallIcon sd_setImageWithURL:[NSURL URLWithString:self.orderInfos[indexPath.row][@"icon"]] placeholderImage:[UIImage imageNamed:@"noImages"]];
    NSArray *infos = self.orderInfos[indexPath.row][@"info"];
    NSDictionary *nameDic = self.orderInfos[indexPath.row][@"info"][0];
    NSMutableString *str = [[NSMutableString alloc]initWithString:nameDic[@"food_name"]];
    for (int i=1; i<infos.count; i++) {
        NSString *name = self.orderInfos[indexPath.row][@"info"][i][@"food_name"];
        [str appendFormat:@"、%@",name];
        if (i >= 2) {
            [str appendString:@"等"];
            break;
        }
    }
    cell.foodNameLabel.text = str;
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ 订购了",self.orderInfos[indexPath.row][@"account_name"]];
    cell.priceLabel.text = [NSString stringWithFormat:@"共计：%@",self.orderInfos[indexPath.row][@"price"]];
    NSInteger order = [self.orderInfos[indexPath.row][@"order_id"] integerValue];
    cell.orderLabel.text = [NSString stringWithFormat:@"订单号：%09ld",order];
    
    BOOL isCancel = [self.orderInfos[indexPath.row][@"is_cancel"] isEqualToString:@"1"];
    BOOL isConfirm = [self.orderInfos[indexPath.row][@"is_confirm"] isEqualToString:@"1"];
    [cell.confirmBtn setHidden:YES];
    [cell.confirmBtn setUserInteractionEnabled:NO];
    [cell.cancelBtn setUserInteractionEnabled:NO];
    [cell.cancelBtn setHidden:YES];
    [cell.cancelOrConfirm setHidden:NO];
    if (!isCancel && !isConfirm) {
        [cell.cancelOrConfirm setHidden:YES];
        [cell.confirmBtn setHidden:NO];
        [cell.cancelBtn setHidden:NO];
        [cell.confirmBtn setUserInteractionEnabled:YES];
        [cell.cancelBtn setUserInteractionEnabled:YES];
        if (isLogin && isAdmin) {
            [cell.confirmBtn setTitle:@"确认订单" forState:UIControlStateNormal];
        }else if (isLogin && !isAdmin){
            [cell.confirmBtn setTitle:@"提交订单" forState:UIControlStateNormal];
        }
        [cell.confirmBtn setTag:indexPath.row + 10];
        [cell.confirmBtn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [cell.cancelBtn setTag:indexPath.row + 100];
        [cell.cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    }else if (isCancel && !isConfirm){
        cell.cancelOrConfirm.text = @"该订单已取消";
    }else if (!isCancel && isConfirm){
        cell.cancelOrConfirm.text = @"该订单已确认";
    }else{
        //既提交又取消
        cell.cancelOrConfirm.text = @"未知错误，请联系管理员";
    }
    
    tableView.rowHeight = cell.height;
    return cell;
}
#pragma mark - 确认订单
- (void)confirm:(UIButton *)sender{
    NSInteger index = sender.tag - 10;
    NSString *alertStr;
    if (isLogin && !isAdmin) {
        alertStr = [NSString stringWithFormat:@"您将为此支付%@",self.orderInfos[index][@"price"]];
    }else if (isLogin && isAdmin){
        alertStr = @"您将确认此订单";
    }
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:alertStr preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.orderView.proHUD setMode:MBProgressHUDModeIndeterminate];
            [self.orderView.proHUD.label setText:@"提交订单中..."];
            [self.orderView.proHUD showAnimated:YES];
        });
        [OrderModel orderWithConfirm:self.orderInfos[index][@"order_id"]];
    }];
    [okAction setValue:[UIColor redColor] forKey:@"_titleTextColor"];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertC addAction:okAction];
    [alertC addAction:cancel];
    [self presentViewController:alertC animated:YES completion:nil];
}

#pragma mark - 取消订单
- (void)cancel:(UIButton *)sender{
    NSInteger index = sender.tag - 100;
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定取消该订单？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.orderView.proHUD setMode:MBProgressHUDModeIndeterminate];
            [self.orderView.proHUD.label setText:@"取消订单中..."];
            [self.orderView.proHUD showAnimated:YES];
        });
        [OrderModel orderWithCancel:self.orderInfos[index][@"order_id"]];
    }];
    [okAction setValue:[UIColor redColor] forKey:@"_titleTextColor"];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"考虑考虑" style:UIAlertActionStyleCancel handler:nil];
    [alertC addAction:okAction];
    [alertC addAction:cancel];
    [self presentViewController:alertC animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
