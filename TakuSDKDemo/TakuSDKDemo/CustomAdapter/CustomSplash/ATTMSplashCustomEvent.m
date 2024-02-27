//
//  ATTMSplashCustomEvent.m
//  eseecloud
//
//  Created by Yc on 2022/10/17.
//  Copyright © 2022 juanvision. All rights reserved.
//

#import "ATTMSplashCustomEvent.h"

@implementation ATTMSplashCustomEvent



- (NSString *)networkUnitId {
    return self.serverInfo[@"unitid"];
}

- (void)removeCustomViewAndsplashAd:(TianmuSplashAd *)splashAd {
    
    if (self.containerView) {
        [self.containerView removeFromSuperview];
    }
    
    if (splashAd) {
        splashAd = nil;
    }
}

#pragma mark - TianmuSplashAdDelegate
/**
 *  开屏广告请求成功
 */
- (void)tianmuSplashAdSuccessLoad:(TianmuSplashAd *)splashAd{
    NSLog(@"%s", __FUNCTION__);
    
}

/**
 *  开屏广告素材加载成功
 */
- (void)tianmuSplashAdDidLoad:(TianmuSplashAd *)splashAd{
    NSLog(@"%s", __FUNCTION__);

    [self trackSplashAdLoaded:splashAd adExtra:nil];
    
}

/**
 *  开屏广告请求失败
 */
- (void)tianmuSplashAdFailLoad:(TianmuSplashAd *)splashAd withError:(NSError *)error{
    NSLog(@"%s %@", __FUNCTION__ ,error);
    
    [self removeCustomViewAndsplashAd:splashAd];
    
    [self trackSplashAdLoadFailed:error];
}
/**
 *  开屏广告渲染失败
 */
- (void)tianmuSplashAdRenderFaild:(TianmuSplashAd *)splashAd withError:(NSError *)error{
    NSLog(@"%s %@", __FUNCTION__ ,error);
    
    [self trackSplashAdShowFailed:error];
}

/**
 *  开屏广告曝光回调
 */
- (void)tianmuSplashAdExposured:(TianmuSplashAd *)splashAd{
    NSLog(@"%s", __FUNCTION__);
    [self trackSplashAdShow];
}


/**
 *  开屏广告点击回调
 */
- (void)tianmuSplashAdClicked:(TianmuSplashAd *)splashAd{
    NSLog(@"%s", __FUNCTION__);
    [self trackSplashAdClick];
}

/**
 *  开屏广告倒计时结束回调
 */
- (void)tianmuSplashAdCountdownToZero:(TianmuSplashAd *)splashAd{
    NSLog(@"%s", __FUNCTION__);
}

/**
 *  开屏广告点击跳过回调
 */
- (void)tianmuSplashAdSkiped:(TianmuSplashAd *)splashAd{
    NSLog(@"%s", __FUNCTION__);
}

/**
 *  开屏广告关闭回调
 */
- (void)tianmuSplashAdClosed:(TianmuSplashAd *)splashAd{
    NSLog(@"%s", __FUNCTION__);
    [self removeCustomViewAndsplashAd:splashAd];
    [self trackSplashAdClosed:nil];
}

/**
 *  开屏广告关闭落地页回调
 */
- (void)tianmuSplashAdCloseLandingPage:(TianmuSplashAd *)splashAd{
    NSLog(@"%s", __FUNCTION__);
    [self trackSplashAdDetailClosed];
}

/**
 *  开屏广告展示失败
 */
- (void)tianmuSplashAdFailToShow:(TianmuSplashAd *)splashAd error:(NSError *)error{
    NSLog(@"%s %@", __FUNCTION__ ,error);
    [self removeCustomViewAndsplashAd:splashAd];
    [self trackSplashAdShowFailed:error];
}



@end
