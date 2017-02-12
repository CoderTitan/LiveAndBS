//
//  BSAddTagViewController.h
//  百思不得姐
//
//  Created by 田全军 on 16/12/28.
//  Copyright © 2016年 田全军. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSAddTagViewController : UIViewController

/**  所有的标签  */
@property(nonatomic,strong)NSArray *tags;
/**  block  */
@property(nonatomic,copy)void(^tagsBlock)(NSArray *tags) ;

@end
