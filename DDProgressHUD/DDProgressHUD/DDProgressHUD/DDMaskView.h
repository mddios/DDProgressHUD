//
//  DDMaskView.h
//  DDProgressHUD
//
//  Created by mdd on 16/12/17.
//  Copyright © 2016年 coohua.mdd. All rights reserved.
//

#import <UIKit/UIKit.h>

static const NSNotificationName DDMaskViewDidClicked = @"DDMaskViewDidClicked";

@interface DDMaskView : UIControl

/// 点击页面后，是否自动消失
@property (nonatomic, assign) BOOL isHiddenAutomatic;

- (void)show;
- (void)dismiss;

/**
 显示规定时间后自动消失

 @param duration 显示时间
 */
+ (void)showWithSubview:(UIView *)subview andTime:(NSTimeInterval) duration;
@end
