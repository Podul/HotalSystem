//
//  HomeViewController.m
//  HotalSystem
//
//  Created by Podul on 2016/11/14.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeView.h"
#import "HomeModel.h"
#import "OrderModel.h"
#import "FoodViewController.h"
#import "HomeTableViewCell.h"
#import "ManagerViewController.h"
#import "NSString+URLEncode.h"
#import "LoginViewController.h"
#import <SWRevealViewController.h>
#import <MBProgressHUD.h>
#import <UIImageView+WebCache.h>
#import <AFNetworking.h>
#import <MJRefresh.h>

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,UITextFieldDelegate>{
    BOOL flag;      //判断是否编辑
}

@property (nonatomic,strong)HomeView *homeView;
@property (nonatomic,strong)MBProgressHUD *proHUD;
@property (nonatomic,strong)NSArray *foods;
@property (nonatomic,strong)NSMutableArray<NSMutableDictionary *> *orders;
@property (nonatomic,strong)NSMutableArray<NSDictionary *> *foodOrders;

@end

@implementation HomeViewController
static NSString *cycleID = @"cycleCell";
static NSString *homeID = @"homeCell";
#pragma mark -- 懒加载
- (HomeView *)homeView{
    if (_homeView == nil) {
        _homeView = [[HomeView alloc]initWithFrame:self.view.frame andNavItem:self.navigationItem];
        //左抽屉
        [_homeView.revealBtn setTarget:self.revealViewController];
        [_homeView.revealBtn setAction:@selector(revealToggle:)];
        [self.revealViewController panGestureRecognizer];
        [self.revealViewController tapGestureRecognizer];
        //注册单元格
        [_homeView.tableView registerClass:[HomeTableViewCell class] forCellReuseIdentifier:homeID];
        [_homeView.tableView registerClass:[HomeTableViewCell class] forCellReuseIdentifier:cycleID];
        [self.view addSubview:_homeView];
    }
    return _homeView;
}

- (MBProgressHUD *)proHUD{
    if (_proHUD == nil) {
        _proHUD = [[MBProgressHUD alloc]initWithView:self.homeView];
        _proHUD.contentColor = [UIColor whiteColor];
        _proHUD.detailsLabel.textColor = [UIColor whiteColor];
        _proHUD.label.textColor = [UIColor whiteColor];
        [_proHUD.bezelView setBackgroundColor:[UIColor blackColor]];
        [self.homeView addSubview:_proHUD];
    }
    return _proHUD;
}

- (NSArray *)foods{
    if (_foods == nil) {
        _foods = [NSArray array];
    }
    return _foods;
}

- (NSMutableArray<NSMutableDictionary *> *)orders{
    if (_orders == nil) {
        _orders = [NSMutableArray array];
        for (int i = 0; i<self.foods.count; i++) {
            [_orders addObject:[[NSMutableDictionary alloc]initWithDictionary:@{@"count":@"0",@"food_id":@""}]];
        }
    }
    return _orders;
}

- (NSMutableArray<NSDictionary *> *)foodOrders{
    if (_foodOrders == nil) {
        _foodOrders = [NSMutableArray array];
    }
    return _foodOrders;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/setting.plist"];
    
    //判断是否为管理员账号登录
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSArray *info = [NSArray arrayWithContentsOfFile:path];
        if ([info[0][0][@"isAdmin"] isEqual:@"1"]) {
            [self.homeView.manageBtn setTitle:@"管理"];
            [self.homeView.manageBtn setEnabled:YES];
        }else{
            [self.homeView.manageBtn setTitle:@""];
            [self.homeView.manageBtn setEnabled:NO];
        }
    }else{
        [self.homeView.manageBtn setTitle:@""];
        [self.homeView.manageBtn setEnabled:NO];
    }
}
#pragma mark - 提交订单成功
- (void)submitSuccess:(id)sender{
    //让数组初始化
    _orders = nil;
    _foodOrders = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.proHUD hideAnimated:YES];
        [self.proHUD setMode:MBProgressHUDModeText];
        self.proHUD.label.text = @"订单提交成功，请到订单中查看！";
        [self.homeView.tableView reloadData];
        self.homeView.submitView.hidden = YES;
        
    });
}
#pragma mark - 提交订单失败
- (void)submitError:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.proHUD.mode = MBProgressHUDModeText;
        self.proHUD.label.text = @"提交订单失败";
    });
}

//加载完成
- (void)foodInfos:(NSNotification *)sender{
    self.foods = sender.userInfo[@"foods"][@"food_names"];
    [self.proHUD hideAnimated:YES];
    [self.homeView.tableView.mj_header endRefreshing];
    [self.homeView.tableView reloadData];
}

//加载失败
- (void)loadError:(id)sender{
    self.proHUD.mode = MBProgressHUDModeText;
    self.proHUD.label.text = @"加载失败";
    [self.proHUD showAnimated:YES];
    [self.homeView.tableView.mj_header endRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.proHUD hideAnimated:NO];
    [self.homeView.tableView.mj_header endRefreshing];
}

