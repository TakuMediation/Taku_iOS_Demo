//
//  AdLoadConfigTool.swift
//  SwiftDemo
//
//  Created by ltz on 2025/1/11.
//

import Foundation
import UIKit
import AnyThinkInterstitial
import AnyThinkRewardedVideo
import AnyThinkSplash
import AnyThinkBanner
import AnyThinkNative

/// 本类中的功能为某一广告类型加载时的配置，可选接入，仅演示部分广告平台支持的特殊功能
class AdLoadConfigTool: NSObject {
    
    // MARK: - 快手指定半屏插屏广告大小
    
    /// 添加仅快手平台可用的插屏加载配置项
    /// Append KuaiShou interstitial ad load config
    /// - Parameter config: 可变字典对象，由本方法往里面添加值
    static func interstitial_loadExtraConfigAppend_KuaiShou(_ config: inout [String: Any]) {
        let size = CGSize(width: kScreenW - 30.0, height: 300.0)
        // 设置半屏插屏广告大小，支持平台：快手，可能会影响展示效果
        config[kATInterstitialExtraAdSizeKey] = NSValue(cgSize: size)
    }
    
    // MARK: - 游可赢指定激励类型
    
    /// 添加仅游可赢平台可用的激励加载配置项
    /// Append Klevin Rewarded ad load config
    /// - Parameter config: 可变字典对象，由本方法往里面添加值
    static func rewarded_loadExtraConfigAppend_Klevin(_ config: inout [String: Any]) {
        // 仅游可赢平台可用，当前准备展示广告的rootVC
        // config[kATExtraInfoRootViewControllerKey] = targetViewController
        
        // 仅游可赢平台可用， 触发的激励类型，1：复活；2：签到；3：道具；4：虚拟货币；5：其他；不设置，则默认为5
        config[kATRewardedVideoKlevinRewardTriggerKey] = 1
        
        // 仅游可赢平台可用， 激励卡秒时长
        config[kATRewardedVideoKlevinRewardTimeKey] = 3
    }
    
    // MARK: - Pangle传入自定义logo
    
    /// 添加仅Pangle平台可用的开屏加载配置项
    /// Append Pangle Splash ad load config
    /// - Parameter config: 可变字典对象，由本方法往里面添加值
    static func splash_loadExtraConfigAppend_Pangle(_ config: inout [String: Any]) {
        // 仅Pangle支持，请传入UIImage对象
        if let logoImage = UIImage(named: "logo") {
            config[kATSplashExtraAppLogoImageKey] = logoImage
        }
    }
    
    // MARK: - Admob自适应横幅设置
    
    /// 添加仅Admob平台可用的横幅加载配置项
    /// Append Admob Banner ad load config
    /// - Parameter config: 可变字典对象，由本方法往里面添加值
    static func banner_loadExtraConfigAppend_Admob(_ config: inout [String: Any]) {
        // Admob自适应横幅设置，需要先引入头文件：import GoogleMobileAds
        // GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth 自适应
        // GADPortraitAnchoredAdaptiveBannerAdSizeWithWidth 竖屏
        // GADLandscapeAnchoredAdaptiveBannerAdSizeWithWidth 横屏
        
        /*
        let admobSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSize(withWidth: kScreenW)
        
        // 仅Admob平台支持，自适应横幅大小
        config[kATAdLoadingExtraAdmobBannerSizeKey] = NSValue(cgSize: admobSize.size)
        config[kATAdLoadingExtraAdmobAdSizeFlagsKey] = admobSize.flags
        */
    }
    
    // MARK: - 腾讯开屏传入启动背景图，背景颜色，优化短暂视觉异常
    
    /// 仅优量汇平台可用的开屏加载配置项
    /// - Parameter config: 可变字典对象，由本方法往里面添加值
    static func splash_loadExtraConfigAppend_Tencent(_ config: inout [String: Any]) {
        if let appLaunchBGImg = UIImage(named: "填入您的背景图片") {
            config["kATGDTSplashBackgroundImageKey"] = appLaunchBGImg
        }
        
        // 选择广告加载时的背景，建议符合应用本身的背景颜色
        let appLaunchBGColor = UIColor.white
        config[kATSplashExtraBackgroundColorKey] = appLaunchBGColor
    }
    
    // MARK: - 请求自适应高度的广告
    
    /// 请求自适应尺寸的原生广告(部分广告平台可用)
    /// Append load optional size to fit (width=x,height=0) config
    /// - Parameter config: 可变字典对象，由本方法往里面添加值
    static func native_loadExtraConfigAppend_SizeToFit(_ config: inout [String: Any]) {
        // 开启根据宽度，请求自适应高度的广告，仅部分广告平台有效（穿山甲、JD、快手）
        config[kATNativeAdSizeToFitKey] = true
    }
    
