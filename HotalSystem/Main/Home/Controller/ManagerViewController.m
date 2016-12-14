//
//  ManagerTableViewController.m
//  HotalSystem
//
//  Created by Podul on 2016/12/9.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import "ManagerViewController.h"
#import "ManagerModel.h"
#import "HomeModel.h"
#import "ManagerTableViewCell.h"
#import <MBProgressHUD.h>

@interface ManagerViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *foods;
@property (nonatomic,strong)MBProgressHUD *proHUD;
@property (nonatomic,strong)UINavigationBar *navBar;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UINavigationItem *navItems;
@end

static NSString *managerID = @"managerCell";

@implementation ManagerViewController

- (id)initWithFoods:(NSArray *)foods{
    if (self = [super init]) {
        self.foods = [[NSMutableArray alloc]initWithArray:foods];
    }
    return self;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UINavigationBar *)navBar{
    if (_navBar == nil) {
        _navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
        [self.view addSubview:_navBar];
    }
    return _navBar;
}
- (UINavigationItem *)navItems{
    if (_navItems == nil) {
        _navItems = [[UINavigationItem alloc]init];
    }
    return _navItems;
}

- (MBProgressHUD *)proHUD{
    if (_proHUD == nil) {
        _proHUD = [[MBProgressHUD alloc]initWithView:self.view];
        _proHUD.contentColor = [UIColor whiteColor];
        _proHUD.detailsLabel.textColor = [UIColor whiteColor];
        _proHUD.label.textColor = [UIColor whiteColor];
        [_proHUD.bezelView setBackgroundColor:[UIColor blackColor]];
        [self.view addSubview:_proHUD];
    }
    return _proHUD;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //接收通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(delFinish:) name:@"delFinish" object:@"Podul"];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addFinish:) name:@"addFinish" object:@"Podul"];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fixFinish:) name:@"fixFinish" object:@"Podul"];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(delError:) name:@"delError" object:@"Podul"];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addError:) name:@"addError" object:@"Podul"];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fixError:) name:@"fixError" object:@"Podul"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //移除所有通知
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setFrame:CGRectMake(0, 64, kWidth, kHeight - 64)];
    
    [self.tableView setEditing:YES animated:YES];
    
    [self.navItems setRightBarButtonItem:[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finish:)] animated:YES];
    [self.navItems setLeftBarButtonItem:[[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addFood:)] animated:YES];
    [self.navBar setItems:@[self.navItems]];
    
    //注册单元格
    [self.tableView registerClass:[ManagerTableViewCell class] forCellReuseIdentifier:managerID];
    
}
//完成
- (void)finish:(id)sender{
    [HomeModel foodInfo];
    [self dismissViewControllerAnimated:YES completion:nil];
}
//添加
- (void)addFood:(id)sender{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"添加菜" message:@"请输入菜名和价格" preferredStyle:UIAlertControllerStyleAlert];
    [alertC addTextFieldWithConfigurationHandler:nil];
    [alertC addTextFieldWithConfigurationHandler:nil];
    for (int i = 0; i<alertC.textFields.count; i++) {
        //关闭自动大写
        alertC.textFields[i].autocapitalizationType = UITextAutocapitalizationTypeNone;
        //关闭自动改正
        alertC.textFields[i].autocorrectionType = UITextAutocorrectionTypeNo;
        //当在编辑的时候显示清除按钮
        alertC.textFields[i].clearButtonMode = UITextFieldViewModeWhileEditing;
        
        if (i == 0) {
            alertC.textFields[i].placeholder = @"请输入菜名";
            //return样式
            alertC.textFields[i].returnKeyType = UIReturnKeyNext;
        }else if (i == 1) {
            alertC.textFields[i].placeholder = @"请输入价格（¥）";
            //修改键盘
            alertC.textFields[i].keyboardType = UIKeyboardTypeNumberPad;
            //return样式
            alertC.textFields[i].returnKeyType = UIReturnKeyDone;
        }else{
            NSLog(@"error");
        }
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ((alertC.textFields[0].text.length != 0) && (alertC.textFields[1].text.length != 0)) {
            self.proHUD.mode = MBProgressHUDModeIndeterminate;
            self.proHUD.label.text = @"添加中...";
            [self.proHUD showAnimated:YES];
            
            [ManagerModel addFood:alertC.textFields[0].text andPrice:alertC.textFields[1].text andMenuid:@"1"];
            [self.foods addObject:@{@"food_name":alertC.textFields[0].text,@"price":[NSString stringWithFormat:@"%@元",alertC.textFields[1].text]}];
        }else{
            self.proHUD.mode = MBProgressHUDModeText;
            self.proHUD.label.text = @"输入错误，请重试";
            [self.proHUD showAnimated:YES];
        }
    }];
    [alertC addAction:cancelAction];
    [alertC addAction:okAction];
    [self presentViewController:alertC animated:YES completion:nil];
}

- (void)addFinish:(id)sender{
    [self.tableView reloadData];
    [self.proHUD hideAnimated:YES];
}

- (void)addError:(id)sender{
    self.proHUD.mode = MBProgressHUDModeText;
    self.proHUD.label.text = @"添加失败！";
}

- (void)fixFinish:(id)sender{
    [self.tableView reloadData];
    [self.proHUD hideAnimated:YES];
}

- (void)fixError:(id)sender{
    self.proHUD.mode = MBProgressHUDModeText;
    self.proHUD.label.text = @"修改失败！";
}

