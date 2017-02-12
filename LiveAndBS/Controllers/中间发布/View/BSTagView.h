//
//  BSTagView.h
//  百思不得姐
//
//  Created by 田全军 on 16/12/29.
//  Copyright © 2016年 田全军. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSTagView : UIView
/**  按钮文字  */
@property(nonatomic,copy)NSString *title;
/**  删除按钮  */
@property(nonatomic,strong)UIButton *deleteButton;


@end
