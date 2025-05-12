//
//  CustomAdapterC2SBiddingRequestManager.m
//  AnyThinkQMAdapter
//
//  Created by Captain on 2024/9/12.
//  Copyright © 2024 AnyThink. All rights reserved.
//

#import "CustomAdapterC2SBiddingRequestManager.h"
#import "ATC2SBiddingNetworkC2STool_QM.h"
#import "CustomAdapterSplashCustomEvent.h"
#import "CustomAdapterRewardVideoCustomEvent.h"
#import "CustomAdapterInterstitialCustomEvent.h"
#import "CustomAdapterNativeCustomEvent.h"
#import "CustomAdapterBannerCustomEvent.h"
#import <QuMengAdSDK/QuMengAdSDK.h>

@implementation CustomAdapterC2SBiddingRequestManager
+ (instancetype)sharedInstance {
    static CustomAdapterC2SBiddingRequestManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CustomAdapterC2SBiddingRequestManager alloc] init];
    });
    return sharedInstance;
    
}

- (void)startWithRequestItem:(CustomAdapterBiddingRequest *)request {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[ATC2SBiddingNetworkC2STool_QM sharedInstance] saveRequestItem:request withUnitId:request.unitID];
        switch (request.adType) {
                
            case ATAdFormatInterstitial:
                
                [self startLoadInterstitialAdWithRequest:request];
                break;
                
            case ATAdFormatRewardedVideo:
                [self startLoadRewardedVideoAdWithRequest:request];
                break;
            
            case ATAdFormatNative:
                [self startLoadNativeAdWithRequest:request];
                break;
                
            case ATAdFormatSplash:
                [self startLoadSplashAdWithRequest:request];
                break;

            case ATAdFormatBanner:
                // 原生混横幅，原生用作横幅
                [self startLoadNativeAdWithRequest:request];
                break;
                
            default:
                break;
        }
    });
}

#pragma mark - ATAdFormatInterstitial
- (void)startLoadInterstitialAdWithRequest:(CustomAdapterBiddingRequest *)request {
    NSString *adslot_id_str = [NSString stringWithFormat:@"%@",request.unitGroup.content[@"adslot_id"]];
    
    QuMengInterstitialAd *interstitial = [[QuMengInterstitialAd alloc] initWithSlot:adslot_id_str];
    request.customObject = interstitial;
    
    CustomAdapterInterstitialCustomEvent *customEvent = (CustomAdapterInterstitialCustomEvent *)request.customEvent;
    interstitial.delegate = customEvent;
    [interstitial loadAdData];

}

#pragma mark - ATAdFormatRewardedVideo
- (void)startLoadRewardedVideoAdWithRequest:(CustomAdapterBiddingRequest *)request {
    NSString *adslot_id_str = [NSString stringWithFormat:@"%@",request.unitGroup.content[@"adslot_id"]];
    
    QuMengRewardedVideoAd *rewardAd = [[QuMengRewardedVideoAd alloc] initWithSlot:adslot_id_str];
    request.customObject = rewardAd;
    
    CustomAdapterRewardVideoCustomEvent *customEvent = (CustomAdapterRewardVideoCustomEvent *)request.customEvent;
    rewardAd.delegate = customEvent;
    [rewardAd loadAdData];
    
}

#pragma mark - ATAdFormatNative
- (void)startLoadNativeAdWithRequest:(CustomAdapterBiddingRequest *)request {
    
    NSDictionary *serverInfo = request.extraInfo;
    NSInteger layoutType = [serverInfo[@"unit_type"] integerValue];// 渲染方式 1:模板渲染 0 自渲染
    NSString *adslot_id_str = [NSString stringWithFormat:@"%@",request.unitGroup.content[@"adslot_id"]];
    if (layoutType == 1 || request.adType == ATAdFormatBanner) {// 模板渲染
        QuMengFeedAd *feedAd = [[QuMengFeedAd alloc] initWithSlot:adslot_id_str];
        request.customObject = feedAd;
        CustomAdapterNativeCustomEvent *customEvent = (CustomAdapterNativeCustomEvent *)request.customEvent;
        feedAd.delegate = customEvent;
        [feedAd loadAdData];

    } else if (layoutType == 0) {// 自渲染
        QuMengNativeAd *nativeAd = [[QuMengNativeAd alloc] initWithSlot:adslot_id_str];
        request.customObject = nativeAd;
        CustomAdapterNativeCustomEvent *customEvent = (CustomAdapterNativeCustomEvent *)request.customEvent;
        nativeAd.delegate = customEvent;
        [nativeAd loadAdData];
    }

}

