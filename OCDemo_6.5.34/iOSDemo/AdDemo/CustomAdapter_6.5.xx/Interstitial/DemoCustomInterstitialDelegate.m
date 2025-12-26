//
//  DemoCustomInterstitialDelegate.m
//  AnyThinkSDKDemo
//
//  Created by ltz on 2025/7/22.
//

#import "DemoCustomInterstitialDelegate.h"

@implementation DemoCustomInterstitialDelegate

/**
   平台广告展示准备就绪，可以进行展示 在此回调中调用show接口展示广告
 */
- (void)msInterstitialAdReadySuccess:(MSInterstitialAd *)msInterstitialAd {
    NSDictionary * extraDic = [DemoCustomBaseAdapter getC2SInfo:[msInterstitialAd ecpm]];
    //自定义参数
    [extraDic setValue:@"custom params value" forKey:@"custom params key"];
    //传入自定义参数
    [self.adStatusBridge setNetworkCustomInfo:extraDic];
     
    [self.adStatusBridge atOnInterstitialAdLoadedExtra:extraDic];
}

/**
 *  广告预加载失败回调
 *  详解:当接收服务器返回的广告数据失败后调用该函数
 */
- (void)msInterstitialError:(MSInterstitialAd *)msInterstitialAd
                      error:(NSError *)error {
    [self.adStatusBridge atOnAdLoadFailed:error adExtra:nil];
}

/**
 *  插屏广告视图展示成功回调
 *  详解: 插屏广告展示成功回调该函数
 */
- (void)msInterstitialShow:(MSInterstitialAd *)msInterstitialAd {
    [self.adStatusBridge atOnAdShow:nil];
}

/**
   平台广告展示失败
   详解：可能广告素材异常或三方异常导致无法广告曝光
 */
- (void)msInterstitialAdShowFail:(MSInterstitialAd *)msInterstitialAd error:(NSError *)error {
    [self.adStatusBridge atOnAdShowFailed:error extra:nil];
}

/**
 *  插屏广告展示结束回调
 *  详解: 插屏广告展示结束回调该函数
 */
- (void)msInterstitialClosed:(MSInterstitialAd *)msInterstitialAd {
    [self.adStatusBridge atOnAdClosed:nil];
}

/**
 *  插屏广告点击回调
 */
- (void)msInterstitialClicked:(MSInterstitialAd *)msInterstitialAd {
    [self.adStatusBridge atOnAdClick:nil];
}

/**
 *  全屏广告页被关闭
 */
- (void)msInterstitialDetailClosed:(MSInterstitialAd *)msInterstitialAd {
    [self.adStatusBridge atOnAdDetailClosed:nil];
}

@end
