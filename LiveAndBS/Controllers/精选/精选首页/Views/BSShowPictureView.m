//
//  BSShowPictureView.m
//  百思不得姐
//
//  Created by 田全军 on 16/11/3.
//  Copyright © 2016年 田全军. All rights reserved.
//

#import "BSShowPictureView.h"

@implementation BSShowPictureView

-(void)awakeFromNib{
    [super awakeFromNib];

    self.roundedCorners = 3;
    self.progressLabel.textColor = [UIColor whiteColor];
}

-(void)setProgress:(CGFloat)progress animated:(BOOL)animated{
    [super setProgress:progress animated:animated];
    NSString *text = [NSString stringWithFormat:@"%.0f%%",progress * 100];
    self.progressLabel.text = [text stringByReplacingOccurrencesOfString:@"-" withString:@""];
}
@end
