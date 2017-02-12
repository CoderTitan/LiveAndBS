//
//  BSMeFooterView.m
//  百思不得姐
//
//  Created by 田全军 on 16/12/26.
//  Copyright © 2016年 田全军. All rights reserved.
//

#import "BSMeFooterView.h"
#import "BSSquareButton.h"
#import "BSSquare.h"
#import "WebViewController.h"

#import <AFNetworking.h>
#import <MJExtension.h>

@implementation BSMeFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        // 参数
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"a"] = @"square";
        params[@"c"] = @"topic";
        
        // 发送请求
        [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
            NSArray *sqaures = [BSSquare mj_objectArrayWithKeyValuesArray:responseObject[@"square_list"]];
            NSMutableArray *array = [NSMutableArray arrayWithObject:[[sqaures firstObject] name]];
            NSMutableArray *sqauresArray = [NSMutableArray arrayWithObject:[sqaures firstObject]];
            for (BSSquare *model in sqaures) {
                if (![array containsObject:model.name]) {
                    [array addObject:model.name];
                    [sqauresArray addObject:model];
                }
            }
            
            // 创建方块
            [self createSquares:sqauresArray];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
    return self;
}

/**
 * 创建方块
 */
- (void)createSquares:(NSArray *)sqaures
{
    // 一行最多4列
    int maxCols = 4;
    
    // 宽度和高度
    CGFloat buttonW = ScreenWidth / maxCols;
    CGFloat buttonH = buttonW;
    
    for (int i = 0; i<sqaures.count; i++) {
        // 创建按钮
        BSSquareButton *button = [BSSquareButton buttonWithType:UIButtonTypeCustom];
        // 监听点击
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        // 传递模型
        button.square = sqaures[i];
        [self addSubview:button];
        
        // 计算frame
        int col = i % maxCols;
        int row = i / maxCols;
        
        button.x = col * buttonW;
        button.y = row * buttonH;
        button.width = buttonW;
        button.height = buttonH;
    }
    
    // 8个方块, 每行显示4个, 计算行数 8/4 == 2 2
    // 9个方块, 每行显示4个, 计算行数 9/4 == 2 3
    // 7个方块, 每行显示4个, 计算行数 7/4 == 1 2
    
    // 总行数
    //    NSUInteger rows = sqaures.count / maxCols;
    //    if (sqaures.count % maxCols) { // 不能整除, + 1
    //        rows++;
    //    }
    
    // 总页数 == (总个数 + 每页的最大数 - 1) / 每页最大数
    
    NSUInteger rows = (sqaures.count + maxCols - 1) / maxCols;
    
    // 计算footer的高度
    self.height = rows * buttonH;
    
    // 重绘
    [self setNeedsDisplay];
}

- (void)buttonClick:(BSSquareButton *)button
{
    if (![button.square.url hasPrefix:@"http"]) return;
    
    WebViewController *web = [[WebViewController alloc] init];
    web.url = button.square.url;
    web.title = button.square.name;

    // 取出当前的导航控制器
    UITabBarController *tabBarVc = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = (UINavigationController *)tabBarVc.selectedViewController;
    [nav pushViewController:web animated:YES];
}

// 设置背景图片
//- (void)drawRect:(CGRect)rect
//{
//    [[UIImage imageNamed:@"mainCellBackground"] drawInRect:rect];
//}

@end
