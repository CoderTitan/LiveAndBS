//
//  BSRecommendCategaryModel.m
//  百思不得姐
//
//  Created by 田全军 on 16/9/26.
//  Copyright © 2016年 田全军. All rights reserved.
//

#import "BSRecommendCategaryModel.h"

@implementation BSRecommendCategaryModel
-(NSMutableArray *)users{
    if (_users == nil) {
        _users = [NSMutableArray array];
    }
    return _users;
}
@end
