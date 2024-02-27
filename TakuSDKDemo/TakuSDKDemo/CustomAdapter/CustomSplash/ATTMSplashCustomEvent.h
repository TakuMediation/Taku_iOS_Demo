//
//  ATTMSplashCustomEvent.h
//  eseecloud
//
//  Created by Yc on 2022/10/17.
//  Copyright © 2022 juanvision. All rights reserved.
//

#import <AnyThinkSplash/AnyThinkSplash.h>
#import <TianmuSDK/TianmuSDK.h>
#import <TianmuSDK/TianmuSplashAd.h>
#import <AnyThinkSDK/ATBidInfoCacheManager.h>


NS_ASSUME_NONNULL_BEGIN

@interface ATTMSplashCustomEvent : ATSplashCustomEvent <TianmuSplashAdDelegate>

@property(nonatomic, weak) UIView *containerView;

@end

NS_ASSUME_NONNULL_END
