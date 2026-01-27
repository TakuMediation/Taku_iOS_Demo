//
//  LaunchLoadingView.h
//  iOSDemo
//
//  Created by ltz on 2025/1/18.
//

#import <UIKit/UIKit.h>
 
@interface LaunchLoadingView : UIView

/// 获取单例实例
+ (instancetype)sharedInstance;

/// 禁止外部调用init方法
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

/// 显示加载视图
- (void)show;

/// 隐藏并移除加载视图
- (void)dismiss;

/// 启动计时器
- (void)startTimer;

@end
