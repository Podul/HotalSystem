//
//  HomeModel.m
//  HotalSystem
//
//  Created by Podul on 2016/12/9.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import "HomeModel.h"
#import <AFNetworking.h>

@implementation HomeModel

+ (void)foodInfo{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{
                                 @"action":@"food"
                                 };
    [manager POST:@"https://www.podul.com.cn/api/food.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                NSLog(@"%@",responseObject[@"food_names"]);
        if ([responseObject[@"result"] isEqual:@1]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"allFoods" object:@"Podul" userInfo:@{@"foods":responseObject}];
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"loadError" object:@"Podul"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"loadError" object:@"Podul"];
    }];
}


@end
