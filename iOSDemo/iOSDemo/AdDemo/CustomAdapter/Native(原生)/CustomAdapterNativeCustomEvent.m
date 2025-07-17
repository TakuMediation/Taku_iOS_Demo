//
//  CustomAdapterNativeCustomEvent.m
//  CustomAdapter
//
//  Created by mac on 2024/8/27.
//

#import "CustomAdapterNativeCustomEvent.h"
   
#import "CustomAdapterC2SBiddingRequestManager.h"
#import "ATSafeThreadDictionary_QM.h"

@interface CustomAdapterNativeCustomEvent ()

@property (nonatomic, strong) QuMengNativeAd *nativeAd;
@property (nonatomic, strong) QuMengFeedAd *feedAd;

@end

@implementation CustomAdapterNativeCustomEvent

- (instancetype)initWithInfo:(NSDictionary *)serverInfo localInfo:(NSDictionary *)localInfo {
    if (self = [super initWithInfo:serverInfo localInfo:localInfo]) {
    }
    return self;
}

#pragma mark - 信息流模板渲染相关回调
/// 信息流广告加载成功
- (void)qumeng_feedAdLoadSuccess:(QuMengFeedAd *)feedAd {
    NSLog(@"QMNative::qm_feedAdLoadSuccess:" );
    
    self.adAsset = [[ATSafeThreadDictionary_QM alloc] init];
    [self.adAsset AT_setDictValue:self key:kATAdAssetsCustomEventKey];
    [self.adAsset AT_setDictValue:feedAd key:kATAdAssetsCustomObjectKey];
    [self.adAsset AT_setDictValue:@([feedAd handleFeedAdHeight]) key:kATNativeADAssetsNativeExpressAdViewHeightKey];
    [self.adAsset AT_setDictValue:feedAd.feedView key:kATNativeADAssetsMediaViewKey];
    [self.adAsset AT_setDictValue:@(YES) key:kATNativeADAssetsIsExpressAdKey];
    
    if (self.isC2SBiding) {
        NSString *price = [NSString stringWithFormat:@"%ld", (long)feedAd.meta.getECPM];
        [CustomAdapterC2SBiddingRequestManager disposeLoadSuccessCall:price customObject:feedAd unitID:self.networkUnitId];

        self.isC2SBiding = NO;
    } else {
        ATSafeThreadDictionary_QM *asset = [[ATSafeThreadDictionary_QM alloc] initWithDictionary:self.adAsset];
        [self trackNativeAdLoaded:@[asset]];
        // 防止循环引用 后续优化
        [self.adAsset removeAllObjects];
        self.adAsset = nil;

    }
}

/// 信息流广告加载失败
- (void)qumeng_feedAdLoadFail:(QuMengFeedAd *)feedAd error:(NSError *)error {
    NSString *errorString = [NSString stringWithFormat:@"QMNative::qm_feedAdLoadFail:error:%@",error];
    NSLog(errorString );

    if (self.isC2SBiding) {
        [CustomAdapterC2SBiddingRequestManager disposeLoadFailCall:error key:kATSDKFailedToLoadNativeADMsg unitID:self.networkUnitId];
    } else {
        [self trackNativeAdLoadFailed:error];
    }
}

/// 信息流广告曝光
- (void)qumeng_feedAdDidShow:(QuMengFeedAd *)feedAd {
    NSLog(@"QMNative::qm_feedAdDidShow:" );
    [self trackNativeAdImpression];
}

/// 信息流广告点击
- (void)qumeng_feedAdDidClick:(QuMengFeedAd *)feedAd {
    NSLog(@"QMNative::qm_feedAdDidClick:" );
    [self trackNativeAdClick];
}

/// 信息流广告关闭
- (void)qumeng_feedAdDidClose:(QuMengFeedAd *)feedAd {
    NSLog(@"QMNative::qm_feedAdDidClose:" );
    [self trackNativeAdClosed];
}

/// 落地页关闭
- (void)qumeng_feedAdDidCloseOtherController:(QuMengFeedAd *)feedAd {
    NSLog(@"QMNative::qm_feedAdDidCloseOtherController:" );
    [self trackNativeAdCloseDetail];
}

#pragma mark - 信息流自渲染相关回调
- (void)qumeng_nativeAdDidClick:(QuMengNativeAd * _Nonnull)nativeAd {
    NSLog(@"QMNative::qm_nativeAdDidClick:" );
    [self trackNativeAdClick];
}

- (void)qumeng_nativeAdDidCloseOtherController:(QuMengNativeAd * _Nonnull)nativeAd {
    NSLog(@"QMNative::qm_nativeAdDidCloseOtherController:" );
    [self trackNativeAdCloseDetail];
}

