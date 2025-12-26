//
//  DemoCustomInterstitialDelegate.h
//  AnyThinkSDKDemo
//
//  Created by ltz on 2025/7/22.
//

#import <Foundation/Foundation.h>
#import "DemoCustomAdapterCommonHeader.h"

@interface DemoCustomInterstitialDelegate : NSObject<MSInterstitialDelegate>

@property (nonatomic, strong) ATInterstitialAdStatusBridge * adStatusBridge;
 
@end
