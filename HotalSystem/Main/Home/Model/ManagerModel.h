//
//  ManagerModel.h
//  HotalSystem
//
//  Created by Podul on 2016/12/9.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ManagerModel : NSObject

//删除菜
+ (void)delFood:(NSString *)foodID;
//添加菜
+ (void)addFood:(NSString *)name andPrice:(NSString *)price andMenuid:(NSString *)menuid;
//修改菜
+ (void)fixFood:(NSString *)newName andPrice:(NSString *)newPrice andComment:(NSString *)newComment andFoodid:(NSString *)foodid;

@end
