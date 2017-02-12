

//
//  BaseTextFileld.m
//  百思不得姐
//
//  Created by 田全军 on 16/10/18.
//  Copyright © 2016年 田全军. All rights reserved.
//

#import "BaseTextFileld.h"

static NSString * const XMGPlacerholderColorKeyPath = @"_placeholderLabel.textColor";

@implementation BaseTextFileld

//-(void)setPlaceHolderColor:(UIColor *)placeHolderColor{
//    _placeHolderColor = placeHolderColor;
//    [self setValue:_placeHolderColor forKeyPath:XMGPlacerholderColorKeyPath];
//
//}

- (void)awakeFromNib
{
    // 设置光标颜色和文字颜色一致
    self.tintColor = self.textColor;
    
    // 不成为第一响应者
    [self resignFirstResponder];
    
    
    [super awakeFromNib];
}

/**
 * 当前文本框聚焦时就会调用
 */
- (BOOL)becomeFirstResponder
{
    // 修改占位文字颜色
    [self setValue:self.textColor forKeyPath:XMGPlacerholderColorKeyPath];
    return [super becomeFirstResponder];
}

/**
 * 当前文本框失去焦点时就会调用
 */
- (BOOL)resignFirstResponder
{
    // 修改占位文字颜色
    [self setValue:[UIColor grayColor] forKeyPath:XMGPlacerholderColorKeyPath];
    return [super resignFirstResponder];
}


@end
