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
+ (void)submitOrder:(NSArray *)foods;
//查询订单信息
+ (void)queryOrder;
@end
