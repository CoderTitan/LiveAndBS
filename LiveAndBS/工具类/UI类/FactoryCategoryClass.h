//
//  FactoryCategoryClass.h
//  FactoryCategory
//
//  Created by xiao_yu on 16/3/3.
//  Copyright © 2016年 xiao_yu. All rights reserved.
//

#import <Foundation/Foundation.h>
//UI
#import <UIKit/UIKit.h>


@interface FactoryCategoryClass : NSObject
//UIButton按钮
+(UIButton *)buttonWithFrame:(CGRect)rect andTitle:(NSString *)title andImageName:(NSString *)imageName andTitleColor:(UIColor *)color andTarget:(id)target andAction:(SEL)selector andTag:(long)tag ;

//UILable
+(UILabel *)lableWithFrame:(CGRect)rect andBackGroundColor:(UIColor *)color1 andText:(NSString *)text andTextColor:(UIColor *)color2 andFont:(UIFont *)floatFont andTag:(long)tag ;

//UITextField
//frame  font,textColor,placeholder,secureTextEntry
+(UITextField *)textFieldWithFrame:(CGRect)rect andPlaceholder:(NSString *)placeholder andSecureTextEntry:(BOOL)bool1 andTextColor:(UIColor *)color1 andBackGroundColor:(UIColor *)color2 andFont:(UIFont *)font andTag:(long)tag;
//UITextView
+(UITextView *)textViewWihFrame:(CGRect)rect andBackGroundColor:(UIColor *)color1 andTextColor:(UIColor *)color2 andFont:(UIFont *)font andScrollEnabled:(BOOL)bool1 andShowsVerticalScrollIndicator:(BOOL)bool2;
//UIBarButton
+ (UIBarButtonItem *)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;
@end
