//
//  BSPostWordController.m
//  百思不得姐
//
//  Created by 田全军 on 16/12/27.
//  Copyright © 2016年 田全军. All rights reserved.
//

#import "BSPostWordController.h"
#import "BSPlaceholderTextView.h"
#import "BSToolBarBorder.h"
@interface BSPostWordController ()<UITextViewDelegate>
/**  UITextView  */
@property(nonatomic,strong)BSPlaceholderTextView *textView;
/**  发表按钮  */
@property(nonatomic,strong)UIButton *publishButton;
/** 工具条 */
@property (nonatomic, weak) BSToolBarBorder *toolbar;

@end

@implementation BSPostWordController

- (void)viewDidLoad {
    [super viewDidLoad];
    //界面布局
    [self onFinishWithView];
    [self setupToolbar];
   
}
//界面布局
-(void)onFinishWithView{
    self.title = @"发表文字";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancleButtonAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStyleDone target:self action:@selector(publishButtonAction)];
    self.navigationItem.rightBarButtonItem.enabled = NO; // 默认不能点击
    // 强制刷新
    [self.navigationController.navigationBar layoutIfNeeded];
    
    self.textView = [[BSPlaceholderTextView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.textView.delegate = self;
    [self.view addSubview:_textView];
    _textView.placeholder = @"你是天边最美的云彩,让我把你留下啦.圣诞节饭店时快捷方式开发开关即可发表接电话附件是南京市v的副教授等环节的收藏家的水泥厂!";
}
- (void)setupToolbar
{
    BSToolBarBorder *toolbar = [BSToolBarBorder viewFromXib];
    toolbar.width = self.view.width;
    toolbar.y = self.view.height - toolbar.height;
    [self.view addSubview:toolbar];
    self.toolbar = toolbar;
    
    [BSNotific addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
/**
 * 监听键盘的弹出和隐藏
 */
- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    CGRect boderFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat boderDuration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:boderDuration animations:^{
        _toolbar.transform = CGAffineTransformMakeTranslation(0, boderFrame.origin.y - ScreenHeight);
    }];
}
#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    self.navigationItem.rightBarButtonItem.enabled = self.textView.hasText;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
#pragma mark - ButtonAction
-(void)cancleButtonAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)publishButtonAction{
    
}

@end
