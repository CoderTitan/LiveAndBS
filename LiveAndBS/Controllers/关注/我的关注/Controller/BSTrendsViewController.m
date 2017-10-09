//
//  BSTrendsViewController.m
//  百思不得姐
//
//  Created by 田全军 on 16/9/25.
//  Copyright © 2016年 田全军. All rights reserved.
//

#import "BSTrendsViewController.h"
#import "BSRecommendController.h"
#import "LoginRegisterViewController.h"
@interface BSTrendsViewController ()

@end

@implementation BSTrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"我的关注";
    self.navigationItem.leftBarButtonItem = [FactoryCategoryClass itemWithImage:@"friendsRecommentIcon" highImage:@"friendsRecommentIcon-click" target:self action:@selector(leftItemClick)];
    self.view.backgroundColor = BSGlobalBackg;
    
    
}
#pragma mark - 按钮点击事件
-(void)leftItemClick{
    BSRecommendController *recommend = [[BSRecommendController alloc]init];
    [self.navigationController pushViewController:recommend animated:YES];
    
}
//立即登录注册按钮
- (IBAction)loginAndresgineButtonClick:(id)sender {
    LoginRegisterViewController *login = [[LoginRegisterViewController alloc]init];
    [self presentViewController:login animated:YES completion:nil];
}


@end