#pragma mark - ATAdFormatBanner
- (void)startLoadNativeBannerAdWithRequest:(CustomAdapterBiddingRequest *)request {
    
    NSDictionary *serverInfo = request.extraInfo;
    NSInteger layoutType = [serverInfo[@"unit_type"] integerValue];// 渲染方式 1:模板渲染 0 自渲染
    NSString *adslot_id_str = [NSString stringWithFormat:@"%@",request.unitGroup.content[@"adslot_id"]];
    if (layoutType == 1 || request.adType == ATAdFormatBanner) { // 模板渲染
        QuMengFeedAd *feedAd = [[QuMengFeedAd alloc] initWithSlot:adslot_id_str];
        request.customObject = feedAd;
        CustomAdapterBannerCustomEvent *customEvent = (CustomAdapterBannerCustomEvent *)request.customEvent;
        feedAd.delegate = customEvent;
        [feedAd loadAdData];
    }
}

#pragma mark - ATAdFormatSplash
- (void)startLoadSplashAdWithRequest:(CustomAdapterBiddingRequest *)request {
    
    NSString *adslot_id_str = [NSString stringWithFormat:@"%@",request.unitGroup.content[@"adslot_id"]];
    
    QuMengSplashAd *splashAd = [[QuMengSplashAd alloc] initWithSlot:adslot_id_str];
    request.customObject = splashAd;
    
    CustomAdapterSplashCustomEvent *splashCustomEvent = (CustomAdapterSplashCustomEvent *)request.customEvent;
    splashAd.delegate = splashCustomEvent;
    [splashAd loadAdData];
}

+ (void)disposeLoadSuccessCall:(NSString *)priceStr customObject:(id)customObject unitID:(NSString *)unitID {
    if (!priceStr || [priceStr doubleValue] < 0) {
        priceStr = @"0";
    }
    
    CustomAdapterBiddingRequest *request = [[ATC2SBiddingNetworkC2STool_QM sharedInstance] getRequestItemWithUnitID:unitID];
    if (request == nil) {
        return;
    }
    
    NSLog(@"%@",[NSString stringWithFormat:@"Qumeng::meta.getECPM:price:%@",priceStr] );

    ATBidInfo *bidInfo = [ATBidInfo bidInfoC2SWithPlacementID:request.placementID unitGroupUnitID:request.unitGroup.unitID adapterClassString:request.unitGroup.adapterClassString price:priceStr currencyType:ATBiddingCurrencyTypeCNYCents expirationInterval:request.unitGroup.bidTokenTime customObject:customObject];
//    bidInfo.networkFirmID = request.unitGroup.networkFirmID;
//    bidInfo.curRate = [ATGeneralTool handleRateForBidInfo:bidInfo];
    if (request.bidCompletion) {
        request.bidCompletion(bidInfo, nil);
    }

}

+ (void)disposeLoadFailCall:(NSError *)error key:(NSString *)keyStr unitID:(NSString *)unitID {
    CustomAdapterBiddingRequest *request = [[ATC2SBiddingNetworkC2STool_QM sharedInstance] getRequestItemWithUnitID:unitID];
    
    if (request == nil) {
        return;
    }
    
    if (request.bidCompletion) {
        request.bidCompletion(nil, [NSError errorWithDomain:@"com.anythink.Qumeng" code:error.code userInfo:@{
            NSLocalizedDescriptionKey:keyStr,
            NSLocalizedFailureReasonErrorKey:error}]);
    }

    [[ATC2SBiddingNetworkC2STool_QM sharedInstance] removeRequestItemWithUnitID:request.unitGroup.content[@"adslot_id"]];

}


@end
