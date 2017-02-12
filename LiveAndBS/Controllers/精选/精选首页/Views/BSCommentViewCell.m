//
//  BSCommentViewCell.m
//  百思不得姐
//
//  Created by 田全军 on 16/11/29.
//  Copyright © 2016年 田全军. All rights reserved.
//

#import "BSCommentViewCell.h"
#import "BSCommentModel.h"
#import "BSUserModel.h"
#import "BSCommentViewCell.h"
#import "UIImageView+WebCache.h"

@interface BSCommentViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeCountButton;
@property (weak, nonatomic) IBOutlet UIButton *voiceButton;


@end
@implementation BSCommentViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
}

-(void)setComment:(BSCommentModel *)comment{
    _comment = comment;
    
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:comment.user.profile_image] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    self.sexView.image = [comment.user.sex isEqualToString:BSUserSexMale] ? [UIImage imageNamed:@"Profile_manIcon"] : [UIImage imageNamed:@"Profile_womanIcon"];
    self.contentLabel.text = comment.content;
    self.usernameLabel.text = comment.user.username;
    [self.likeCountButton setTitle:[NSString stringWithFormat:@"%zd", comment.like_count] forState:UIControlStateNormal];
    
    if (comment.voiceuri.length) {
        self.voiceButton.hidden = NO;
        [self.voiceButton setTitle:[NSString stringWithFormat:@"%zd''", comment.voicetime] forState:UIControlStateNormal];
    } else {
        self.voiceButton.hidden = YES;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
