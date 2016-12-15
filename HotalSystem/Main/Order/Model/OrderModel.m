//
//  OrderModel.m
//  HotalSystem
//
//  Created by Podul on 2016/12/13.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import "OrderModel.h"
#import <AFNetworking.h>

@implementation OrderModel

#pragma mark - 取消订单
+ (void)orderWithCancel:(NSString *)orderid{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{
                                 @"action"  : @"userCancelOrder",
                                 @"order_id": orderid
                                 };
    [manager POST:@"https://www.podul.com.cn/api/order.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"result"] isEqual:@1]) {
            //            [[NSNotificationCenter defaultCenter]postNotificationName:@"querySuccess" object:@"Podul" userInfo:@{@"order_info":responseObject[@"order_info"]}];
        }else{
            //            [[NSNotificationCenter defaultCenter]postNotificationName:@"queryError" object:@"Podul"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        //        [[NSNotificationCenter defaultCenter]postNotificationName:@"queryError" object:@"Podul"];
    }];
}

#pragma mark - 确认订单
+ (void)orderWithConfirm:(NSString *)orderid{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{
                                 @"action"  : @"userConfirmOrder",
                                 @"order_id": orderid
                                 };
    [manager POST:@"https://www.podul.com.cn/api/order.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"%@",responseObject);
        if ([responseObject[@"result"] isEqual:@1]) {
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"querySuccess" object:@"Podul" userInfo:@{@"order_info":responseObject[@"order_info"]}];
        }else{
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"queryError" object:@"Podul"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"queryError" object:@"Podul"];
    }];
}

#pragma mark - 查询订单信息
+ (void)orderWithQuery:(NSString *)accountid{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{
                                 @"action" :     @"queryOrder",
                                 @"account_id" : accountid
                                 };
    [manager POST:@"https://www.podul.com.cn/api/order.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
        if ([responseObject[@"result"] isEqual:@1]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"querySuccess" object:@"Podul" userInfo:@{@"order_info":responseObject[@"order_info"]}];
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"queryError" object:@"Podul"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"queryError" object:@"Podul"];
    }];
}

#pragma mark - 提交订单信息
+ (void)orderWithsubmit:(NSArray *)foods{
//    NSLog(@"%@",foods);
    //将foods分解
    NSString *accountid = foods[0][@"account_id"];
    NSMutableArray *foodNames = [NSMutableArray array];
    NSInteger price = 0;
    NSMutableArray *counts = [NSMutableArray array];
    for (int i=0; i<foods.count; i++) {
        [foodNames addObject:foods[i][@"food_name"]];
        [counts addObject:foods[i][@"count"] ];
        NSInteger tmpCount = [foods[i][@"count"] integerValue];
        NSInteger tmpPrice = [foods[i][@"price"] integerValue];
        price += tmpPrice * tmpCount;
    }
    
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        NSDictionary *parameters = @{
                                     @"action"      : @"submitOrder",
                                     @"food_name"   : foodNames,    //传array
                                     @"account_id"  : accountid,
                                     @"package_name": @"",
                                     @"price"       : [NSString stringWithFormat:@"%ld元",price],
                                     @"count"       : counts
                                     };
    
        [manager POST:@"https://www.podul.com.cn/api/order.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            if ([responseObject[@"result"] isEqual:@1]) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"submitSuccess" object:@"Podul"];
            }else{
                [[NSNotificationCenter defaultCenter]postNotificationName:@"submitError" object:@"Podul"];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
            [[NSNotificationCenter defaultCenter]postNotificationName:@"submitError" object:@"Podul"];
        }];
    
}
@end
