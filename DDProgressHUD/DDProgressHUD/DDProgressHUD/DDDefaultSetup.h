//
//  DDDefaultSetup.h
//  DDProgressHUD
//
//  Created by mdd on 16/12/17.
//  Copyright © 2016年 coohua.mdd. All rights reserved.
//

#ifndef DDDefaultSetup_h
#define DDDefaultSetup_h

#pragma mark - DDMaskView，遮罩默认设置

/// 遮罩默认不透明度
#define kMaskViewAlpha              0.6f
/// 遮罩默认颜色
#define kMaskViewBackgroundColorRGB 0x999999
/// 默认展示动画时间
#define kShowAnimateDuration        0.2f
/// 默认隐藏动画时间
#define kDismissAnimateDuration     0.2f

#pragma mark - DDProgressAnimateView，进度条默认设置
/// 进度圆环线半径大小
#define kRingRadius                 25.0f
/// 进度圆环线宽度
#define kRingLineWidth              3.0f
/// 进度圆环颜色
#define kForegroundRingLineColorRGB 0x333333
#define kBackgroundRingLineColorRGB 0xE0E0E0

#pragma mark - DDInfiniteLoopView，无限循环图片设置
///  无限循环动画旋转一周的时间，默认1秒
#define kOneRoundDuration           1.0f

/// 圆角半径
#define kCornerRadius               10
///
#define kHudColor                   0xF0F0F0

#define kDDMaxImageShowDuration     10.0f
#define kDDMinimumImageShowDuration 3.0f
/// 每个文字显示时间
#define kEveryWordShowDuration      0.2f

/*********************************下面的设置最好不要动*********************************/

/// hud最大宽度与屏幕宽度比例
#define kMaxWidthRatioScreenWidth   (2.0/3.0)
/// hud最大高度与屏幕高度比例
#define kMaxHeightRatioScreenHeight (2.0/3.0)
/// hud最小宽高比，避免hud显得太瘦，使用者可以通过将文本换行(\n\r)来避免太胖
#define kMinimumWidthRatioHeight    0.95

/// 图片与文字之间的间隙（竖直方向）
#define kViewMargin                 12
/// 与父视图间隙
#define kTopAndBottomMargin         16
/// 与父视图间隙
#define kLeftAndRightMargin         16


#endif /* DDDefaultSetup_h */
