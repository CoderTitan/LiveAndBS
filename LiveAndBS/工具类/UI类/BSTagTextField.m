//
//  BSTagTextField.m
//  百思不得姐
//
//  Created by 田全军 on 16/12/30.
//  Copyright © 2016年 田全军. All rights reserved.
//

#import "BSTagTextField.h"

@implementation BSTagTextField

-(void)deleteBackward{
    [super deleteBackward];
    
    !self.deleteBlock ? : self.deleteBlock();
}
@end
