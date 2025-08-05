//
//  CustomAdapterBannerCustomEvent.m
//  CustomAdapter
//
//  Created by Captain on 2024/12/23.
//  Copyright © 2024 AnyThink. All rights reserved.
//

#import "CustomAdapterBannerCustomEvent.h"
 
@implementation CustomAdapterBannerCustomEvent
/**
 A view controller that will be used to present modal view controllers.

 @param bannerView  The banner view sending the message.
 @return            A presenting view controller.
 */
- (nonnull UIViewController *)presentingViewControllerForBannerView:(id _Nonnull)bannerView {
    NSLog(@"Banner::presentingViewControllerForBannerView:");

    UIViewController *showViewController = [ATBannerCustomEvent rootViewControllerWithPlacementID:((ATPlacementModel *)self.serverInfo[kATAdapterCustomInfoPlacementModelKey]).placementID requestID:self.serverInfo[kATAdapterCustomInfoRequestIDKey]];

    NSHashTable *showVCHashTable = self.localInfo[kATAdLoadingExtraShowViewControllerKey];
    // 检查是否是 NSHashTable 类型
    if ([showVCHashTable isKindOfClass:[NSHashTable class]]) {
        // 遍历 NSHashTable 中的所有对象
        for (UIViewController *showVC in showVCHashTable) {
            // 由于 NSHashTable 存储的是弱引用，所以需要检查对象是否还存在并且是 UIViewController 类型
            if (showVC && [showVC isKindOfClass:[UIViewController class]]) {
                showViewController = showVC;
                break; // 结束循环
            }
        }
    }
    
    return showViewController;
}

/**
 Sent when TTL has expired, based on the timestamp from the SOMA header.

 @param bannerView  The banner view sending the message.
 */
- (void)bannerViewDidTTLExpire:(id _Nonnull)bannerView {
    NSLog(@"Banner::bannerViewDidTTLExpire:" );
    NSError *error = [NSError errorWithDomain:@"com.anythink.Banner" code:10000 userInfo:@{NSLocalizedDescriptionKey:kATSDKFailedToLoadBannerADMsg, NSLocalizedFailureReasonErrorKey:@"SDK has failed to load banner."}];

    [self trackBannerAdLoadFailed:error];
}


/**
 Sent when the banner view loads an ad successfully.

 @param bannerView The banner view sending the message.
 */
- (void)bannerViewDidLoad:(id _Nonnull)bannerView {
    NSLog(@"Banner::bannerViewDidLoad:" );
    
    if (self.isC2SBiding) {
        NSString *price = [NSString stringWithFormat:@"%ld", (long)bannerView.meta.getECPM];
        [CustomAdapterC2SBiddingRequestManager disposeLoadSuccessCall:price customObject:bannerView unitID:self.networkUnitId];
        self.isC2SBiding = NO;
    } else {
        [self trackBannerAdLoaded:bannerView adExtra:nil];
    }
}

/**
 Sent when banner view is clicked.

 @param bannerView  The banner view sending the message.
 */
- (void)bannerViewDidClick:(id _Nonnull)bannerView {
    NSLog(@"Banner::bannerViewDidClick:" );
    [self trackBannerAdClick];
}

/**
 Sent when the banner view fails to load an ad successfully.

 @param bannerView  The banner view sending the message.
 @param error       An error object containing details of why the banner view failed to load an ad.
 */
- (void)bannerView:(id _Nonnull)bannerView didFailWithError:(NSError *_Nonnull)error {
    NSLog(@"Banner:bannerView:didFailWithError:" );
    if (self.isC2SBiding) {
        [CustomAdapterC2SBiddingRequestManager disposeLoadFailCall:error key:kATSDKFailedToLoadBannerADMsg unitID:self.networkUnitId];
    } else {
        [self trackBannerAdLoadFailed:error];
    }
}

/**
 Sent when the ad view impression has been tracked by the sdk.

 @param bannerView  The banner view sending the message.
 */
- (void)bannerViewDidImpress:(id _Nonnull)bannerView {
    NSLog(@"Banner:bannerViewDidImpress:" );
    [self trackBannerAdImpression];
}

/**
 Sent when the user taps on an ad and modal content will be presented (e.g. internal browser).

 @param bannerView  The banner view sending the message.
 */
- (void)bannerViewWillPresentModalContent:(id _Nonnull)bannerView {
    NSLog(@"Banner:bannerViewWillPresentModalContent:" );

}

/**
 Sent when modal content has been presented.

 @param bannerView  The banner view sending the message.
 */
- (void)bannerViewDidPresentModalContent:(id _Nonnull)bannerView {
    NSLog(@"Banner:bannerViewDidPresentModalContent:" );

}

/**
 Sent when modal content will be dismissed.

 @param bannerView  The banner view sending the message.
 */
- (void)bannerViewDidDismissModalContent:(id _Nonnull)bannerView {
    NSLog(@"Banner:bannerViewDidDismissModalContent:" );

}

/**
 Sent when the ad causes the user to leave the application.

 @param bannerView  The banner view sending the message.
 */
- (void)bannerWillLeaveApplicationFromAd:(id _Nonnull)bannerView {
    NSLog(@"Banner:bannerWillLeaveApplicatishowonFromAd:" );

}

//- (BOOL)sendImpressionTrackingIfNeed {
//    return YES;
//}

- (NSString *)networkUnitId {
    return self.serverInfo[@"unit_id"];
}

@end

