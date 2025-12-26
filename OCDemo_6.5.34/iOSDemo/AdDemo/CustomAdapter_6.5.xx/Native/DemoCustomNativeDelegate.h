//
//  DemoCustomNativeDelegate.h
//  AnyThinkSDKDemo
//
//  Created by ltz on 2025/7/22.
//

#import <Foundation/Foundation.h>
#import "DemoCustomAdapterCommonHeader.h"

@interface DemoCustomNativeDelegate : NSObject<MSNativeFeedAdDelegate,MSFeedVideoDelegate>

@property (nonatomic,strong) ATNativeAdStatusBridge *adStatusBridge;

@property (nonatomic, strong) ATAdMediationArgument *adMediationArgument;

@end
