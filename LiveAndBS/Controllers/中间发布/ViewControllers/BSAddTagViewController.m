//
//  BSAddTagViewController.m
//  百思不得姐
//
//  Created by 田全军 on 16/12/28.
//  Copyright © 2016年 田全军. All rights reserved.
//

#import "BSAddTagViewController.h"
#import <SVProgressHUD.h>
#import "BSTagView.h"
#import "BSTagTextField.h"
//#import "BSTagView.h"

@interface BSAddTagViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
/** 内容 */
@property (nonatomic, weak) UIView *contentView;
/** 文本输入框 */
@property (nonatomic, weak) BSTagTextField *textField;
/** tableVIew */
@property (nonatomic, weak) UITableView *tableView;
/** 标签按钮 */
@property (nonatomic, strong) NSMutableArray *tagViewsArray;
/**  所有的标签按钮  */
@property(nonatomic,strong)NSMutableArray *allTagViewsArr;
/**  索引  */
@property(nonatomic,assign)NSInteger tagIndex;
/**  数据源数组  */
@property(nonatomic,strong)NSMutableArray *dataArray;
/**  键盘高度  */
//@property(nonatomic,assign)CGFloat <#参数#>;




@end

@implementation BSAddTagViewController

#pragma mark - 懒加载
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithObjects:@"我",@"我是",@"我是你",@"我是你大",@"我是你大爷",@"我是你大爷的",@"我是你大爷的爷",@"我是你大爷的爷爷",@"我是你大爷的爷爷的",@"我是你大爷的爷爷的爷",@"我",@"我是",@"我是你",@"我是你大",@"我是你大爷",@"我是你大爷的",@"我是你大爷的爷",@"我是你大爷的爷爷",@"我是你大爷的爷爷的",@"我是你大爷的爷爷的爷", nil];
    }
    return _dataArray;
}
-(NSMutableArray *)allTagViewsArr{
    if (!_allTagViewsArr) {
        _allTagViewsArr = [NSMutableArray array];
    }
    return _allTagViewsArr;
}
- (NSMutableArray *)tagViewsArray{
    if (!_tagViewsArray) {
        _tagViewsArray = [NSMutableArray array];
    }
    return _tagViewsArray;
}

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc]init];
        tableView.width = self.contentView.width;
        tableView.x = 0;
        tableView.backgroundColor = BSGlobalBackg;
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.contentView addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupContentView];
    
    [self setupTextFiled];
}

#pragma mark - 搭建界面
- (void)setupContentView{
    UIView *contentView = [[UIView alloc] init];
    contentView.x = BSTagMargin;
    contentView.width = self.view.width - 2 * contentView.x;
    contentView.y = 64 + BSTagMargin;
    contentView.height = ScreenHeight - contentView.y;
    [self.view addSubview:contentView];
    self.contentView = contentView;
}

