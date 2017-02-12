//
//  BSTagButton.m
//  百思不得姐
//
//  Created by 田全军 on 16/12/29.
//  Copyright © 2016年 田全军. All rights reserved.
//

#import "BSTagButton.h"

@implementation BSTagButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setImage:[UIImage imageNamed:@"chose_tag_close_icon"] forState:UIControlStateNormal];
        self.backgroundColor = ColorWithRGB(74, 139, 209);
        self.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return self;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    
    [self sizeToFit];
    
    self.width += 3 * BSTagMargin;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.x = BSTagMargin;
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + BSTagMargin;
}

@end
