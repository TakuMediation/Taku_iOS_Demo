//
//  DemoCustomRewardVideoAdapter.m
//  AnyThinkSDKDemo
//
//  Created by ltz on 2025/7/22.
//

#import "DemoCustomRewardVideoAdapter.h"
#import "DemoCustomRewardVideoDelegate.h"

@interface DemoCustomRewardVideoAdapter()

@property (nonatomic, strong) DemoCustomRewardVideoDelegate *rewardedVideoDelegate;

@property (nonatomic, strong) MSRewardVideoAd *rewardAd;

@end

@implementation DemoCustomRewardVideoAdapter
 
#pragma mark - Ad load
- (void)loadADWithArgument:(ATAdMediationArgument *)argument {
     
    self.rewardAd = [[MSRewardVideoAd alloc] init];
    self.rewardAd.delegate = self.rewardedVideoDelegate;
    
    MSRewardAdConfigParams *adParam = [[MSRewardAdConfigParams alloc]init];
    adParam.userId = argument.localInfoDic[kATAdLoadingExtraUserIDKey];
    adParam.videoMuted = [argument.localInfoDic[@"video_muted"] intValue] == 0 ? NO : YES;
 
    [self.rewardAd loadRewardVideoAdWithPid:argument.serverContentDic[@"slot_id"] adConfigParams:adParam];
}
 
#pragma mark - Ad show
- (void)showRewardedVideoInViewController:(UIViewController *)viewController {
    [self.rewardAd showRewardVideoAdFromRootViewController:viewController];
}

#pragma mark - Ad ready
- (BOOL)adReadyRewardedWithInfo:(NSDictionary *)info {
    return self.rewardAd.isAdValid;
}

#pragma mark - C2S Win Loss
- (void)didReceiveBidResult:(ATBidWinLossResult *)result {
    if (result.bidResultType == ATBidWinLossResultTypeWin) {
        [self sendWin:result];
        return;
    }
    [self sendLoss:result];
}

- (void)sendWin:(ATBidWinLossResult *)result {
    [ATAdLogger logMessage:[NSString stringWithFormat:@"DemoCustomRewardVideoAdapter sendWin"] type:ATLogTypeExternal];
    
    NSMutableDictionary *infoDic = [DemoCustomBaseAdapter getWinInfoResult:result];
    [self.rewardAd sendWinNotificationWithInfo:infoDic];
}

- (void)sendLoss:(ATBidWinLossResult *)result {
   [ATAdLogger logMessage:[NSString stringWithFormat:@"DemoCustomRewardVideoAdapter sendLoss"] type:ATLogTypeExternal];
    
    NSString *priceStr = [self.rewardAd mediaExt][@"ecpm"];
    
    NSMutableDictionary *infoDict = [DemoCustomBaseAdapter getLossInfoResult:result];
    [infoDict AT_setDictValue:priceStr key:kMSAdMediaWinPrice];
    [self.rewardAd sendLossNotificationWithInfo:infoDict];
}

#pragma mark - lazy
- (DemoCustomRewardVideoDelegate *)rewardedVideoDelegate{
    if (_rewardedVideoDelegate == nil) {
        _rewardedVideoDelegate = [[DemoCustomRewardVideoDelegate alloc] init];
        _rewardedVideoDelegate.adStatusBridge = self.adStatusBridge;
    }
    return _rewardedVideoDelegate;
}

@end