#pragma mark -  接收通知
- (void)createNotif{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(foodInfos:) name:@"allFoods" object:@"Podul"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadError:) name:@"loadError" object:@"Podul"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(submitSuccess:) name:@"submitSuccess" object:@"Podul"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(submitError:) name:@"submitError" object:@"Podul"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNotif];     //创建一堆通知
    //下拉刷新
    self.homeView.tableView.mj_header= [MJRefreshStateHeader headerWithRefreshingBlock:^{
        [HomeModel foodInfo];
    }];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.homeView createHomeView:self];
    self.proHUD.mode = MBProgressHUDModeIndeterminate;
    [self.proHUD.label setText:@"加载中..."];
    [self.proHUD showAnimated:YES];
    //打开就加载数据
    [HomeModel foodInfo];
    [self.homeView.submitView setHidden:YES];
}
#pragma mark - 提交订单
- (void)submitOrder:(UIButton *)sender{
//    NSLog(@"提交订单");
    [self.proHUD setMode:MBProgressHUDModeIndeterminate];
    self.proHUD.label.text = @"提交中...";
    [self.proHUD showAnimated:YES];
    NSLog(@"%@",self.foodOrders);
//    NSMutableArray *names = [NSMutableArray array];
    for (id obj in self.foods) {
        for (int i=0; i<self.foodOrders.count; i++) {
            if ([obj[@"food_id"] isEqualToString:self.foodOrders[i][@"food_id"] ]){
                NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc]initWithDictionary:self.foodOrders[i]];
                [tmpDict setObject:obj[@"food_name"] forKey:@"food_name"];
                [self.foodOrders removeObjectAtIndex:i];
                [self.foodOrders insertObject:tmpDict atIndex:i];
//                [names addObject:self.foodOrders[i][@"food_name"]];
            }
        }
    }
    
//    [OrderModel submitOrder:@"Podul" andFoodName:names andPackageName:nil];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/setting.plist"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSArray *tmpArray = [NSMutableArray arrayWithContentsOfFile:path];
        for (int i=0; i<self.foodOrders.count; i++) {
            NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc]initWithDictionary:self.foodOrders[i]];
            [tmpDict setObject:tmpArray[0][0][@"account_id"] forKey:@"account_id"];
            [self.foodOrders removeObjectAtIndex:i];
            [self.foodOrders insertObject:tmpDict atIndex:i];
            
//            NSLog(@"%@",tmpArray[0][0][@"user_name"]);
        }
        NSLog(@"%@",self.foodOrders);
        [OrderModel submitOrder:self.foodOrders];
    }else{
//        NSLog(@"没有登录");
        [self presentViewController:[[LoginViewController alloc]init] animated:YES completion:nil];
    }
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]){
        CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
        [self.homeView.submitView setFrame:CGRectMake(0, kHeight - 64 - 49 - 50 + offset.y, kWidth, 50)];
    }
}

