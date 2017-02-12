//
//  BSMineViewController.m
//  百思不得姐
//
//  Created by 田全军 on 17/1/1.
//  Copyright © 2017年 田全军. All rights reserved.
//

#import "BSMineViewController.h"
#import "BSMeFooterView.h"
#import "BSMeTableViewCell.h"

@interface BSMineViewController ()

@end

@implementation BSMineViewController


- (void)viewDidLoad
{

    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupTableView];
}

- (void)setupTableView
{
    // 设置背景色
    self.tableView.backgroundColor = BSGlobalBackg;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:NSClassFromString(kBSMeTableViewCell) forCellReuseIdentifier:kBSMeTableViewCell];
    
    // 调整header和footer
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = BSTopicCellMargin;
    
    // 调整inset
    self.tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - 49);
    
    // 设置footerView
    self.tableView.tableFooterView = [[BSMeFooterView alloc] init];
}

- (void)setupNav
{
    // 设置导航栏标题
    self.navigationItem.title = @"我的";
    
    // 设置导航栏右边的按钮
    UIBarButtonItem *settingItem = [FactoryCategoryClass itemWithImage:@"mine-setting-icon" highImage:@"mine-setting-icon-click" target:self action:@selector(settingClick)];
    UIBarButtonItem *moonItem = [FactoryCategoryClass itemWithImage:@"mine-moon-icon" highImage:@"mine-moon-icon-click" target:self action:@selector(moonClick)];
    self.navigationItem.rightBarButtonItems = @[settingItem, moonItem];
}

- (void)settingClick
{
    BSLogFunc;
}

- (void)moonClick
{
    BSLogFunc;
}
#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BSMeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBSMeTableViewCell];
    
    if (indexPath.section == 0) {
        cell.imageView.image = [UIImage imageNamed:@"mine_icon_nearby"];
        cell.textLabel.text = @"登录/注册";
    } else if (indexPath.section == 1) {
        cell.textLabel.text = @"离线下载";
    }
    
    return cell;
}

@end
