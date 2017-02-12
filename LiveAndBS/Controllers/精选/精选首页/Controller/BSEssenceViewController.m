//
//  BSEssenceViewController.m
//  百思不得姐
//
//  Created by 田全军 on 16/9/22.
//  Copyright © 2016年 田全军. All rights reserved.
//

#import "BSEssenceViewController.h"
#import "BSSubRecommendController.h"
#import "BSTopicViewController.h"


@interface BSEssenceViewController ()<UIScrollViewDelegate>
/**高亮按钮*/
@property(nonatomic,weak)UIButton *selectButton;
/**  滑动条  */
@property(nonatomic,weak)UIView *indexView;
/**  scrollView  */
@property(nonatomic,weak)UIScrollView *containView;
/**  背景  */
@property(nonatomic,weak)UIView *titleView;

@end

@implementation BSEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //添加导航栏
    [self setUpNavigation];
    //添加子控制器
    [self addChildViewControllers];
    //创建头部按钮界面
    [self setUpView];
    //创建ScrollView
    [self setUpScrollView];
    
}
#pragma mark - 界面展示
//创建导航栏
-(void)setUpNavigation{
    //标题
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MainTitle"]];
    //左边按钮
    self.navigationItem.leftBarButtonItem = [FactoryCategoryClass itemWithImage:@"MainTagSubIcon" highImage:@"MainTagSubIconClick" target:self action:@selector(leftBarButtonItemClick:)];
    self.view.backgroundColor = BSGlobalBackg;
}
//创建基本界面
-(void)setUpView{
    // 标签栏整体
    UIView *titlesView = [[UIView alloc] init];
    titlesView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    titlesView.width = self.view.width;
    titlesView.height = 35;
    titlesView.y = 64;
    self.titleView = titlesView;
    [self.view addSubview:titlesView];
    

    NSArray *titles = @[@"全部", @"视频", @"声音", @"图片", @"段子"];
    CGFloat btnW = ScreenWidth / titles.count;
    for (NSInteger i = 0; i<titles.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        button.tag = i;
        button.frame = CGRectMake(btnW * i, 0, btnW, 30);
        [button setTitle:titles[i] forState:UIControlStateNormal];
        //        [button layoutIfNeeded]; // 强制布局(强制更新子控件的frame)
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:button];
        
        // 默认点击了第一个按钮
        if (i == 0) {
            button.enabled = NO;
            self.selectButton = button;
            
            // 让按钮内部的label根据文字内容来计算尺寸
            [button.titleLabel sizeToFit];
        }
    }
    // 底部的红色指示器
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.frame = CGRectMake(10, 33, btnW - 20, 2);
    indicatorView.backgroundColor = [UIColor redColor];
    indicatorView.height = 2;
    indicatorView.tag = -1;
    indicatorView.y = titlesView.height - indicatorView.height;
    self.indexView = indicatorView;
    [titlesView addSubview:indicatorView];
}
//创建scrollVIew
-(void)setUpScrollView{
    // 不要自动调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.frame = self.view.bounds;
    contentView.delegate = self;
    contentView.pagingEnabled = YES;
    [self.view insertSubview:contentView atIndex:0];
    contentView.contentSize = CGSizeMake(contentView.width * self.childViewControllers.count, 0);
    self.containView = contentView;

    // 添加第一个控制器的view
    [self scrollViewDidEndScrollingAnimation:contentView];
}
-(void)addChildViewControllers{
    
    BSTopicViewController *all = [[BSTopicViewController alloc]init];
    all.type = BSTopicTypeAll;
    [self addChildViewController:all];
    
    BSTopicViewController *video = [[BSTopicViewController alloc]init];
    video.type = BSTopicTypeVideo;
    [self addChildViewController:video];
    
    BSTopicViewController *voice = [[BSTopicViewController alloc]init];
    voice.type = BSTopicTypeVoice;
    [self addChildViewController:voice];
    
    BSTopicViewController *picture = [[BSTopicViewController alloc]init];
    picture.type = BSTopicTypePicture;
    [self addChildViewController:picture];
    
    BSTopicViewController *world =[[BSTopicViewController alloc] init];
    world.type = BSTopicTypeWord;
    [self addChildViewController:world];
}
#pragma mark - 按钮点击事件
-(void)leftBarButtonItemClick:(id)sender{
    BSSubRecommendController *sub = [[BSSubRecommendController alloc]init];
    [self.navigationController pushViewController:sub animated:YES];
}
/**
 *  @param button 导航栏按钮
 */
- (void)titleClick:(UIButton *)button
{
    // 修改按钮状态
    self.selectButton.enabled = YES;
    button.enabled = NO;
    self.selectButton = button;
    
    // 动画
    [UIView animateWithDuration:0.25 animations:^{
        self.indexView.center = CGPointMake(button.center.x, 33);
    }];
    
    // 滚动
    CGPoint offset = self.containView.contentOffset;
    offset.x = button.tag * self.containView.width;
    [self.containView setContentOffset:offset animated:YES];
}
#pragma mark - UIScrollView代理方法
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    //取出对应的索引
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    //取出对应的控制器
    UITableViewController *vc = self.childViewControllers[index];
    vc.view.x = scrollView.contentOffset.x;
    vc.view.y = 0; // 设置控制器view的y值为0(默认是20)
    vc.view.height = scrollView.height; // 设置控制器view的height值为整个屏幕的高度(默认是比屏幕高度少个20)
    // 设置内边距
    CGFloat bottom = self.tabBarController.tabBar.height;
    CGFloat top = CGRectGetMaxY(self.titleView.frame);
    vc.tableView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    
    // 设置滚动条的内边距
    vc.tableView.scrollIndicatorInsets = vc.tableView.contentInset;
    [scrollView addSubview:vc.view];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    // 点击按钮
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    [self titleClick:self.titleView.subviews[index]];
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
