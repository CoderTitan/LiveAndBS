//
//  BSSquareButton.m
//  百思不得姐
//
//  Created by 田全军 on 16/12/26.
//  Copyright © 2016年 田全军. All rights reserved.
//

#import "BSSquareButton.h"
#import "BSSquare.h"

#import "UIButton+WebCache.h"

@implementation BSSquareButton

- (void)setup
{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    [self setBackgroundImage:[UIImage imageNamed:@"mainCellBackground"] forState:UIControlStateNormal];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];
    
    [super awakeFromNib];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 调整图片
    self.imageView.y = self.height * 0.15;
    self.imageView.width = self.width * 0.5;
    self.imageView.height = self.imageView.width;
    self.imageView.centerX = self.width * 0.5;
    
    // 调整文字
    self.titleLabel.x = 0;
    self.titleLabel.y = CGRectGetMaxY(self.imageView.frame);
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.titleLabel.y;
}

- (void)setSquare:(BSSquare *)square
{
    _square = square;
    
    [self setTitle:square.name forState:UIControlStateNormal];
    // 利用SDWebImage给按钮设置image
    [self sd_setImageWithURL:[NSURL URLWithString:square.icon] forState:UIControlStateNormal];
}

@end
