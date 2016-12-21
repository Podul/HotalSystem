//
//  AddViewController.m
//  HotalSystem
//
//  Created by mac-mini on 2016/12/19.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import "AddViewController.h"
#import "AddModel.h"
#import "AddView.h"

@interface AddViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) AddView *addView;
@property (nonatomic,strong) NSArray *foods;
@property (nonatomic,strong) NSMutableArray *tmpArray;
@property (nonatomic,strong) NSMutableArray<NSDictionary *> *tmpData;
@end


@implementation AddViewController

- (AddView *)addView{
    if (_addView == nil) {
        _addView = [[AddView alloc]initWithFrame:self.view.frame];
        [_addView setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:_addView];
    }
    return _addView;
}

- (NSArray *)foods{
    if (_foods == nil) {
        _foods = [NSArray arrayWithContentsOfFile:FPATH];
    }
    return _foods;
}

- (NSMutableArray *)tmpArray{
    if (_tmpArray == nil) {
        _tmpArray = [NSMutableArray array];
        for (NSDictionary *tmpDict in self.foods) {
            [_tmpArray addObject:@{@"selected":@"",@"food_id":tmpDict[@"food_id"]}];
        }
    }
    return _tmpArray;
}

- (NSMutableArray<NSDictionary *> *)tmpData{
    if (_tmpData == nil) {
        _tmpData = [NSMutableArray array];
    }
    return _tmpData;
}

- (void)createNotif{
    //添加成功
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addPreSuccess:) name:@"addPreSuccess" object:@"Podul"];
    //添加失败
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addPreError:) name:@"addPreError" object:@"Podul"];
}
#pragma mark - 添加成功
- (void)addPreSuccess:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.addView.proHUD hideAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}
#pragma mark - 添加失败
- (void)addPreError:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.addView.proHUD setMode:MBProgressHUDModeText];
        self.addView.proHUD.label.text = @"添加失败";
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNotif]; //通知
    // Do any additional setup after loading the view.
    [self.addView createAddView:self];
    
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.foods.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"addCell"];
    }
    cell.textLabel.text = self.foods[indexPath.row][@"food_name"];
    cell.detailTextLabel.text = self.tmpArray[indexPath.row][@"selected"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //选中打勾
    //判断是否选中
    if ([self.tmpArray[indexPath.row][@"selected"] isEqualToString:@"✓"]) {
        for (int i=0; i<self.tmpData.count; i++) {
            if ([self.tmpData[i] isEqual:self.tmpArray[indexPath.row][@"food_id"]]) {
                [self.tmpData removeObjectAtIndex:i];
            }
        }
        [self.tmpArray removeObjectAtIndex:indexPath.row];
        [self.tmpArray insertObject:@{@"selected":@"",@"food_id":@""} atIndex:indexPath.row];
    }else{
        [self.tmpArray removeObjectAtIndex:indexPath.row];
        [self.tmpArray insertObject:@{@"selected":@"✓",@"food_id":self.foods[indexPath.row][@"food_id"]} atIndex:indexPath.row];
        [self.tmpData addObject:self.tmpArray[indexPath.row][@"food_id"]];
    }
    
    [tableView reloadData];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 下一步
- (void)nextStep:(id)sender{
    if (self.tmpData.count != 0) {  //如果选了
//        [self.addView.preInfoView setHidden:NO];
        //设置价格
        UIAlertController *priceAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请设置价格" preferredStyle:UIAlertControllerStyleAlert];
        [priceAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入优惠名";
        }];
        [priceAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入价格";
            [textField setKeyboardType:UIKeyboardTypeNumberPad];
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"提交" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (priceAlert.textFields.firstObject.text.length != 0 && priceAlert.textFields.lastObject.text.length != 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.addView.proHUD setMode:MBProgressHUDModeIndeterminate];
                    self.addView.proHUD.label.text = @"提交中...";
                    [self.addView.proHUD showAnimated:YES];
                });
                [AddModel addWithPre:self.tmpData andName:priceAlert.textFields[0].text withPrice:priceAlert.textFields[1].text];
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.addView.proHUD setMode:MBProgressHUDModeText];
                    self.addView.proHUD.label.text = @"请输入正确内容";
                    [self.addView.proHUD showAnimated:YES];
                });
            }
            
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [priceAlert addAction:okAction];
        [priceAlert addAction:cancelAction];
        [self presentViewController:priceAlert animated:YES completion:nil];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.addView.proHUD.mode == MBProgressHUDModeText) {
        [self.addView.proHUD hideAnimated:YES];
    }
}

#pragma mark - 取消
- (void)cancel:(id)sender{
//    if (self.addView.preInfoView.hidden) {
        [self dismissViewControllerAnimated:YES completion:nil];
//    }else{
//        [self.addView.preInfoView setHidden:YES];
//    }
    
}

@end
