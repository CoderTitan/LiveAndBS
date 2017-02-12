//
//  BSVideoView.h
//  百思不得姐
//
//  Created by 田全军 on 16/11/15.
//  Copyright © 2016年 田全军. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BSTopicModel;

@interface BSVideoView : UIView

/**  模型  */
@property(nonatomic,strong)BSTopicModel *topic;

+(instancetype)videoView;

@end
