//
//  DemoCustomBannerDelegate.m
//  AnyThinkSDKDemo
//
//  Created by ltz on 2025/7/22.
//

#import "DemoCustomBannerDelegate.h"

@implementation DemoCustomBannerDelegate

/**
   平台广告准备就绪，可以进行展示
 */
- (void)msBannerAdReadySuccess:(MSBannerView *)msBannerAd {
    NSDictionary * extraDic = [DemoCustomBaseAdapter getC2SInfo:[msBannerAd ecpm]];
    //自定义参数
    [extraDic setValue:@"custom params value" forKey:@"custom params key"];
    [self.adStatusBridge atOnBannerAdLoadedWithView:msBannerAd adExtra:extraDic];
}

/**
 * 请求广告失败后调用
 */
- (void)msBannerError:(MSBannerView *)msBannerAd error:(NSError *)error {
    [self.adStatusBridge atOnAdLoadFailed:error adExtra:nil];
}

/**
   广告渲染成功
 */
- (void)msBannerAdRenderSuccess:(MSBannerView *)msBannerAd {

}

/**
   广告渲染失败
 */
- (void)msBannerAdRenderFail:(MSBannerView *)msBannerAd error:(NSError *)error {
    
}

/**
 * banner广告曝光
 */
- (void)msBannerShow:(MSBannerView *)msBannerAd {
    [self.adStatusBridge atOnAdShow:nil];
}

/**
 *  banner条点击回调
 */
- (void)msBannerClicked:(MSBannerView *)msBannerAd {
    [self.adStatusBridge atOnAdClick:nil];
}

/**
 *  banner条被用户关闭时调用
 */
- (void)msBannerClosed:(MSBannerView *)msBannerAd {
    [self.adStatusBridge atOnAdClosed:nil];
}

/**
 *  banner广告点击以后弹出全屏广告页完毕
 */
- (void)msBannerDetailShow:(MSBannerView *)msBannerAd {
    [self.adStatusBridge atOnAdDetailWillShow:nil];
}

/**
 *  全屏广告页已经被关闭
 */
- (void)msBannerDetailClosed:(MSBannerView *)msBannerAd {
    [self.adStatusBridge atOnAdDetailClosed:nil];
}

@end
