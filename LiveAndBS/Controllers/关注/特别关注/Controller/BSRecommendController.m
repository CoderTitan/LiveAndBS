//
//  BSRecommendController.m
//  百思不得姐
//
//  Created by 田全军 on 16/9/25.
//  Copyright © 2016年 田全军. All rights reserved.
//

#import "BSRecommendController.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import <MJRefresh.h>
#import <SVProgressHUD.h>
#import "BSRecommendCategaryModel.h"
#import "RecomCategaryViewCell.h"
#import "BSTransionRightModel.h"
#import "BSTransionRightCell.h"
#import "HeaderDefine.h"

@interface BSRecommendController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableview;

/** 请求参数 */
@property (nonatomic, strong) NSMutableDictionary *params;

/** AFN请求管理者 */
@property (nonatomic, strong) AFHTTPSessionManager *manager;
/**左边类别数据*/
@property(nonatomic,strong)NSArray *categorys;


@end

@implementation BSRecommendController
static NSString * const BSLeftCell = @"left";
static NSString * const BSRightCell = @"right";



-(AFHTTPSessionManager *)manager{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];

    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //界面加载
    [self setUpViewUI];
    // 添加刷新控件
    [self setupRefresh];
    //数据请求
    [self requestWithLeftData];
    
}
/**
 *  界面展示
 */
-(void)setUpViewUI{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"推荐关注";
    self.view.backgroundColor = BSGlobalBackg;

    [_leftTableView registerNib:[UINib nibWithNibName:NSStringFromClass([RecomCategaryViewCell class]) bundle:nil] forCellReuseIdentifier:BSLeftCell];
    [_rightTableview registerNib:[UINib nibWithNibName:NSStringFromClass([BSTransionRightCell class]) bundle:nil] forCellReuseIdentifier:BSRightCell];
    self.leftTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.rightTableview.contentInset = self.leftTableView.contentInset;
    self.rightTableview.rowHeight = 70;

}
//刷新控件
-(void)setupRefresh{
    self.rightTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    self.rightTableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerWithRefresh)];
    
}
#pragma mark - 数据请求
/**
 *  数据请求
 */
-(void)requestWithLeftData{
    // 显示指示器
    [SVProgressHUD show];
    
    // 发送请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"category";
    params[@"c"] = @"subscribe";
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        // 隐藏指示器
        [SVProgressHUD dismiss];
        // 服务器返回的JSON数据
        self.categorys = [BSRecommendCategaryModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 刷新表格
        [self.leftTableView reloadData];
        
        // 默认选中首行
        [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        
        // 让用户表格进入下拉刷新状态
        [self.rightTableview.mj_header beginRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        // 显示失败信息
        [SVProgressHUD showErrorWithStatus:@"加载推荐信息失败!"];
    }];
}

//下拉刷新
- (void)headerRefresh{
    
    BSRecommendCategaryModel *rc = SelectedCategory;
    
    // 设置当前页码为1
    rc.currentPage = 1;
    
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    params[@"category_id"] = @(rc.ID);
    params[@"page"] = @(rc.currentPage);
    self.params = params;
    
    // 发送请求给服务器, 加载右侧的数据
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params  progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        // 字典数组 -> 模型数组
        NSArray *users = [BSTransionRightModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 清除所有旧数据
        [rc.users removeAllObjects];
        
        // 添加到当前类别对应的用户数组中
        [rc.users addObjectsFromArray:users];
        
        // 保存总数
        rc.total = [responseObject[@"total"] integerValue];
        
        // 不是最后一次请求
        if (self.params != params) return;
        
        // 刷新右边的表格
        [self.rightTableview reloadData];
        
        // 结束刷新
        [self.rightTableview.mj_header endRefreshing];
        
        // 让底部控件结束刷新
        [self checkFooterState];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (self.params != params) return;
        
        // 提醒
        [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
        
        // 结束刷新
        [self.rightTableview.mj_header endRefreshing];
    }];
}
//上拉加载
-(void)footerWithRefresh{
    BSRecommendCategaryModel *category = SelectedCategory;

    // 发送请求给服务器, 加载右侧的数据
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    params[@"category_id"] = @(category.ID);
    params[@"page"] = @(++category.currentPage);
    self.params = params;
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params  progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        // 字典数组 -> 模型数组
        NSArray *users = [BSTransionRightModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 添加到当前类别对应的用户数组中
        [category.users addObjectsFromArray:users];
        
        // 不是最后一次请求
        if (self.params != params) return;
        
        // 刷新右边的表格
        [self.rightTableview reloadData];
        
        // 让底部控件结束刷新
        [self checkFooterState];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (self.params != params) return;
        
        // 提醒
        [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
        
        // 让底部控件结束刷新
        [self.rightTableview.mj_footer endRefreshing];
    }];
}
/**
 * 时刻监测footer的状态
 */
- (void)checkFooterState
{
    BSRecommendCategaryModel *cateModel = SelectedCategory;
    
    // 每次刷新右边数据时, 都控制footer显示或者隐藏
    self.rightTableview.mj_footer.hidden = (cateModel.users.count == 0);
    
    // 让底部控件结束刷新
    if (cateModel.users.count == cateModel.total) { // 全部数据已经加载完毕
        [self.rightTableview.mj_footer endRefreshingWithNoMoreData];
    } else { // 还没有加载完毕
        [self.rightTableview.mj_footer endRefreshing];
    }
}
#pragma mark - UITableViewDataSource
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.leftTableView) {
        return [self.categorys count];
    }
    return [SelectedCategory users].count;
}
//cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.leftTableView) {
        RecomCategaryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BSLeftCell];
        cell.model = self.categorys[indexPath.row];
        return cell;
    }
    BSTransionRightCell *rightCell = [tableView dequeueReusableCellWithIdentifier:BSRightCell];
    rightCell.model = [SelectedCategory users][indexPath.row];
    return rightCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 结束刷新
    [self.rightTableview.mj_header endRefreshing];
    [self.rightTableview.mj_footer endRefreshing];
    
    BSRecommendCategaryModel *c = self.categorys[indexPath.row];
    if (c.users.count) {
        // 显示曾经的数据
        [self.rightTableview reloadData];
    } else {
        // 赶紧刷新表格,目的是: 马上显示当前category的用户数据, 不让用户看见上一个category的残留数据
        [self.rightTableview reloadData];
        
        // 进入下拉刷新状态
        [self.rightTableview.mj_header beginRefreshing];
    }
}
#pragma mark - 控制器的销毁
- (void)dealloc
{
    // 停止所有操作
    [self.manager.operationQueue cancelAllOperations];
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
