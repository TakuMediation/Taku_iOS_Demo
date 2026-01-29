//
//  DemoCustomNativeObject.m
//  AnyThinkSDKDemo
//
//  Created by ltz on 2025/7/22.
//

#import "DemoCustomNativeObject.h"

@interface DemoCustomNativeObject()

@property (nonatomic, strong) ATNativeAdRenderConfig *configuration;

@end

@implementation DemoCustomNativeObject

#pragma mark - 推荐实现，释放资源
- (void)dealloc {
    [[self getMSFeedVideoView] unregisterDataObject];
    [self.feedAdMetaad unAttachAd];
}

#pragma mark - 必须实现，获取配置并设置给自定义广告平台 SDK
- (void)setNativeADConfiguration:(ATNativeAdRenderConfig *)configuration {
    self.configuration = configuration;
    [self getMSFeedVideoView].presentVc = configuration.rootViewController;
}

#pragma mark - 必须实现，根据渲染类型注册容器
- (void)registerClickableViews:(NSArray<UIView *> *)clickableViews withContainer:(UIView *)container registerArgument:(ATNativeRegisterArgument *)registerArgument {
     
    if (self.nativeAdRenderType == ATNativeAdRenderExpress) {
        [self templateRender];
        return;
    }
    [self slefRenderRenderClickableViews:clickableViews withContainer:container registerArgument:registerArgument];
}

#pragma mark - 模板
- (void)templateRender {
    UIViewController *rootVC = self.configuration.rootViewController;
    if (rootVC == nil) {
        rootVC = [ATGeneralManage getCurrentViewControllerWithWindow:nil];
    }
    self.feedAdModel.presentVC = rootVC;
}

#pragma mark - 自渲染
- (void)slefRenderRenderClickableViews:(NSArray<UIView *> *)clickableViews withContainer:(UIView *)container registerArgument:(ATNativeRegisterArgument *)registerArgument {
    
    UIViewController *rootVC = self.configuration.rootViewController;
    if (rootVC == nil) {
        rootVC = [ATGeneralManage getCurrentViewControllerWithWindow:nil];
    }
    [self.feedAdMetaad setMetaLogoFrame:self.configuration.logoViewFrame];
    
    if ([self getMSFeedVideoView] && self.feedAdMetaad) {
        [[self getMSFeedVideoView] registerDataObject:self.feedAdMetaad
                            clickableViews:clickableViews];
    }
    
    [self.feedAdMetaad attachAd:container renderViews:container.subviews clickView:clickableViews closeView:registerArgument.dislikeButton presentVc:rootVC];
}

- (MSFeedVideoView *)getMSFeedVideoView {
    return (MSFeedVideoView *)self.mediaView;
}

#pragma mark - 可选实现，如果需要开发者手动释放资源可实现这个方法
//- (void)destroyNative {
//    
//}

#pragma mark - 以下均为可选实现，用于控制自定义广告平台 SDK 视频相关内容
//- (void)muteEnable:(BOOL)flag {
//    //获取外部传入的是否静音标识，传入给第三方 SDK
//}
//
///**
// * The duration of the video ad playing, unit ms
// */
//- (CGFloat)videoPlayTime {}
//
///**
// * Video ad duration, unit ms
// */
//- (CGFloat)videoDuration {}
// 
///**
// * The video ad play
// */
//- (void)videoPlay {}
//
///**
// * set voice button hidden, only suport TopOn Adx ad
// */
//- (void)updateVoiceBtnHidden:(BOOL)hidden {}
//
///**
// * The video ad pause
// */
//- (void)videoPause{}
//
//- (void)setVideoAutoPlay:(NSInteger)autoPlayType{}
 
  
@end
