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
#import <MJRefresh.h>

@interface OrderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) OrderView *orderView;
@property (nonatomic ,strong) NSArray *orderInfos;
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

- (void)createNotif{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(querySuccess:) name:@"querySuccess" object:@"Podul"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(queryError:) name:@"queryError" object:@"Podul"];
}

#pragma mark - 查询成功
- (void)querySuccess:(NSNotification *)sender{
//    NSLog(@"success");
    self.orderInfos = sender.userInfo[@"order_info"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.orderView.tableView reloadData];
        [self.orderView.tableView.mj_header endRefreshing];
    });
}

#pragma mark - 查询失败
- (void)queryError:(id)sender{
    NSLog(@"error");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.orderView.tableView.mj_header endRefreshing];
    });
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
    [OrderModel queryOrder];
    //下拉刷新
    self.orderView.tableView.mj_header= [MJRefreshStateHeader headerWithRefreshingBlock:^{
        [OrderModel queryOrder];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.orderInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    [cell.smallIcon setImage:[UIImage imageNamed:@"lunbo_01"]];
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
    cell.nameLabel.text = [NSString stringWithFormat:@"%@",str];
    //    cell.nameLabel.text = [NSString stringWithFormat:@"%@、%@等",name1,name2];
    [cell.priceLabel setText:self.orderInfos[indexPath.row][@"price"]];
    tableView.rowHeight = cell.height;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
