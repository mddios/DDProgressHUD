//
//  DDProgressHUD.m
//  DDProgressHUD
//
//  Created by mdd on 16/12/22.
//  Copyright © 2016年 coohua.mdd. All rights reserved.
//

#import "DDProgressHUD.h"
#import "DDDefaultSetup.h"
#import "DDMaskView.h"
#import "DDProgressAnimateView.h"
#import "DDInfiniteLoopView.h"

@interface DDProgressHUD() {
    CGFloat _minimumImageShowDuration;
    CGFloat _maxImageShowDuration;
    CGFloat _everyWordShowDuration;
}

@property (nonatomic, strong) DDMaskView *maskView;
@property (nonatomic, strong) DDInfiniteLoopView *infiniteLoopView;
@property (nonatomic, strong) DDProgressAnimateView *foregroundRingProgressView;
@property (nonatomic, strong) DDProgressAnimateView *backgroundRingProgressView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIImageView *infoImageView;
//@property (nonatomic, strong) UIImage *errorImage;
//@property (nonatomic, strong) UIImage *successImage;

@property (nonatomic, strong) UILabel *statusLbl;
@property (nonatomic, strong) NSTimer *durationTimer;

@property (nonatomic, strong) UIFont *font;

@end

@implementation DDProgressHUD

+ (DDProgressHUD *)shareProgress {
    static DDProgressHUD *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DDProgressHUD alloc] initWithFrame:[[[UIApplication sharedApplication] delegate] window].bounds];
    });
    return instance;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 默认采用偏好设置 小标题字体样式
        _font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        _maxImageShowDuration = kDDMaxImageShowDuration;
        _minimumImageShowDuration = kDDMinimumImageShowDuration;
        _everyWordShowDuration = kEveryWordShowDuration;
    }
    return self;
}

+ (void)show {
    [self showWithStatus:nil];
}

+ (void)showWithStatus:(NSString *)status {
    [self showWithStatus:status andDuration:0];
}

+ (void)showWithStatus:(NSString *)status andDuration:(NSTimeInterval)duration{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        DDProgressHUD *hud = [DDProgressHUD shareProgress];
        // 如果没有str则为0
        CGFloat viewMargin = kViewMargin;
        CGRect lblBound = CGRectZero;
        // lbl最大的宽高
        CGSize lblSize = (CGSize){[UIScreen mainScreen].bounds.size.width  * kMaxWidthRatioScreenWidth,[UIScreen mainScreen].bounds.size.height * kMaxHeightRatioScreenHeight};
        if (status) {
            // 根据计算字符串尺寸
            lblBound = [status boundingRectWithSize:lblSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: hud.statusLbl.font} context:NULL];
        } else {
            viewMargin = 0;
        }
        CGSize loopImgSize = hud.infiniteLoopView.loopImg.size;
        
        // 根据loopImgSize与lblBound计算frame
        CGFloat hudHeight = kTopAndBottomMargin + loopImgSize.height + viewMargin + CGRectGetHeight(lblBound) + kTopAndBottomMargin;
        CGFloat hudWidth = MAX(loopImgSize.width, CGRectGetWidth(lblBound)) + kLeftAndRightMargin * 2;
        
        // 如果太瘦，则对宽高做处理
        if (hudWidth / hudHeight < kMinimumWidthRatioHeight) {
            if (hudHeight * kMinimumWidthRatioHeight <= lblSize.width) {
                hudWidth = hudHeight * kMinimumWidthRatioHeight;
            }
        }
        
        [hud.backgroundView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        if (status) {
            hud.statusLbl.text = status;
            [hud.backgroundView addSubview:hud.statusLbl];
        }
        hud.infiniteLoopView.frame = CGRectMake((hudWidth - loopImgSize.width) / 2, kTopAndBottomMargin, loopImgSize.width, loopImgSize.height);
        hud.statusLbl.frame = CGRectMake((hudWidth - lblBound.size.width) / 2, kTopAndBottomMargin + loopImgSize.height + viewMargin, lblBound.size.width, lblBound.size.height);
        hud.backgroundView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - hudWidth) / 2, ([UIScreen mainScreen].bounds.size.height - hudHeight) / 2, hudWidth, hudHeight);
        
        [hud.backgroundView addSubview:hud.infiniteLoopView];
        
        [hud showWithView:hud.backgroundView andDuration:duration];
    }];
}

+ (void)showProgress:(CGFloat)progress {
    [self showProgress:progress withStatus:nil];
}

