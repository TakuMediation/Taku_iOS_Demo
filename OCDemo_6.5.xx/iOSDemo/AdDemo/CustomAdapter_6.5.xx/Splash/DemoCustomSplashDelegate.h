//
//  DemoCustomSplashDelegate.h
//  AnyThinkSDKDemo
//
//  Created by ltz on 2025/7/21.
//

#import <Foundation/Foundation.h>
#import "DemoCustomAdapterCommonHeader.h"

@interface DemoCustomSplashDelegate : NSObject<MSSplashAdDelegate>

@property (nonatomic, strong) ATSplashAdStatusBridge * adStatusBridge;

@property (nonatomic, strong,nullable) UIView *splashView;

@property (nonatomic, strong,nullable) UIView *containerView;


@end
 
