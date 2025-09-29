//
//  AdLoadConfigTool.m
//  iOSDemo
//
//  Created by ltz on 2025/1/11.
//

#import "AdLoadConfigTool.h"
#import <AnyThinkInterstitial/AnyThinkInterstitial.h>
#import <AnyThinkRewardedVideo/AnyThinkRewardedVideo.h>
#import <AnyThinkSplash/AnyThinkSplash.h>
#import <AnyThinkBanner/AnyThinkBanner.h>
#import <AnyThinkNative/AnyThinkNative.h>
//#import <AnyThinkKuaiShouAdapter/ATKSExtraConfig.h>

@implementation AdLoadConfigTool

#pragma mark - 快手指定半屏插屏广告大小
/// 添加仅快手平台可用的插屏加载配置项
/// Append KuaiShou interstitial ad load config
/// - Parameter config: 可变字典对象，由本方法往里面添加值
+ (void)interstitial_loadExtraConfigAppend_KuaiShou:(NSMutableDictionary *)config {
    if (!config) {
        ATDemoLog(@"⚠️interstitial_loadExtraConfigAppend_KuaiShou: Input config instance is null");
    }
    CGSize size = CGSizeMake(kScreenW - 30.0f, 300.0f);
    // 设置半屏插屏广告大小，支持平台：快手，可能会影响展示效果
    [config setValue:[NSValue valueWithCGSize:size] forKey:kATInterstitialExtraAdSizeKey];
}

#pragma mark - 游可赢指定激励类型
/// 添加仅游可赢平台可用的激励加载配置项
/// Append Klevin Rewarded ad load config
/// - Parameter config: 可变字典对象，由本方法往里面添加值
+ (void)rewarded_loadExtraConfigAppend_Klevin:(NSMutableDictionary *)config {
    if (!config) {
        ATDemoLog(@"⚠️splash_loadExtraConfigAppend_Klevin: Input config instance is null");
    }
    
    // 仅游可赢平台可用，当前准备展示广告的rootVC
    // [config setValue:targetViewController forKey:kATExtraInfoRootViewControllerKey];
    
    // 仅游可赢平台可用， 触发的激励类型，1：复活；2：签到；3：道具；4：虚拟货币；5：其他；不设置，则默认为5
    [config setValue:@1 forKey:kATRewardedVideoKlevinRewardTriggerKey];
     
    // 仅游可赢平台可用， 激励卡秒时长
    [config setValue:@3 forKey:kATRewardedVideoKlevinRewardTimeKey];
}

#pragma mark - Pangle传入自定义logo
/// 添加仅Pangle平台可用的开屏加载配置项
/// Append Pangle Splash ad load config
/// - Parameter config: 可变字典对象，由本方法往里面添加值
+ (void)splash_loadExtraConfigAppend_Pangle:(NSMutableDictionary *)config {
    if (!config) {
        ATDemoLog(@"⚠️splash_loadExtraConfigAppendPangle: Input config instance is null");
    }
    //仅Pangle支持，请传入UIImage对象
    [config setValue:[UIImage imageNamed:@"logo"] forKey:kATSplashExtraAppLogoImageKey];
}

#pragma mark - Admob自适应横幅设置
/// 添加仅Admob平台可用的开屏加载配置项
/// Append Admob Banner ad load config
/// - Parameter config: 可变字典对象，由本方法往里面添加值
+ (void)banner_loadExtraConfigAppend_Admob:(NSMutableDictionary *)config {
    if (!config) {
        ATDemoLog(@"⚠️splash_loadExtraConfigAppendPangle: Input config instance is null");
    }

    //Admob自适应横幅设置，需要先引入头文件：#import <GoogleMobileAds/GoogleMobileAds.h>
    //GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth 自适应
    //GADPortraitAnchoredAdaptiveBannerAdSizeWithWidth 竖屏
    //GADLandscapeAnchoredAdaptiveBannerAdSizeWithWidth 横屏
//    GADAdSize admobSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(kScreenW);
//    
//    // 仅Admob平台支持，自适应横幅大小
//    [config setValue:[NSValue valueWithCGSize:admobSize.size] forKey:kATAdLoadingExtraAdmobBannerSizeKey];
//    [config setValue:@(admobSize.flags) forKey:kATAdLoadingExtraAdmobAdSizeFlagsKey];
}

