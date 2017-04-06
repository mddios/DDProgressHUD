//
//  DDMaskView.m
//  DDProgressHUD
//
//  Created by mdd on 16/12/17.
//  Copyright © 2016年 coohua.mdd. All rights reserved.
//

#import "DDMaskView.h"
#import "DDDefaultSetup.h"

@implementation DDMaskView


/**
 将frame写死
 */
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:[[[UIApplication sharedApplication] delegate] window].bounds]) {
        self.alpha = 0;
        self.backgroundColor = [UIColor colorWithRed:((kMaskViewBackgroundColorRGB >> 16) & 0xFF) / 255.0 green:((kMaskViewBackgroundColorRGB >> 8) & 0xFF) / 255.0 blue:(kMaskViewBackgroundColorRGB & 0xFF) / 255.0 alpha:kMaskViewAlpha];
        [self addTarget:self action:@selector(maskviewDidClicked) forControlEvents:UIControlEventTouchUpInside];
        _isHiddenAutomatic = NO;
    }
    return self;
}

- (void)show {
    if (!self.superview) {
        self.alpha = 0;
        [self addToWindow];
        [UIView animateWithDuration:kShowAnimateDuration animations:^{
            self.alpha = 1;
        }];
    } else {
        [self.superview bringSubviewToFront:self];
    }
}

- (void)dismiss {
    if (self.superview) {
        [UIView animateWithDuration:kDismissAnimateDuration animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

- (void)maskviewDidClicked {
    [[NSNotificationCenter defaultCenter] postNotificationName:DDMaskViewDidClicked object:nil];
    if (self.isHiddenAutomatic) {
        [self dismiss];
    }
}

+ (void)showWithSubview:(UIView *)subview {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        DDMaskView *maskview = [[self alloc] init];
        [maskview addSubview:subview];
        [maskview show];
    }];
}

+ (void)showWithSubview:(UIView *)subview andTime:(NSTimeInterval) duration {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        DDMaskView *maskview = [[self alloc] init];
        [maskview addSubview:subview];
        [maskview show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [maskview dismiss];
        });
    }];
}

- (void)addToWindow {
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
        if(windowOnMainScreen && windowIsVisible && windowLevelNormal) {
            [window addSubview:self];
            break;
        }
    }
}

@end
