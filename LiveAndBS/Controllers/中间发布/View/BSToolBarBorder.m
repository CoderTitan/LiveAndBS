//
//  BSToolBarBorder.m
//  百思不得姐
//
//  Created by 田全军 on 16/12/28.
//  Copyright © 2016年 田全军. All rights reserved.
//

#import "BSToolBarBorder.h"
#import "BSAddTagViewController.h"

@interface BSToolBarBorder ()
@property (weak, nonatomic) IBOutlet UIView *topView;
/** 添加按钮 */
@property (weak, nonatomic) UIButton *addButton;
/**  存放所有标签的数组  */
@property(nonatomic,strong)NSMutableArray *tagLabels;

@end
@implementation BSToolBarBorder

- (NSMutableArray *)tagLabels
{
    if (!_tagLabels) {
        _tagLabels = [NSMutableArray array];
    }
    return _tagLabels;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // 添加一个加号按钮
    UIButton *addButton = [[UIButton alloc] init];
    [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [addButton setImage:[UIImage imageNamed:@"tag_add_icon"] forState:UIControlStateNormal];
    //让按钮大小与图片大小一样的三种方法
//    addButton.size = [addButton imageForState:UIControlStateNormal].size;
//    addButton.size = [UIImage imageNamed:@"tag_add_icon"].size;
    //获得当前图片的尺寸
    addButton.size = addButton.currentImage.size;
    addButton.x = BSTagMargin;
    [self.topView addSubview:addButton];
    _addButton = addButton;
    
    // 默认就拥有2个标签
    [self createTagLabels:@[@"吐槽", @"糗事"]];

}

- (void)addButtonClick
{
    BSAddTagViewController *vc = [[BSAddTagViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    [vc setTagsBlock:^(NSArray *tags) {
        [weakSelf createTagLabels:tags];
    }];
    vc.tags = [self.tagLabels valueForKeyPath:@"text"];
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = (UINavigationController *)root.presentedViewController;
    [nav pushViewController:vc animated:YES];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (int i = 0; i<self.tagLabels.count; i++) {
        UILabel *tagLabel = self.tagLabels[i];
        
        // 设置位置
        if (i == 0) { // 最前面的标签
            tagLabel.x = 0;
            tagLabel.y = 0;
        } else { // 其他标签
            UILabel *lastTagLabel = self.tagLabels[i - 1];
            // 计算当前行左边的宽度
            CGFloat leftWidth = CGRectGetMaxX(lastTagLabel.frame) + BSTagMargin;
            // 计算当前行右边的宽度
            CGFloat rightWidth = self.topView.width - leftWidth;
            if (rightWidth >= tagLabel.width) { // 按钮显示在当前行
                tagLabel.y = lastTagLabel.y;
                tagLabel.x = leftWidth;
            } else { // 按钮显示在下一行
                tagLabel.x = 0;
                tagLabel.y = CGRectGetMaxY(lastTagLabel.frame) + BSTagMargin;
            }
        }
    }
    
    // 最后一个标签
    UILabel *lastTagLabel = [self.tagLabels lastObject];
    CGFloat leftWidth = CGRectGetMaxX(lastTagLabel.frame) + BSTagMargin;
    
    // 更新textField的frame
    if (self.topView.width - leftWidth >= self.addButton.width) {
        self.addButton.y = lastTagLabel.y;
        self.addButton.x = leftWidth;
    } else {
        self.addButton.x = 0;
        self.addButton.y = CGRectGetMaxY(lastTagLabel.frame) + BSTagMargin;
    }
    
    // 整体的高度
    CGFloat oldH = self.height;
    self.height = CGRectGetMaxY(self.addButton.frame) + 45;
    self.y -= self.height - oldH;
}

/**
 * 创建标签
 */
- (void)createTagLabels:(NSArray *)tags
{
    [self.tagLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.tagLabels removeAllObjects];
    
    for (int i = 0; i<tags.count; i++) {
        UILabel *tagLabel = [[UILabel alloc] init];
        [self.tagLabels addObject:tagLabel];
        tagLabel.backgroundColor = ColorWithRGB(74, 139, 209);
        tagLabel.textAlignment = NSTextAlignmentCenter;
        tagLabel.text = tags[i];
        tagLabel.font = [UIFont systemFontOfSize:14];
        // 应该要先设置文字和字体后，再进行计算
        [tagLabel sizeToFit];
        tagLabel.width += 2 * BSTagMargin;
        tagLabel.height = 25;
        tagLabel.textColor = [UIColor whiteColor];
        [self.topView addSubview:tagLabel];
    }
    
    // 重新布局子控件
    [self setNeedsLayout];
}


@end
