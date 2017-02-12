//
//  BaseRequest.m
//  百思不得姐
//
//  Created by 田全军 on 16/9/27.
//  Copyright © 2016年 田全军. All rights reserved.
//

#import "BaseRequest.h"
#import <AFNetworking.h>

@implementation BaseRequest
//get
+(void)getWithURL:(NSString *)url parmeter:(NSDictionary *)para completeHandle:(void (^)(id, NSError *))handle
{
    
    //创建封装了NSURLSession对象的的管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置二进制的解析器
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager GET:url parameters:para progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        handle(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        handle(nil,error);
    }];
//    [manager GET:url parameters:para success:^(NSURLSessionDataTask *task, id responseObject) {
//        handle(responseObject,nil);
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        handle(nil,error);
//    }];
    
}

+(void)postWithURL:(NSString *)url parmeter:(NSDictionary *)para completeHandle:(void (^)(id, NSError *))handle
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:para progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        handle(responseObject,nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        handle(nil,error);
    }];
}


@end
