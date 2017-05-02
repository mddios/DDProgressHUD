//
//  DDInfiniteLoopView.m
//  DDProgressHUD
//
//  Created by mdd on 16/12/22.
//  Copyright © 2016年 coohua.mdd. All rights reserved.
//

#import "DDInfiniteLoopView.h"
#import "DDDefaultSetup.h"
#import "DDProgressHUD.h"

@interface DDInfiniteLoopView()
@property (nonatomic, strong) CALayer *imgLayer;
@end

@implementation DDInfiniteLoopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _duration = kOneRoundDuration;
        NSURL *url = [[NSBundle bundleForClass:[DDProgressHUD class]] URLForResource:@"DDProgressHUD" withExtension:@"bundle"];
        NSBundle *imageBundle = [NSBundle bundleWithURL:url];
        NSString *path = [imageBundle pathForResource:@"infiniteLoop@2x" ofType:@"png"];
        if ([UIScreen mainScreen].scale >= (3 - 0.01)) {
            path = [imageBundle pathForResource:@"infiniteLoop@3x" ofType:@"png"];
        }
        _loopImg = [UIImage imageWithContentsOfFile:path];
        [self addLoopImageLayer];
    }
    return self;
}

/**
 处于view的中间位置，大小为image的大小
 */
- (void)addLoopImageLayer {
    if (self.imgLayer.superlayer) {
        [self.imgLayer removeFromSuperlayer];
        self.imgLayer = nil;
    }
    CALayer *imgLayer = [[CALayer alloc] init];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"Action_Refresh" ofType:@".png"];
    imgLayer.contents = (__bridge id)[self.loopImg CGImage];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.fromValue = [NSNumber numberWithDouble:-M_PI_2];
    animation.toValue = [NSNumber numberWithDouble:3 * M_PI_2];
    animation.duration = self.duration;
    // 线性匀速
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.removedOnCompletion = NO;
    animation.repeatCount = INFINITY;
    // 保持动画的结束状态
    animation.fillMode = kCAFillModeForwards;
    [imgLayer addAnimation:animation forKey:@"animateTransform"];
    
    // 大小根据img决定，位于中间
    CGFloat w = self.loopImg.size.width;
    CGFloat h = self.loopImg.size.height;
    imgLayer.frame = CGRectMake((self.frame.size.width - w) / 2, (self.frame.size.height - h) / 2, w, h);
    [self.layer addSublayer:imgLayer];
    self.imgLayer = imgLayer;
}

#pragma mark - setter getter

/**
 设置属性时，会从新创建imgLayer
 */

/**
 设置属性时，会从新创建ringlayer
 */
- (void)setFrame:(CGRect)frame {
    if (!CGRectEqualToRect(frame, super.frame)) {
        [super setFrame:frame];
        [self addLoopImageLayer];
    }
}

- (void)setLoopImg:(UIImage *)loopImg {
    if (!loopImg) {
        return;
    }
    _loopImg = loopImg;
    [self addLoopImageLayer];
}

- (void)setDuration:(CGFloat)duration {
    // 可以对小的数做一个处理
    _duration = duration;
    [self addLoopImageLayer];
}

@end
