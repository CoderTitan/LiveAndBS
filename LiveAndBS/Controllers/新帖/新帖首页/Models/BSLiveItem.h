//
//  BSLiveItem.h
//  百思不得姐
//
//  Created by 田全军 on 17/1/28.
//  Copyright © 2017年 田全军. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BSCreatorItem;
@interface BSLiveItem : NSObject

/** 直播流地址 */
@property (nonatomic, copy) NSString *stream_addr;
/** 关注人 */
@property (nonatomic, assign) NSUInteger online_users;
/** 城市 */
@property (nonatomic, copy) NSString *city;
/** 主播 */
@property (nonatomic, strong) BSCreatorItem *creator;

@end
