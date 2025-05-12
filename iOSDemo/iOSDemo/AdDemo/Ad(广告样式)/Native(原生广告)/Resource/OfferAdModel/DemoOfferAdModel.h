//
//  DemoOfferAdModel.h
//  iOSDemo
//
//  Created by ltz on 2025/1/21.
//

#import <Foundation/Foundation.h>

@import AnyThinkNative;
 
@interface DemoOfferAdModel : NSObject

@property(nonatomic, strong) ATNativeADView  * nativeADView;

@property(nonatomic, strong) ATNativeAdOffer * offer;
 
@property(nonatomic, assign) BOOL isNativeAd;
 
@end
