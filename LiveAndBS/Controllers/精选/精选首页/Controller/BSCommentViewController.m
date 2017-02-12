//
//  BSCommentViewController.m
//  百思不得姐
//
//  Created by 田全军 on 16/11/23.
//  Copyright © 2016年 田全军. All rights reserved.
//

#import "BSCommentViewController.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import <AFNetworking.h>
#import "BSTopicModel.h"
#import "BSCommentModel.h"
#import "BSUserModel.h"
#import "TopicTableCell.h"
#import "BSCommentViewCell.h"

@interface BSCommentViewController ()<UITableViewDelegate,UITableViewDataSource>
/** 工具条底部间距 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSapce;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** 最热评论 */
@property (nonatomic, strong) NSArray *hotComments;
/** 最新评论 */
@property (nonatomic, strong) NSMutableArray *latestComments;
/** 保存帖子的top_cmt */
@property (nonatomic, strong) BSCommentModel *saved_top_cmt;
/** 保存当前的页码 */
@property (nonatomic, assign) NSInteger page;

/** 管理者 */
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@end

@implementation BSCommentViewController
-(AFHTTPSessionManager *)manager{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
        
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupBasic];
    
    [self setupHeader];
    
    [self setupRefresh];
    
    
}
//刷新
- (void)setupRefresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewComments)];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComments)];
    self.tableView.mj_footer.hidden = YES;
}
- (void)loadMoreComments{
    // 结束之前的所有请求
//    [self.manager invalidateSessionCancelingTasks:YES];//取消session的请求,session将不再起作用,舍弃
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];//将tasks数组中的所有任务执行cancel
    
    // 页码
    NSInteger page = self.page + 1;
    
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topicModel.ID;
    params[@"page"] = @(page);
    BSCommentModel *cmt = [self.latestComments lastObject];
    params[@"lastcid"] = cmt.ID;

    //http://api.budejie.com/api/api_open.php?a=dataList&c=comment&data_id=22453103&page=5&lastcid=70163573
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        // 没有数据
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            self.tableView.mj_footer.hidden = YES;
            return;
        }
        // 最新评论
        NSArray *newComments = [BSCommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.latestComments addObjectsFromArray:newComments];
        
        //页码
        self.page = page;
        
        // 刷新数据
        [self.tableView reloadData];
        
        // 控制footer的状态
        NSInteger total = [responseObject[@"total"] integerValue];
        if (self.latestComments.count >= total) {// 全部加载完毕
            //方式一:提示没有更多的数据
            //            [self.tableview.mj_footer noticeNoMoreData];
            //方式二:直接隐藏footer
            self.tableView.mj_footer.hidden = YES;
        } else {
            // 结束刷新状态
            [self.tableView.mj_footer endRefreshing];

        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.mj_footer endRefreshing];
    }];

    
}
- (void)loadNewComments
{
    // 结束之前的所有请求
    //    [self.manager invalidateSessionCancelingTasks:YES];//取消session的请求,session将不再起作用,舍弃
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];//将tasks数组中的所有任务执行cancel
    
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topicModel.ID;
    params[@"hot"] = @"1";
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        // 没有数据
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            [self.tableView.mj_header endRefreshing];
            return;
        }
        // 最热评论
        self.hotComments = [BSCommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        // 最新评论
        self.latestComments = [BSCommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        // 页码
        self.page = 1;
        
        // 刷新数据
        [self.tableView reloadData];
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        
        // 控制footer的状态
        NSInteger total = [responseObject[@"total"] integerValue];
        if (self.latestComments.count >= total) {// 全部加载完毕
            //方式一:提示没有更多的数据
//            [self.tableview.mj_footer noticeNoMoreData];
            //方式二:直接隐藏footer
            self.tableView.mj_footer.hidden = YES;
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];

}

- (void)setupHeader
{
    // 创建header
    UIView *header = [[UIView alloc] init];
    
    // 清空top_cmt
    if (self.topicModel.top_cmt) {
        self.saved_top_cmt = self.topicModel.top_cmt;
        self.topicModel.top_cmt = nil;
        [self.topicModel setValue:@0 forKeyPath:@"cellHeight"];
    }
    TopicTableCell *cell = [TopicTableCell viewFromXib];
    cell.cellLeftMargin = -BSTopicCellMargin;
    cell.topicModel = self.topicModel;
    cell.frame = CGRectMake(0, -10, ScreenWidth  + 2 * BSTopicCellMargin, self.topicModel.cellHeight);    [header addSubview:cell];
    //设置头视图的高度
    header.height = self.topicModel.cellHeight ;
    self.tableView.tableHeaderView = header;
}
- (void)setupBasic
{
    self.title = @"评论";
    self.navigationItem.rightBarButtonItem = [FactoryCategoryClass itemWithImage:@"comment_nav_item_share_icon_click" highImage:nil target:nil action:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //shezhitableView的高度自适应(自动计算)
    //先设置默认高度
    _tableView.estimatedRowHeight = 44;
    //自动计算高度
    _tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.backgroundColor = BSGlobalBackg;
    
    [_tableView registerNib:[UINib nibWithNibName:kBSCommentViewCell bundle:nil] forCellReuseIdentifier:kBSCommentViewCell];
    
    //去掉分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //设置内边距
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, BSTopicCellMargin, 0);
}
#pragma mark - 数组返回的数据
/**
 * 返回第section组的所有评论数组
 */
- (NSArray *)commentsInSection:(NSInteger)section{
    if (section == 0) {
        return self.hotComments.count ? self.hotComments : self.latestComments;
    }
    return self.latestComments;
}
-(BSCommentModel *)commentsInIndexPath:(NSIndexPath *)indexPath{
    return [self commentsInSection:indexPath.section][indexPath.row];
}
#pragma mark - UITableViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (menu.isMenuVisible) {
        [menu setMenuVisible:NO animated:YES];
    } else {
        // 被点击的cell
        BSCommentViewCell *cell = (BSCommentViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        // 出现一个第一响应者
        [cell becomeFirstResponder];
        
        // 显示MenuController
        UIMenuItem *ding = [[UIMenuItem alloc] initWithTitle:@"顶" action:@selector(ding:)];
        UIMenuItem *replay = [[UIMenuItem alloc] initWithTitle:@"回复" action:@selector(replay:)];
        UIMenuItem *report = [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(report:)];
        menu.menuItems = @[ding, replay, report];
        CGRect rect = CGRectMake(0, cell.height * 0.5, cell.width, cell.height * 0.5);
        [menu setTargetRect:rect inView:cell];
        [menu setMenuVisible:YES animated:YES];
    }
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger hotCount = self.hotComments.count;
    NSInteger latestCount = self.latestComments.count;
    
    if (hotCount) return 2; // 有"最热评论" + "最新评论" 2组
    if (latestCount) return 1; // 有"最新评论" 1 组
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger hotCount = self.hotComments.count;
    NSInteger latestCount = self.latestComments.count;
    
    // 隐藏尾部控件
    self.tableView.mj_footer.hidden = (latestCount == 0);
    
    if (section == 0) {
        return hotCount ? hotCount : latestCount;
    }
    return latestCount;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BSCommentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBSCommentViewCell forIndexPath:indexPath];
    BSCommentModel *comment = [self commentsInIndexPath:indexPath];
    cell.comment = comment;
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth - 10,30)];
    titleLable.backgroundColor = [UIColor whiteColor];
    if (section == 0) {
        titleLable.text = self.hotComments.count ? @"最热评论" : @"最新评论";
    }else{
        titleLable.text = @"最新评论";
    }
    [view addSubview:titleLable];
    return view;
}
#pragma mark - 通知监听方法
-(void)keyboardWillChangeFrame:(NSNotification *)noti{
    // 键盘显示\隐藏完毕的frame
    CGRect keyRect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 修改底部约束
    self.bottomSapce.constant = ScreenHeight - keyRect.origin.y;
    //动画时间
    CGFloat duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //动画 及时刷新
    [UIView animateWithDuration:duration animations:^{
        //强制重新布局
        [self.view layoutIfNeeded];
    }];
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 恢复帖子的top_cmt
    if (self.saved_top_cmt) {
        self.topicModel.top_cmt = self.saved_top_cmt;
        [self.topicModel setValue:@0 forKey:@"cellHeight"];
    }
    
    // 取消所有任务
    //    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    [self.manager invalidateSessionCancelingTasks:YES];

}
#pragma mark - MenuItem处理
    - (void)ding:(UIMenuController *)menu
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSLog(@"%s %@", __func__, [self commentsInIndexPath:indexPath].content);
    }
    
    - (void)replay:(UIMenuController *)menu
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSLog(@"%s %@", __func__, [self commentsInIndexPath:indexPath].content);
    }
    
    - (void)report:(UIMenuController *)menu
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSLog(@"%s %@", __func__, [self commentsInIndexPath:indexPath].content);
    }

@end
