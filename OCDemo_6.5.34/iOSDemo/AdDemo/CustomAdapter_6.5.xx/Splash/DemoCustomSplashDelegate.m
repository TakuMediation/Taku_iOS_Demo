//
//  DemoCustomSplashDelegate.m
//  AnyThinkSDKDemo
//
//  Created by ltz on 2025/7/21.
//

#import "DemoCustomSplashDelegate.h"
#import "DemoCustomInitAdapter.h"

@implementation DemoCustomSplashDelegate

/**
 * 开屏广告展示准备就绪回调
 * 回调说明：开屏广告已准备就绪，媒体收到此回调后调用show接口
 * 注意事项：⚠️如果调用是loadAndShowSplashAd接口则不需要调用show接口
 */
- (void)msSplashAdReadySuccess:(MSSplashAd *)splashAd {
    NSDictionary * extraDic = [DemoCustomBaseAdapter getC2SInfo:[splashAd ecpm]];
    //自定义参数
    [extraDic setValue:@"custom params value" forKey:@"custom params key"];
    [self.adStatusBridge atOnSplashAdLoadedExtra:extraDic];
}

/**
 * 开屏广告投屏成功回调
 */
- (void)msSplashPresent:(MSSplashAd *)splashAd {
    
}

/**
 * 开屏广告曝光成功回调
 */
- (void)msSplashShow:(MSSplashAd *)splashAd {
    [self.adStatusBridge atOnAdShow:nil];
}

/**
 * 开屏广告曝光失败回调
 * 详解：可能广告素材异常或三方异常导致无法广告曝光
 */
- (void)msSplashAdShowFail:(MSSplashAd *)splashAd error:(NSError *)error {
    [self.adStatusBridge atOnAdShowFailed:error extra:nil];
}

/**
 * 开屏广告请求失败回调
 * 回调说明：如收到该回调说明本次请求已加载失败
 */
- (void)msSplashError:(MSSplashAd *)splashAd withError:(NSError *)error {
    [self.adStatusBridge atOnAdLoadFailed:error adExtra:nil];
}

/**
 * 开屏广告点击回调
 */
- (void)msSplashClicked:(MSSplashAd *)splashAd {
    [self.adStatusBridge atOnAdClick:nil];
}

/**
 * 开屏广告将要关闭回调
 */
- (void)msSplashWillClosed:(MSSplashAd *)splashAd {
    [self.adStatusBridge atOnAdWillClosed:nil];
}

/**
 * 开屏广告关闭回调
 */
- (void)msSplashClosed:(MSSplashAd *)splashAd {
    [self.adStatusBridge atOnAdClosed:nil];
}

/**
 * 广告落地页已经关闭
 */
- (void)msSplashDetailClosed:(MSSplashAd *)splashAd {
    [self.adStatusBridge atOnAdDetailClosed:nil];
}

/**
 * 开屏广告跳过回调
 * 回调说明：点击跳过按钮时触发
 */
- (void)msSplashSkip:(MSSplashAd *)splashAd {
}
 

@end
