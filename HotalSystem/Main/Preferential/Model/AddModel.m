//
//  AddModel.m
//  HotalSystem
//
//  Created by mac-mini on 2016/12/21.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import "AddModel.h"
#import <AFNetworking.h>

@implementation AddModel
+ (void)addWithQueryPre{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *params = @{
                             @"action":@"query",
                             };
    [manager POST:@"https://www.podul.com.cn/api/package.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"result"] isEqual:@1]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"queryPreSuccess" object:@"Podul" userInfo:@{@"data":responseObject[@"data"]}];
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"queryPreError" object:@"Podul"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"queryPreError" object:@"Podul"];
    }];
}

+ (void)addWithPre:(NSArray *)foods andName:(NSString *)name withPrice:(NSString *)price{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *params = @{
                             @"action":@"package",
                             @"food_id":foods,
                             @"price":[NSString stringWithFormat:@"%@元",price],
                             @"name":name
                             };
    [manager POST:@"https://www.podul.com.cn/api/package.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"result"] isEqual:@1]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"addPreSuccess" object:@"Podul"];
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"addPreError" object:@"Podul"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"addPreError" object:@"Podul"];
    }];
}
@end
