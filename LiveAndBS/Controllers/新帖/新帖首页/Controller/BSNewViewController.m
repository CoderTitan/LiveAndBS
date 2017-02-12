//
//  BSNewViewController.m
//  百思不得姐
//
//  Created by 田全军 on 16/9/22.
//  Copyright © 2016年 田全军. All rights reserved.
//

#import "BSNewViewController.h"
#import "BSLiveItem.h"
#import "BSLiveTableViewCell.h"
#import "BSLiveViewController.h"
#import <SVProgressHUD.h>
#import <MJExtension.h>
#import <AFNetworking.h>
#import <MJRefresh.h>
static NSString * const ID = @"cell";

@interface BSNewViewController ()

/** 直播 */
@property(nonatomic, strong) NSMutableArray *livesArray;

@end

@implementation BSNewViewController

/***/
-(NSMutableArray *)livesArray{
    if (!_livesArray) {
        _livesArray = [NSMutableArray array];
    }
    return _livesArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];

//    //标题
    self.navigationItem.title = @"直播列表";

    // 加载数据
    [self loadData];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BSLiveTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    

}

#pragma mark - 加载数据
-(void)loadData{
    // 映客数据url
    NSString *urlStr = @"http://116.211.167.106/api/live/aggregation?uid=133825214&interest=1";
    
    // 请求数据
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", nil];
    [mgr GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        _livesArray = [BSLiveItem mj_objectArrayWithKeyValuesArray:responseObject[@"lives"]];
        
        [self.tableView reloadData];
        //结束下拉刷新
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        [self.tableView.mj_header endRefreshing];
        [SVProgressHUD showWithStatus:@"数据加载失败"];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _livesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BSLiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.live = _livesArray[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BSLiveViewController *liveVc = [[BSLiveViewController alloc] init];
    liveVc.live = _livesArray[indexPath.row];
    
    [self presentViewController:liveVc animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 430;
}




@end
