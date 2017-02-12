//
//  ADPushGuideView.m
//  百思不得姐
//
//  Created by 田全军 on 16/10/19.
//  Copyright © 2016年 田全军. All rights reserved.
//

#import "ADPushGuideView.h"

@implementation ADPushGuideView
- (IBAction)cleaseButton:(id)sender {
    [self removeFromSuperview];
}

+ (instancetype)guideView{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

+ (void)show{
    NSString *key = @"CFBundleShortVersionString";
    
    // 获得当前软件的版本号
    NSString *nowVerson = [NSBundle mainBundle].infoDictionary[key];
    // 获得沙盒中存储的版本号
    NSString *boxVerson = [[NSUserDefaults standardUserDefaults]stringForKey:key];
    if (![nowVerson isEqualToString:boxVerson]) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        ADPushGuideView *guideView = [ADPushGuideView guideView];
        guideView.frame = window.bounds;
        [window addSubview:guideView];
        
        // 存储版本号
        [[NSUserDefaults standardUserDefaults]setObject:nowVerson forKey:key];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}


@end
