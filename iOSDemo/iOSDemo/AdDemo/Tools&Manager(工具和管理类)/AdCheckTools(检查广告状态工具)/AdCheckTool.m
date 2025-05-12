//
//  AdCheckTool.m
//  iOSDemo
//
//  Created by ltz on 2025/4/27.
//

#import "AdCheckTool.h"

#import <AnyThinkInterstitial/AnyThinkInterstitial.h>
#import <AnyThinkRewardedVideo/AnyThinkRewardedVideo.h>
#import <AnyThinkSplash/AnyThinkSplash.h>
#import <AnyThinkBanner/AnyThinkBanner.h>
#import <AnyThinkNative/AnyThinkNative.h>

@implementation AdCheckTool

/// 查询广告加载状态
/// - Parameters:
///   - placementID: 目标广告位ID
///   - adType: 目标广告位ID对应的广告类型
+ (ATCheckLoadModel *)adLoadingStatusWithPlacementID:(NSString *)placementID adType:(AdType)adType {
    
    if (placementID.length == 0 || adType == AdTypeUnknown) {
        ATDemoLog(@"adLoadingStatusWithPlacementID - input error")
        return nil;
    }
    
    switch (adType) {
        case AdTypeInterstitial:
            return [[ATAdManager sharedManager] checkInterstitialLoadStatusForPlacementID:placementID];
        case AdTypeRewardVideo:
            return [[ATAdManager sharedManager] checkRewardedVideoLoadStatusForPlacementID:placementID];
        case AdTypeSplash:
            return [[ATAdManager sharedManager] checkSplashLoadStatusForPlacementID:placementID];
        case AdTypeBanner:
            return [[ATAdManager sharedManager] checkBannerLoadStatusForPlacementID:placementID];
        case AdTypeNative:
            return [[ATAdManager sharedManager] checkNativeLoadStatusForPlacementID:placementID];
            
        default:
            ATDemoLog(@"adLoadingStatusWithPlacementID - Unknow adType")
            return nil;
    }
}

/// 查询可用于展示的广告缓存
/// - Parameters:
///   - placementID: 目标广告位ID
///   - adType: 目标广告位ID对应的广告类型
+ (NSArray <NSDictionary *> *)getValidAdsForPlacementID:(NSString *)placementID adType:(AdType)adType {
    
    if (placementID.length == 0 || adType == AdTypeUnknown) {
        ATDemoLog(@"getValidAdsForPlacementID - input error")
        return [NSArray array];
    }
    
    switch (adType) {
        case AdTypeInterstitial:
            return [[ATAdManager sharedManager] getInterstitialValidAdsForPlacementID:placementID];
        case AdTypeRewardVideo:
            return [[ATAdManager sharedManager] getRewardedVideoValidAdsForPlacementID:placementID];
        case AdTypeSplash:
            return [[ATAdManager sharedManager] getSplashValidAdsForPlacementID:placementID];
        case AdTypeBanner:
            return [[ATAdManager sharedManager] getBannerValidAdsForPlacementID:placementID];
        case AdTypeNative:
            return [[ATAdManager sharedManager] getNativeValidAdsForPlacementID:placementID];
        default:
            return [NSArray array];
    }
}

@end
