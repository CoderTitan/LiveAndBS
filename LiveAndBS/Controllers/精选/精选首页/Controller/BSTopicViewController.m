//
//  BSTopicViewController.m
//  百思不得姐
//
//  Created by 田全军 on 16/10/25.
//  Copyright © 2016年 田全军. All rights reserved.
//

#import "BSTopicViewController.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import "BSCommentViewController.h"
#import "BSNewViewController.h"
#import "TopicTableCell.h"
#import "BSTopicModel.h"

@interface BSTopicViewController ()
/** 帖子数据 */
@property (nonatomic, strong) NSMutableArray *topics;
/** 当前页码 */
@property (nonatomic, assign) NSInteger page;
/** 当加载下一页数据时需要这个参数 */
@property (nonatomic, copy) NSString *maxtime;
/** 上一次的请求参数 */
@property (nonatomic, strong) NSDictionary *params;

/**  tabbar的点击次数  */
@property(nonatomic,assign)NSInteger lastSelectedIndex;


@end

@implementation BSTopicViewController

static NSString * const TopicCellId = @"topic";

- (NSMutableArray *)topics
{
    if (!_topics) {
        _topics = [NSMutableArray array];
    }
    return _topics;
}
-(NSString *)listStr{
    return [self.parentViewController isKindOfClass:[BSNewViewController class]] ? @"newlist" : @"list";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 初始化表格
    [self setupTableView];
    
    // 添加刷新控件
    [self setupRefresh];
    
    
    
}
-(void)setupTableView{
    self.tableView.contentInset = UIEdgeInsetsMake(99, 0, 49, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TopicTableCell class]) bundle:nil] forCellReuseIdentifier:TopicCellId];
    
    [BSNotific addObserver:self selector:@selector(notificationTabBarClick) name:BSTabBarDidSelectNotification object:nil];
}
#pragma mark - 通知的监听
-(void)notificationTabBarClick{
    // 如果是连续选中2次, 直接刷新
    if (self.tabBarController.selectedIndex == self.lastSelectedIndex &&
        //self.tabBarController.selectedViewController == self.navigationController &&
        self.view.isShowingOnKeyWindow) {
        [self.tableView.mj_header beginRefreshing];
    }
    // 记录这一次选中的索引
    self.lastSelectedIndex = self.tabBarController.selectedIndex;
}
-(void)setupRefresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshData)];
    //自动改变透明度
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshData)];
}
/**
 *  下拉刷新,加载新数据
 */
-(void)headerRefreshData{
    //结束上拉加载
    [self.tableView.mj_footer endRefreshing];
    
    //开始刷新新的数据
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [self listStr];
    params[@"c"] = @"data";
    params[@"type"] = @(self.type);
    self.params = params;
    //http://api.budejie.com/api/api_open.php?a=list&c=data&type=10
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (self.params != params) {
            return ;
        }
        //存储这一页的标识符maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        //字典转模型
        self.topics = [BSTopicModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        //刷新表格
        [self.tableView reloadData];
        //结束下拉刷新
        [self.tableView.mj_header endRefreshing];
        //清空页码
        self.page = 0;
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (self.params != params)   return ;
        //结束刷新
        [self.tableView.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"数据加载失败"];
    }];
    
}
//上拉加载更多的数据
-(void)footerRefreshData{
    //结束下拉刷新
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"data";
    params[@"type"] = @(self.type);
    NSInteger page = self.page + 1;
    params[@"page"] = @(page);
    params[@"maxtime"] = self.maxtime;
    self.params = params;
    
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (self.params != params) {
            return ;
        }
        // 存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        //加载数据
        NSArray *newTopics = [BSTopicModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.topics addObjectsFromArray:newTopics];
        //刷新表格
        [self.tableView reloadData];
        //结束刷新
        [self.tableView.mj_footer endRefreshing];
        //设置页码
        self.page = page;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (self.params != params) {
            return ;
        }
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    self.tableView.mj_footer.hidden = (self.topics.count == 0);
    return self.topics.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TopicTableCell *cell = [tableView dequeueReusableCellWithIdentifier:TopicCellId];
    cell.topicModel = self.topics[indexPath.row];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //取出模型
    BSTopicModel *topicModel = self.topics[indexPath.row];
    
    return topicModel.cellHeight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BSCommentViewController *comment = [[BSCommentViewController alloc]init];
    comment.topicModel = self.topics[indexPath.row];
    comment.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:comment animated:YES];
}
-(void)dealloc{
    [BSNotific removeObserver:self name:BSTabBarDidSelectNotification object:nil];
}
@end
