//
//  BSTabBar.m
//  百思不得姐
//
//  Created by 田全军 on 16/9/16.
//  Copyright © 2016年 田全军. All rights reserved.
//

#import "BSTabBar.h"
#import "BSPublishViewController.h"
#import "BSPublishView.h"

@interface BSTabBar()

/** 发布按钮 */
@property (nonatomic, weak) UIButton *publishButton;

@end

@implementation BSTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 设置tabbar的背景图片
        [self setBackgroundImage:[UIImage imageNamed:@"tabbar-light"]];
        
        UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        [publishButton addTarget:self action:@selector(publishClick) forControlEvents:UIControlEventTouchUpInside];
        publishButton.size = publishButton.currentBackgroundImage.size;
        [self addSubview:publishButton];
        self.publishButton = publishButton;
    }
    return self;
}
#pragma mark - ButtonAction
- (void)publishClick
{
    BSPublishViewController *publish = [[BSPublishViewController alloc] init];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:publish animated:NO completion:nil];

//    BSPublishView *publish = [BSPublishView publishView];
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    publish.frame = window.bounds;
//    [window addSubview:publish];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = self.width;
    CGFloat height = self.height;
    
    
    // 设置发布按钮的frame
    self.publishButton.width = self.publishButton.currentBackgroundImage.size.width;
    self.publishButton.height = self.publishButton.currentBackgroundImage.size.height;
    self.publishButton.center = CGPointMake(width * 0.5, height * 0.5);
    
    // 设置其他UITabBarButton的frame
    CGFloat buttonY = 0;
    CGFloat buttonW = width / 5;
    CGFloat buttonH = height;
    NSInteger index = 0;
    for (UIView *button in self.subviews) {
        //        if (![button isKindOfClass:NSClassFromString(@"UITabBarButton")]) continue;
        if (![button isKindOfClass:[UIControl class]] || button == self.publishButton) continue;
        
        // 计算按钮的x值
        CGFloat buttonX = buttonW * ((index > 1)?(index + 1):index);
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        // 增加索引
        index++;
    }
}


@end
