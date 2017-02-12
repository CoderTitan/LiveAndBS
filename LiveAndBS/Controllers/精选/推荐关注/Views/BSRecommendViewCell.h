//
//  BSRecommendViewCell.h
//  百思不得姐
//
//  Created by 田全军 on 16/10/15.
//  Copyright © 2016年 田全军. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BSRecommendModel;
@interface BSRecommendViewCell : UITableViewCell

/**  模型数据  */
@property(nonatomic,strong)BSRecommendModel *recommendModel;
@end
