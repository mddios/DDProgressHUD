//
//  DDProgressAnimateView.m
//  DDProgressHUD
//
//  Created by mdd on 16/12/17.
//  Copyright © 2016年 coohua.mdd. All rights reserved.
//

#import "DDProgressAnimateView.h"
#import "DDDefaultSetup.h"

@interface DDProgressAnimateView()

/// 圆环图层
@property (nonatomic, strong) CAShapeLayer *ringLayer;

@end

@implementation DDProgressAnimateView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _ringRadius = kRingRadius;
        _ringLineWidth = kRingLineWidth;
        _ringLineColor = [UIColor colorWithRed:((kForegroundRingLineColorRGB >> 16) & 0xFF) / 255.0 green:((kForegroundRingLineColorRGB >> 8) & 0xFF) / 255.0 blue:(kForegroundRingLineColorRGB & 0xFF) / 255.0 alpha:1.0];
        _progress = 0;
        self.backgroundColor = [UIColor clearColor];
        // 确定layer的位置
        [self addRingLayerToSuperLayer];
    }
    return self;
}

/**
 每当属性改变时都调用
 */
- (void)addRingLayerToSuperLayer {
    if (_ringLayer.superlayer) {
        [_ringLayer removeFromSuperlayer];
        _ringLayer = nil;
    }
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.ringRadius, self.ringRadius) radius:self.ringRadius startAngle:-M_PI_2 endAngle:3*M_PI_2 clockwise:YES];
    CAShapeLayer *layer = [CAShapeLayer layer];
    
    layer.lineWidth = self.ringLineWidth;
    layer.strokeColor = self.ringLineColor.CGColor;
    layer.path = path.CGPath;
    layer.bounds = (CGRect){0,0,self.ringRadius * 2, self.ringRadius * 2};
    
    // 填充颜色，默认为black，nil为不填充
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    layer.strokeEnd = self.progress;
    [self.layer addSublayer:layer];
    _ringLayer = layer;
}

#pragma mark - getter setter

/**
 设置属性时，会从新创建ringlayer
 */
- (void)setFrame:(CGRect)frame {
    if(!CGRectEqualToRect(frame, super.frame)) {
        [super setFrame:frame];
        [self addRingLayerToSuperLayer];
    }
}

- (void)setRingLineWidth:(CGFloat)ringLineWidth {
    _ringLineWidth = ringLineWidth;
    _ringLayer.lineWidth = ringLineWidth;
    [self addRingLayerToSuperLayer];
}

- (void)setRingLineColor:(UIColor *)ringLineColor {
    _ringLineColor = ringLineColor;
    _ringLayer.strokeColor = ringLineColor.CGColor;
    [self addRingLayerToSuperLayer];
}

- (void)setRingRadius:(CGFloat)ringRadius {
    _ringRadius = ringRadius;
    [self addRingLayerToSuperLayer];
}

- (void)setProgress:(CGFloat)progress {
    if (progress > 1.0) {
        progress = 1.0;
    }
    _progress = progress;
    _ringLayer.strokeEnd = progress;
}

@end
