//
//  NSString+URLEncode.h
//  HotalSystem
//
//  Created by Podul on 2016/12/13.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLEncode)
+ (NSString *)decodeFromPercentEscapeString:(NSString *)input;
@end
