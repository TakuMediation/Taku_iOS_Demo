//
//  DemoCustomSplashAdapter.m
//  AnyThinkSDKDemo
//
//  Created by ltz on 2025/7/21.
//

#import "DemoCustomSplashAdapter.h"
#import "DemoCustomSplashDelegate.h"

@interface DemoCustomSplashAdapter()

@property (nonatomic, strong) MSSplashAd *splashAd;

@property (nonatomic, strong) DemoCustomSplashDelegate *splashDelegate;
 
@end

@implementation DemoCustomSplashAdapter
 
#pragma mark - load Ad
- (void)loadADWithArgument:(ATAdMediationArgument *)argument {
     
    self.splashAd = [[MSSplashAd alloc] init];
    self.splashAd.delegate = self.splashDelegate;

    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    if (self.containerView) {
        size = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - self.containerView.frame.size.height);
    }
    MSSplashAdConfigParams *adParam = [[MSSplashAdConfigParams alloc]init];
    adParam.adSize = size;
    adParam.hideSplashStatusBar = YES;
    if (self.containerView) {
        adParam.bottomView = self.containerView;
    }
    [self.splashAd loadSplashAdWithPid:argument.serverContentDic[@"slot_id"] adParam:adParam];
}
 
// Ad ready
- (BOOL)adReadySplashWithInfo:(NSDictionary *)info {
    return self.splashAd.isAdValid;
}

// Ad show
- (void)showSplashAdInWindow:(UIWindow *)window inViewController:(UIViewController *)inViewController parameter:(NSDictionary *)parameter {
    [self.splashAd showSplashAdInWindow:window];
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
    [ATAdLogger logMessage:[NSString stringWithFormat:@"DemoCustomSplashAdapter sendWin"] type:ATLogTypeExternal];
    
    NSMutableDictionary *infoDic = [DemoCustomBaseAdapter getWinInfoResult:result];
    [self.splashAd sendWinNotificationWithInfo:infoDic];
}

- (void)sendLoss:(ATBidWinLossResult *)result {
   [ATAdLogger logMessage:[NSString stringWithFormat:@"DemoCustomSplashAdapter sendLoss"] type:ATLogTypeExternal];
    
    NSString *priceStr = [self.splashAd mediaExt][@"ecpm"];
    
    NSMutableDictionary *infoDict = [DemoCustomBaseAdapter getLossInfoResult:result];
    [infoDict AT_setDictValue:priceStr key:kMSAdMediaWinPrice];
    [self.splashAd sendLossNotificationWithInfo:infoDict];
}

#pragma mark - lazy
- (DemoCustomSplashDelegate *)splashDelegate {
    if (_splashDelegate == nil) {
        _splashDelegate = [[DemoCustomSplashDelegate alloc] init];
        _splashDelegate.adStatusBridge = self.adStatusBridge;
    }
    return _splashDelegate;
}

@end
