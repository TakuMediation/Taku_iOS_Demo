//
//  AdDisplayVC.h
//  iOSDemo
//
//  Created by ltz on 2025/1/11.
//

#import "BannerVC.h"

#import <AnyThinkNative/AnyThinkNative.h>
 
@interface AdDisplayVC : BaseVC

- (instancetype)initWithAdView:(ATNativeADView *)adView offer:(ATNativeAdOffer *)offer adViewSize:(CGSize)size;

@end
