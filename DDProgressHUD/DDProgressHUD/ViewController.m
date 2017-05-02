//
//  ViewController.m
//  DDProgressHUD
//
//  Created by mdd on 16/12/17.
//  Copyright © 2016年 coohua.mdd. All rights reserved.
//

#import "ViewController.h"
#import "DDMaskView.h"
#import "DDProgressAnimateView.h"
#import "DDInfiniteLoopView.h"
#import "DDProgressHUD.h"

@interface ViewController () <UIAlertViewDelegate>{
    CGFloat _progress;
}
@property (weak, nonatomic) IBOutlet UITextField *statusText;
@property (nonatomic, copy) NSString *statusStr;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 点击maskview后视图自动消失
    [DDProgressHUD setMaskViewAutomaticHidden:YES];
    // 设置无限旋转的图片
//    [DDProgressHUD setLoopImage:[UIImage imageNamed:@"refresh"]];
    
    [self v101test];
}

#pragma mark - test

/**
 1.01版本解决下面的调用产生的问题，执行不同步
 */
- (void)v101test {
    //[DDProgressHUD show];
    //[DDProgressHUD dismiss];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [DDProgressHUD dismiss];
        [DDProgressHUD show];
    });
}

#pragma mark - action

- (IBAction)show:(UIButton *)sender {
    [self.statusText resignFirstResponder];
    [DDProgressHUD show];
}

- (IBAction)showWithStatus:(UIButton *)sender {
    [self.statusText resignFirstResponder];
    [DDProgressHUD showWithStatus:self.statusStr];
}

- (IBAction)showWithStatusAndDuration:(UIButton *)sender {
    [self.statusText resignFirstResponder];
    [DDProgressHUD showWithStatus:self.statusStr andDuration:1.0];
}

- (IBAction)showProgress:(UIButton *)sender {
    [self.statusText resignFirstResponder];
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    _progress = 0;
    self.timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(showProgress) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (IBAction)showProgressWithStatus:(UIButton *)sender {
    [self.statusText resignFirstResponder];
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    _progress= 0;
    self.timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(showProgressAndStatus) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (IBAction)showSuccessImage:(UIButton *)sender {
    [self.statusText resignFirstResponder];
    [DDProgressHUD showSuccessImage];
}

- (IBAction)showSuccessImageWithInfo:(UIButton *)sender {
    [self.statusText resignFirstResponder];
    [DDProgressHUD showSuccessImageWithInfo:self.statusStr];
}

- (IBAction)showErrorImage:(id)sender {
    [self.statusText resignFirstResponder];
    [DDProgressHUD showErrorImage];
}

- (IBAction)showErrorImageWithInfo:(id)sender {
    [self.statusText resignFirstResponder];
    [DDProgressHUD showErrorImageWithInfo:self.statusStr];
}

- (IBAction)showImageandInfo:(id)sender {
    [self.statusText resignFirstResponder];
    [DDProgressHUD showImage:[UIImage imageNamed:@"infoImage"] andInfo:@"自定义图片"];
}

- (IBAction)showImageAndInfoAndDuration:(id)sender {
    [self.statusText resignFirstResponder];
    [DDProgressHUD showImage:[UIImage imageNamed:@"infoImage"] andInfo:@"自定义图片，显示时间为2s" andDuration:2];
}

- (IBAction)showWithViewAndDuration:(UIButton *)sender {
    [self.statusText resignFirstResponder];
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 300) / 2, ([UIScreen mainScreen].bounds.size.height - 30) / 2, 300, 42)];
    lbl.text = @"自定义View，Frame需要使用者自己定义，当前显示在屏幕中间";
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.textColor = [UIColor whiteColor];
    lbl.backgroundColor = [UIColor grayColor];
    lbl.font = [UIFont systemFontOfSize:13];
    lbl.numberOfLines = 0;
    [DDProgressHUD showWithView:lbl andDuration:5];
}

- (IBAction)showActivityView:(UIButton *)sender {
    // 直接显示在view的中间位置
    [self.statusText resignFirstResponder];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(sender.frame.size.width - 100, 0, 100, sender.frame.size.height)];
    [sender addSubview:view];
    [view showActivityView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(50 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [view hiddenActivityView];
        [view removeFromSuperview];
    });
}

#pragma mark - 辅助函数

- (void)showProgressAndStatus {
    _progress += 0.05;
    NSString *str = @"Hello DDProgressHUD";
    if (_progress > 0.3) {
        str = @"这是一个文字长度可变的进度弹窗";
    }
    if (_progress > 0.6) {
        str = @"这是一个文字长度可变有空行的进度弹窗\n\r\n\r\n\r\n\r\n\r这是一个文字长度可变有空行的进度弹窗";
    }
    [DDProgressHUD showProgress:_progress withStatus:str];
    if (_progress > 1) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)showProgress {
    _progress += 0.1;
    [DDProgressHUD showProgress:_progress];
    if (_progress > 1) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (NSString *)statusStr {
    if (self.statusText.text.length == 0) {
        return @"Hello DDProgressHUD!";
    }
    return self.statusText.text;
}
@end
