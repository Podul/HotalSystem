//
//  SettingModel.m
//  HotalSystem
//
//  Created by Podul on 2016/11/21.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import "SettingModel.h"
#import <AFNetworking.h>

@implementation SettingModel

- (NSMutableArray *)infos{
    if (_infos == nil) {
//        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/setting.plist"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:SPATH]) {
            _infos = [NSMutableArray arrayWithContentsOfFile:SPATH];
        }else{
            _infos = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"setting" ofType:@"plist"]];
        }
    }
    return _infos;
}

#pragma mark - 退出登录
+ (void)exitLogin:(NSString *)accountid{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{
                                 @"action":@"exit",
                                 @"account_id":accountid
                                 };
    [manager POST:@"https://www.podul.com.cn/api/account.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"result"] isEqual:@1]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"exitSuccess" object:@"Podul"];
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"exitError" object:@"Podul"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"exitError" object:@"Podul"];
    }];
}

@end