/**
 每次都会计算frame
 */
+ (void)showProgress:(CGFloat)progress withStatus:(NSString *)status {
    if (progress >= 1) {
        progress = 1;
    }
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        DDProgressHUD *hud = [DDProgressHUD shareProgress];
        CGFloat viewMargin = kViewMargin;
        CGRect lblBound = CGRectZero;
        // lbl最大的宽高
        CGSize lblSize = (CGSize){[UIScreen mainScreen].bounds.size.width  * kMaxWidthRatioScreenWidth,[UIScreen mainScreen].bounds.size.height * kMaxHeightRatioScreenHeight};
        if (status) {
            // 根据计算字符串尺寸
            lblBound = [status boundingRectWithSize:lblSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: hud.statusLbl.font} context:NULL];
        } else {
            viewMargin = 0;
        }
        
        CGSize ringViewSize = (CGSize){hud.foregroundRingProgressView.ringRadius * 2 + hud.foregroundRingProgressView.ringLineWidth, hud.foregroundRingProgressView.ringRadius * 2 + hud.foregroundRingProgressView.ringLineWidth};
        
        CGFloat hudHeight = kTopAndBottomMargin + ringViewSize.height + viewMargin + CGRectGetHeight(lblBound) + kTopAndBottomMargin;
        CGFloat hudWidth = MAX(ringViewSize.width, CGRectGetWidth(lblBound)) + kLeftAndRightMargin * 2;
        
        // 如果太瘦，则对宽高做处理
        if (hudWidth / hudHeight < kMinimumWidthRatioHeight) {
            if (hudHeight * kMinimumWidthRatioHeight <= lblSize.width) {
                hudWidth = hudHeight * kMinimumWidthRatioHeight;
            }
        }

        [hud.backgroundView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        if (status) {
            hud.statusLbl.text = status;
            [hud.backgroundView addSubview:hud.statusLbl];
        }
        hud.backgroundRingProgressView.frame = CGRectMake((hudWidth - ringViewSize.width) / 2, kTopAndBottomMargin, ringViewSize.width, ringViewSize.height);
        hud.foregroundRingProgressView.frame = CGRectMake((hudWidth - ringViewSize.width) / 2, kTopAndBottomMargin, ringViewSize.width, ringViewSize.height);
        hud.statusLbl.frame = CGRectMake((hudWidth - lblBound.size.width) / 2, kTopAndBottomMargin + ringViewSize.height + viewMargin, lblBound.size.width, lblBound.size.height);
        hud.backgroundView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - hudWidth) / 2, ([UIScreen mainScreen].bounds.size.height - hudHeight) / 2, hudWidth, hudHeight);
        hud.foregroundRingProgressView.progress = progress;
        
        [hud.backgroundView addSubview:hud.backgroundRingProgressView];
        [hud.backgroundView addSubview:hud.foregroundRingProgressView];
        [hud showWithView:hud.backgroundView andDuration:0];
    }];
}

+ (void)showSuccessImage {
    NSURL *url = [[NSBundle bundleForClass:[DDProgressHUD class]] URLForResource:@"DDProgressHUD" withExtension:@"bundle"];
    NSBundle *imageBundle = [NSBundle bundleWithURL:url];
    NSString *path = [imageBundle pathForResource:@"success@2x" ofType:@"png"];
    if ([UIScreen mainScreen].scale >= (3 - 0.01)) {
        path = [imageBundle pathForResource:@"success@3x" ofType:@"png"];
    }
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    [self showImage:image andInfo:nil andDuration:[self shareProgress]->_minimumImageShowDuration];
}

+ (void)showSuccessImageWithInfo:(NSString *)info {
    NSURL *url = [[NSBundle bundleForClass:[DDProgressHUD class]] URLForResource:@"DDProgressHUD" withExtension:@"bundle"];
    NSBundle *imageBundle = [NSBundle bundleWithURL:url];
    NSString *path = [imageBundle pathForResource:@"success@2x" ofType:@"png"];
    if ([UIScreen mainScreen].scale >= (3 - 0.01)) {
        path = [imageBundle pathForResource:@"success@3x" ofType:@"png"];
    }
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    CGFloat duration = info.length * [self shareProgress]->_everyWordShowDuration;
    duration = MAX(duration, [self shareProgress]->_minimumImageShowDuration);
    duration = MIN(duration, [self shareProgress]->_maxImageShowDuration);
    [self showImage:image andInfo:info andDuration:duration];
}

