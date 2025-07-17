//
//  CustomAdapterSplashCustomEvent.m
//  CustomAdapter
//
//  Created by mac on 2024/8/27.
//

#import "CustomAdapterSplashCustomEvent.h"
#import "CustomAdapterC2SBiddingRequestManager.h"
  
@interface CustomAdapterSplashCustomEvent()<QuMengSplashAdDelegate>

@end

@implementation CustomAdapterSplashCustomEvent

- (instancetype)initWithInfo:(NSDictionary *)serverInfo localInfo:(NSDictionary *)localInfo {
    if (self = [super initWithInfo:serverInfo localInfo:localInfo]) {
    }
    return self;
}

// MARK: - QuMengSplashAdDelegate
- (void)qumeng_splashAdLoadSuccess:(QuMengSplashAd *)splashAd {
    NSLog(@"QumengSplash::qm_splashAdLoadSuccess:" );
    if (self.isC2SBiding) {
        NSString *price = [NSString stringWithFormat:@"%ld", (long)splashAd.meta.getECPM];
        [CustomAdapterC2SBiddingRequestManager disposeLoadSuccessCall:price customObject:splashAd unitID:self.networkUnitId];
        self.isC2SBiding = NO;
    } else {
        [self trackSplashAdLoaded:splashAd adExtra:nil];
    }
}

- (void)qumeng_splashAdLoadFail:(QuMengSplashAd *)splashAd error:(NSError *)error {
    NSLog(@"QumengSplash::qm_splashAdLoadFail:error" );
    if (self.isC2SBiding) {
        [CustomAdapterC2SBiddingRequestManager disposeLoadFailCall:error key:kATSDKFailedToLoadSplashADMsg unitID:self.networkUnitId];
    } else {
        [self trackSplashAdLoadFailed:error];
    }

}

- (void)qumeng_splashAdDidShow:(QuMengSplashAd *)splashAd {
    NSLog(@"QumengSplash::qm_splashAdDidShow:" );
    [self trackSplashAdShow];
}

- (void)qumeng_splashAdDidClick:(QuMengSplashAd *)splashAd {
    NSLog(@"QumengSplash::qm_splashAdDidClick:" );
    [self trackSplashAdClick];
}

- (void)qumeng_splashAdDidClose:(QuMengSplashAd *)splashAd closeType:(QuMengSplashAdCloseType)type {
    NSLog(@"QumengSplash::qm_splashAdDidClose:" );

    ATAdCloseType closeType = ATAdCloseUnknow;
    [self.containerView removeFromSuperview];
    [self trackSplashAdClosed:@{kATADDelegateExtraDismissTypeKey:@(closeType)}];
}

- (void)qumeng_splashAdVideoDidPlayFinished:(QuMengSplashAd *)splashAd didFailWithError:(NSError *)error {
//    NSLog(@"QumengSplash::qm_splashAdVideoDidPlayFinished:" );
}
 
- (NSString *)networkUnitId {
    return self.serverInfo[@"adslot_id"];
}


@end
