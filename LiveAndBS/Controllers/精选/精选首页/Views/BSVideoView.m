//
//  BSVideoView.m
//  百思不得姐
//
//  Created by 田全军 on 16/11/15.
//  Copyright © 2016年 田全军. All rights reserved.
//

#import "BSVideoView.h"
#import "BSTopicModel.h"
#import "UIImageView+WebCache.h"
#import "BSShowPictureController.h"

@interface BSVideoView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *videotimeLabel;

@end
@implementation BSVideoView

+(instancetype)videoView{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

-(void)awakeFromNib{
    [super awakeFromNib];

    self.autoresizingMask = UIViewAutoresizingNone;
    // 给图片添加监听器
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture)]];
}

- (void)showPicture
{
    BSShowPictureController *showPicture = [[BSShowPictureController alloc] init];
    showPicture.topicModel = self.topic;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:showPicture animated:YES completion:nil];

}
- (void)setTopic:(BSTopicModel *)topic
{
    _topic = topic;
    
    // 图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image]];
    
    // 播放次数
    self.playcountLabel.text = [NSString stringWithFormat:@"%zd播放", topic.playcount];
    
    // 时长
    NSInteger minute = topic.videotime / 60;
    NSInteger second = topic.videotime % 60;
    self.videotimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", minute, second];
}

@end
