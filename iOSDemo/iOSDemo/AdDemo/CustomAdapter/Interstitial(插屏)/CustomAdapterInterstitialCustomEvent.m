//
//  CustomAdapterInterstitialCustomEvent.m
//  CustomAdapter
//
//  Created by mac on 2024/8/27.
//

#import "CustomAdapterInterstitialCustomEvent.h"
#import "CustomAdapterC2SBiddingRequestManager.h"
 
@interface CustomAdapterInterstitialCustomEvent()<QuMengInterstitialAdDelegate>

@end

@implementation CustomAdapterInterstitialCustomEvent

- (instancetype)initWithInfo:(NSDictionary *)serverInfo localInfo:(NSDictionary *)localInfo {
    if (self = [super initWithInfo:serverInfo localInfo:localInfo]) {
    }
    return self;
}

// MARK: - QMInterstitialAdDelegate
- (void)qumeng_interstitialAdLoadSuccess:(QuMengInterstitialAd *)interstitialAd {
    NSLog(@"%@",[NSString stringWithFormat:@"QumengInterstitial::qm_interstitialAdLoadSuccess:"] );
    if (self.isC2SBiding) {
        NSString *price = [NSString stringWithFormat:@"%ld", (long)interstitialAd.meta.getECPM];
        [CustomAdapterC2SBiddingRequestManager disposeLoadSuccessCall:price customObject:interstitialAd unitID:self.networkUnitId];
        self.isC2SBiding = NO;
    } else {
        [self trackInterstitialAdLoaded:interstitialAd adExtra:nil];
    }
}

- (void)qumeng_interstitialAdLoadFail:(QuMengInterstitialAd *)interstitialAd error:(NSError *)error {
    NSLog(@"%@",[NSString stringWithFormat:@"QumengRewardedVideo::qm_interstitialAdLoadFail:error:%@",error] );
    if (self.isC2SBiding) {
        [CustomAdapterC2SBiddingRequestManager disposeLoadFailCall:error key:kATSDKFailedToLoadInterstitialADMsg unitID:self.networkUnitId];
    } else {
        [self trackInterstitialAdLoadFailed:error];
    } 
}

- (void)qumeng_interstitialAdDidShow:(QuMengInterstitialAd *)interstitialAd {
    NSLog(@"%@",[NSString stringWithFormat:@"QumengInterstitial::qm_interstitialAdDidShow:"] );

    [self trackInterstitialAdShow];
}

- (void)qumeng_interstitialAdDidClick:(QuMengInterstitialAd *)interstitialAd {
    NSLog(@"%@",[NSString stringWithFormat:@"QumengInterstitial::qm_interstitialAdDidClick:"] );
    [self trackInterstitialAdClick];
}

- (void)qumeng_interstitialAdDidCloseOtherController:(QuMengInterstitialAd *)interstitialAd {
    NSLog(@"%@",[NSString stringWithFormat:@"QumengInterstitial::qm_interstitialAdDidCloseOtherController:"] );
    [self trackInterstitialAdLPClose:nil];
}

- (void)qumeng_interstitialAdDidClose:(QuMengInterstitialAd *)interstitialAd closeType:(QuMengInterstitialAdCloseType)type {
    NSLog(@"%@",[NSString stringWithFormat:@"QumengInterstitial::qm_interstitialAdDidClose:"] );
    [self trackInterstitialAdClose:nil];
}

- (void)qumeng_interstitialAdVideoDidPlayComplection:(QuMengInterstitialAd *)interstitialAd {
    NSLog(@"%@",[NSString stringWithFormat:@"QumengInterstitial::qm_interstitialAdVideoDidPlayComplection:"] );
//    [self trackInterstitialAdVideoEnd]; // 趣盟插屏目前不对外 回调视频类素材的播放动作
}

- (void)qumeng_interstitialAdVideoDidPlayFinished:(QuMengInterstitialAd *)interstitialAd didFailWithError:(NSError *)error {
    NSLog(@"%@",[NSString stringWithFormat:@"QumengInterstitial::qm_interstitialAdVideoDidPlayFinished:"] );
    [self trackInterstitialAdDidFailToPlayVideo:error];
}

- (NSString *)networkUnitId {
    return self.serverInfo[@"adslot_id"];
}

@end
