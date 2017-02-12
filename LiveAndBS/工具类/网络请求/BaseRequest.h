//
//  BaseRequest.h
//  百思不得姐
//
//  Created by 田全军 on 16/9/27.
//  Copyright © 2016年 田全军. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseRequest : NSObject
//GET
+(void)getWithURL:(NSString *)url parmeter:(NSDictionary *)para completeHandle:(void (^)(id data, NSError *error))handle;

//POST
+(void)postWithURL:(NSString *)url parmeter:(NSDictionary *)para completeHandle:(void (^)(id data, NSError *error))handle;

@end
