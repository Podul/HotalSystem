//
//  SettingViewController.m
//  HotalSystem
//
//  Created by Podul on 2016/11/14.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingView.h"
#import "SettingModel.h"
#import "SettingTableViewCell.h"
#import "LoginViewController.h"
#import <SDImageCache.h>
#import <SWRevealViewController.h>
#import <UIImageView+WebCache.h>

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>{
    BOOL isLogin;       //储存是否登录
}

@property (nonatomic,strong) SettingView *settingView;
@property (nonatomic,strong) SettingModel *settingM;
@end

@implementation SettingViewController

static NSString *userCell = @"userCell";
static NSString *settingCell = @"settingCell";

#pragma mark -- 懒加载
- (SettingView *)settingView{
    if (_settingView == nil) {
        _settingView = [[SettingView alloc]initWithFrame:self.view.frame];
        //注册单元格
        [_settingView.tableView registerClass:[SettingTableViewCell class] forCellReuseIdentifier:userCell];
        [_settingView.tableView registerClass:[SettingTableViewCell class] forCellReuseIdentifier:settingCell];
        
        [self.view addSubview:_settingView];
    }
    return _settingView;
}

- (SettingModel *)settingM{
    if (_settingM == nil) {
        _settingM = [[SettingModel alloc]init];
    }
    return _settingM;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.settingView.tableView reloadData];
}

#pragma mark -- 各种通知
- (void)createNotification{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(login:) name:@"loginSuccess" object:@"Podul"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(exitSuccess:) name:@"exitSuccess" object:@"Podul"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(exitError:) name:@"exitError" object:@"Podul"];
}
//退出成功
- (void)exitSuccess:(id)sender{
    //删除文件
    [[NSFileManager defaultManager]removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/setting.plist"] error:nil];
    self.settingM.infos = nil;
    isLogin = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.settingView.proHUD hideAnimated:YES];
        [self.settingView.tableView reloadData];
    });
}
//退出失败
- (void)exitError:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.settingView.proHUD setMode:MBProgressHUDModeText];
        self.settingView.proHUD.label.text = @"退出失败";
    });
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.settingView.proHUD.mode == MBProgressHUDModeText) {
        [self.settingView.proHUD hideAnimated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //判断是否登录
    if ([[NSFileManager defaultManager] fileExistsAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/setting.plist"]]) {
        isLogin = YES;
    }else{
        isLogin = NO;
    }
    
    [self createLeftBtnItem];
    [self.settingView createSettingView:self];
    //创建各种通知
    [self createNotification];
}
- (void)dealloc{
    //移除各种通知
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)login:(NSNotification *)sender{
    if ([sender.userInfo[@"isLogin"] isEqual:@"1"]) {
        NSDictionary *dict = @{
                               @"account_id":sender.userInfo[@"account_id"],
                               @"user_name":sender.userInfo[@"userName"],
                               @"icon_url":sender.userInfo[@"iconURL"],
                               @"signature":sender.userInfo[@"signature"],
                               @"isAdmin":sender.userInfo[@"isAdmin"]
                               };
        [self.settingM.infos insertObject:@[dict] atIndex:0];
        if ([self.settingM.infos.lastObject isEqual:@[@"登录"]]) {
            isLogin = YES;
            [self.settingM.infos removeLastObject];
            [self.settingM.infos addObject:@[@"退出登录"]];
        }
    }else{
        if ([self.settingM.infos.lastObject isEqual:@[@"退出登录"]]) {
            isLogin = NO;
            [self.settingM.infos removeObjectAtIndex:0];
            [self.settingM.infos removeLastObject];
            [self.settingM.infos addObject:@[@"登录"]];
        }
    }
    
    //保存到plist文件
//    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/setting.plist"];
    [self.settingM.infos writeToFile:SPATH atomically:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        //刷新单元格
        [self.settingView.tableView reloadData];
    });
}

//左抽屉
- (void)createLeftBtnItem{
    SWRevealViewController *revealVC = self.revealViewController;
    //手势
    [revealVC panGestureRecognizer];
    [revealVC tapGestureRecognizer];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStylePlain target:revealVC action:@selector(revealToggle:)];
    leftBtnItem.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}

#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.settingM.infos.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = self.settingM.infos[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettingTableViewCell *cell;
    NSArray *array = self.settingM.infos[indexPath.section];
    if (isLogin) {
        if (indexPath.section == 0 && indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:userCell forIndexPath:indexPath];
            cell.loginLabel.text = [array[indexPath.row][@"user_name"] lowercaseString];
            
            [cell.icon sd_setImageWithURL:[NSURL URLWithString:array[indexPath.row][@"icon_url"]] placeholderImage:[UIImage imageNamed:@"noIcon"]];
            cell.signLabel.text = array[indexPath.row][@"signature"];
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:settingCell forIndexPath:indexPath];
            cell.settingLabel.text = array[indexPath.row];
            if ([cell.settingLabel.text isEqualToString:@"退出登录"]) {
                [cell.settingLabel setTextColor:[UIColor redColor]];
            }else{
                [cell.settingLabel setTextColor:[UIColor blackColor]];
            }
            
            if ([cell.settingLabel.text isEqualToString:@"清除缓存"]) {
                //计算检查缓存大小
                NSUInteger size = [[SDImageCache sharedImageCache]getSize]; //字节
                NSString *tmpSize;
                if (size < 1024) {    //b
                    tmpSize = [NSString stringWithFormat:@"%.1fB",size/1.0];
                }else if (size < 1024*1024){    //kb
                    tmpSize = [NSString stringWithFormat:@"%.1fKB",size/1024.0];
                }else if (size < 1024*1024*1024){   //mb
                    tmpSize = [NSString stringWithFormat:@"%.1fMB",size/1024.0/1024.0];
                }else{  //gb
                    tmpSize = [NSString stringWithFormat:@"%.1fGB",size/1024.0/1024.0/1024.0];
                }
                cell.cacheLabel.text = tmpSize;
            }
        }
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:settingCell forIndexPath:indexPath];
        cell.settingLabel.text = array[indexPath.row];
        if ([cell.settingLabel.text isEqualToString:@"退出登录"]) {
            [cell.settingLabel setTextColor:[UIColor redColor]];
        }else{
            [cell.settingLabel setTextColor:[UIColor blackColor]];
        }
    }
    
    //显示最右边的箭头
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    tableView.rowHeight = cell.height;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.settingM.infos[indexPath.section][indexPath.row] isEqual:@"登录"]) {
        [self presentViewController:[[LoginViewController alloc]init] animated:YES completion:nil];
    }else if ([self.settingM.infos[indexPath.section][indexPath.row] isEqual:@"退出登录"]){
        [self exitLogin:self.settingM.infos[0][0][@"account_id"]];
    }else if ([self.settingM.infos[indexPath.section][indexPath.row] isEqualToString:@"清除缓存"]){
        [[SDImageCache sharedImageCache] clearDisk];
        [[SDImageCache sharedImageCache] clearMemory];//可有可无
        [self.settingView.tableView reloadData];
    }else{
        NSLog(@"没有用");
    }
}
- (void)exitLogin:(NSString *)accountid{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定退出登录？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.settingView.proHUD setMode:MBProgressHUDModeIndeterminate];
            self.settingView.proHUD.label.text = @"退出中...";
            [self.settingView.proHUD showAnimated:YES];
        });
        [SettingModel exitLogin:accountid];
    }];
    [okAction setValue:[UIColor redColor] forKey:@"_titleTextColor"];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertC addAction:okAction];
    [alertC addAction:cancelAction];
    [self presentViewController:alertC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