+ (void)showErrorImage {
    NSURL *url = [[NSBundle bundleForClass:[DDProgressHUD class]] URLForResource:@"DDProgressHUD" withExtension:@"bundle"];
    NSBundle *imageBundle = [NSBundle bundleWithURL:url];
    NSString *path = [imageBundle pathForResource:@"error@2x" ofType:@"png"];
    if ([UIScreen mainScreen].scale >= (3 - 0.01)) {
        path = [imageBundle pathForResource:@"error@3x" ofType:@"png"];
    }
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    [self showImage:image andInfo:nil andDuration:[self shareProgress]->_minimumImageShowDuration];
}

+ (void)showErrorImageWithInfo:(NSString *)info {
    NSURL *url = [[NSBundle bundleForClass:[DDProgressHUD class]] URLForResource:@"DDProgressHUD" withExtension:@"bundle"];
    NSBundle *imageBundle = [NSBundle bundleWithURL:url];
    NSString *path = [imageBundle pathForResource:@"error@2x" ofType:@"png"];
    if ([UIScreen mainScreen].scale >= (3 - 0.01)) {
        path = [imageBundle pathForResource:@"error@3x" ofType:@"png"];
    }
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    CGFloat duration = info.length * [self shareProgress]->_everyWordShowDuration;
    duration = MAX(duration, [self shareProgress]->_minimumImageShowDuration);
    duration = MIN(duration, [self shareProgress]->_maxImageShowDuration);
    [self showImage:image andInfo:info andDuration:duration];
}

+ (void)showImage:(UIImage *)image andInfo:(NSString *)info {
    CGFloat duration = info.length * [self shareProgress]->_everyWordShowDuration;
    duration = MAX(duration, [self shareProgress]->_minimumImageShowDuration);
    duration = MIN(duration, [self shareProgress]->_maxImageShowDuration);
    [self showImage:image andInfo:info andDuration:duration];
}

+ (void)showImage:(UIImage *)image andInfo:(NSString *)info andDuration:(CGFloat)duration {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        DDProgressHUD *hud = [DDProgressHUD shareProgress];
        CGFloat viewMargin = kViewMargin;
        CGRect lblBound = CGRectZero;
        // lbl最大的宽高
        CGSize lblSize = (CGSize){[UIScreen mainScreen].bounds.size.width  * kMaxWidthRatioScreenWidth,[UIScreen mainScreen].bounds.size.height * kMaxHeightRatioScreenHeight};
        if (info) {
            // 根据计算字符串尺寸
            lblBound = [info boundingRectWithSize:lblSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: hud.statusLbl.font} context:NULL];
        } else {
            viewMargin = 0;
        }
        
        CGFloat hudHeight = kTopAndBottomMargin + image.size.height + viewMargin + CGRectGetHeight(lblBound) + kTopAndBottomMargin;
        CGFloat hudWidth = MAX(image.size.width, CGRectGetWidth(lblBound)) + kLeftAndRightMargin * 2;
        
        // 如果太瘦，则对宽高做处理
        if (hudWidth / hudHeight < kMinimumWidthRatioHeight) {
            if (hudHeight * kMinimumWidthRatioHeight <= lblSize.width) {
                hudWidth = hudHeight * kMinimumWidthRatioHeight;
            }
        }

        [hud.backgroundView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        if (info) {
            hud.statusLbl.text = info;
            [hud.backgroundView addSubview:hud.statusLbl];
        }
        hud.infoImageView.image = image;
        hud.infoImageView.frame = CGRectMake((hudWidth - image.size.width) / 2, kTopAndBottomMargin, image.size.width, image.size.height);
        hud.statusLbl.frame = CGRectMake((hudWidth - lblBound.size.width) / 2, kTopAndBottomMargin + image.size.height + viewMargin, lblBound.size.width, lblBound.size.height);
        hud.backgroundView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - hudWidth) / 2, ([UIScreen mainScreen].bounds.size.height - hudHeight) / 2, hudWidth, hudHeight);
        
        [hud.backgroundView addSubview:hud.infoImageView];
        [hud showWithView:hud.backgroundView andDuration:duration];
    }];
}

+ (void)showWithView:(UIView *)view andDuration:(NSTimeInterval)duration {
    /// 在主线程，与其它类方法保持一致，保证顺序执行
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[self shareProgress] showWithView:view andDuration:duration];
    }];
}

+ (void)dismiss {
    [[self shareProgress] dismissWithDelay:0];
}

