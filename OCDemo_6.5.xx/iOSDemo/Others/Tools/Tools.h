//
//  Tools.h
//  iOSDemo
//
//  Created by ltz on 2025/1/11.
//

#import <Foundation/Foundation.h>



@class ATNativeAdOffer;
@interface Tools : NSObject

+ (NSDictionary *)getOfferInfo:(ATNativeAdOffer *)nativeAdOffer;

+ (NSString *)getIdfaString;

/**
 * 检查输入的控制器是否有push或present出来的控制器，并返回当前显示的控制器
 * @param viewController 需要检查的视图控制器
 * @return UIViewController* 如果有push或present出的控制器，则返回该控制器；否则返回nil
 */
+ (UIViewController *)getVisibleChildViewController:(UIViewController *)viewController;

/**
 * 将一个控制器从当前Window切换到目标Window
 * @param viewController 需要切换的视图控制器
 * @param sourceWindow 源Window(当前显示控制器的Window)
 * @param targetWindow 目标Window
 * @param completion 完成回调
 */
+ (void)switchViewController:(UIViewController *)viewController
                 fromWindow:(UIWindow *)sourceWindow
                   toWindow:(UIWindow *)targetWindow
                  completion:(void(^)(BOOL success))completion;

/// 打印原生广告素材信息
/// - Parameter nativeAdOffer: 原生广告素材offer对象
+ (void)printNativeAdOffer:(ATNativeAdOffer *)nativeAdOffer;

+ (UIImage *)imageWithColor:(UIColor *)color;

@end


