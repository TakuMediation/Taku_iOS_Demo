//
//  ATNativeShowViewController.h
//  AnyThingSDKDemo
//
//  Created by mac on 2021/12/7.
//

#import <UIKit/UIKit.h>
@import AnyThinkNative;

NS_ASSUME_NONNULL_BEGIN

@interface ATNativeShowViewController : UIViewController

- (instancetype)initWithAdView:(ATNativeADView *)adView placementID:(NSString *)placementID offer:(ATNativeAdOffer *)offer;

@end

NS_ASSUME_NONNULL_END
