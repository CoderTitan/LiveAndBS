//
//  TQJSingleTonInstance.h
//  01-掌握-GCD单例模式
//
//  Created by 果子 on 16-3-20.
//  Copyright (c) 2016年 田全军. All rights reserved.
//

#define TQJSingleTonInstanceH  +(instancetype)sharedInstance;

#define TQJSingleTonInstanceM  static id _instance;\
+(instancetype)allocWithZone:(struct _NSZone *)zone\
{\
    @synchronized(self){\
        if (!_instance) {\
            _instance = [super allocWithZone:zone];\
        }\
    }\
    return _instance;\
}\
+(instancetype)sharedInstance\
{\
    @synchronized(self){\
        if (!_instance) {\
            _instance = [[self alloc]init];\
        }\
    }\
    return _instance;\
}\
-(id)copyWithZone:(NSZone *)zone\
{\
    return _instance;\
}
