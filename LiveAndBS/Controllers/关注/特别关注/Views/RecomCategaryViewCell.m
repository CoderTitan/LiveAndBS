//
//  RecomCategaryViewCell.m
//  百思不得姐
//
//  Created by 田全军 on 16/9/26.
//  Copyright © 2016年 田全军. All rights reserved.
//

#import "RecomCategaryViewCell.h"
#import "BSRecommendCategaryModel.h"

@interface RecomCategaryViewCell ()
@property (weak, nonatomic) IBOutlet UIView *leftView;

@end
@implementation RecomCategaryViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = ColorWithRGB(244, 244, 244);
    
    [super awakeFromNib];

}
-(void)setModel:(BSRecommendCategaryModel *)model{
    _model = model;
    self.textLabel.text = model.name;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 重新调整内部textLabel的frame
    self.textLabel.y = 2;
    self.textLabel.height = self.contentView.height - 2 * self.textLabel.y;
}

/**
 * 可以在这个方法中监听cell的选中和取消选中
 */

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


    self.leftView.hidden = !selected;
    self.textLabel.textColor = selected ? self.leftView.backgroundColor : ColorWithRGB(78, 78, 78);
}

@end
