//
//  LeftModel.m
//  HotalSystem
//
//  Created by Podul on 2016/12/2.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import "LeftModel.h"
#import <AFNetworking.h>

@implementation LeftModel

//获取菜类
+ (void)menuInfo{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{
                                 @"action":@"menu"
                                 };
    [manager POST:@"https://www.podul.com.cn/api/menu.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
        if ([responseObject[@"result"] isEqual:@1]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"menu" object:@"Podul" userInfo:@{@"menus":responseObject[@"menus"]}];
            //保存在本地
            NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/menus.plist"];
            [responseObject[@"menus"] writeToFile:path atomically:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

+ (void)foodNames:(NSString *)menuid andMenuName:(NSString *)menuName{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{
                                 @"action":@"showMenu",
                                 @"menu_id":menuid
                                 };
    [manager POST:@"https://www.podul.com.cn/api/menu.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
        if ([responseObject[@"result"] isEqual:@1]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"loadFoodInfoSuccess" object:@"Podul" userInfo:@{@"food_info":responseObject[@"food_info"],@"menu_name":menuName}];
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"loadFoodInfoError" object:@"Podul"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"loadFoodInfoError" object:@"Podul"];
    }];
}
@end
