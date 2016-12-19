//
//  LoginModel.m
//  HotalSystem
//
//  Created by Podul on 2016/12/7.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import "LoginModel.h"
#import <AFNetworking.h>

@implementation LoginModel

+ (void)regWithName:(NSString *)name andPassword:(NSString *)psd andTel:(NSString *)tel{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *params = @{
                             @"action":@"register",
                             @"name":name,
                             @"psd":psd,
                             @"tel":tel
                             };
    [manager POST:@"https://www.podul.com.cn/api/account.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
        if ([responseObject[@"register_result"] isEqual:@1]) {  //注册成功
            [[NSNotificationCenter defaultCenter]postNotificationName:@"regSuccess" object:@"Podul"];
        }else{
            if ([responseObject[@"register_result"] isEqual:@"0"]) {    //用户名存在
                [[NSNotificationCenter defaultCenter]postNotificationName:@"nameExist" object:@"Podul"];
            }else{  //注册失败
                [[NSNotificationCenter defaultCenter]postNotificationName:@"regError" object:@"Podul"];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"regError" object:@"Podul"];
    }];
}
@end
