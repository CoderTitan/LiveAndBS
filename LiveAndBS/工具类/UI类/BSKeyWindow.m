//
//  BSKeyWindow.m
//  百思不得姐
//
//  Created by 田全军 on 16/12/3.
//  Copyright © 2016年 田全军. All rights reserved.
//

#import "BSKeyWindow.h"

@implementation BSKeyWindow

static UIWindow *window_;

//初始化的时候只会创建一次
+(void)initialize{
    window_ = [[UIWindow alloc]init];
    window_.frame = CGRectMake(0, 0, ScreenWidth, 20);
    window_.backgroundColor = [UIColor yellowColor];
    /*windowLevel层级关系属性
    *UIWindowLevelAlert,将view排在最前面
    *Normal < StatusBar < Alert
    */
    window_.windowLevel = UIWindowLevelAlert;
    [window_ addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(windowClick)]];
}

+(void)show{
    window_.hidden = NO;
}

///
+(void)hide{
    window_.hidden = YES;
}

/**
 * 监听窗口点击
 */
+(void)windowClick{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [self searchScrollViewInView:keyWindow];
}

+(void)searchScrollViewInView:(UIView *)superview{
    
    for (UIScrollView *subview in superview.subviews) {
        // 如果是scrollview, 滚动最顶部
        if ([subview isKindOfClass:[UIScrollView class]] && subview.isShowingOnKeyWindow) {
            CGPoint offset = subview.contentOffset;
            offset.y = - subview.contentInset.top;
            [subview setContentOffset:offset animated:YES];
        }
        
        // 继续查找子控件
        [self searchScrollViewInView:subview];
    }


}


@end
