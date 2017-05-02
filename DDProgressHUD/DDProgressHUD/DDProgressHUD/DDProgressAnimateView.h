//
//  DDProgressAnimateView.h
//  DDProgressHUD
//
//  Created by mdd on 16/12/17.
//  Copyright © 2016年 coohua.mdd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDProgressAnimateView : UIView
/// 进度0-1
@property (nonatomic, assign) CGFloat progress;
/// 圆弧半径
@property (nonatomic, assign) CGFloat ringRadius;
/// 圆弧线宽度
@property (nonatomic, assign) CGFloat ringLineWidth;
/// 圆弧线颜色
@property (nonatomic, strong) UIColor *ringLineColor;
@end
