//
//  MenuViewController.m
//  HotalSystem
//
//  Created by Podul on 2016/12/2.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuView.h"
#import "MenuTableViewCell.h"
#import "ManagerViewController.h"
#import <UIImageView+WebCache.h>
@interface MenuViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)MenuView *menuView;
@property (nonatomic,strong)NSArray *foods;

@end
static NSString *menuCell = @"menuCell";
@implementation MenuViewController

- (MenuView *)menuView{
    if (_menuView == nil) {
        _menuView = [[MenuView alloc]initWithFrame:self.view.frame];
        [_menuView.tableView registerClass:[MenuTableViewCell class] forCellReuseIdentifier:menuCell];
        [self.view addSubview:_menuView];
    }
    return _menuView;
}

- (NSArray *)foods{
    if (_foods == nil) {
        _foods = [[NSArray alloc]init];
    }
    return _foods;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/setting.plist"];
    //判断是否为管理员账号登录
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSArray *info = [NSArray arrayWithContentsOfFile:path];
        if ([info[0][0][@"isAdmin"] isEqual:@"1"]) {
            [self.menuView.managerItem setTitle:@"管理"];
            [self.menuView.managerItem setEnabled:YES];
        }else{
            [self.menuView.managerItem setTitle:@""];
            [self.menuView.managerItem setEnabled:NO];
        }
    }else{
        [self.menuView.managerItem setTitle:@""];
        [self.menuView.managerItem setEnabled:NO];
    }
}

- (void)createNotification{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadFoodInfoSuccenss:) name:@"loadFoodInfoSuccess" object:@"Podul"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadFoodInfoError:) name:@"loadFoodInfoError" object:@"Podul"];
}

//加载失败
- (void)loadFoodInfoError:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.menuView.proHUD setMode:MBProgressHUDModeText];
        self.menuView.proHUD.label.text = @"加载失败";
    });
}
//加载成功
- (void)loadFoodInfoSuccenss:(NSNotification *)sender{
    self.menuView.backItem.title = sender.userInfo[@"menu_name"];
    self.foods = sender.userInfo[@"food_info"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.menuView.proHUD hideAnimated:YES];
        [self.menuView.tableView reloadData];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.menuView createMenuView:self];
    
    [self.menuView.proHUD setMode:MBProgressHUDModeIndeterminate];
    self.menuView.proHUD.label.text = @"加载中...";
    [self.menuView.proHUD showAnimated:YES];
    //各种通知
    [self createNotification];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.menuView.proHUD.mode == MBProgressHUDModeText) {
        [self.menuView.proHUD hideAnimated:YES];
    }
}

- (void)dealloc{
    //移除各种通知
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)back:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)manager:(id)sender{
    [self presentViewController:[[ManagerViewController alloc]initWithFoods:self.foods] animated:YES completion:nil];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.foods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:menuCell forIndexPath:indexPath];
    cell.foodLabel.text = self.foods[indexPath.row][@"food_name"];
    cell.introdLabel.text = self.foods[indexPath.row][@"comment"];
    //价格
    cell.priceLabel.text = self.foods[indexPath.row][@"price"];
    
    //图片
    NSString *menuName = [self.foods[indexPath.row][@"menu_name"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *foodName = [self.foods[indexPath.row][@"food_name"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [cell.foodImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:self.foods[indexPath.row][@"food_url"],menuName,foodName]] placeholderImage:[UIImage imageNamed:@"noImages"]];
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