    // MARK: - 快手原生广告滑一滑和点击控制
    
    /// 快手原生广告滑一滑和点击相关控制
    /// Kuaishou native ads swipe and click controls
    /// - Parameter config: 可变字典对象，由本方法往里面添加值
    static func native_loadExtraConfigAppend_KuaiShou_SlideOrClickAble(_ config: inout [String: Any]) {
        // 快手原生广告滑一滑和点击相关控制,请引入头文件
        // import AnyThinkKuaiShouAdapter
        
        /*
        config[ATKSNativeInteractionConfigKey] = [
            ATKSNativeAdIsClickableKey: 1,         // NSNumber类型 0:关闭 1:开启
            ATKSNativeAdIsSlidableKey: 1,          // NSNumber类型 0:关闭 1:开启
            ATKSNativeAdContainrIsSlidableKey: 1,  // NSNumber类型 0:关闭 1:开启
            ATKSNativeAdContainrIsClickableKey: 1  // NSNumber类型 0:关闭 1:开启
        ]
        */
        
        // 例如，设置ATKSNativeAdIsSlidableKey 和 ATKSNativeAdContainrIsSlidableKey 为 1，ATKSNativeAdIsClickableKey和ATKSNativeAdContainrIsClickableKey为 0。
        // 上述效果是在广告上面滑动其滚动容器会滑动，且单击广告视图允许跳转。
    }
    
    // MARK: - 开屏广告自定义跳过按钮
    
    /// 添加部分广告平台可用的自定义开屏跳过按钮
    /// Append Splash ad show custom skip button config
    /// - Parameter config: 可变字典对象，由本方法往里面添加值
    static func splash_loadExtraConfigAppend_CustomSkipButton(_ config: inout [String: Any]) {
        // 自定义跳过按钮，注意需要在广告倒计时回调中实现按钮文本的变化处理
        let skipButton = UIButton(type: .custom)
        skipButton.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        skipButton.frame = CGRect(x: UIScreen.main.bounds.size.width - 80 - 20, y: 50, width: 80, height: 21)
        skipButton.layer.cornerRadius = 10.5
        skipButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        // 多数平台已经不支持自定义跳过按钮，目前支持更改自定义跳过按钮有穿山甲(TT)，直投、ADX、原生作开屏和游可盈，具体需要运行看实际效果
        // 自定义跳过按钮倒计时时长，毫秒单位
        config[kATSplashExtraCountdownKey] = 50000
        // 自定义跳过按钮
        config[kATSplashExtraCustomSkipButtonKey] = skipButton
        // 自定义跳过按钮倒计时回调间隔
        config[kATSplashExtraCountdownIntervalKey] = 500
    }
    
    // MARK: - 共享广告位
    
    /// 设置共享广告位额外参数 - 开屏广告
    /// - Parameter extraDict: 额外参数字典
    static func setSplashSharePlacementConfig(_ extraDict: [String: Any]) {
        ATSDKGlobalSetting.sharedManager().sharePlacementConfig.splashLoadExtra = extraDict
    }
    
    /// 设置共享广告位额外参数 - 插屏广告
    /// - Parameter extraDict: 额外参数字典
    static func setInterstitialSharePlacementConfig(_ extraDict: [String: Any]) {
        ATSDKGlobalSetting.sharedManager().sharePlacementConfig.interstitialLoadExtra = extraDict
    }
    
    /// 设置共享广告位额外参数 - 激励视频广告
    /// - Parameter extraDict: 额外参数字典
    static func setRewardedVideoSharePlacementConfig(_ extraDict: [String: Any]) {
        ATSDKGlobalSetting.sharedManager().sharePlacementConfig.rewardedVideoLoadExtra = extraDict
    }
    
    /// 设置共享广告位额外参数 - 横幅广告
    /// - Parameter extraDict: 额外参数字典
    static func setBannerSharePlacementConfig(_ extraDict: [String: Any]) {
        ATSDKGlobalSetting.sharedManager().sharePlacementConfig.bannerLoadExtra = extraDict
    }
    
    /// 设置共享广告位额外参数 - 原生广告
    /// - Parameter extraDict: 额外参数字典
    static func setNativeSharePlacementConfig(_ extraDict: [String: Any]) {
        ATSDKGlobalSetting.sharedManager().sharePlacementConfig.nativeLoadExtra = extraDict
    }
}
