//
//  BSPublishViewController.m
//  百思不得姐
//
//  Created by 田全军 on 16/12/25.
//  Copyright © 2016年 田全军. All rights reserved.
//

#import "BSPublishViewController.h"
#import "BaseNavigationController.h"
#import "BSPostWordController.h"
#import "BaseButton.h"
#import <POP.h>


#define BSSpringFactor 10
#define BSAnimationDelay 0.1
@interface BSPublishViewController ()

@end

@implementation BSPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 让控制器的view不能被点击
    self.view.userInteractionEnabled = NO;
    
    // 数据
    NSArray *images = @[@"publish-video", @"publish-picture", @"publish-text", @"publish-audio", @"publish-review", @"publish-offline"];
    NSArray *titles = @[@"发视频", @"发图片", @"发段子", @"发声音", @"审帖", @"离线下载"];
    
    // 中间的6个按钮
    int maxCols = 3;
    CGFloat buttonW = 72;
    CGFloat buttonH = buttonW + 30;
    CGFloat buttonStartY = (ScreenHeight - 2 * buttonH) * 0.5;
    CGFloat buttonStartX = 20;
    CGFloat xMargin = (ScreenWidth - 2 * buttonStartX - maxCols * buttonW) / (maxCols - 1);
    for (int i = 0; i < images.count; i++) {
        BaseButton *button = [[BaseButton alloc] init];
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        // 设置内容
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        
        // 计算X\Y
        int row = i / maxCols;
        int col = i % maxCols;
        CGFloat buttonX = buttonStartX + col * (xMargin + buttonW);
        CGFloat buttonEndY = buttonStartY + row * buttonH;
        CGFloat buttonBeginY = buttonEndY - ScreenHeight;
        
        // 按钮动画
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        anim.fromValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonBeginY, buttonW, buttonH)];
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonEndY, buttonW, buttonH)];
        anim.springBounciness = BSSpringFactor;
        anim.springSpeed = BSSpringFactor;
        anim.beginTime = CACurrentMediaTime() + BSAnimationDelay * i;
        [button pop_addAnimation:anim forKey:nil];
    }
    // 添加标语
    UIImageView *sloganView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_slogan"]];
    [self.view addSubview:sloganView];
    
    // 标语动画
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    CGFloat centerX = ScreenWidth * 0.5;
    CGFloat centerEndY = ScreenHeight * 0.2;
    CGFloat centerBeginY = centerEndY - ScreenHeight;
    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerBeginY)];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerEndY)];
    anim.beginTime = CACurrentMediaTime() + images.count * BSAnimationDelay;
    anim.springBounciness = BSSpringFactor;
    anim.springSpeed = BSSpringFactor;
    [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        // 标语动画执行完毕, 恢复点击事件
        self.view.userInteractionEnabled = YES;
    }];
    [sloganView pop_addAnimation:anim forKey:nil];
    

    
}
#pragma mark - ButtonAction
- (IBAction)cancleButton:(id)sender {
    [self cancelWithCompletionBlock:nil];
}

- (void)buttonClick:(UIButton *)button
{
    [self cancelWithCompletionBlock:^{
        if (button.tag == 2) {
            BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:[[BSPostWordController alloc]init]];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
        } else if (button.tag == 1) {
            BSLog(@"发图片");
        }
    }];
}

/**
 * 先执行退出动画, 动画完毕后执行completionBlock
 */
- (void)cancelWithCompletionBlock:(void (^)())completionBlock
{
    // 不能被点击
    self.view.userInteractionEnabled = NO;
    
    int beginIndex = 2;
    
    for (int i = beginIndex; i<self.view.subviews.count; i++) {
        UIView *subview = self.view.subviews[i];
        
        // 基本动画
        POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        CGFloat centerY = subview.centerY + ScreenHeight;
        // 动画的执行节奏(一开始很慢, 后面很快)
        //        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        anim.toValue = [NSValue valueWithCGPoint:CGPointMake(subview.centerX, centerY)];
        anim.beginTime = CACurrentMediaTime() + (i - beginIndex) * BSAnimationDelay;
        [subview pop_addAnimation:anim forKey:nil];
        
        // 监听最后一个动画
        if (i == self.view.subviews.count - 1) {
            [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
                [self dismissViewControllerAnimated:NO completion:nil];
                
                // 执行传进来的completionBlock参数
                //                if (completionBlock) {
                //                    completionBlock();
                //                }
                !completionBlock ? : completionBlock();
            }];
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self cancelWithCompletionBlock:nil];
}


@end
