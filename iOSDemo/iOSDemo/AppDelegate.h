//
//  AppDelegate.h
//  iOSDemo
//
//  Created by ltz on 2025/1/5.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow * window;

/// 可选接入，开屏广告示例，使用新的Window对象展示开屏广告
@property (strong, nonatomic) UIWindow * splashWindow;

/// 可选接入，开屏广告示例，使用新的Window对象展示开屏广告
- (void)initSplashWindow;

@end

