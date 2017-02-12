//
//  BSPlaceholderTextView.h
//  百思不得姐
//
//  Created by 田全军 on 16/12/27.
//  Copyright © 2016年 田全军. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSPlaceholderTextView : UITextView
/**  占位文字yanse  */
@property(nonatomic,strong)UIColor *placeholderColor;
/**  占位文字  */
@property(nonatomic,copy)NSString *placeholder;

@end
