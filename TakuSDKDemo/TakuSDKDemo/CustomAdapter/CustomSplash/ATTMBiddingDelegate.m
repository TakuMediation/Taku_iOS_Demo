//
//  ATTMBiddingDelegate.m
//  HeadBiddingDemo
//
//  Created by lix on 2022/10/20.
//

#import "ATTMBiddingDelegate.h"
#import "ATTMBiddingManager.h"
#import "ATTMBiddingRequest.h"

#import <TianmuSDK/TianmuSDK.h>
#import <TianmuSDK/TianmuSplashAd.h>
#import <AnyThinkSplash/AnyThinkSplash.h>

@interface ATTMBiddingDelegate () <TianmuSplashAdDelegate>

@end

@implementation ATTMBiddingDelegate


- (void)tianmuSplashAdSuccessLoad:(TianmuSplashAd *)splashAd{
    NSLog(@"%s", __FUNCTION__);
}

/**
 *  开屏广告素材加载成功
 */
- (void)tianmuSplashAdDidLoad:(TianmuSplashAd *)splashAd {
    
    
    NSLog(@"%s", __FUNCTION__);

    ATTMBiddingRequest *request = [[ATTMBiddingManager sharedInstance] getRequestItemWithUnitID:self.unitID];
    
    if (request.bidCompletion) {
        ATBidInfo *bidInfo = [ATBidInfo bidInfoC2SWithPlacementID:request.placementID unitGroupUnitID:request.unitGroup.unitID adapterClassString:request.unitGroup.adapterClassString price:@(splashAd.bidPrice/100.0f).stringValue currencyType:ATBiddingCurrencyTypeCNY expirationInterval:request.unitGroup.networkTimeout customObject:splashAd];
        request.bidCompletion(bidInfo, nil);
    }
    
    [[ATTMBiddingManager sharedInstance] removeBiddingDelegateWithUnitID:self.unitID];
    
}

/**
 *  开屏广告请求失败
 */
- (void)tianmuSplashAdFailLoad:(TianmuSplashAd *)splashAd withError:(NSError *)error{
    NSLog(@"%s %@", __FUNCTION__ ,error);
    
    ATTMBiddingRequest *request = [[ATTMBiddingManager sharedInstance] getRequestItemWithUnitID:self.unitID];
    if (request.bidCompletion) {
        request.bidCompletion(nil, error);
    }
    [[ATTMBiddingManager sharedInstance] removeBiddingDelegateWithUnitID:self.unitID];
}

@end
