//
//  DDProgressHUD.h
//  DDProgressHUD
//
//  Created by mdd on 16/12/22.
//  Copyright © 2016年 coohua.mdd. All rights reserved.
//

/// 当前版本V1.0.2

#import <UIKit/UIKit.h>

@interface DDProgressHUD : UIView

#pragma mark - 全局设置方法，设置后会影响以后所有的显示
/// 遮罩颜色，默认为0x999999，alpha为0.6，具体参照：DDDefaultSetup.h为准
+ (void)setMaskviewColor:(UIColor *)color;
/// 点击maskview页面后，视图是否自动消失，默认不自动消失
+ (void)setMaskViewAutomaticHidden:(BOOL)isAuto;

/// 自定义旋转的图片
+ (void)setLoopImage:(UIImage *)image;
/// 控制旋转的速度：旋转一圈所用的时间，默认为1s，具体参照：DDDefaultSetup.h为准
+ (void)setLoopOneRingDuration:(CGFloat)duration;

/// 圆弧半径，默认为25，具体参照：DDDefaultSetup.h为准
+ (void)setForegroundRingRadius:(CGFloat)radius;
+ (void)setBackgroundRingRadius:(CGFloat)radius;
/// 圆弧线宽度，默认为3，具体参照：DDDefaultSetup.h为准
+ (void)setForegroundRingLineWidth:(CGFloat)width;
+ (void)setBackgroundRingLineWidth:(CGFloat)width;
/// 圆弧线颜色，默认为0xE0E0E0 0x333333，具体参照：DDDefaultSetup.h为准
+ (void)setForegroundRingLineColor:(UIColor *)color;
+ (void)setBackgroundRingLineColor:(UIColor *)color;

/// 设置圆角，默认为10，具体参照：DDDefaultSetup.h为准
+ (void)setBackgroundViewCornerRadius:(CGFloat)radius;
/// 设置背景颜色，默认为0xF0F0F0，具体参照：DDDefaultSetup.h为准
+ (void)setBackgroundViewColor:(UIColor *)color;
/// 设置字体，默认为偏好设置字体
+ (void)setFont:(UIFont *)font;

/**
 设置成功失败弹窗，最大展示时间与最小展示时间
 程序会根据文本长度来计算显示时间，如果计算的时间超出此范围，则为最大值或者最小值，默认为3s/10s，具体参照：DDDefaultSetup.h为准。应保证:Max >= Minimum
 */
+ (void)setMaxImageShowDuration:(CGFloat)duration;
+ (void)setMinimumImageShowDuration:(CGFloat)duration;
/// 默认每个文字0.2s，具体参照：DDDefaultSetup.h为准
+ (void)setEveryWordShowDuration:(CGFloat)duration;
#pragma mark - 展示方法
/**************************************************************************************
 三种类别的展示方法：
 1.展示无限循化的图片，不会自动消失，需要调用dismiss函数；
 2.显示进度，也不会自动消失，需要调用dismiss函数;
 3.显示弹窗图片，会自动消失，时间根据要显示文字的长短计算，计算的结果会限定在上面的全局设置最大和最小时间内
 **************************************************************************************/

/**
 显示不停旋转的"圈"
 */
+ (void)show;

/**
 显示不停旋转的"圈"，和文字信息
 
 @param status 要显示的文字信息
 */
+ (void)showWithStatus:(NSString *)status;

/**
 显示不停旋转的"圈"，状态描述

 @param status 要显示的描述
 @param duration 显示的时间，之后自动消失
 */
+ (void)showWithStatus:(NSString *)status andDuration:(NSTimeInterval)duration;

/**
 显示进度，不会自动消失，需要调用隐藏方法

 @param progress 取值范围0~1
 */
+ (void)showProgress:(CGFloat)progress;

/**
 显示进度，和一段描述，不会自动消失，需要调用隐藏方法

 @param progress 取值范围0~1
 @param status 描述文字
 */
+ (void)showProgress:(CGFloat)progress withStatus:(NSString *)status;

/**
 展示默认成功状态的图片
 */
+ (void)showSuccessImage;

/**
 展示默认成功状态图片和info
 @param info 显示的文字信息
 */
+ (void)showSuccessImageWithInfo:(NSString *)info;

/**
 展示默认错误状态的图片
 */
+ (void)showErrorImage;

/**
 展示默认错误状态的图片和文字信息

 @param info 展示的文字信息
 */
+ (void)showErrorImageWithInfo:(NSString *)info;

/**
 显示自定义图片和文字信息，视图大小会根据文字和图片的大小自动调整

 @param image 本次要显示的图片，此图片不会对以后产生影响
 @param info 显示的文字信息
 */
+ (void)showImage:(UIImage *)image andInfo:(NSString *)info;

/**
 显示自定义图片和文字信息时间到后自动消失，视图大小会根据文字和图片的大小自动调整

 @param image 本次要显示的图片，此图片不会对以后产生影响
 @param info 显示的文字
 @param duration 本次显示的时间，之后视图自动消失
 */
+ (void)showImage:(UIImage *)image andInfo:(NSString *)info andDuration:(CGFloat)duration;

/**
 将view显示在最前端（弹窗）,高度自定义，不建议使用
 
 @param view 将要显示的view，这里的view会被添加到maskview上（window），需要自己计算frame
 @param duration 将被显示的时间，如果为0则一直显示，直到调用dismiss相关函数
 */
+ (void)showWithView:(UIView *)view andDuration:(NSTimeInterval)duration;

#pragma mark - 隐藏方法

/**
 隐藏最近一次显示的视图
 */
+ (void)dismiss;

@end

#pragma mark - 系统加载进度条（小菊花）显示在调用者上面
/********************************* UIView扩展 ***************************************/

@interface UIView (DDActivityView)

/**
 将DDProgressHUD无限循环动画添加到view

 @return 返回DDProgressHUD实例
 */
- (UIActivityIndicatorView *)showActivityView;


/**
 将最顶层的ActivityView从父视图删除，如果添加了多次则只会删除最顶层!

 @return 找到并删除成功返回YES，否则NO
 */
- (BOOL)hiddenActivityView;
@end
