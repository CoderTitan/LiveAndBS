//
//  NSDate+Extension.h
//  百思不得姐
//
//  Created by 田全军 on 16/10/24.
//  Copyright © 2016年 田全军. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)
/**
 * 比较from和self的时间差值
 */
- (NSDateComponents *)deltaFrom:(NSDate *)from;

/**
 * 是否为今年
 */
- (BOOL)isThisYear;

/**
 * 是否为今天
 */
- (BOOL)isToday;

/**
 * 是否为昨天
 */
- (BOOL)isYesterday;
@end
