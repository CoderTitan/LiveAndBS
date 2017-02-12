//
//  BSTagTextField.h
//  百思不得姐
//
//  Created by 田全军 on 16/12/30.
//  Copyright © 2016年 田全军. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSTagTextField : UITextField
/** 按了删除键后的回调 */
@property (nonatomic, copy) void (^deleteBlock)();

@end
