//
//  AdLoadConfigTool.h
//  iOSDemo
//
//  Created by ltz on 2025/1/11.
//

#import <Foundation/Foundation.h>
 
/// 本类中的功能为某一广告类型加载时的配置，可选接入，仅演示部分广告平台支持的特殊功能
@interface AdLoadConfigTool : NSObject

#pragma mark - 快手指定半屏插屏广告大小
/// 添加仅快手平台可用的插屏加载配置项
/// Append KuaiShou interstitial ad load config
/// - Parameter config: 可变字典对象，由本方法往里面添加值
+ (void)interstitial_loadExtraConfigAppend_KuaiShou:(NSMutableDictionary *)config;

#pragma mark - 游可赢指定激励类型
/// 添加仅游可赢平台可用的激励加载配置项
/// Append Klevin Rewarded ad load config
/// - Parameter config: 可变字典对象，由本方法往里面添加值
+ (void)rewarded_loadExtraConfigAppend_Klevin:(NSMutableDictionary *)config;

#pragma mark - Pangle开屏传入自定义logo
/// 添加仅Pangle平台可用的开屏加载配置项
/// Append Pangle Splash ad load config
/// - Parameter config: 可变字典对象，由本方法往里面添加值
+ (void)splash_loadExtraConfigAppend_Pangle:(NSMutableDictionary *)config;

#pragma mark - Admob自适应横幅设置
/// 添加仅Admob平台可用的开屏加载配置项
/// Append Admob Banner ad load config
/// - Parameter config: 可变字典对象，由本方法往里面添加值
+ (void)banner_loadExtraConfigAppend_Admob:(NSMutableDictionary *)config;

#pragma mark - 腾讯开屏传入启动背景图，背景颜色，优化短暂视觉异常
/// 仅优量汇平台可用的开屏加载配置项
/// - Parameter config: 可变字典对象，由本方法往里面添加值
+ (void)splash_loadExtraConfigAppend_Tencent:(NSMutableDictionary *)config;

#pragma mark - 特殊功能
#pragma mark - 开屏广告自定义跳过按钮
/// 添加部分广告平台可用的自定义开屏跳过按钮
/// Append Splash ad show custom skip button config
/// - Parameter config: 可变字典对象，由本方法往里面添加值
+ (void)splash_loadExtraConfigAppend_CustomSkipButton:(NSMutableDictionary *)config;


#pragma mark - 请求自适应高度的广告
/// 请求自适应尺寸的原生广告(部分广告平台可用)
/// Append load optional size to fit (width=x,height=0) config
/// - Parameter config: 可变字典对象，由本方法往里面添加值
+ (void)native_loadExtraConfigAppend_SizeToFit:(NSMutableDictionary *)config;

#pragma mark - 快手原生广告滑一滑和点击控制
/// 快手原生广告滑一滑和点击相关控制
/// Kuaishou native ads swipe and click controls
/// - Parameter config: 可变字典对象，由本方法往里面添加值
+ (void)native_loadExtraConfigAppend_KuaiShou_SlideOrClickAble:(NSMutableDictionary *)config;

#pragma mark - 共享广告位
/// 设置共享广告位额外参数 - 开屏广告
/// - Parameter extraDict: 额外参数字典
+ (void)setSplashSharePlacementConfig:(NSMutableDictionary *)extraDict;

/// 设置共享广告位额外参数 - 插屏广告
/// - Parameter extraDict: 额外参数字典
+ (void)setInterstitialSharePlacementConfig:(NSMutableDictionary *)extraDict;

/// 设置共享广告位额外参数 - 激励视频广告
/// - Parameter extraDict: 额外参数字典
+ (void)setRewardedVideoSharePlacementConfig:(NSMutableDictionary *)extraDict;

/// 设置共享广告位额外参数 - 横幅广告
/// - Parameter extraDict: 额外参数字典
+ (void)setBannerSharePlacementConfig:(NSMutableDictionary *)extraDict;

/// 设置共享广告位额外参数 - 原生广告
/// - Parameter extraDict: 额外参数字典
+ (void)setNativeSharePlacementConfig:(NSMutableDictionary *)extraDict;

@end
 
