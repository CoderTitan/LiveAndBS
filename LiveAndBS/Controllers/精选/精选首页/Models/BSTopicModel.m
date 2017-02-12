//
//  BSTopicModel.m
//  百思不得姐
//
//  Created by 田全军 on 16/10/24.
//  Copyright © 2016年 田全军. All rights reserved.
//

#import "BSTopicModel.h"
#import "BSCommentModel.h"
#import "BSUserModel.h"
#import <MJExtension.h>
@implementation BSTopicModel
{
    CGFloat _cellHeight;
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"small_image"  : @"image0",
             @"large_image"  : @"image1",
             @"middle_image" : @"image2",
             @"ID"           : @"id",
             @"top_cmt"      : @"top_cmt[0]"
             };
}
//+ (NSDictionary *)mj_objectClassInArray{
//    return @{@"top_cmt" : [BSCommentModel class]};
////    return @{@"top_cmt" : @"BSCommentModel"};
//}
- (NSString *)create_time
{
    // 日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 设置日期格式(y:年,M:月,d:日,H:时,m:分,s:秒)
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // 帖子的创建时间
    NSDate *create = [fmt dateFromString:_create_time];
    
    if (create.isThisYear) { // 今年
        if (create.isToday) { // 今天
            NSDateComponents *cmps = [[NSDate date] deltaFrom:create];
            
            if (cmps.hour >= 1) { // 时间差距 >= 1小时
                return [NSString stringWithFormat:@"%zd小时前", cmps.hour];
            } else if (cmps.minute >= 1) { // 1小时 > 时间差距 >= 1分钟
                return [NSString stringWithFormat:@"%zd分钟前", cmps.minute];
            } else { // 1分钟 > 时间差距
                return @"刚刚";
            }
        } else if (create.isYesterday) { // 昨天
            fmt.dateFormat = @"昨天 HH:mm:ss";
            return [fmt stringFromDate:create];
        } else { // 其他
            fmt.dateFormat = @"MM-dd HH:mm:ss";
            return [fmt stringFromDate:create];
        }
    } else { // 非今年
        return _create_time;
    }
}
/**
 *  默认只计算一次高度,当刷新新数据时,会自动重新计算一次高度
 */
-(CGFloat)cellHeight{
    if (!_cellHeight) {
        // 文字的最大尺寸
        CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 4 * BSTopicCellMargin, MAXFLOAT);
        
        /**  计算文字高度
         *  CGSize 最大尺寸
         *  options  默认都是NSStringDrawingUsesLineFragmentOrigin
         *  attributes  对应的字典参数
         *  context:nil
         */
        CGFloat textH = [self.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
        
        _cellHeight = BSTopicCellTextY + textH + BSTopicCellMargin;
        
        // 根据段子的类型来计算cell的高度
        if (self.type == BSTopicTypePicture) { // 图片帖子
            // 图片显示出来的宽度
            CGFloat pictureW = maxSize.width;
            // 图片显示出来的高度
            CGFloat pictureH = pictureW * self.height / self.width;
            if (pictureH >= BSTopicCellPictureMaxH) {//图片高度过长
                pictureH = BSTopicCellPictureBreakH;
                self.bigPicture = YES;//大图
            }
            // 计算图片控件的frame
            CGFloat pictureX = BSTopicCellMargin;
            CGFloat pictureY = BSTopicCellTextY + textH + BSTopicCellMargin;
            _pictureF = CGRectMake(pictureX, pictureY, pictureW, pictureH);
            //图片所占用的高度
            _cellHeight += pictureH + BSTopicCellMargin;
        } else if (self.type == BSTopicTypeVoice) { // 声音帖子
            CGFloat voiceX = BSTopicCellMargin;
            CGFloat voiceY = BSTopicCellTextY + textH + BSTopicCellMargin;
            CGFloat voiceW = maxSize.width;
            CGFloat voiceH = voiceW * self.height / self.width;
            _voiceF = CGRectMake(voiceX, voiceY, voiceW, voiceH);
            _cellHeight += voiceH + BSTopicCellMargin;
        } else if (self.type == BSTopicTypeVideo){
            CGFloat videoX = BSTopicCellMargin;
            CGFloat videoY = BSTopicCellTextY + textH + BSTopicCellMargin;
            CGFloat videoW = maxSize.width;
            CGFloat videoH = videoW * self.height / self.width;
            _videoF = CGRectMake(videoX, videoY, videoW, videoH);
            _cellHeight += videoH + BSTopicCellMargin;
        }
        // 如果有最热评论
        if (self.top_cmt) {
            NSString *contain = [NSString stringWithFormat:@"%@ : %@",self.top_cmt.user.username,self.top_cmt.content];
            CGFloat containH = [contain boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size.height;
            _cellHeight += BSTopicCellTopCmtTitleH + containH + BSTopicCellMargin;
        }
        
        _cellHeight +=  BSTopicCellMargin + BSTopicCellBottomBarH;
    }
    return _cellHeight;
}
@end
