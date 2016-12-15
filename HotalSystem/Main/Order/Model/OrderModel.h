//
//  OrderModel.h
//  HotalSystem
//
//  Created by Podul on 2016/12/13.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject
//提交订单信息
+ (void)orderWithsubmit:(NSArray *)foods;
//查询订单信息
+ (void)orderWithQuery:(NSString *)accountid;
//用户确认订单
+ (void)orderWithUserConfirm:(NSString *)orderid;
//管理员确认订单
+ (void)orderWithAdminConfirm:(NSString *)orderid;
//用户取消订单
+ (void)orderWithUserCancel:(NSString *)orderid;
//管理员取消订单
+ (void)orderWithAdminCancel:(NSString *)orderid;
@end
