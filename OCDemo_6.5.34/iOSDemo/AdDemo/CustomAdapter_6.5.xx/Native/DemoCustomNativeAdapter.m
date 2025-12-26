//
//  DemoCustomNativeAdapter.m
//  AnyThinkSDKDemo
//
//  Created by ltz on 2025/7/22.
//

#import "DemoCustomNativeAdapter.h"
#import "DemoCustomNativeDelegate.h"

@interface DemoCustomNativeAdapter()

@property (nonatomic, strong) DemoCustomNativeDelegate * nativeDelegate;
@property (nonatomic, strong) MSNativeFeedAd           * nativeExpressAd;
 
@end

@implementation DemoCustomNativeAdapter

#pragma mark - init
- (void)loadADWithArgument:(ATAdMediationArgument *)argument {
   
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.nativeExpressAd = [[MSNativeFeedAd alloc]init];
        self.nativeExpressAd.delegate = self.nativeDelegate;
        
        self.nativeDelegate.adMediationArgument = argument;
        
        MSNativeFeedAdConfigParams *adParam = [[MSNativeFeedAdConfigParams alloc] init];
        //params from dashboard
        adParam.adCount = [argument.serverContentDic[@"request_num"] intValue] ? [argument.serverContentDic[@"request_num"] intValue] : 1;
        //params from dashboard
        adParam.videoMuted = [argument.serverContentDic[@"video_muted"] intValue] == 0 ? NO : YES;
        adParam.isAutoPlay = NO;
        
        if ([argument.localInfoDic[kATExtraInfoNativeAdSizeKey] respondsToSelector:@selector(CGSizeValue)]) {
            CGSize size = [argument.localInfoDic[kATExtraInfoNativeAdSizeKey] CGSizeValue];
 
            NSDictionary * userExtra = argument.localInfoDic[kATADDelegateExtraUserCustomData];
            BOOL sizeToFit = userExtra[kATNativeAdSizeToFitKey];
            adParam.prerenderAdSize = CGSizeMake(size.width, sizeToFit?0:size.height);
        }
        [self.nativeExpressAd loadAdWithPid:argument.serverContentDic[@"slot_id"]  adParam:adParam];
    });
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
    NSMutableDictionary *infoDict = [DemoCustomBaseAdapter getWinInfoResult:result];
    
    NSString *priceStr = [self.nativeExpressAd mediaExt][@"ecpm"];
    [infoDict AT_setDictValue:priceStr key:kMSAdMediaWinPrice];
    [self.nativeExpressAd sendWinNotificationWithInfo:infoDict];
}

- (void)sendLoss:(ATBidWinLossResult *)result {
    NSMutableDictionary *infoDic = [DemoCustomBaseAdapter getLossInfoResult:result];
    [self.nativeExpressAd sendLossNotificationWithInfo:infoDic];
}
 
#pragma mark - lazy
- (DemoCustomNativeDelegate *)nativeDelegate{
    if (_nativeDelegate == nil) {
        _nativeDelegate = [[DemoCustomNativeDelegate alloc] init];
        _nativeDelegate.adStatusBridge = self.adStatusBridge;
    }
    return _nativeDelegate;
}

@end
