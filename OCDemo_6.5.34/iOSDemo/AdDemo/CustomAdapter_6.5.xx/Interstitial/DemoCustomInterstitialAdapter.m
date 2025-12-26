//
//  DemoCustomInterstitialAdapter.m
//  AnyThinkSDKDemo
//
//  Created by ltz on 2025/7/22.
//

#import "DemoCustomInterstitialAdapter.h"
#import "DemoCustomInterstitialDelegate.h"

@interface DemoCustomInterstitialAdapter()

@property (nonatomic, strong) DemoCustomInterstitialDelegate * interstitialDelegate;

@property (nonatomic, strong) MSInterstitialAd *interstitialAd;

@end

@implementation DemoCustomInterstitialAdapter

#pragma mark - Ad load
- (void)loadADWithArgument:(ATAdMediationArgument *)argument {
 
    self.interstitialAd = [[MSInterstitialAd alloc] init];
    self.interstitialAd.delegate = self.interstitialDelegate;
    
    MSInterstitialAdConfigParams *adParam = [[MSInterstitialAdConfigParams alloc]init];
    adParam.videoMuted = [argument.localInfoDic[@"video_muted"] intValue] == 0 ? NO : YES;
    adParam.isNeedCloseAdAfterClick = [argument.localInfoDic[@"click_close"] intValue] == 0 ? NO : YES;
     
    [self.interstitialAd loadAdWithPid:argument.serverContentDic[@"slot_id"] adConfigParams:adParam];
}
 
#pragma mark - Ad show
- (void)showInterstitialInViewController:(UIViewController *)viewController {
    [self.interstitialAd showAdFromRootViewController:viewController];
}
 
#pragma mark - Ad ready
- (BOOL)adReadyInterstitialWithInfo:(NSDictionary *)info {
    return self.interstitialAd.isAdValid;
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
    [ATAdLogger logMessage:[NSString stringWithFormat:@"DemoCustomInterstitialAdapter sendWin"] type:ATLogTypeExternal];
    
    NSMutableDictionary *infoDic = [DemoCustomBaseAdapter getWinInfoResult:result];
    [self.interstitialAd sendWinNotificationWithInfo:infoDic];
}

- (void)sendLoss:(ATBidWinLossResult *)result {
   [ATAdLogger logMessage:[NSString stringWithFormat:@"DemoCustomInterstitialAdapter sendLoss"] type:ATLogTypeExternal];
    
    NSString *priceStr = [self.interstitialAd mediaExt][@"ecpm"];
    
    NSMutableDictionary *infoDict = [DemoCustomBaseAdapter getLossInfoResult:result];
    [infoDict AT_setDictValue:priceStr key:kMSAdMediaWinPrice];
    [self.interstitialAd sendLossNotificationWithInfo:infoDict];
}

#pragma mark - lazy
- (DemoCustomInterstitialDelegate *)interstitialDelegate{
    if (_interstitialDelegate == nil) {
        _interstitialDelegate = [[DemoCustomInterstitialDelegate alloc] init];
        _interstitialDelegate.adStatusBridge = self.adStatusBridge;
    }
    return _interstitialDelegate;
}

@end