#pragma mark - 腾讯开屏传入启动背景图，背景颜色，优化短暂视觉异常
/// 仅优量汇平台可用的开屏加载配置项
/// - Parameter config: 可变字典对象，由本方法往里面添加值
+ (void)splash_loadExtraConfigAppend_Tencent:(NSMutableDictionary *)config {
    if (!config) {
        ATDemoLog(@"⚠️splash_loadExtraConfigAppend_Tencent: Input config instance is null");
    }
    
    UIImage * appLaunchBGImg = [UIImage imageNamed:@"填入您的背景图片"];
    [config setValue:appLaunchBGImg forKey:@"kATGDTSplashBackgroundImageKey"];
    
    //选择广告加载时的背景，建议符合应用本身的背景颜色
    UIColor * appLaunchBGColor = [UIColor whiteColor];
    [config setValue:appLaunchBGColor forKey:kATSplashExtraBackgroundColorKey];
}

#pragma mark - 请求自适应高度的广告
/// 请求自适应尺寸的原生广告(部分广告平台可用)
/// Append load optional size to fit (width=x,height=0) config
/// - Parameter config: 可变字典对象，由本方法往里面添加值
+ (void)native_loadExtraConfigAppend_SizeToFit:(NSMutableDictionary *)config {
    if (!config) {
        ATDemoLog(@"⚠️native_loadExtraConfigAppend_SizeToFit: Input config instance is null");
    }
    //开启根据宽度，请求自适应高度的广告，仅部分广告平台有效（穿山甲、JD、快手）
    [config setValue:@YES forKey:kATNativeAdSizeToFitKey];
}

#pragma mark - 快手原生广告滑一滑和点击控制
/// 快手原生广告滑一滑和点击相关控制
/// Kuaishou native ads swipe and click controls
/// - Parameter config: 可变字典对象，由本方法往里面添加值
+ (void)native_loadExtraConfigAppend_KuaiShou_SlideOrClickAble:(NSMutableDictionary *)config {
    if (!config) {
        ATDemoLog(@"⚠️native_loadExtraConfigAppend_KuaiShou_SlideOrClickAble: Input config instance is null");
    }
    //快手原生广告滑一滑和点击相关控制,请引入头文件
    //#import <AnyThinkKuaiShouAdapter/ATKSExtraConfig.h>
//    
//    [config setValue:@{ // 不传的话,即字典为空 全部默认为1
//        ATKSNativeAdIsClickableKey : @1,         // NSNumer类型 0:关闭 1:开启
//        ATKSNativeAdIsSlidableKey : @1,          // NSNumer类型 0:关闭 1:开启
//        ATKSNativeAdContainrIsSlidableKey : @1,  // NSNumer类型 0:关闭 1:开启
//        ATKSNativeAdContainrIsClickableKey : @1} // NSNumer类型 0:关闭 1:开启
//        forKey:ATKSNativeInteractionConfigKey];
    
    //例如，设置ATKSNativeAdIsSlidableKey 和 ATKSNativeAdContainrIsSlidableKey 为 @1，ATKSNativeAdIsClickableKey和ATKSNativeAdContainrIsClickableKey为 @0。
    //上述效果是在广告上面滑动其滚动容器会滑动，且单击广告视图允许跳转。
}

