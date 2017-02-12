//
//  TopicTableCell.m
//  百思不得姐
//
//  Created by 田全军 on 16/10/24.
//  Copyright © 2016年 田全军. All rights reserved.
//

#import "TopicTableCell.h"
#import "BSTopicModel.h"
#import "BSCommentModel.h"
#import "BSUserModel.h"
#import "BSPictureView.h"
#import "BSVoiceView.h"
#import "BSVideoView.h"
#import <UIImageView+WebCache.h>

@interface TopicTableCell()
/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
/** 昵称 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** 时间 */
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
/** 顶 */
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
/** 踩 */
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
/** 分享 */
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
/** 评论 */
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
/** 新浪加V */
@property (weak, nonatomic) IBOutlet UIImageView *sinaVView;
@property (weak, nonatomic) IBOutlet UILabel *text_Lable;

/** 图片帖子中间的内容 */
@property (nonatomic, weak) BSPictureView *pictureView;
/** 声音帖子中间的内容 */
@property (nonatomic, weak) BSVoiceView *voiceView;
/** 视频帖子中间的内容 */
@property (nonatomic, weak) BSVideoView *videoView;

/** 最热评论的内容 */
@property (weak, nonatomic) IBOutlet UILabel *topCmtContentLabel;
/** 最热评论的整体 */
@property (weak, nonatomic) IBOutlet UIView *topCmtView;
@end

@implementation TopicTableCell

- (BSPictureView *)pictureView{
    if (!_pictureView) {
        BSPictureView *pictureView = [BSPictureView viewFromXib];
        [self.contentView addSubview:pictureView];
        _pictureView = pictureView;
    }
    return _pictureView;
}

-(BSVoiceView *)voiceView{
    if (!_voiceView) {
        BSVoiceView *voiceView = [BSVoiceView viewFromXib];
        [self.contentView addSubview:voiceView];
        _voiceView = voiceView;
    }
    return _voiceView;
}


-(BSVideoView *)videoView{
    if (!_videoView) {
        BSVideoView *videoView = [BSVideoView videoView];
        [self.contentView addSubview:videoView];
        _videoView = videoView;
    }
    return _videoView;
}

- (void)awakeFromNib {
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.image = [UIImage imageNamed:@"mainCellBackground"];
    self.backgroundView = bgView;
    [super awakeFromNib];
}
-(void)setTopicModel:(BSTopicModel *)topicModel{
    _topicModel = topicModel;
    
    // 新浪加V
    self.sinaVView.hidden = !topicModel.isSina_v;
    
    // 设置其他控件
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:topicModel.profile_image] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    self.nameLabel.text = topicModel.name;
    self.createTimeLabel.text = topicModel.create_time;
    
    // 设置按钮文字
    [self setupButtonTitle:self.dingButton count:topicModel.ding placeholder:@"顶"];
    [self setupButtonTitle:self.caiButton count:topicModel.cai placeholder:@"踩"];
    [self setupButtonTitle:self.shareButton count:topicModel.repost placeholder:@"分享"];
    [self setupButtonTitle:self.commentButton count:topicModel.comment placeholder:@"评论"];
    self.text_Lable.text = topicModel.text;
    // 根据模型类型(帖子类型)添加对应的内容到cell的中间
    if (topicModel.type == BSTopicTypePicture) { // 图片帖子
        self.pictureView.hidden = NO;
        self.voiceView.hidden = YES;
        self.videoView.hidden = YES;
        self.pictureView.topic= topicModel;
        self.pictureView.frame = topicModel.pictureF;
    } else if (topicModel.type == BSTopicTypeVoice) { // 声音帖子
        self.pictureView.hidden = YES;
        self.voiceView.hidden = NO;
        self.videoView.hidden = YES;
        self.voiceView.topic = topicModel;
        self.voiceView.frame = topicModel.voiceF;
    } else if (topicModel.type == BSTopicTypeVideo){
        self.pictureView.hidden = YES;
        self.voiceView.hidden = YES;
        self.videoView.hidden = NO;
        self.videoView.topic = topicModel;
        self.videoView.frame = topicModel.videoF;
    }else{
        self.pictureView.hidden = YES;
        self.voiceView.hidden = YES;
        self.videoView.hidden = YES;

    }
    // 处理最热评论
    if (topicModel.top_cmt) {
        self.topCmtView.hidden = NO;
        self.topCmtContentLabel.text = [NSString stringWithFormat:@"%@ : %@",topicModel.top_cmt.user.username,topicModel.top_cmt.content];
    }else{
        self.topCmtView.hidden = YES;
    }
}
- (void)setupButtonTitle:(UIButton *)button count:(NSInteger)count placeholder:(NSString *)placeholder
{
    if (count > 10000) {
        placeholder = [NSString stringWithFormat:@"%.1f万", count / 10000.0];
    } else if (count > 0) {
        placeholder = [NSString stringWithFormat:@"%zd", count];
    }
    [button setTitle:placeholder forState:UIControlStateNormal];
}

-(void)setFrame:(CGRect)frame{
    
    frame.origin.x = BSTopicCellMargin + self.cellLeftMargin;
    frame.size.width -= 2 * BSTopicCellMargin;
    frame.size.height -= BSTopicCellMargin;
    frame.origin.y += BSTopicCellMargin;
    
    [super setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
