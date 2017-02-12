//
//  BSTopicViewController.h
//  百思不得姐
//
//  Created by 田全军 on 16/10/25.
//  Copyright © 2016年 田全军. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSTopicViewController : UITableViewController

/** 帖子类型(交给子类去实现) */
@property (nonatomic, assign) BSTopicType type;


@end