#pragma mark - 开屏广告自定义跳过按钮
/// 添加部分广告平台可用的自定义开屏跳过按钮
/// Append Splash ad show custom skip button config
/// - Parameter config: 可变字典对象，由本方法往里面添加值
+ (void)splash_loadExtraConfigAppend_CustomSkipButton:(NSMutableDictionary *)config {
    if (!config) {
        ATDemoLog(@"⚠️splash_loadExtraConfigAppendPangle: Input config instance is null");
    }
    // 自定义跳过按钮，注意需要在广告倒计时- (void)splashCountdownTime:(NSInteger)countdown forPlacementID:(NSString *)placementID extra:(NSDictionary *)extra回调中实现按钮文本的变化处理
    UIButton * skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    skipButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    skipButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 80 - 20, 50, 80, 21);
    skipButton.layer.cornerRadius = 10.5;
    skipButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    // 多数平台已经不支持自定义跳过按钮，目前支持更改自定义跳过按钮有穿山甲(TT)，直投、ADX、原生作开屏和游可盈，具体需要运行看实际效果
    // 自定义跳过按钮倒计时时长，毫秒单位
    [config setValue:@50000 forKey:kATSplashExtraCountdownKey];
    // 自定义跳过按钮
    [config setValue:skipButton forKey:kATSplashExtraCustomSkipButtonKey];
    // 自定义跳过按钮倒计时回调间隔
    [config setValue:@500 forKey:kATSplashExtraCountdownIntervalKey];
}

#pragma mark - 共享广告位
/// 设置共享广告位额外参数 - 开屏广告
/// - Parameter extraDict: 额外参数字典
+ (void)setSplashSharePlacementConfig:(NSMutableDictionary *)extraDict {
    
    if (![ATSDKGlobalSetting sharedManager].sharePlacementConfig) {
        [ATSDKGlobalSetting sharedManager].sharePlacementConfig = [[ATSharePlacementConfig alloc] init];
    }
    [ATSDKGlobalSetting sharedManager].sharePlacementConfig.splashLoadExtra = extraDict;
}

/// 设置共享广告位额外参数 - 插屏广告
/// - Parameter extraDict: 额外参数字典
+ (void)setInterstitialSharePlacementConfig:(NSMutableDictionary *)extraDict {
    
    if (![ATSDKGlobalSetting sharedManager].sharePlacementConfig) {
        [ATSDKGlobalSetting sharedManager].sharePlacementConfig = [[ATSharePlacementConfig alloc] init];
    }
    [ATSDKGlobalSetting sharedManager].sharePlacementConfig.interstitialLoadExtra = extraDict;
}

/// 设置共享广告位额外参数 - 激励视频广告
/// - Parameter extraDict: 额外参数字典
+ (void)setRewardedVideoSharePlacementConfig:(NSMutableDictionary *)extraDict {
    
    if (![ATSDKGlobalSetting sharedManager].sharePlacementConfig) {
        [ATSDKGlobalSetting sharedManager].sharePlacementConfig = [[ATSharePlacementConfig alloc] init];
    }
    [ATSDKGlobalSetting sharedManager].sharePlacementConfig.rewardedVideoLoadExtra = extraDict;
}

/// 设置共享广告位额外参数 - 横幅广告
/// - Parameter extraDict: 额外参数字典
+ (void)setBannerSharePlacementConfig:(NSMutableDictionary *)extraDict {
    
    if (![ATSDKGlobalSetting sharedManager].sharePlacementConfig) {
        [ATSDKGlobalSetting sharedManager].sharePlacementConfig = [[ATSharePlacementConfig alloc] init];
    }
    [ATSDKGlobalSetting sharedManager].sharePlacementConfig.bannerLoadExtra = extraDict;
}

/// 设置共享广告位额外参数 - 原生广告
/// - Parameter extraDict: 额外参数字典
+ (void)setNativeSharePlacementConfig:(NSMutableDictionary *)extraDict {
    
    if (![ATSDKGlobalSetting sharedManager].sharePlacementConfig) {
        [ATSDKGlobalSetting sharedManager].sharePlacementConfig = [[ATSharePlacementConfig alloc] init];
    }
    [ATSDKGlobalSetting sharedManager].sharePlacementConfig.nativeLoadExtra = extraDict;
}

@end



