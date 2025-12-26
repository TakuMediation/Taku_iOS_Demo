//
//  DemoCustomRewardVideoDelegate.h
//  AnyThinkSDKDemo
//
//  Created by ltz on 2025/7/22.
//

#import <Foundation/Foundation.h>
#import "DemoCustomAdapterCommonHeader.h"

@interface DemoCustomRewardVideoDelegate : NSObject<MSRewardVideoAdDelegate>

@property (nonatomic, strong) ATRewardedAdStatusBridge * adStatusBridge;

@end
