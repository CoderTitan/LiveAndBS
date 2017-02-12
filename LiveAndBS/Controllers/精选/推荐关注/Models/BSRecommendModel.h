//
//  BSRecommendModel.h
//  百思不得姐
//
//  Created by 田全军 on 16/10/15.
//  Copyright © 2016年 田全军. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSRecommendModel : NSObject
/** 图片 */
@property (nonatomic, copy) NSString *image_list;
/** 名字 */
@property (nonatomic, copy) NSString *theme_name;
/** 订阅数 */
@property (nonatomic, assign) NSInteger sub_number;


@end
