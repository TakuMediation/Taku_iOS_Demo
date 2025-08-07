//
//  CustomAdapterNativeRenderer.m
//  CustomAdapter
//
//  Created by mac on 2024/8/28.
//

#import "CustomAdapterNativeRenderer.h"

#import "CustomAdapterNativeCustomEvent.h"
#import <QuMengAdSDK/QuMengAdSDK.h>

@interface CustomAdapterNativeRenderer ()

@property (nonatomic, readonly, weak) CustomAdapterNativeCustomEvent *customEvent;

@property (nonatomic, strong) QuMengNativeAd *nativeAd;

@end

@implementation CustomAdapterNativeRenderer

- (void)renderOffer:(ATNativeADCache *)offer {
    [super renderOffer:offer];
    
    _customEvent = offer.assets[kATAdAssetsCustomEventKey];
    _customEvent.adView = self.ADView;
    self.ADView.customEvent = _customEvent;
    
    id value = offer.assets[kATAdAssetsCustomObjectKey];
    
    // 模板渲染
    if ([value isKindOfClass:[QuMengFeedAd class]]) {
        QuMengFeedAd *feedAd = (QuMengFeedAd *)value;
        feedAd.feedView.frame = self.ADView.bounds;
        [self.ADView addSubview:feedAd.feedView];
        feedAd.feedView.center = CGPointMake(CGRectGetMidX(self.ADView.bounds), CGRectGetMidY(self.ADView.bounds));
    }
    
    // 自渲染
    if ([value isKindOfClass:[QuMengNativeAd class]]) {
        QuMengNativeAd *nativeAd = (QuMengNativeAd *)value;
        [nativeAd registerContainer:self.ADView withClickableViews:[self.ADView clickableViews]];
    }
}

- (UIView *)getNetWorkMediaView {
    // 先调用了这里
    ATNativeADCache *offer = (ATNativeADCache *)self.ADView.nativeAd;
    id valueOri = offer.assets[kATAdAssetsCustomObjectKey];
    QuMengNativeAd * value = valueOri;
    
    if ([valueOri isKindOfClass:[QuMengNativeAd class]] && (value.meta.getMaterialType == 4)) { // QuMengMaterialTypeVideo
        UIView *videoAdView = value.videoView;
        videoAdView.frame = CGRectMake(0, 0, self.configuration.mediaViewFrame.size.width, self.configuration.mediaViewFrame.size.height);
        return videoAdView;
    }
    
    return nil;
}

#pragma mark - 以下若需要才重写 Overwrite if needed
- (BOOL)isVideoContents {
    id valueOri = offer.assets[kATAdAssetsCustomObjectKey];
    QuMengNativeAd * nativeAd = valueOri;
    return nativeAd.hasVideoContent;
}
 
- (void)dealloc {
    id valueOri = offer.assets[kATAdAssetsCustomObjectKey];
    QuMengNativeAd * nativeAd = valueOri;
    if (nativeAd) {
        [nativeAd unregisterAdView];
    }
}
 
- (ATNativeAdRenderType)getCurrentNativeAdRenderType {
    id valueOri = offer.assets[kATAdAssetsCustomObjectKey];
    QuMengNativeAd * nativeAd = valueOri;
    if (nativeAd.nativeType == QMNativeAdRenderSelfRender) {
        return ATNativeAdRenderSelfRender;
    }
    return ATNativeAdRenderExpress
}
 
- (ATNativeAdType)getNativeAdType {
    
}

/**
 * The duration of the video ad playing, unit ms
 */
- (CGFloat)videoPlayTime {
    
}

/**
 * Video ad duration, unit ms
 */
- (CGFloat)videoDuration {
    
}

/**
 Play mute switch
 @param flag whether to mute
 */
- (void)muteEnable:(BOOL)flag {
    
}

/**
 * The video ad play
 */
- (void)videoPlay {
    
}

/**
 * The video ad pause
 */
- (void)videoPause {
    
}

@end
