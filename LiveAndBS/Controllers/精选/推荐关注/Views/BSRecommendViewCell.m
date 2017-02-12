//
//  BSRecommendViewCell.m
//  百思不得姐
//
//  Created by 田全军 on 16/10/15.
//  Copyright © 2016年 田全军. All rights reserved.
//

#import "BSRecommendViewCell.h"
#import "BSRecommendModel.h"
#import "UIImageView+WebCache.h"

@interface BSRecommendViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageListImageView;
@property (weak, nonatomic) IBOutlet UILabel *themeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subNumberLabel;
@end

@implementation BSRecommendViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];

}
-(void)setRecommendModel:(BSRecommendModel *)recommendModel{
    _recommendModel = recommendModel;
    
    [self.imageListImageView sd_setImageWithURL:[NSURL URLWithString:recommendModel.image_list] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    self.themeNameLabel.text = recommendModel.theme_name;
    NSString *subNumber = nil;
    if (recommendModel.sub_number < 10000) {
        subNumber = [NSString stringWithFormat:@"%zd人订阅", recommendModel.sub_number];
    } else { // 大于等于10000
        subNumber = [NSString stringWithFormat:@"%.1f万人订阅", recommendModel.sub_number / 10000.0];
    }
    self.subNumberLabel.text = subNumber;
}
-(void)setFrame:(CGRect)frame{
    frame.origin.x = 5;
    frame.size.width -= 2 * frame.origin.x;
    frame.size.height -= 1;
    [super setFrame:frame];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
