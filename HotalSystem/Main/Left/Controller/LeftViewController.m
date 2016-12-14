//
//  LeftViewController.m
//  HotalSystem
//
//  Created by Podul on 2016/11/16.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import "LeftViewController.h"
#import "LeftView.h"
#import "MenuViewController.h"
#import "LeftModel.h"

@interface LeftViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)LeftView *leftView;
@property (nonatomic,strong)LeftModel *leftModel;
@property (nonatomic,strong)NSArray *menus;
@end

@implementation LeftViewController
- (LeftView *)leftView{
    if (_leftView == nil) {
        _leftView = [[LeftView alloc]initWithFrame:self.view.frame];
        [self.view addSubview:_leftView];
    }
    return _leftView;
}

- (NSArray *)menus{
    if (_menus == nil) {
        _menus = [[NSArray alloc]init];
    }
    return _menus;
}

- (LeftModel *)leftModel{
    if (_leftModel == nil) {
        _leftModel = [[LeftModel alloc]init];
        
    }
    return _leftModel;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //接收通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(menu:) name:@"menu" object:@"Podul"];
}
- (void)menu:(NSNotification *)sender{
    self.menus = sender.userInfo[@"menus"];
    [self.leftView.tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //清除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.leftView createLeftView:self];
    [LeftModel menuInfo];
}

#pragma mark - UITableViewDataSource
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"菜单";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.menus.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"aaa"];
    cell.textLabel.text = self.menus[indexPath.row][@"menu_name"];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [LeftModel foodNames:self.menus[indexPath.row][@"menu_id"] andMenuName:self.menus[indexPath.row][@"menu_name"]];
    [self presentViewController:[[MenuViewController alloc]init] animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
