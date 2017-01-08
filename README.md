# DDProgressHUD
Progress 进度条，UIActivityIndicatorView 小菊花，弹窗，状态显示，高度自定义

##DDProgressHUD的介绍

提供了四种类型的展示：

* 显示无限旋转的加载图（比如小菊花，可以自定义），显示文字信息。网络刷新时经常用到。

![loading图片](http://7xs4tc.com1.z0.glb.clouddn.com/FirstType_infiniteLoopImageInfo@2x.gif)

* 显示加载进度的动画，也可以显示文字。网络下载时用的比较多，加载网页时也可以用。

![进度提示动画](http://7xs4tc.com1.z0.glb.clouddn.com/secondTypeAnimate_ProgressInfo.gif)


* 与用户弹窗交互的弹窗，告知用户当前操作的状态，成功还是失败，显示一张图片和文字。图片和文字也都可自定义

![成功弹窗提示](http://7xs4tc.com1.z0.glb.clouddn.com/DDProgressHUDthirdType_successImageInfo.png)

![失败弹窗提示](http://7xs4tc.com1.z0.glb.clouddn.com/DDProgressHUDthirdType_errorImageInfo.png)

![自定义图片弹窗提示](http://7xs4tc.com1.z0.glb.clouddn.com/DDProgressHUDthirdType_customInageInfo.png)

* 可高度自定义的弹窗，将一个view显示在遮罩上面，相当于做了一个蒙版

![自定义图片](http://7xs4tc.com1.z0.glb.clouddn.com/DDProgressHUDfourthType_customView.png)

最后旋转的菊花，提供了一个view的扩展，将`UIActivityIndicatorView`小菊花显示在调用者中间位置。

![小菊花](http://7xs4tc.com1.z0.glb.clouddn.com/FiveAnimate_ActivityIndicatorView.gif)

##DDProgressHUD的简单使用与方法介绍
####准备

* 下载代码：使用很简单，将工程从github：[https://github.com/mddios/DDProgressHUD](https://github.com/mddios/DDProgressHUD)下载下来，将DDProgressHUD文件全部拖入工程
* 包含`DDProgressHUD.h`头文件即可使用
* 不用考虑线程的问题，主线程和非主线程均可以

工程现在下来可以看到是一个demo，点击上面的按钮就一目了然

> 为了方便管理与自定义，建议还是fork一份到自己的github

####简单使用与方法介绍
* 第一类显示提供三个类方法：无限循化的图片

```
/// 只显示图片，一直显示直到调用dismiss方法
+ (void)show;

/// 显示图片和文字，一直显示直到调用dismiss方法
+ (void)showWithStatus:(NSString *)status;

/// 很明显，显示时间由duration决定，当然，中途也可以调用dismiss方法来取消显示
+ (void)showWithStatus:(NSString *)status andDuration:(NSTimeInterval)duration;
```

* 第二类显示提供2个类方法：加载进度

```
/// 显示进度，不会自动消失，需要调用dismiss方法,progress 取值范围0~1
+ (void)showProgress:(CGFloat)progress;

/// 显示进度，和一段描述，不会自动消失，需要调用dismiss方法
+ (void)showProgress:(CGFloat)progress withStatus:(NSString *)status;

```

* 第三类显示提供6个类方法：弹窗，显示图片和文字

```
/// 成功弹窗，只显示图片，
+ (void)showSuccessImage;

/// 成功状态图片和info
+ (void)showSuccessImageWithInfo:(NSString *)info;

/// 错误弹窗，只显示图片
+ (void)showErrorImage;

/// 错误状态图片和info
+ (void)showErrorImageWithInfo:(NSString *)info;

/// 显示自定义图片和文字信息，视图大小会根据文字和图片的大小自动调整
+ (void)showImage:(UIImage *)image andInfo:(NSString *)info;

/// 显示自定义图片和文字信息时间到后自动消失，视图大小会根据文字和图片的大小自动调整
+ (void)showImage:(UIImage *)image andInfo:(NSString *)info andDuration:(CGFloat)duration;
```

**关于显示时间的问题：**会根据传入的Info长短来计算一个时间，然后和最大时间、最小时间做比较，防止超过预期值，最大最小值都可以程序设置，具体参照下面关于设置的介绍。

成功和失败的图片没有提供接口来替换，如果需要显示自定义的图片，上面也提供了方法。

当然你也将程序默认成功和失败的图片自己替换掉（在bundle中），程序会根据图片的大小来自动计算Frame，所以图片大小也不受限制，但是图片名字必须与默认的保持一致。

* 第四类显示：在maskview（相当于蒙版）上显示view，高度自定义

```
+ (void)showWithView:(UIView *)view andDuration:(NSTimeInterval)duration;
```
随意显示，和上面最大的不同就是，它的frame需要使用者自己定义与计算，HUD只是提供一个蒙版，还有就是点击蒙版后的操作（隐藏，发送通知，或者什么也不做）

* 最后，也算第五类吧

显示系统的菊花到view的中间，view的扩展方法

```
/// 将DDProgressHUD无限循环动画添加到view, @return 返回DDProgressHUD实例
- (UIActivityIndicatorView *)showActivityView;

/// 将最顶层的ActivityView从父视图删除，如果添加了多次则只会删除最顶层! @return 找到并删除成功返回YES，否则NO
- (BOOL)hiddenActivityView;
```

##DDProgressHUD的全局设置
设置有两种：

* 头文件里面的默认设置（宏定义），相当于初始化，全局有效。位置：`DDDefaultSetup.h`头文件
* 程序提供的类方法，会覆盖之前的设置，全局有效。接口头文件：`DDProgressHUD.h`

简单看下视图和对应的名称，还有层级

1. maskview显示在window上
2. DDProgressHUD（下面简称hud）的backgroundView
3. 大部分视图处于这一层级，比如上面提到的第一类、第二类、第三类显示的视图都在这个层级，下面示意图展示的是第二类：进度
* 3.1： 进度条的，有两个，黑色的为foregroundRing，灰色的为backgroundRing
* 3.2：显示的lbl

![](http://7xs4tc.com1.z0.glb.clouddn.com/viewLevelAndName.png)

也可以根据上面显示类别和view的层级关系，分为以下几种

####1 maskview，蒙版的设置
首先默认设置，一共有4个

```
/// 遮罩默认不透明度
#define kMaskViewAlpha              0.6f
/// 遮罩默认颜色
#define kMaskViewBackgroundColorRGB 0x999999

/// 默认展示动画时间
#define kShowAnimateDuration        0.2f
/// 默认隐藏动画时间
#define kDismissAnimateDuration     0.2f
```
前两个好理解，后面两个是展示maskview和隐藏时的动画时间，是对alpha做的动画。

对应类方法设置为：`(void)setMaskviewColor:(UIColor *)color`，颜色和透明度，一起设置。动画时间没有提供。

另外还有`setMaskViewAutomaticHidden:`，即点击蒙版后是否自动消失视图，即调用dismiss方法。无论YES或者NO，点击后都会发送一个通知`static const NSNotificationName DDMaskViewDidClicked = @"DDMaskViewDidClicked";`

####2 白色的背景设置

头文件默认设置

```
/// 圆角半径
#define kCornerRadius               10
#define kHudColor                   0xF0F0F0
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
```

* 与屏幕的宽高比：主要是计算字符串文字信息是给的限定，防止超过限制，从而显得不美观
* hud自身的宽高比：主要是避免显得太瘦，比如文字信息很短，就会现的很瘦，而太胖的话，可以对文字信息进行换行处理
* 还有间隙的设置：主要是针对hud的子view

类方法的设置：有的没有提供（比如宽高比，比如视图间隙）

```
/// 设置圆角，默认为10，具体参照：DDDefaultSetup.h为准
+ (void)setBackgroundViewCornerRadius:(CGFloat)radius;
/// 设置背景颜色，默认为0xF0F0F0，具体参照：DDDefaultSetup.h为准
+ (void)setBackgroundViewColor:(UIColor *)color;
/// 设置字体，默认为偏好设置字体
+ (void)setFont:(UIFont *)font;
```

####3 弹窗、无限旋转的图片、进度圈的设置

共同的设置，即文字（lbl）字体：

类方法：`setFont:`，默认设置为跟随偏好设置的小标题大小变化`[UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline]`

* **弹窗**

默认：

```
/// 最长10秒，最短3秒
#define kDDMaxImageShowDuration     10.0f
#define kDDMinimumImageShowDuration 3.0f
/// 每个文字显示时间
#define kEveryWordShowDuration      0.2f
```

类方法：

```
+ (void)setMaxImageShowDuration:(CGFloat)duration;
+ (void)setMinimumImageShowDuration:(CGFloat)duration;
/// 默认每个文字0.2s，具体参照：DDDefaultSetup.h为准
+ (void)setEveryWordShowDuration:(CGFloat)duration;
```

主要用于计算弹窗显示时间长短

* **无限旋转的图片**

默认：

```
/// 旋转一周所用的时间，控制旋转的速度
#define kOneRoundDuration           1.0f
```
类方法：多提供了旋转的图片设置，可以在这里设置，也可以直接将bundle里面的替换，替换后全局有效

```
/// 自定义旋转的图片
+ (void)setLoopImage:(UIImage *)image;
/// 控制旋转的速度：旋转一圈所用的时间，默认为1s，具体参照：DDDefaultSetup.h为准
+ (void)setLoopOneRingDuration:(CGFloat)duration;
```

* **进度圈**

默认：

```
/// 进度圆环线半径大小
#define kRingRadius                 25.0f
/// 进度圆环线宽度
#define kRingLineWidth              3.0f
/// 进度圆环颜色
#define kForegroundRingLineColorRGB 0x333333
#define kBackgroundRingLineColorRGB 0xE0E0E0
```

类方法：

```
/// 圆弧半径，默认为25，具体参照：DDDefaultSetup.h为准
+ (void)setForegroundRingRadius:(CGFloat)radius;
+ (void)setBackgroundRingRadius:(CGFloat)radius;
/// 圆弧线宽度，默认为3，具体参照：DDDefaultSetup.h为准
+ (void)setForegroundRingLineWidth:(CGFloat)width;
+ (void)setBackgroundRingLineWidth:(CGFloat)width;
/// 圆弧线颜色，默认为0xE0E0E0 0x333333，具体参照：DDDefaultSetup.h为准
+ (void)setForegroundRingLineColor:(UIColor *)color;
+ (void)setBackgroundRingLineColor:(UIColor *)color;
```

>github地址：[https://github.com/mddios/DDProgressHUD](https://github.com/mddios/DDProgressHUD)  
> **如果帮到了你，给颗星吧！**
