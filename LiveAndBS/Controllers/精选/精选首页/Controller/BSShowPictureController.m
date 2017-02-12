//
//  BSShowPictureController.m
//  百思不得姐
//
//  Created by 田全军 on 16/11/3.
//  Copyright © 2016年 田全军. All rights reserved.
//

#import "BSShowPictureController.h"
#import <SVProgressHUD.h>
#import "UIImageView+WebCache.h"
#import "BSShowPictureView.h"
#import "BSTopicModel.h"

@interface BSShowPictureController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
/**  imageView  */
@property(nonatomic,strong)UIImageView *imageView;
/**  大图显示view  */
@property(nonatomic,strong)IBOutlet BSShowPictureView *showView;

@end

@implementation BSShowPictureController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加图片
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backAction:)]];
    [self.scrollView addSubview:imageView];
    self.imageView = imageView;
    
    //图片尺寸
    CGFloat pictureW = ScreenWidth;
    CGFloat pictureH = ScreenWidth * self.topicModel.height / self.topicModel.width;
    if (pictureH > ScreenHeight) {
        //超过一个屏幕
        imageView.frame = CGRectMake(0, 0, pictureW, pictureH);
        self.scrollView.contentSize = CGSizeMake(0, pictureH);
    }else{
        imageView.size = CGSizeMake(pictureW, pictureH);
        imageView.centerY = ScreenHeight * 0.5;
    }
    // 马上显示当前图片的下载进度
    [self.showView setProgress:self.topicModel.pictureProgress animated:NO];
    // 下载图片
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.topicModel.large_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        [self.showView setProgress:self.topicModel.pictureProgress animated:NO];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.showView.hidden = YES;
    }];

    
}
#pragma mark - 按钮Action
- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)saveAction:(id)sender {
    if (self.imageView.image == nil) {
        [SVProgressHUD showErrorWithStatus:@"图片下载失败"];
        return;
    }
    //把图片写入相册
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
}
- (IBAction)relayAction:(id)sender {
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    }else{
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    }
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