- (void)setupTextFiled{
    BSTagTextField *textField = [[BSTagTextField alloc] init];
    [textField becomeFirstResponder];
    textField.delegate = self;
    textField.width = ScreenWidth;
    textField.height = 25;
    textField.placeholder = @"多个标签用逗号或者换行隔开";
    // 设置了占位文字内容以后, 才能设置占位文字的颜色
    
    if (textField.text.length == 0) {
        
    }
    [textField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [textField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    [textField becomeFirstResponder];
    [self.contentView addSubview:textField];
    self.textField = textField;
    
    [BSNotific addObserver:self selector:@selector(keyBoderDidShowFrame:) name:UIKeyboardDidShowNotification object:nil];
}

- (void)setupNav
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"添加标签";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
}


/**
 * 专门用来更新标签按钮的frame
 */
- (void)updatetagViewFrame
{
    // 更新标签按钮的frame
    for (int i = 0; i<self.tagViewsArray.count; i++) {
        BSTagView *tagView = self.tagViewsArray[i];
        
        if (i == 0) { // 最前面的标签按钮
            tagView.x = 0;
            tagView.y = 0;
        } else { // 其他标签按钮
            BSTagView *lasttagView = self.tagViewsArray[i - 1];
            // 计算当前行左边的宽度
            CGFloat leftWidth = CGRectGetMaxX(lasttagView.frame) + BSTagMargin;
            // 计算当前行右边的宽度
            CGFloat rightWidth = self.contentView.width - leftWidth;
            if (rightWidth >= tagView.width) { // 按钮显示在当前行
                tagView.y = lasttagView.y;
                tagView.x = leftWidth;
            } else { // 按钮显示在下一行
                tagView.x = 0;
                tagView.y = CGRectGetMaxY(lasttagView.frame) + BSTagMargin;
            }
        }
    }
    
    // 最后一个标签按钮
    BSTagView *lasttagView = [self.tagViewsArray lastObject];
    CGFloat leftWidth = CGRectGetMaxX(lasttagView.frame) + BSTagMargin;
    
    // 更新textField的frame
    if (self.contentView.width - leftWidth >= [self textFieldTextWidth]) {
        self.textField.y = lasttagView.y;
        self.textField.x = leftWidth;
    } else {
        self.textField.x = 0;
        self.textField.y = CGRectGetMaxY(lasttagView.frame) + BSTagMargin;
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.hasText) {
        [self tableViewClick:textField.text];
    }
    
    return YES;
}
#pragma mark - 监听事件
- (void)textDidChange:(CGFloat)height
{
    if (self.textField.hasText) { // 有文字
        // 显示"添加标签"的按钮
        self.tableView.hidden = NO;
        self.tableView.y = CGRectGetMaxY(self.textField.frame) + BSTagMargin;
        self.tableView.height = CGRectGetHeight(self.contentView.frame) - self.tableView.y - 271;
        // 获得最后一个字符
        NSString *text = self.textField.text;
        NSUInteger len = text.length;
        NSString *lastLetter = [text substringFromIndex:len - 1];
        if (([lastLetter isEqualToString:@","]
             || [lastLetter isEqualToString:@"，"]) && len > 1) {
            // 去除逗号
            self.textField.text = [text substringToIndex:len - 1];
            
            [self tableViewClick:self.textField.text];
        }
        
        if (self.dataArray.count > 20) {
            [self.dataArray removeObjectAtIndex:0];
        }
        [self.dataArray insertObject:text atIndex:0];
        
    } else { // 没有文字
        // 隐藏"添加标签"的按钮
        self.tableView.hidden = YES;
        __weak typeof(self) weakSelf = self;
        self.textField.deleteBlock = ^{
            if (weakSelf.textField.hasText) return;
            
            [weakSelf tagViewClick:[[weakSelf.tagViewsArray lastObject] deleteButton]];
        };
    }
    [self.tableView reloadData];
    // 更新标签和文本框的frame
    [self updatetagViewFrame];
}

/**
 * textField的文字宽度
 */
- (CGFloat)textFieldTextWidth
{
    CGFloat textW = [self.textField.text sizeWithAttributes:@{NSFontAttributeName : self.textField.font}].width;
    CGFloat textFieldW = [self.textField.placeholder sizeWithAttributes:@{NSFontAttributeName : self.textField.font}].width;
    return MAX(textFieldW, textW);
}

/**
 *  监听键盘弹出
 */
-(void)keyBoderDidShowFrame:(NSNotification *)note{
    CGFloat keyBoderH = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [self textDidChange:keyBoderH];
}
#pragma mark - 按钮点击
- (void)done
{
    // 传递数据给上一个控制器
    //        NSMutableArray *tags = [NSMutableArray array];
    //        for (BSTagView *tagView in self.tagViewsArray) {
    //            [tags addObject:tagView.title];
    //        }
    // 传递tags给这个block
    NSArray *tags = [self.tagViewsArray valueForKeyPath:@"title"];
    !self.tagsBlock ? : self.tagsBlock(tags);
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)tableViewClick:(NSString *)title
{
    if (self.tagViewsArray.count == 5) {
        [SVProgressHUD showErrorWithStatus:@"最多添加5个标签"];
        return;
    }
    
    self.textField.placeholder = nil;
    // 添加一个"标签按钮"
    BSTagView *tagView = [[BSTagView alloc]init];
    tagView.title = title;
    tagView.deleteButton.tag = _tagIndex;
    [tagView.deleteButton addTarget:self action:@selector(tagViewClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:tagView];
    [self.tagViewsArray addObject:tagView];
    [self.allTagViewsArr addObject:tagView];
    
    _tagIndex ++;
    // 更新标签按钮的frame
    [self updatetagViewFrame];
    
    // 清空textField文字
    self.textField.text = nil;
    self.tableView.hidden = YES;
}

/**
 * 删除标签按钮的点击
 */
- (void)tagViewClick:(UIButton *)delButton
{
    BSTagView *tagView = self.allTagViewsArr[delButton.tag];
    
    [tagView removeFromSuperview];
    [self.tagViewsArray removeObject:tagView];
    //    [self.allTagViewsArr removeObject:tagView];
    
    // 重新更新所有标签按钮的frame
    [UIView animateWithDuration:0.25 animations:^{
        [self updatetagViewFrame];
    }];
    if (self.tagViewsArray.count == 0) {
        _textField.placeholder = @"多个标签用逗号或者换行隔开";
        _tagIndex = 0;
        [self.allTagViewsArr removeAllObjects];
    }
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.backgroundColor = BSGlobalBackg;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self tableViewClick:self.dataArray[indexPath.row]];
}
@end
