//
//  PreferentialViewController.m
//  HotalSystem
//
//  Created by Podul on 2016/11/14.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import "PreferentialViewController.h"
#import "AddViewController.h"
#import <MJRefresh.h>
#import "PreView.h"
#import "AddModel.h"

@interface PreferentialViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)PreView *preView;
@property (nonatomic,strong)NSArray *packageInfos;
@end

@implementation PreferentialViewController
- (PreView *)preView{
    if (_preView == nil) {
        _preView = [[PreView alloc]initWithFrame:self.view.frame andNavItem:self.navigationItem];
        [self.view addSubview:_preView];
    }
    return _preView;
}

- (NSArray *)packageInfos{
    if (_packageInfos == nil) {
        _packageInfos = [NSArray array];
    }
    return _packageInfos;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.preView createPreView:self];
    
    [self createNotif]; //通知
    
    self.preView.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [AddModel addWithQueryPre];
    }];
}
- (void)createNotif{
    //查询成功
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(queryPreSuccess:) name:@"queryPreSuccess" object:@"Podul"];
    //查询失败
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(queryPreError:) name:@"queryPreError" object:@"Podul"];
}
#pragma mark - 查询成功
- (void)queryPreSuccess:(NSNotification *)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.preView.tableView.mj_header endRefreshing];
        [self.preView.proHUD hideAnimated:YES];
        self.packageInfos = sender.userInfo[@"data"];
        [self.preView.tableView reloadData];
        if (self.packageInfos.count != 0) {
            [self.preView.noInfoLabel setHidden:YES];
        }else{
            [self.preView.noInfoLabel setHidden:NO];
        }
    });
}
#pragma mark - 查询失败
- (void)queryPreError:(NSNotification *)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.preView.tableView.mj_header endRefreshing];
        self.preView.proHUD.mode = MBProgressHUDModeText;
        self.preView.proHUD.label.text = @"加载失败";
        if (self.packageInfos.count != 0) {
            [self.preView.noInfoLabel setHidden:YES];
        }else{
            [self.preView.noInfoLabel setHidden:NO];
        }
    });
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //如果没有内容
    self.preView.noInfoLabel.text = @"暂无优惠信息";
    if (self.packageInfos.count != 0) {
        [self.preView.noInfoLabel setHidden:YES];
    }else{
        [self.preView.noInfoLabel setHidden:NO];
    }
}


- (void)addPre:(id)sender{
    [self presentViewController:[[AddViewController alloc]init] animated:YES completion:nil];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.packageInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.packageInfos[indexPath.row][@"name"];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
