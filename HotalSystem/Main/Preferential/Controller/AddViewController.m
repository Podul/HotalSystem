//
//  AddViewController.m
//  HotalSystem
//
//  Created by mac-mini on 2016/12/19.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import "AddViewController.h"
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

- (void)viewDidLoad {
    [super viewDidLoad];
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
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
        [view setBackgroundColor:[UIColor whiteColor]];
        //设置优惠界面
        
        [self.addView addSubview:view];
    }
}

#pragma mark - 取消
- (void)cancel:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
