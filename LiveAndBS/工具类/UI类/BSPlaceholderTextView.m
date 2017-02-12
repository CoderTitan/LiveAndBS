//
//  BSPlaceholderTextView.m
//  百思不得姐
//
//  Created by 田全军 on 16/12/27.
//  Copyright © 2016年 田全军. All rights reserved.
//

#import "BSPlaceholderTextView.h"

#define BSNotificationCenter [NSNotificationCenter defaultCenter]

@interface BSPlaceholderTextView ()
/** 占位文字label */
@property (nonatomic, weak) UILabel *placeholderLabel;

@end
@implementation BSPlaceholderTextView

-(void)awakeFromNib{
    [self setTextViewPlaceholder];
    [super awakeFromNib];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTextViewPlaceholder];
    }
    return self;
}
- (UILabel *)placeholderLabel
{
    if (!_placeholderLabel) {
        // 添加一个用来显示占位文字的label
        UILabel *placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.numberOfLines = 0;
        placeholderLabel.x = 4;
        placeholderLabel.y = 7;
        [self addSubview:placeholderLabel];
        _placeholderLabel = placeholderLabel;
    }
    return _placeholderLabel;
}

-(void)setTextViewPlaceholder{
    //设置始终垂直弹性效果
    self.alwaysBounceVertical = YES;
    //设置默认字体大小和颜色
    self.placeholderColor = [UIColor lightGrayColor];
    self.font = [UIFont systemFontOfSize:15];
    //监听字数的变化
    [BSNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
}
/**
 * 监听文字改变
 */
- (void)textDidChange
{
    // 只要有文字, 就隐藏占位文字label
    self.placeholderLabel.hidden = self.hasText;
}

/**
 * 更新占位文字的尺寸
 */
- (void)updatePlaceholderLabelSize
{
    CGSize maxSize = CGSizeMake(ScreenWidth - 2 * self.placeholderLabel.x, MAXFLOAT);
    self.placeholderLabel.size = [self.placeholder boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.font} context:nil].size;
}
#pragma mark - dealloc
-(void)dealloc{
    [BSNotificationCenter removeObserver:self];
}
#pragma mark - 重写setter方法
- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    
    self.placeholderLabel.textColor = placeholderColor;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    
    self.placeholderLabel.text = placeholder;
    
    [self updatePlaceholderLabelSize];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    self.placeholderLabel.font = font;
    
    [self updatePlaceholderLabelSize];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    [self textDidChange];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    
    [self textDidChange];
}

@end
