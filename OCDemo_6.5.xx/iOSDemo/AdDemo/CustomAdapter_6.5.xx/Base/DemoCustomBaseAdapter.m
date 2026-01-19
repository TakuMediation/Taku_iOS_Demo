//
//  DemoCustomBaseAdapter.m
//  AnyThinkSDKDemo
//
//  Created by ltz on 2025/7/21.
//

#import "DemoCustomBaseAdapter.h"


@implementation DemoCustomBaseAdapter

#pragma mark - adapter init class name define
- (Class)initializeClassName {
    return [DemoCustomInitAdapter class];
}

#pragma mark - tools
+ (NSMutableDictionary *)getC2SInfo:(NSInteger)ecpm {
    
    NSMutableDictionary *infoDic = [NSMutableDictionary dictionary];
    
    NSString *priceStr = [NSString stringWithFormat:@"%ld",ecpm];
    NSString *logOriginalString = [NSString stringWithFormat:@"MS:C2S Original priceStr :%@",priceStr];
    NSLog(@"DemoCustomBaseAdapter 获取到广告价格:%@",logOriginalString);
    
    if ([priceStr doubleValue] < 0) {
        priceStr = @"0";
    }
    
    [infoDic AT_setDictValue:priceStr key:ATAdSendC2SBidPriceKey];
    [infoDic AT_setDictValue:@(ATBiddingCurrencyTypeCNYCents) key:ATAdSendC2SCurrencyTypeKey];
    
    NSString *logString = [NSString stringWithFormat:@"[Network:C2S]::MS::%@",infoDic];
    NSLog(@"DemoCustomBaseAdapter 获取到C2S信息:%@",logString);

    return infoDic;
}

+ (NSMutableDictionary *)getLossInfoResult:(ATBidWinLossResult *)winLossResult {
    
    //拼装广告平台 SDK 所需要的信息，每个广告平台 SDK需要的信息各不相同，请根据实际情况来创建信息。
    NSString *errorCode = @"1";

    switch (winLossResult.lossReasonType) {
        case ATBiddingLossWithLowPriceInNormal:
        case ATBiddingLossWithLowPriceInHB:
        case ATBiddingLossWithFloorFilter:
            errorCode = @"1";
            break;
        case ATBiddingLossWithExpire:
            errorCode = @"101";
            break;
        default:
            break;
    }
    
    NSString *winADN = @"2";

    NSString *winLossAdWinnerNetworkFirmID = winLossResult.userInfoDic[kATWinLossAdWinnerNetworkFirmID];
    if ([winLossAdWinnerNetworkFirmID isEqualToString:@"93"]) {
        winADN = @"4";
    }
    
    NSMutableDictionary *infoDic = [NSMutableDictionary dictionary];

    [infoDic AT_setDictValue:winLossResult.winPrice key:kMSAdMediaWinPrice];
    //竞败原因 (1：竞争力不足 101：未参与竞价 10001：其他)
    [infoDic AT_setDictValue:errorCode key:kMSAdMediaLossReason];
    //竞胜方渠道ID (1：美数其他非bidding广告位 2：第三方ADN 3：自售广告主 4：美数其他bidding广告位)
    [infoDic AT_setDictValue:winADN key:kMSAdMediaWinADN];
    return infoDic;
}

+ (NSMutableDictionary *)getWinInfoResult:(ATBidWinLossResult *)winLossResult {
    NSMutableDictionary *infoDic = [NSMutableDictionary dictionary];
    //通常需要回传二价
    [infoDic AT_setDictValue:winLossResult.secondPrice key:kMSAdMediaLossPrice];
    return infoDic;
}

@end
