//
//  BSPictureView.m
//  百思不得姐
//
//  Created by 田全军 on 16/10/25.
//  Copyright © 2016年 田全军. All rights reserved.
//

#import "BSPictureView.h"
#import "BSTopicModel.h"
#import "UIImageView+WebCache.h"
#import "BSShowPictureView.h"
#import "BSShowPictureController.h"
@interface BSPictureView ()
/** 图片 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/** gif标识 */
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
/** 查看大图按钮 */
@property (weak, nonatomic) IBOutlet UIButton *seeBigButton;
/** 进度条控件 */
@property (weak, nonatomic) IBOutlet BSShowPictureView *progressView;

@end
@implementation BSPictureView


-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.autoresizingMask = UIViewAutoresizingNone;
    // 给图片添加监听器
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture)]];
}

-(void)showPicture{
    BSShowPictureController *showPicture = [[BSShowPictureController alloc]init];
    showPicture.topicModel = self.topic;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:showPicture animated:YES completion:nil];
}

-(void)setTopic:(BSTopicModel *)topic{
    _topic = topic;
    
    NSLog(@"%@",topic.large_image);
    // 设置图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        self.progressView.hidden = NO;
        // 计算进度值
        topic.pictureProgress = 1.0 * receivedSize / expectedSize;
        // 显示进度值
        [self.progressView setProgress:topic.pictureProgress animated:NO];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.progressView.hidden = YES;
        // 如果是大图片, 才需要进行绘图处理
        if (topic.isBigPicture == NO) return;
        
        // 开启图形上下文
        UIGraphicsBeginImageContextWithOptions(topic.pictureF.size, YES, 0.0);
        
        // 将下载完的image对象绘制到图形上下文
        CGFloat width = topic.pictureF.size.width;
        CGFloat height = width * image.size.height / image.size.width;
        [image drawInRect:CGRectMake(0, 0, width, height)];
        
        // 获得图片
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        
        // 结束图形上下文
        UIGraphicsEndImageContext();
    }];
    
    
//    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image]];
    /**在不知道图片扩展名的情况下, 如何知道图片的真实类型?
     * 取出图片数据的第一个字节, 就可以判断出图片的真实类型*/
    // 判断是否为gif
    //取出路径的扩展名
    NSString *extension = topic.large_image.pathExtension;
    //lowercaseString不管是否是大写的GIF都转成小写字母
    self.gifView.hidden = ![extension.lowercaseString isEqualToString:@"gif"];
    // 判断是否显示"点击查看全图"
    if (topic.isBigPicture) { // 大图
        self.seeBigButton.hidden = NO;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    } else { // 非大图
        self.seeBigButton.hidden = YES;
        self.imageView.contentMode = UIViewContentModeScaleToFill;
    }

    
}
@end
