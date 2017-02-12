//
//  BSCommentViewCell.h
//  百思不得姐
//
//  Created by 田全军 on 16/11/29.
//  Copyright © 2016年 田全军. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kBSCommentViewCell @"BSCommentViewCell"

@class BSCommentModel;
@interface BSCommentViewCell : UITableViewCell
/** 评论 */
@property (nonatomic, strong) BSCommentModel *comment;
@end
