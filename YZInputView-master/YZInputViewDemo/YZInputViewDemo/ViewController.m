//
//  ViewController.m
//  YZInputViewDemo
//
//  Created by yz on 16/8/1.
//  Copyright © 2016年 yz. All rights reserved.
//

#import "ViewController.h"
#import "YZInputView.h"
#import "Masonry.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHCons;
@property (weak, nonatomic) IBOutlet YZInputView *inputView;


@property (nonatomic, strong) UIView *ttcBackVIew;
@property (nonatomic, strong) YZInputView *ttcinputVIew;


@end

@implementation ViewController

-  (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self.view endEditing:YES];
    self.inputView.text = [NSString stringWithFormat:@"%@%@",self.inputView.text,@"erwer的还是开发环境"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 监听键盘弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
//    // 设置文本框占位文字
    _inputView.placeholder = @"小码哥 iOS培训 吖了个峥";
    _inputView.placeholderColor = [UIColor redColor];
    // 监听文本框文字高度改变
    _inputView.yz_textHeightChangeBlock = ^(NSString *text,CGFloat textHeight){
        // 文本框文字高度改变会自动执行这个【block】，可以在这【修改底部View的高度】
        // 设置底部条的高度 = 文字高度 + textView距离上下间距约束
        // 为什么添加10 ？（10 = 底部View距离上（5）底部View距离下（5）间距总和）
        _bottomHCons.constant = textHeight + 10;
    };
    // 设置文本框最大行数
    _inputView.maxNumberOfLines = 4;
    
    
    self.ttcBackVIew = [[UIView alloc]init];
    self.ttcBackVIew.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.ttcBackVIew];
    [self.ttcBackVIew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.with.offset(0);
        make.bottom.with.offset(-400);
        make.height.mas_equalTo(20);
    }];
    self.ttcinputVIew = [[YZInputView alloc]init];
    self.ttcinputVIew.font = [UIFont systemFontOfSize:14];
    self.ttcinputVIew.backgroundColor = [UIColor greenColor];
    [self.ttcBackVIew addSubview:self.ttcinputVIew];
    [self.ttcinputVIew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.with.offset(5);
        make.right.bottom.with.offset(-5);
    }];
    _ttcinputVIew.placeholder = @"小码哥 iOS培训 吖了个峥";
    _ttcinputVIew.placeholderColor = [UIColor redColor];
    // 监听文本框文字高度改变
    __weak typeof(self)weakSelf = self;
    _ttcinputVIew.yz_textHeightChangeBlock = ^(NSString *text,CGFloat textHeight){
        // 文本框文字高度改变会自动执行这个【block】，可以在这【修改底部View的高度】
        // 设置底部条的高度 = 文字高度 + textView距离上下间距约束
        // 为什么添加10 ？（10 = 底部View距离上（5）底部View距离下（5）间距总和）
        [weakSelf.ttcBackVIew mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(textHeight + 10);
        }];
    };
    // 设置文本框最大行数
    _ttcinputVIew.maxNumberOfLines = 4;
}

// 键盘弹出会调用
- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    // 获取键盘frame
    CGRect endFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 获取键盘弹出时长
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    
    // 修改底部视图距离底部的间距
    _bottomCons.constant = endFrame.origin.y != screenH?endFrame.size.height:0;
    
    // 约束动画
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

@end
