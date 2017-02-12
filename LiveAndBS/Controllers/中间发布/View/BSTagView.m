//
//  BSTagView.m
//  百思不得姐
//
//  Created by 田全军 on 16/12/29.
//  Copyright © 2016年 田全军. All rights reserved.
//

#import "BSTagView.h"
#define TagBlueColor  ColorWithRGB(74, 139, 209)

@interface BSTagView ()
/**  lable  */
@property(nonatomic,strong)UILabel *titleLable;

@end

@implementation BSTagView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self onFinishTheView];
    }
    return self;
}

-(void)onFinishTheView{
    self.layer.borderColor = TagBlueColor.CGColor;
    self.layer.borderWidth = 1;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    
    _titleLable = [[UILabel alloc]init];
    _titleLable.font = [UIFont systemFontOfSize:14];
    _titleLable.textColor = TagBlueColor;
    [self addSubview:_titleLable];
    
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteButton setImage:[UIImage imageNamed:@"chose_tag_close_icon"] forState:UIControlStateNormal];
    [self addSubview:_deleteButton];
}

-(void)updataAllViewsFrame{
    CGFloat titleWidth = [self.title sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]}].width;
    if (titleWidth >= 60) {
        _titleLable.width = 60;
    }else{
        _titleLable.width = titleWidth;
    }
    _titleLable.height = 25;
    _titleLable.x = 5;
    _titleLable.y = 0;
    
    _deleteButton.size = _deleteButton.currentImage.size;
    _deleteButton.x = CGRectGetMaxX(_titleLable.frame) + BSTagMargin;
    _deleteButton.centerY = _titleLable.centerY;
    
    self.width = CGRectGetWidth(_titleLable.frame) + CGRectGetWidth(_deleteButton.frame) + 3 * BSTagMargin;
    self.height = 30;
}

#pragma mark - 重写setter方法
-(void)setTitle:(NSString *)title{
    _title = [title copy];
    _titleLable.text = title;
    
    [self updataAllViewsFrame];
}
@end
