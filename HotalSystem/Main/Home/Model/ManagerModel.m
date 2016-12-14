//
//  ManagerModel.m
//  HotalSystem
//
//  Created by Podul on 2016/12/9.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import "ManagerModel.h"
#import <AFNetworking.h>

@implementation ManagerModel

+ (void)addFood:(NSString *)name andPrice:(NSString *)price andMenuid:(NSString *)menuid{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    
    NSMutableString *tmpPrice = [NSMutableString stringWithFormat:@"%@",price];
    price = [tmpPrice stringByReplacingOccurrencesOfString:@"元" withString:@""];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{
                                 @"action":@"addFood",
                                 @"menu_id":menuid,
                                 @"food_name":name,
                                 @"price":[NSString stringWithFormat:@"%@元",price]
                                 };
    [manager POST:@"https://www.podul.com.cn/api/food.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
        if ([responseObject[@"add_result"] isEqual:@1]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"addFinish" object:@"Podul"];
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"addError" object:@"Podul"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"addError" object:@"Podul"];
    }];
}

+ (void)delFood:(NSString *)foodID{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{
                                 @"action":@"delFood",
                                 @"food_id":foodID
                                 };
    [manager POST:@"https://www.podul.com.cn/api/food.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"result"] isEqual:@1]) {
            //如果删除完成，则发送通知
            [[NSNotificationCenter defaultCenter]postNotificationName:@"delFinish" object:@"Podul"];
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"delError" object:@"Podul"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"delError" object:@"Podul"];
    }];
}

//修改菜
+ (void)fixFood:(NSString *)newName andPrice:(NSString *)newPrice andComment:(NSString *)newComment andFoodid:(NSString *)foodid{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSMutableString *tmpPrice = [NSMutableString stringWithFormat:@"%@",newPrice];
    newPrice = [tmpPrice stringByReplacingOccurrencesOfString:@"元" withString:@""];
    NSDictionary *parameters = @{
                                 @"action":@"fixFood",
                                 @"food_id":foodid,
                                 @"food_name":newName,
                                 @"price":[NSString stringWithFormat:@"%@元",newPrice],
                                 @"comment":newComment
                                 };
    [manager POST:@"https://www.podul.com.cn/api/food.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"fix_result"] isEqual:@1]) {
            //如果删除完成，则发送通知
            [[NSNotificationCenter defaultCenter]postNotificationName:@"fixFinish" object:@"Podul"];
        }else{
            //删除错误的通知
            [[NSNotificationCenter defaultCenter]postNotificationName:@"fixError" object:@"Podul"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        //删除错误的通知
        [[NSNotificationCenter defaultCenter]postNotificationName:@"fixError" object:@"Podul"];
    }];
}

@end
