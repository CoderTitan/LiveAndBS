//
//  BSTransionRightCell.m
//  百思不得姐
//
//  Created by 田全军 on 16/10/7.
//  Copyright © 2016年 田全军. All rights reserved.
//

#import "BSTransionRightCell.h"
#import "UIImageView+WebCache.h"
#import "BSTransionRightModel.h"

@interface BSTransionRightCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *numberLable;
@property (weak, nonatomic) IBOutlet UIButton *trentionButton;


@end
@implementation BSTransionRightCell
-(void)awakeFromNib{
    [super awakeFromNib];
}
-(void)setModel:(BSTransionRightModel *)model{
    
    _model = model;
    self.nameLable.text = model.screen_name;
    
    NSString *fulStr = nil;
    if (model.fans_count < 10000) {
        fulStr = [NSString stringWithFormat:@"%zd人关注",model.fans_count];
    }else{
        fulStr = [NSString stringWithFormat:@"%.1f万人关注",model.fans_count / 10000.0];
    }
    self.numberLable.text = fulStr;
    
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.cornerRadius = self.imageView.bounds.size.width / 2;
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:model.header] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    
}
@end
