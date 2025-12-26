//
//  DemoCustomNativeDelegate.m
//  AnyThinkSDKDemo
//
//  Created by ltz on 2025/7/22.
//

#import "DemoCustomNativeDelegate.h"
#import "DemoCustomNativeObject.h"

@interface DemoCustomNativeDelegate()

@property (nonatomic, strong) MSNativeFeedAd *nativeFeedAd;

@end

@implementation DemoCustomNativeDelegate

- (void)nativeRenderingFeedAds:(NSArray <MSNativeFeedAdModel *> *)feedAds {
    
    MSNativeFeedAdModel *feedAdModel = feedAds.firstObject;
    //判断是自渲染广告还是模版广告，走对应不同的处理逻辑
    if (feedAdModel.isNativeExpress) {
        [self _expressRenderingFeedAds:feedAds];
    }else{
        [self _selfRenderingFeedAds:feedAds];
    }
}

- (void)_selfRenderingFeedAds:(NSArray <MSNativeFeedAdModel *> *)feedAds {
    
    NSMutableArray *offerArray = [NSMutableArray array];
    
    NSDictionary *infoDic = [DemoCustomBaseAdapter getC2SInfo:[feedAds.firstObject ecpm]];
    
    [feedAds enumerateObjectsUsingBlock:^(MSNativeFeedAdModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
        id<MSFeedAdMeta> ad = obj.adMaterialMeta;
        
        DemoCustomNativeObject *nativeObject = [[DemoCustomNativeObject alloc] init];
        nativeObject.feedAdMetaad = ad;
        nativeObject.nativeAdRenderType = ATNativeAdRenderSelfRender;
        nativeObject.title = ad.metaContent;
        nativeObject.mainText = ad.metaContent;
        nativeObject.ctaText = ad.metaActionTitle;
        nativeObject.rating = @([ad.metaAppScore doubleValue]);
        nativeObject.appPrice = ad.metaAppPrice;
        nativeObject.videoDuration = ad.metaVideoDuration;
        
        CGSize imageSize = ad.metaMainImageSize;
        nativeObject.mainImageWidth = imageSize.width;
        nativeObject.mainImageHeight = imageSize.height;

        nativeObject.iconUrl = ad.metaIcon;
        nativeObject.imageUrl = ad.metaImageUrls.firstObject;
        nativeObject.imageList = ad.metaImageUrls;
        
        //设置一个期望的默认值
        CGRect mediaViewFrame = CGRectMake(0, 0, kScreenW, 100);
        
        //取开发者load的时候，通过kATExtraInfoMediaViewFrameKey传入的
        NSValue *mediaViewFrameV = self.adMediationArgument.localInfoDic[kATExtraInfoMediaViewFrameKey];
        
        if ([mediaViewFrameV respondsToSelector:@selector(CGRectValue)]) {
            mediaViewFrame = [mediaViewFrameV CGRectValue];
        }
        
        //根据自定义广告平台SDK素材类型，设置是否是视频素材
        if (ad.metaCreativeType == MSCreativeTypeVideo) {
            //设置为视频素材
            nativeObject.isVideoContents = YES;
            
            MSFeedVideoConfig *config = [MSFeedVideoConfig new];
            //根据参数取出，并设置给自定义广告平台SDK是否静音
            config.isMute = [self.adMediationArgument.serverContentDic[@"video_muted"] intValue] == 0 ? NO : YES;;
            config.isAutoPlay = NO;
            
            MSFeedVideoView *feedVideoView = [[MSFeedVideoView alloc] init];
            feedVideoView.videoConfig = config;
            //添加媒体视图代理对象
            feedVideoView.delegate = self;
            //获取自定义广告平台 SDK的媒体视图并赋值给我们
            nativeObject.mediaView = feedVideoView;
        }
        
        [offerArray addObject:nativeObject];
    }];
    
    //自定义参数
    [infoDic setValue:@"custom params value" forKey:@"custom params key"];
    
    [self.adStatusBridge atOnNativeAdLoadedArray:offerArray adExtra:infoDic];
}

