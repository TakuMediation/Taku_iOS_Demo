//
//  ATOfferAdMode.h
//  AnyThinkSDKDemo
//
//  Created by GUO PENG on 2022/6/30.
//  Copyright © 2022 抽筋的灯. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AnyThinkNative;

NS_ASSUME_NONNULL_BEGIN

@interface ATDemoOfferAdMode : NSObject

@property(nonatomic, strong) ATNativeADView *nativeADView;

@property(nonatomic, strong) ATNativeAdOffer *offer;

@property(nonatomic, strong) NSString *drawVideoUrlStr;

@property(nonatomic, assign) BOOL isNativeAd;

@end

NS_ASSUME_NONNULL_END
