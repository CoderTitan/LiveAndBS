//
//  BSSubRecommendController.m
//  百思不得姐
//
//  Created by 田全军 on 16/10/15.
//  Copyright © 2016年 田全军. All rights reserved.
//

#import "BSSubRecommendController.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import "BSRecommendModel.h"
#import "BSRecommendViewCell.h"

@interface BSSubRecommendController ()
/**  表格数组  */
@property(nonatomic,strong) NSArray *dataArray;

@end


@implementation BSSubRecommendController
static NSString * const TagsId = @"tagID";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建表格和界面布局
    [self setUITableView];
    //加载数据
    [self creatData];
}
-(void)setUITableView{
    self.title = @"推荐订阅";
    self.tableView.backgroundColor = BSGlobalBackg;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BSRecommendViewCell class]) bundle:nil] forCellReuseIdentifier:TagsId];
    self.tableView.rowHeight = 70;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
-(void)creatData{
    [SVProgressHUD show];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"tag_recommend";
    params[@"action"] = @"sub";
    params[@"c"] = @"topic";
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        self.dataArray = [BSRecommendModel mj_objectArrayWithKeyValuesArray:responseObject];
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"数据加载失败"];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BSRecommendViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TagsId];
    cell.recommendModel = self.dataArray[indexPath.row];
    
    return cell;
}

@end
