//
//  LoginRegisterViewController.m
//  百思不得姐
//
//  Created by 田全军 on 16/10/17.
//  Copyright © 2016年 田全军. All rights reserved.
//

#import "LoginRegisterViewController.h"

@interface LoginRegisterViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginOrRegisterButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginBackLeading;


@end

@implementation LoginRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

//调节状态栏颜色为白色
-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}
#pragma mark - 按钮点击事件
- (IBAction)loginOrRegisterButtonClick:(id)sender {
    if (self.loginBackLeading.constant == 0) {
        _loginBackLeading.constant = -self.view.width;
        [_loginOrRegisterButton setTitle:@"已有账号?" forState:UIControlStateNormal];
    }else{
        _loginBackLeading.constant = 0;
        [_loginOrRegisterButton setTitle:@"注册账号" forState:UIControlStateNormal];
    }
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
    
}
- (IBAction)cancleButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 三方登录按钮点击事件
- (IBAction)QQLoginClick:(id)sender {
    
}
- (IBAction)weiboLoginClick:(id)sender {
    
}
- (IBAction)tengxunLoginClick:(id)sender {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
