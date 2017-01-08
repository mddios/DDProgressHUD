//
//  DDInfiniteLoopView.h
//  DDProgressHUD
//
//  Created by mdd on 16/12/22.
//  Copyright © 2016年 coohua.mdd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDInfiniteLoopView : UIView
/// 在这里可以自定义旋转的图像
@property (nonatomic, strong) UIImage *loopImg;
/// 转一圈所用的时间
@property (nonatomic, assign) CGFloat duration;
@end
