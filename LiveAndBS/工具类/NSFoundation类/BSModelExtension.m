//
//  BSModelExtension.m
//  百思不得姐
//
//  Created by 田全军 on 16/10/25.
//  Copyright © 2016年 田全军. All rights reserved.
//

#import "BSModelExtension.h"
#import <MJExtension.h>

#import "BSRecommendCategaryModel.h"
#import "BSTopicModel.h"
@implementation BSModelExtension
/**
 *  第一次调用这个类的时候就会调用这个方法
 */
+(void)initialize{
    [BSTopicModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"small_image" : @"image0",
                 @"large_image" : @"image1",
                 @"middle_image" : @"image2"};
    }];
    
    [BSRecommendCategaryModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID" : @"id"};
    }];
}
@end
