//
//  CustomAdapterRewardVideoCustomEvent.m
//  CustomAdapter
//
//  Created by mac on 2024/8/27.
//

#import "CustomAdapterRewardVideoCustomEvent.h"
#import "CustomAdapterC2SBiddingRequestManager.h" 

@interface CustomAdapterRewardVideoCustomEvent()<QuMengRewardedVideoAdDelegate>

@property (nonatomic, assign) BOOL isRewarded;
@property (nonatomic, assign) BOOL isVideoPlayFinished;

@end

@implementation CustomAdapterRewardVideoCustomEvent

- (instancetype)initWithInfo:(NSDictionary *)serverInfo localInfo:(NSDictionary *)localInfo {
    if (self = [super initWithInfo:serverInfo localInfo:localInfo]) {
        self.isRewarded = NO;
    }
    return self;
}

// MARK: - QMInterstitialAdDelegate
- (void)qumeng_rewardedVideoAdLoadSuccess:(QuMengRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"%@",[NSString stringWithFormat:@"QumengRewardedVideo::qm_rewardedVideoAdLoadSuccess:"] );
    if (self.isC2SBiding) {
        NSString *price = [NSString stringWithFormat:@"%ld", (long)rewardedVideoAd.meta.getECPM];
        [CustomAdapterC2SBiddingRequestManager disposeLoadSuccessCall:price customObject:rewardedVideoAd unitID:self.networkUnitId];
        self.isC2SBiding = NO;
    } else {
        [self trackRewardedVideoAdLoaded:rewardedVideoAd adExtra:nil];
    }

}

- (void)qumeng_rewardedVideoAdLoadFail:(QuMengRewardedVideoAd *)rewardedVideoAd error:(NSError *)error {
    NSLog(@"%@",[NSString stringWithFormat:@"QumengRewardedVideo::qm_rewardedVideoAdLoadFail:error:%@",error] );
    if (self.isC2SBiding) {
        [CustomAdapterC2SBiddingRequestManager disposeLoadFailCall:error key:kATSDKFailedToLoadRewardedVideoADMsg unitID:self.networkUnitId];
    } else {
        [self trackRewardedVideoAdLoadFailed:error];
    }

}

- (void)qumeng_rewardedVideoAdDidShow:(QuMengRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"%@",[NSString stringWithFormat:@"QumengRewardedVideo::qm_rewardedVideoAdDidShow:"] );
    [self trackRewardedVideoAdShow];
    [self trackRewardedVideoAdVideoStart];
}

- (void)qumeng_rewardedVideoAdDidClick:(QuMengRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"%@",[NSString stringWithFormat:@"QumengRewardedVideo::qm_rewardedVideoAdDidClick"] );
    [self trackRewardedVideoAdClick];
}

- (void)qumeng_rewardedVideoAdDidRewarded:(QuMengRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"%@",[NSString stringWithFormat:@"QumengRewardedVideo::qm_rewardedVideoAdDidRewarded"] );
    self.isRewarded = YES;
    [self trackRewardedVideoAdRewarded];
}

- (void)qumeng_rewardedVideoAdDidCloseOtherController:(QuMengRewardedVideoAd *)rewardedVideoAd {
//    NSLog(@"【媒体】激励视频: 关闭落地页");
}

- (void)qumeng_rewardedVideoAdDidClose:(QuMengRewardedVideoAd *)rewardedVideoAd closeType:(QuMengRewardedVideoAdCloseType)type {
    NSLog(@"%@",[NSString stringWithFormat:@"QumengRewardedVideo::qm_rewardedVideoAdDidClose:closeType:%ld", type] );
    ATAdCloseType closeType = ATAdCloseUnknow;
    [self trackRewardedVideoAdCloseRewarded:self.isRewarded extra:@{kATADDelegateExtraDismissTypeKey:@(closeType)}];
}

- (void)qumeng_rewardedVideoAdVideoDidPlayComplection:(QuMengRewardedVideoAd *)rewardedVideoAd rewarded:(BOOL)isRewarded {
    NSLog(@"%@",[NSString stringWithFormat:@"QumengRewardedVideo::qumeng_rewardedVideoAdVideoDidPlayComplection:rewarded:%d",isRewarded] );
    if (!self.isVideoPlayFinished) { // 只对外回调一次
        [self trackRewardedVideoAdVideoEnd];
        self.isVideoPlayFinished = YES;
    }
}

- (void)qumeng_rewardedVideoAdVideoDidPlayFinished:(QuMengRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error rewarded:(BOOL)isRewarded {
    NSLog(@"%@",[NSString stringWithFormat:@"QumengRewardedVideo::qumeng_rewardedVideoAdVideoDidPlayFinished:didFailWithError:%ld:rewarded:%d", (long)error.code, isRewarded] );
    if (error) {
        [self trackRewardedVideoAdPlayEventWithError:error];
    }
}

- (NSString *)networkUnitId {
    return self.serverInfo[@"adslot_id"];
}

@end
