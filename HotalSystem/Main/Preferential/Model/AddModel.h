//
//  AddModel.h
//  HotalSystem
//
//  Created by mac-mini on 2016/12/21.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddModel : NSObject

+ (void)addWithPre:(NSArray *)foods andName:(NSString *)name withPrice:(NSString *)price;

+ (void)addWithQueryPre;
@end
