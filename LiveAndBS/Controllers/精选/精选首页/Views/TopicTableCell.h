//
//  TopicTableCell.h
//  百思不得姐
//
//  Created by 田全军 on 16/10/24.
//  Copyright © 2016年 田全军. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BSTopicModel;
@interface TopicTableCell : UITableViewCell

/**  cell左间距  */
@property(nonatomic,assign)CGFloat cellLeftMargin;
/**  模型  */
@property(nonatomic,strong)BSTopicModel *topicModel;

@end