- (void)delFinish:(id)sender{
    [self.proHUD hideAnimated:YES];
    [self.tableView reloadData];
}
//删除失败
- (void)delError:(id)sender{
    self.proHUD.mode = MBProgressHUDModeText;
    self.proHUD.label.text = @"删除失败！";
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.proHUD.mode == MBProgressHUDModeText) {
        [self.proHUD hideAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.foods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ManagerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:managerID forIndexPath:indexPath];
    cell.nameLabel.text = self.foods[indexPath.row][@"food_name"];
    cell.commentLabel.text = self.foods[indexPath.row][@"comment"];
    cell.priceLabel.text = self.foods[indexPath.row][@"price"];
    
    [cell.nameLabel setTag:100+indexPath.row];
    [cell.commentLabel setTag:100+indexPath.row];
    [cell.priceLabel setTag:100+indexPath.row];
    
    [cell.nameTap addTarget:self action:@selector(fixName:)];
    [cell.commentTap addTarget:self action:@selector(fixComment:)];
    [cell.priceTap addTarget:self action:@selector(fixPrice:)];
    
    tableView.rowHeight = cell.height;
    return cell;
}

//修改菜名
- (void)fixName:(UITapGestureRecognizer *)sender{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"修改名字" preferredStyle:UIAlertControllerStyleAlert];
    [alertC addTextFieldWithConfigurationHandler:nil];
    alertC.textFields[0].text = self.foods[sender.view.tag - 100][@"food_name"];
    alertC.textFields[0].placeholder = @"请输入菜名";
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        self.proHUD.mode = MBProgressHUDModeIndeterminate;
        self.proHUD.label.text = @"修改中...";
        [self.proHUD showAnimated:YES];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:self.foods[sender.view.tag - 100]];
        [dict setValue:alertC.textFields[0].text forKey:@"food_name"];
        [self.foods removeObjectAtIndex:(sender.view.tag - 100)];
        [self.foods insertObject:dict atIndex:(sender.view.tag - 100)];
 
        //请求网络
        [ManagerModel fixFood:alertC.textFields[0].text andPrice:self.foods[sender.view.tag - 100][@"price"] andComment:self.foods[sender.view.tag - 100][@"comment"] andFoodid:self.foods[sender.view.tag - 100][@"food_id"]];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertC addAction:okAction];
    [alertC addAction:cancelAction];
    [self presentViewController:alertC animated:YES completion:nil];
}
//修改简介
- (void)fixComment:(UITapGestureRecognizer *)sender{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"修改简介" preferredStyle:UIAlertControllerStyleAlert];
    [alertC addTextFieldWithConfigurationHandler:nil];
    alertC.textFields[0].text = self.foods[sender.view.tag - 100][@"comment"];
    alertC.textFields[0].placeholder = @"请输入简介";
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.proHUD.mode = MBProgressHUDModeIndeterminate;
        self.proHUD.label.text = @"修改中...";
        [self.proHUD showAnimated:YES];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:self.foods[sender.view.tag - 100]];
        [dict setValue:alertC.textFields[0].text forKey:@"comment"];
        [self.foods removeObjectAtIndex:(sender.view.tag - 100)];
        [self.foods insertObject:dict atIndex:(sender.view.tag - 100)];

        //请求网络
        [ManagerModel fixFood:self.foods[sender.view.tag - 100][@"food_name"] andPrice:self.foods[sender.view.tag - 100][@"price"] andComment:alertC.textFields[0].text andFoodid:self.foods[sender.view.tag - 100][@"food_id"]];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertC addAction:okAction];
    [alertC addAction:cancelAction];
    [self presentViewController:alertC animated:YES completion:nil];
}

//修改价格
- (void)fixPrice:(UITapGestureRecognizer *)sender{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"修改价格" preferredStyle:UIAlertControllerStyleAlert];
    [alertC addTextFieldWithConfigurationHandler:nil];
    
    NSMutableString *tmpStr = [NSMutableString stringWithFormat:@"%@",self.foods[sender.view.tag - 100][@"price"]];
    NSString *tmpPrice = [tmpStr stringByReplacingOccurrencesOfString:@"元" withString:@""];
    
    alertC.textFields[0].text = tmpPrice;
    alertC.textFields[0].placeholder = @"请输入价格";
    alertC.textFields[0].keyboardType = UIKeyboardTypeNumberPad;
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.proHUD.mode = MBProgressHUDModeIndeterminate;
        self.proHUD.label.text = @"修改中...";
        [self.proHUD showAnimated:YES];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:self.foods[sender.view.tag - 100]];
        
        [dict setValue:[NSString stringWithFormat:@"%@元",alertC.textFields[0].text] forKey:@"price"];
        [self.foods removeObjectAtIndex:(sender.view.tag - 100)];
        [self.foods insertObject:dict atIndex:(sender.view.tag - 100)];
        
        //请求网络
        [ManagerModel fixFood:self.foods[sender.view.tag - 100][@"food_name"] andPrice:alertC.textFields[0].text andComment:self.foods[sender.view.tag - 100][@"comment"] andFoodid:self.foods[sender.view.tag - 100][@"food_id"]];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertC addAction:okAction];
    [alertC addAction:cancelAction];
    [self presentViewController:alertC animated:YES completion:nil];
}

//删除四步走：
#pragma mark 开启编辑动画
- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:YES animated:animated];
}

#pragma mark 允许编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

#pragma mark 选择编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

#pragma mark 开始删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //判断编辑样式(删除还是插入)
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定删除" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.proHUD.mode = MBProgressHUDModeIndeterminate;
            self.proHUD.label.text = @"删除中...";
            [self.proHUD showAnimated:YES];
            [ManagerModel delFood:self.foods[indexPath.row][@"food_id"]];
            [self.foods removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
        }];
        //确定键颜色
        [okAction setValue:[UIColor redColor] forKey:@"_titleTextColor"];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertC addAction:okAction];
        [alertC addAction:cancelAction];
        
        [self presentViewController:alertC animated:YES completion:nil];
    }
}

@end
