//
//  BSUserModel.h
//  百思不得姐
//
//  Created by 田全军 on 16/11/23.
//  Copyright © 2016年 田全军. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSUserModel : NSObject
/** 用户名 */
@property (nonatomic, copy) NSString *username;
/** 性别 */
@property (nonatomic, copy) NSString *sex;
/** 头像 */
@property (nonatomic, copy) NSString *profile_image;
@end