- (void)qumeng_nativeAdDidShow:(QuMengNativeAd * _Nonnull)nativeAd {
    NSLog(@"QMNative::qm_nativeAdDidShow:" );
    [self trackNativeAdImpression];
}

- (void)qumeng_nativeAdLoadFail:(QuMengNativeAd * _Nonnull)nativeAd error:(NSError * _Nonnull)error {
    NSLog(@"QMNative::qm_nativeAdLoadFail:" );
    
    if (self.isC2SBiding) {
        [CustomAdapterC2SBiddingRequestManager disposeLoadFailCall:error key:kATSDKFailedToLoadNativeADMsg unitID:self.networkUnitId];
    } else {
        [self trackNativeAdLoadFailed:error];
    }
}

- (void)qumeng_nativeAdLoadSuccess:(QuMengNativeAd * _Nonnull)nativeAd {
    NSLog(@"QMNative::qm_nativeAdLoadSuccess:" );
    
    self.adAsset = [[ATSafeThreadDictionary_QM alloc] init];;
    [self.adAsset AT_setDictValue:self key:kATAdAssetsCustomEventKey];
    //将三方sdk广告对象引用
    [self.adAsset AT_setDictValue:nativeAd key:kATAdAssetsCustomObjectKey];
    [self.adAsset AT_setDictValue:nativeAd.meta.getTitle key:kATNativeADAssetsMainTitleKey];
    [self.adAsset AT_setDictValue:nativeAd.meta.getDesc key:kATNativeADAssetsMainTextKey];
    [self.adAsset AT_setDictValue:nativeAd.meta.getInteractionTitle key:kATNativeADAssetsCTATextKey];
    [self.adAsset AT_setDictValue:@(NO) key:kATNativeADAssetsIsExpressAdKey];
    [self.adAsset AT_setDictValue:nativeAd.meta.getAppLogoUrl key:kATNativeADAssetsIconURLKey];
    [self.adAsset AT_setDictValue:@(nativeAd.meta.getMediaSize.width) key:kATNativeADAssetsMainImageWidthKey];
    [self.adAsset AT_setDictValue:@(nativeAd.meta.getMediaSize.height) key:kATNativeADAssetsMainImageHeightKey];
    
    if (nativeAd.meta.getMaterialType == 4) { // QuMengMaterialTypeVideo
        [self.adAsset AT_setDictValue:nativeAd.meta.logoUrl key:kATNativeADAssetsImageURLKey];
        [self.adAsset AT_setDictValue:@(YES) key:kATNativeADAssetsContainsVideoFlag];
        [self.adAsset AT_setDictValue:nativeAd.meta.getMediaUrl key:kATNativeADAssetsVideoUrlKey];
        [self.adAsset AT_setDictValue:@(nativeAd.meta.getVideoDuration) key:kATNativeADAssetsVideoDurationKey];
        [self.adAsset AT_setDictValue:@(nativeAd.meta.getMediaMute) key:kATNativeADAssetsVideoMutedTypeKey];
    } else if (nativeAd.meta.getMaterialType == 3) { // QuMengMaterialTypeImageAtlas
        NSMutableArray *images = [[NSMutableArray alloc] init];
        for (NSString *url in nativeAd.meta.getExtUrls) {
            [images addObject:url];
        }
        [self.adAsset AT_setDictValue:images key:kATNativeADAssetsImageListKey];
    } else if (nativeAd.meta.getMaterialType == 2 || nativeAd.meta.getMaterialType == 1) { // QuMengMaterialTypeImageLarge || QuMengMaterialTypeImageSmall
        [self.adAsset AT_setDictValue:nativeAd.meta.getMediaUrl key:kATNativeADAssetsImageURLKey];
    }
    
    if (self.isC2SBiding) {
        NSString *price = [NSString stringWithFormat:@"%ld", (long)nativeAd.meta.getECPM];
        [CustomAdapterC2SBiddingRequestManager disposeLoadSuccessCall:price customObject:nativeAd unitID:self.networkUnitId];
        self.isC2SBiding = NO;
    } else {
        
        ATSafeThreadDictionary_QM *asset = [[ATSafeThreadDictionary_QM alloc] initWithDictionary:self.adAsset];
        [self trackNativeAdLoaded:@[asset]];
        // 防止循环引用 后续优化
        [self.adAsset removeAllObjects];
        self.adAsset = nil;

    }
}

- (NSString *)networkUnitId {
    return self.serverInfo[@"adslot_id"];
}

- (ATSafeThreadDictionary_QM *)getAdAssets {
    return self.adAsset;
}



@end
