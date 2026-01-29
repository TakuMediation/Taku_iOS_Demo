//
//  DemoCustomBaseAdapter.h
//  AnyThinkSDKDemo
//
//  Created by ltz on 2025/7/21.
//

#import <Foundation/Foundation.h>
#import "DemoCustomAdapterCommonHeader.h"

@interface DemoCustomBaseAdapter : ATBaseMediationAdapter

//C2S flow needed
+ (NSMutableDictionary *)getLossInfoResult:(ATBidWinLossResult *)winLossResult;

//C2S flow needed
+ (NSMutableDictionary *)getWinInfoResult:(ATBidWinLossResult *)winLossResult;

//C2S flow needed
+ (NSMutableDictionary *)getC2SInfo:(NSInteger)ecpm;
 
@end
