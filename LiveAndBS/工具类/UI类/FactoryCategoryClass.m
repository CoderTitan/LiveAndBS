//
//  FactoryCategoryClass.m
//  FactoryCategory
//
//  Created by xiao_yu on 16/3/3.
//  Copyright © 2016年 xiao_yu. All rights reserved.
//

#import "FactoryCategoryClass.h"

@implementation FactoryCategoryClass
//UIButton方法实现
+(UIButton *)buttonWithFrame:(CGRect)rect andTitle:(NSString *)title andImageName:(NSString *)imageName andTitleColor:(UIColor *)color andTarget:(id)target andAction:(SEL)selector andTag:(long)tag {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    button.layer.cornerRadius = 0;
    button.tag = tag;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    [button setImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:1] forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}
//UILable方法实现
+(UILabel *)lableWithFrame:(CGRect)rect andBackGroundColor:(UIColor *)color1 andText:(NSString *)text andTextColor:(UIColor *)color2 andFont:(UIFont *)floatFont andTag:(long)tag {
    UILabel *lable = [[UILabel alloc]init];
    lable.frame = rect;
    lable.backgroundColor = color1;
    lable.text = text;
    lable.textColor = color2;
    lable.font = floatFont;
    lable.tag = tag;
    return lable;
}
//UITextField方法实现
+(UITextField *)textFieldWithFrame:(CGRect)rect andPlaceholder:(NSString *)placeholder andSecureTextEntry:(BOOL)bool1 andTextColor:(UIColor *)color1 andBackGroundColor:(UIColor *)color2 andFont:(UIFont *)font andTag:(long)tag{
    UITextField *textField = [[UITextField alloc]init];
    textField.frame = rect;
    textField.backgroundColor = color2;
    textField.placeholder = placeholder;
    textField.secureTextEntry = bool1;
    textField.textColor = color1;
    textField.font = font;
    textField.tag = tag;
    return textField;
}
//UITextView
+(UITextView *)textViewWihFrame:(CGRect)rect andBackGroundColor:(UIColor *)color1 andTextColor:(UIColor *)color2 andFont:(UIFont *)font andScrollEnabled:(BOOL)bool1 andShowsVerticalScrollIndicator:(BOOL)bool2{
    UITextView *textView = [[UITextView alloc]initWithFrame:rect];
    textView.backgroundColor = color1;
    textView.textColor = color2;
    textView.font = font;
    textView.scrollEnabled = bool1;
    textView.showsVerticalScrollIndicator = bool2;
    return textView;
}
//UIBarButton
+ (UIBarButtonItem *)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    button.size = button.currentBackgroundImage.size;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}
@end