- (void)dismiss {
    [self dismissWithDelay:0];
}

/**
 显示最终均会调用此函数，显示view

 @param view 将被添加到superView即maskview
 @param duration 将被显示的时间，如果为0则一直显示，直到调用dismiss相关函数
 */
- (void)showWithView:(UIView *)view andDuration:(NSTimeInterval)duration {
    // DDProgressHUD为单利，可以不用weak，但应有较好的编程习惯
    __weak DDProgressHUD *weakSelf = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        __strong DDProgressHUD *strongSelf = weakSelf;
        if (![view.superview isMemberOfClass:[DDMaskView class]]) {
            [strongSelf.maskView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [strongSelf.maskView addSubview:view];
        }
        [strongSelf.maskView show];
        if (duration > 0) {
            strongSelf.durationTimer = [NSTimer timerWithTimeInterval:duration target:strongSelf selector:@selector(dismiss) userInfo:nil repeats:NO];
            [[NSRunLoop mainRunLoop] addTimer:strongSelf.durationTimer forMode:NSRunLoopCommonModes];
        } else {
            // 防止被上次的影响
            [strongSelf.durationTimer invalidate];
            strongSelf.durationTimer = nil;
        }
    }];
}


/**
 取消显示最终调用函数

 @param delay 等待多长时间后取消显示，单位秒
 */
- (void)dismissWithDelay:(NSTimeInterval)delay {
    // 如果已经取消，则直接返回
    if (!self.maskView.superview) {
        return;
    }
    __weak DDProgressHUD *weakSelf = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        __strong DDProgressHUD *strongSelf = weakSelf;
        if (strongSelf) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [strongSelf.maskView dismiss];
                [strongSelf.backgroundView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                if (strongSelf.backgroundView.superview) {
                    [strongSelf.backgroundView removeFromSuperview];
                }
            });
        }
    }];
}

#pragma mark - set 设置

/// 因为此类为单利，且强引用了对应的view，所以这里设置后

+ (void)setMaskviewColor:(UIColor *)color {
    [self shareProgress].maskView.backgroundColor = color;
}

+ (void)setLoopImage:(UIImage *)image {
    [self shareProgress].infiniteLoopView.loopImg = image;
}

+ (void)setLoopOneRingDuration:(CGFloat)duration {
    [self shareProgress].infiniteLoopView.duration = duration;
}

+ (void)setBackgroundViewCornerRadius:(CGFloat)radius {
    [self shareProgress].backgroundView.layer.cornerRadius = radius;
}

+ (void)setBackgroundViewColor:(UIColor *)color {
    [self shareProgress].backgroundView.backgroundColor = color;
}

+ (void)setFont:(UIFont *)font {
    [self shareProgress].font = font;
}

+ (void)setForegroundRingRadius:(CGFloat)radius {
    [self shareProgress].foregroundRingProgressView.ringRadius = radius;
}

+ (void)setForegroundRingLineWidth:(CGFloat)width {
    [self shareProgress].foregroundRingProgressView.ringLineWidth = width;
}

+ (void)setForegroundRingLineColor:(UIColor *)color {
    [self shareProgress].foregroundRingProgressView.ringLineColor = color;
}

+ (void)setBackgroundRingRadius:(CGFloat)radius {
    [self shareProgress].backgroundRingProgressView.ringRadius = radius;
}

+ (void)setBackgroundRingLineWidth:(CGFloat)width {
    [self shareProgress].backgroundRingProgressView.ringLineWidth = width;
}

+ (void)setBackgroundRingLineColor:(UIColor *)color {
    [self shareProgress].backgroundRingProgressView.ringLineColor = color;
}

+ (void)setMaskViewAutomaticHidden:(BOOL)isAuto {
    [self shareProgress].maskView.isHiddenAutomatic = isAuto;
}

+ (void)setMinimumImageShowDuration:(CGFloat)duration {
    [self shareProgress]->_minimumImageShowDuration = duration;
}

+ (void)setMaxImageShowDuration:(CGFloat)duration {
    [self shareProgress]->_maxImageShowDuration = duration;
}

+ (void)setEveryWordShowDuration:(CGFloat)duration {
    [self shareProgress]->_everyWordShowDuration = duration;
}

#pragma mark - getter setter

- (DDInfiniteLoopView *)infiniteLoopView {
    if (!_infiniteLoopView) {
        DDInfiniteLoopView *loopView = [[DDInfiniteLoopView alloc] init];
        _infiniteLoopView = loopView;
    }
    return _infiniteLoopView;
}

