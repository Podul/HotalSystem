//
//  SettingModel.h
//  HotalSystem
//
//  Created by Podul on 2016/11/21.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingModel : NSObject

@property (nonatomic,strong) NSMutableArray *infos;
//退出登录
+ (void)exitLogin:(NSString *)accountid;
@end
