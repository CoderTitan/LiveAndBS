//
//  BSCommentModel.h
//  百思不得姐
//
//  Created by 田全军 on 16/11/23.
//  Copyright © 2016年 田全军. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BSUserModel;

@interface BSCommentModel : NSObject
/** id */
@property (nonatomic, copy) NSString *ID;
/** 音频文件的时长 */
@property (nonatomic, assign) NSInteger voicetime;
/** 音频文件的路径 */
@property (nonatomic, copy) NSString *voiceuri;
/** 评论的文字内容 */
@property (nonatomic, copy) NSString *content;
/** 被点赞的数量 */
@property (nonatomic, assign) NSInteger like_count;
/** 用户 */
@property (nonatomic, strong) BSUserModel *user;
@end