//管理
- (void)management:(UIBarButtonItem *)sender{
    [self presentViewController:[[ManagerViewController alloc]initWithFoods:self.foods] animated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.proHUD.mode == MBProgressHUDModeText) {
        [self.proHUD hideAnimated:YES];
    }
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //返回值要 + 1
    return self.foods.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeTableViewCell *cell;
    if ((indexPath.row == 0) && (indexPath.section == 0)) {
        cell = [tableView dequeueReusableCellWithIdentifier:cycleID forIndexPath:indexPath];
        [cell.contentView addSubview:self.homeView.cycleScrollView];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:homeID forIndexPath:indexPath];
        cell.foodLabel.text = self.foods[indexPath.row - 1][@"food_name"];
        cell.introdLabel.text = self.foods[indexPath.row - 1][@"comment"];
        //价格
        cell.priceLabel.text = self.foods[indexPath.row - 1][@"price"];
        //图片
        NSString *menuName = [self.foods[indexPath.row - 1][@"menu_name"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *foodName = [self.foods[indexPath.row - 1][@"food_name"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        [cell.foodImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:self.foods[indexPath.row - 1][@"food_url"],menuName,foodName]] placeholderImage:[UIImage imageNamed:@"noImages"]];
        [cell.countLabel setText:self.orders[indexPath.row - 1][@"count"]];
        [cell.addBtn setTag:indexPath.row - 1 + 100];
        [cell.addBtn addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
        [cell.reduceBtn setTag:indexPath.row - 1 + 1000];
        [cell.reduceBtn addTarget:self action:@selector(reduce:) forControlEvents:UIControlEventTouchUpInside];
    }
    tableView.rowHeight = cell.height;
    return cell;
}

#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self presentViewController:[[FoodViewController alloc]init] animated:YES completion:nil];
}

- (void)add:(UIButton *)sender{
    NSString *countStr = self.orders[sender.tag - 100][@"count"];
    if ([countStr isEqualToString:@"99"]) {
        [self.orders[sender.tag - 100] setValue:@"99" forKey:@"count"];
        [self.orders[sender.tag - 100] setValue:@"" forKey:@"food_id"];
        [self alert];
    }else{
        [self.orders[sender.tag - 100] setValue:[NSString stringWithFormat:@"%ld",[countStr integerValue] + 1] forKey:@"count"];
        [self.orders[sender.tag - 100] setValue:self.foods[sender.tag - 100][@"food_id"] forKey:@"food_id"];
        [self.homeView.tableView reloadData];
    }
    
    NSMutableString *tmpStr = [NSMutableString stringWithFormat:@"%@",self.foods[sender.tag - 100][@"price"]];
    NSString *tmpPrice = [tmpStr stringByReplacingOccurrencesOfString:@"元" withString:@""];
    
    int i;
    for (i=0; i<self.foodOrders.count; i++) {
        if ([self.foodOrders[i][@"food_id"] isEqualToString:self.orders[sender.tag - 100][@"food_id"]]) {
            [self.foodOrders removeObjectAtIndex:i];
            [self.foodOrders insertObject:@{@"count":[NSString stringWithFormat:@"%@",self.orders[sender.tag - 100][@"count"]],@"food_id":self.foods[sender.tag - 100][@"food_id"],@"price":tmpPrice} atIndex:i];
            break;
        }
    }
    if (i == self.foodOrders.count) {
        [self.foodOrders addObject:@{@"count":[NSString stringWithFormat:@"%@",self.orders[sender.tag - 100][@"count"]],@"food_id":self.foods[sender.tag - 100][@"food_id"],@"price":tmpPrice}];
        
    }
    for (int i = 0; i<self.foodOrders.count; i++) {
        if ([self.foodOrders[i][@"count"] isEqualToString:@"0"]) {
            [self.foodOrders removeObjectAtIndex:i];
        }
    }
    //显示或者隐藏提交订单
    if (self.foodOrders.count == 0) {
        self.homeView.submitView.hidden = YES;
    }else{
        self.homeView.submitView.hidden = NO;
        NSInteger price = 0;
        for (int i=0; i<self.foodOrders.count; i++) {
            price += [self.foodOrders[i][@"count"] integerValue] * [self.foodOrders[i][@"price"] integerValue];
        }
        self.homeView.priceLabel.text = [NSString stringWithFormat:@"总价为：%ld.00元",price];
    }
}

- (void)reduce:(UIButton *)sender{
    NSString *countStr = self.orders[sender.tag - 1000][@"count"];
    if ([countStr isEqualToString:@"0"]) {
        [self.orders[sender.tag - 1000] setValue:@"0" forKey:@"count"];
        [self.orders[sender.tag - 1000] setValue:@"" forKey:@"food_id"];
    }else{
        [self.orders[sender.tag - 1000] setValue:[NSString stringWithFormat:@"%ld",[countStr integerValue] - 1] forKey:@"count"];
        [self.orders[sender.tag - 1000] setValue:self.foods[sender.tag - 1000][@"food_id"] forKey:@"food_id"];
        [self.homeView.tableView reloadData];
    }
    
    NSMutableString *tmpStr = [NSMutableString stringWithFormat:@"%@",self.foods[sender.tag - 1000][@"price"]];
    NSString *tmpPrice = [tmpStr stringByReplacingOccurrencesOfString:@"元" withString:@""];
    
    int i;
    for (i=0; i<self.foodOrders.count; i++) {
        if ([self.foodOrders[i][@"food_id"] isEqualToString:self.orders[sender.tag - 1000][@"food_id"]]) {
            [self.foodOrders removeObjectAtIndex:i];
            [self.foodOrders insertObject:@{@"count":[NSString stringWithFormat:@"%@",self.orders[sender.tag - 1000][@"count"]],@"food_id":self.foods[sender.tag - 1000][@"food_id"],@"price":tmpPrice} atIndex:i];
            break;
        }
    }
    if (i == self.foodOrders.count) {
        [self.foodOrders addObject:@{@"count":[NSString stringWithFormat:@"%@",self.orders[sender.tag - 1000][@"count"]],@"food_id":self.foods[sender.tag - 1000][@"food_id"],@"price":tmpPrice}];
    }
    for (int i = 0; i<self.foodOrders.count; i++) {
        if ([self.foodOrders[i][@"count"] isEqualToString:@"0"]) {
            [self.foodOrders removeObjectAtIndex:i];
        }
    }
    
//    NSLog(@"%@",self.foodOrders);
    
    //显示或者隐藏提交订单
    if (self.foodOrders.count == 0) {
        self.homeView.submitView.hidden = YES;
    }else{
        self.homeView.submitView.hidden = NO;
        NSInteger price = 0;
        for (int i=0; i<self.foodOrders.count; i++) {
            price += [self.foodOrders[i][@"count"] integerValue] * [self.foodOrders[i][@"price"] integerValue];
        }
        self.homeView.priceLabel.text = [NSString stringWithFormat:@"总价为：%ld.00元",price];
    }
}

- (void)alert{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"数量必须在0到99之间" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertC addAction:cancelAction];
    [self presentViewController:alertC animated:YES completion:nil];
}

#pragma mark -- SDCycleScrollViewDelegate
//点击图片回调
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"%ld",index);
}

- (void)dealloc{
    //移除所有通知
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    //移除监听
    [self.homeView.tableView removeObserver:self forKeyPath:@"contentOffset" context:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
