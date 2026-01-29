//
//  DemoCustomBannerAdapter.m
//  AnyThinkSDKDemo
//
//  Created by ltz on 2025/7/22.
//

#import "DemoCustomBannerAdapter.h"
#import "DemoCustomBannerDelegate.h"

@interface DemoCustomBannerAdapter()

@property (nonatomic, strong) DemoCustomBannerDelegate * bannerDelegate;

@property (nonatomic, strong) MSBannerView *bannerView;

@end

@implementation DemoCustomBannerAdapter

#pragma mark - Ad load
- (void)loadADWithArgument:(ATAdMediationArgument *)argument {
    dispatch_async(dispatch_get_main_queue(), ^{
 
        CGSize bannerSize = CGSizeMake(320, 50);
        if (!CGSizeEqualToSize(argument.bannerSize, CGSizeZero)) {
            bannerSize = argument.bannerSize;
        }
        
        self.bannerView = [[MSBannerView alloc] initWithFrame:CGRectMake(0, 0, bannerSize.width, bannerSize.height)];
        self.bannerView.delegate = self.bannerDelegate;
        
        MSBannerAdConfigParams *adParam = [[MSBannerAdConfigParams alloc]init];
        adParam.showCloseBtn = NO;
        adParam.interval = 0;
         
        [self.bannerView loadAdAndShowWithPid:argument.serverContentDic[@"slot_id"] presentVC:argument.viewController adParams:adParam];
    });
}

#pragma mark - lazy
- (DemoCustomBannerDelegate *)bannerDelegate{
    if (_bannerDelegate == nil) {
        _bannerDelegate = [[DemoCustomBannerDelegate alloc] init];
        _bannerDelegate.adStatusBridge = self.adStatusBridge;
    }
    return _bannerDelegate;
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
    [ATAdLogger logMessage:[NSString stringWithFormat:@"DemoCustomBannerAdapter sendWin"] type:ATLogTypeExternal];
    
    NSMutableDictionary *infoDic = [DemoCustomBaseAdapter getWinInfoResult:result];
    [self.bannerView sendWinNotificationWithInfo:infoDic];
}

- (void)sendLoss:(ATBidWinLossResult *)result {
   [ATAdLogger logMessage:[NSString stringWithFormat:@"DemoCustomBannerAdapter sendLoss"] type:ATLogTypeExternal];
    
    NSString *priceStr = [self.bannerView mediaExt][@"ecpm"];
    
    NSMutableDictionary *infoDict = [DemoCustomBaseAdapter getLossInfoResult:result];
    [infoDict AT_setDictValue:priceStr key:kMSAdMediaWinPrice];
    [self.bannerView sendLossNotificationWithInfo:infoDict];
}
 

@end