- (UILabel *)statusLbl {
    if (!_statusLbl) {
        UILabel *lbl = [[UILabel alloc] init];
        lbl.numberOfLines = 0;
        lbl.backgroundColor = [UIColor clearColor];
        lbl.adjustsFontSizeToFitWidth = YES;
        lbl.textAlignment = NSTextAlignmentCenter;
        _statusLbl = lbl;
    }
    if (_statusLbl) {
        _statusLbl.font = self.font;
    }
    return _statusLbl;
}

- (void)setDurationTimer:(NSTimer *)durationTimer {
    if (_durationTimer) {
        [_durationTimer invalidate];
        _durationTimer = nil;
    }
    _durationTimer = durationTimer;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[DDMaskView alloc] init];
    }
    return _maskView;
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.layer.masksToBounds = YES;
        _backgroundView.layer.cornerRadius = kCornerRadius;
        _backgroundView.backgroundColor = [UIColor colorWithRed:((kHudColor >> 16) & 0xFF) / 255.0 green:((kHudColor >> 8) & 0xFF) / 255.0 blue:(kHudColor & 0xFF) / 255.0 alpha:1];
    }
    return _backgroundView;
}

- (DDProgressAnimateView *)foregroundRingProgressView {
    if (!_foregroundRingProgressView) {
        _foregroundRingProgressView = [[DDProgressAnimateView alloc] init];
        _foregroundRingProgressView.ringLineColor = [UIColor colorWithRed:((kForegroundRingLineColorRGB >> 16) & 0xFF) / 255.0 green:((kForegroundRingLineColorRGB >> 8) & 0xFF) / 255.0 blue:(kForegroundRingLineColorRGB & 0xFF) / 255.0 alpha:1.0];
    }
    return _foregroundRingProgressView;
}

- (DDProgressAnimateView *)backgroundRingProgressView {
    if (!_backgroundRingProgressView) {
        _backgroundRingProgressView = [[DDProgressAnimateView alloc] init];
        _backgroundRingProgressView.ringLineColor = [UIColor colorWithRed:((kBackgroundRingLineColorRGB >> 16) & 0xFF) / 255.0 green:((kBackgroundRingLineColorRGB >> 8) & 0xFF) / 255.0 blue:(kBackgroundRingLineColorRGB & 0xFF) / 255.0 alpha:1.0];
        _backgroundRingProgressView.progress = 1;
    }
    return _backgroundRingProgressView;
}

- (UIImageView *)infoImageView {
    if (!_infoImageView) {
        _infoImageView = [[UIImageView alloc] init];
    }
    return _infoImageView;
}

//- (UIImage *)successImage {
//    if (!_successImage) {
//        NSURL *url = [[NSBundle bundleForClass:[DDProgressHUD class]] URLForResource:@"DDProgressHUD" withExtension:@"bundle"];
//        NSBundle *imageBundle = [NSBundle bundleWithURL:url];
//        NSString *path = [imageBundle pathForResource:@"success" ofType:@"png"];
//        _successImage = [UIImage imageWithContentsOfFile:path];
//    }
//    return _successImage;
//}
//
//- (UIImage *)errorImage {
//    if (!_errorImage) {
//        NSURL *url = [[NSBundle bundleForClass:[DDProgressHUD class]] URLForResource:@"DDProgressHUD" withExtension:@"bundle"];
//        NSBundle *imageBundle = [NSBundle bundleWithURL:url];
//        NSString *path = [imageBundle pathForResource:@"error" ofType:@"png"];
//        _errorImage = [UIImage imageWithContentsOfFile:path];
//    }
//    return _errorImage;
//}

@end

@implementation UIView (DDActivityView)
- (UIActivityIndicatorView *)showActivityView {
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activity.frame = self.bounds;
    // 设置菊花颜色
//    activity.color = [UIColor grayColor];
    [activity startAnimating];
    [self addSubview:activity];
    return activity;
}

- (BOOL)hiddenActivityView {
    NSEnumerator *enums = [self.subviews reverseObjectEnumerator];
    for (UIView *subview in enums) {
        if ([subview isKindOfClass:[UIActivityIndicatorView class]]) {
            UIActivityIndicatorView *activity = (UIActivityIndicatorView *)subview;
            activity.hidden = YES;
            [activity stopAnimating];
            [activity removeFromSuperview];
            return YES;
        }
    }
    return NO;
}

@end
