//
//  BSLiveViewController.m
//  百思不得姐
//
//  Created by 田全军 on 17/1/29.
//  Copyright © 2017年 田全军. All rights reserved.
//

#import "BSLiveViewController.h"
#import "BSLiveItem.h"
#import "BSCreatorItem.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import <UIImageView+WebCache.h>

#define IMAGE_HOST @"http://img.meelive.cn/"

@interface BSLiveViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/**  直播播放器  */
@property(nonatomic,strong)IJKFFMoviePlayerController *player;

@end

@implementation BSLiveViewController
- (IBAction)backClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置占位图片
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.live.creator.portrait]];
    [self.imageView sd_setImageWithURL:url placeholderImage:nil];
    
    //拉留地址
    NSURL *liveUrl = [NSURL URLWithString:self.live.stream_addr];
    // 创建IJKFFMoviePlayerController：专门用来直播，传入拉流地址就好了
    IJKFFMoviePlayerController *player = [[IJKFFMoviePlayerController alloc]initWithContentURL:liveUrl withOptions:nil];
    //准备播放
    [player prepareToPlay];
    // 强引用，反正被销毁
    _player = player;
    
    //设置尺寸
    player.view.frame = [UIScreen mainScreen].bounds;
    [self.view insertSubview:player.view atIndex:1];
    
    
    //创建毛玻璃效果
//    [self initBlurImage];
    
    

}
-(void)initBlurImage{
    //添加图片
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.imageView = imageView;
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", self.live.creator.portrait]] placeholderImage:[UIImage imageNamed:@"default_room"]];
    
    [self.view addSubview:imageView];
    
    //  创建需要的毛玻璃特效类型
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    //  毛玻璃view 视图
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    //添加到要有毛玻璃特效的控件中
    effectView.frame = self.view.bounds;
    [imageView addSubview:effectView];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // 界面消失，一定要记得停止播放
    [_player pause];
    [_player stop];
    [_player shutdown];
}

@end