- (void)_expressRenderingFeedAds:(NSArray <MSNativeFeedAdModel *> *)feedAds {
    
    NSMutableArray *offerArray = [NSMutableArray array];

    NSDictionary *infoDic = [DemoCustomBaseAdapter getC2SInfo:[feedAds.firstObject ecpm]];

    
    [feedAds enumerateObjectsUsingBlock:^(MSNativeFeedAdModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIView *nativeAdView = obj.feedView;
        DemoCustomNativeObject *nativeObject = [[DemoCustomNativeObject alloc] init];
        nativeObject.feedAdModel = obj;
        nativeObject.templateView = nativeAdView;
        nativeObject.nativeAdRenderType = ATNativeAdRenderExpress;
        nativeObject.nativeExpressAdViewWidth = nativeAdView.frame.size.width;
        nativeObject.nativeExpressAdViewHeight = nativeAdView.frame.size.height;
        nativeObject.isVideoContents = obj.isVideo;
        
        [offerArray addObject:nativeObject];
    }];
    
    [self.adStatusBridge atOnNativeAdLoadedArray:offerArray adExtra:infoDic];
}

/**
 *  新原生广告加载广告数据成功回调，返回为广告物料的数组
 */
- (void)msNativeFeedAdLoaded:(MSNativeFeedAd *)nativeFeedAd feedAds:(NSArray <MSNativeFeedAdModel *> *)feedAds {
    self.nativeFeedAd = nativeFeedAd;
    [self nativeRenderingFeedAds:feedAds];
}

/**
 *  新原生广告加载广告数据失败回调
 */
- (void)msNativeFeedAdError:(MSNativeFeedAd *)nativeFeedAd withError:(NSError *)error {
    [self.adStatusBridge atOnAdLoadFailed:error adExtra:nil];
}

/**
 *  广告素材预处理成功回调
 */
- (void)msNativeFeedAdMaterialMetaReadySuccess:(MSNativeFeedAd *)nativeFeedAd feedAd:(MSNativeFeedAdModel *)feedAd {

}

/**
 *  广告素材预处理失败回调
 */
- (void)msNativeFeedAdMaterialMetaReadyError:(MSNativeFeedAd *)nativeFeedAd feedAd:(MSNativeFeedAdModel *)feedAd error:(NSError *)error {

}

/**
 *注意⚠️：当该广告物料是⚠️[模版广告]⚠️时触发此回调
 *  广告被关闭
 *  详解:广告点击关闭后回调
 */
- (void)msNativeFeedAdClosed:(MSNativeFeedAdModel *)feedAd {
    [self.adStatusBridge atOnAdClosed:nil];
}

/**
 *  新原生广告即将展现
 */
- (void)msNativeFeedAdShow:(MSNativeFeedAdModel *)feedAd {
}
 
/**
 *  新原生广告展现失败
 */
- (void)msNativeFeedAdShowFailed:(MSNativeFeedAdModel *)feedAd error:(NSError *)error {
}

/**
 *  广告被点击
 */
- (void)msNativeFeedAdClick:(MSNativeFeedAdModel *)feedAd {
    [self.adStatusBridge atOnAdClick:nil];
}

/**
 模版视频播放状态
 注意：仅ms、广点通、穿山甲会回调
 */
- (void)msNativeFeedAdVideoStateDidChanged:(MSPlayerPlayState)playerState
                                    feedAd:(MSNativeFeedAdModel *)feedAd {

}

/**
 *注意⚠️：当该广告物料是⚠️自渲染广告⚠️时触发此回调
 *  原生广告点击之后将要展示内嵌浏览器或应用内AppStore回调
 */
- (void)msNativeFeedAdDetailShow {

}

/**
 *注意⚠️：当该广告物料是⚠️自渲染广告⚠️时触发此回调
 * 新原生广告点击以后，内置AppStore或是内置浏览器被关闭时回调
 */
- (void)msNativeFeedAdDetailClosed {
    [ATAdLogger logMessage:@"ATMSNativeCustomEvent::msNativeFeedAdDetailClosed" type:ATLogTypeExternal];

    [self.adStatusBridge atOnAdDetailClosed:nil];
}

#pragma mark - video
//视频播放完成
- (void)msFeedVideoFinish {
 
}

//视频开始播放
- (void)msFeedVideoStart {
 
}

//视频暂停播放
- (void)msFeedVideoPause {

}

//视频恢复播放
- (void)msFeedVideoResume {

}

/// 视频播放进度
/// - Parameters:
///   - progress: 播放进度百分比 取值[0~100%]
///   - currentTime: 当前播放时间
///   - totalTime:   视频总时长
- (void)msFeedVideoPlayingProgress:(CGFloat)progress currentTime:(CGFloat)currentTime totalTime:(CGFloat)totalTime {
}

//视频播放出错
- (void)msFeedVideoError:(NSError *)error {
    
}

@end
