//
//  ExpressVC.m
//  iOSDemo
//
//  Created by ltz on 2025/1/18.
//

#import "ExpressVC.h"

#import <AnyThinkNative/AnyThinkNative.h>
 
#import "AdDisplayVC.h"

@interface ExpressVC () <ATNativeADDelegate>

@property (strong, nonatomic) ATNativeADView  * adView;
@property (nonatomic, strong) ATNativeAdOffer * nativeAdOffer;
// 重试次数计数器
@property (nonatomic, assign) NSInteger         retryAttempt;

@end

@implementation ExpressVC

//广告位ID

//三方广告平台本身就是模版渲染的广告位
#define Native_Express_PlacementID @"b680af46e13e5c"

//选择SDK渲染-实际三方广告是自渲染的广告位
//#define Native_Express_PlacementID @"n67ff515ba1460"

//场景ID，可选，可在后台生成。没有可传入空字符串
#define Native_Express_SceneID @""

//注意模版的宽高比与后台选择对应
#define ExpressAdWidth (kScreenW)
//注意模版的宽高比与后台选择对应
#define ExpressAdHeight (kScreenW/2.f)

#define ExpressMediaViewWidth (kScreenW)
#define ExpressMediaViewHeight (350 - kNavigationBarHeight - 150)
 
#pragma mark - Load Ad 加载广告
/// 加载广告按钮被点击
- (void)loadAd {
 
    [self showLog:kLocalizeStr(@"点击了加载广告")];
     
    NSMutableDictionary * loadConfigDict = [NSMutableDictionary dictionary];
    
    //请求模版广告，指定一个大小，广告平台会匹配这个大小返回广告，不一定完全匹配，和广告平台后台勾选的模版类型有关
    [loadConfigDict setValue:[NSValue valueWithCGSize:CGSizeMake(ExpressAdWidth, ExpressAdHeight)] forKey:kATExtraInfoNativeAdSizeKey];
    
    [[ATAdManager sharedManager] loadADWithPlacementID:Native_Express_PlacementID extra:loadConfigDict delegate:self];
}
 
#pragma mark - Show Ad 展示广告
/// 展示广告按钮被点击
- (void)showAd {
    
    //场景统计功能，可选接入
    [[ATAdManager sharedManager] entryNativeScenarioWithPlacementID:Native_Express_PlacementID scene:Native_Express_SceneID];
    
//    //查询可用于展示的广告缓存(可选接入)
//    NSArray <NSDictionary *> * adCaches = [[ATAdManager sharedManager] getNativeValidAdsForPlacementID:Native_SelfRender_PlacementID];
//    ATDemoLog(@"getValidAds : %@",adCaches);
//
//    //查询广告加载状态(可选接入)
//    ATCheckLoadModel * status = [[ATAdManager sharedManager] checkNativeLoadStatusForPlacementID:Native_SelfRender_PlacementID];
//    ATDemoLog(@"checkLoadStatus : %d",status.isLoading);
    
    //检查是否有就绪
    if (![[ATAdManager sharedManager] nativeAdReadyForPlacementID:Native_Express_PlacementID]) {
        [self loadAd];
        return;
    }
    
    // 初始化config配置
    ATNativeADConfiguration *config = [[ATNativeADConfiguration alloc] init];
    // 给模版广告nativeADView设置大小，通常为请求广告时设置的大小
    config.ADFrame = CGRectMake(0, 0, ExpressAdWidth, ExpressAdHeight);
    config.delegate = self;
    //设置展示根控制器
    config.rootViewController = self;
    // 开启模版广告自适应高度，当实际返回的广告大小与请求广告时设置的大小不一致时，SDK内部将自动调整nativeADView的大小为实际返回广告的大小。
    config.sizeToFit = YES;
    //设置仅wifi模式才自动播放，部分广告平台有效
    config.videoPlayType = ATNativeADConfigVideoPlayOnlyWiFiAutoPlayType;
 
    // 获取offer广告对象,获取后消耗一条广告缓存
    ATNativeAdOffer *offer = [[ATAdManager sharedManager] getNativeAdOfferWithPlacementID:Native_Express_PlacementID scene:Native_Express_SceneID];
    
    // 创建广告nativeADView
    ATNativeADView *nativeADView = [[ATNativeADView alloc] initWithConfiguration:config currentOffer:offer placementID:Native_Express_PlacementID];
 
    //调试时打印信息
    //[self printNativeAdInfoAfterRendererWithOffer:offer nativeADView:nativeADView];
    
    //渲染广告
    [offer rendererWithConfiguration:config selfRenderView:nil nativeADView:nativeADView];
 
    //引用
    self.adView = nativeADView;
    
    //展示广告
    AdDisplayVC *showVc = [[AdDisplayVC alloc] initWithAdView:nativeADView offer:offer adViewSize:CGSizeMake(ExpressAdWidth, ExpressAdHeight)];
    [self.navigationController pushViewController:showVc animated:YES];
}
 
- (void)printNativeAdInfoAfterRendererWithOffer:(ATNativeAdOffer *)offer nativeADView:(ATNativeADView *)nativeADView {
    ATNativeAdRenderType nativeAdRenderType = [nativeADView getCurrentNativeAdRenderType];
    if (nativeAdRenderType == ATNativeAdRenderExpress) {
        ATDemoLog(@"✅✅✅--模板广告");
        ATDemoLog(@"🔥--模板广告宽高：%lf，%lf，请求广告时设置的宽高：%f,%f，如果尺寸差距太大，请检查后台配置的模版",offer.nativeAd.nativeExpressAdViewWidth,offer.nativeAd.nativeExpressAdViewHeight,ExpressAdWidth,ExpressAdHeight);
    } else {
        ATDemoLog(@"⚠️⚠️⚠️--这是自渲染广告了");
    }
    BOOL isVideoContents = [nativeADView isVideoContents];
    ATDemoLog(@"🔥--是否为原生视频广告：%d",isVideoContents);
}

#pragma mark - 移除广告
- (void)removeAd {
    if (self.adView && self.adView.superview) {
        [self.adView removeFromSuperview];
    }
    [self.adView destroyNative];
    self.adView = nil;
}
 
#pragma mark - 广告位代理回调
/// 广告位加载完成
/// - Parameter placementID: 广告位ID
- (void)didFinishLoadingADWithPlacementID:(NSString *)placementID {
    BOOL isReady = [[ATAdManager sharedManager] nativeAdReadyForPlacementID:placementID];
    [self showLog:[NSString stringWithFormat:@"didFinishLoadingADWithPlacementID:%@ Express 是否准备好:%@", placementID,isReady ? @"YES":@"NO"]];
    
    // 重置重试次数
    self.retryAttempt = 0;
}
 
/// 广告位加载失败
/// - Parameters:
///   - placementID: 广告位ID
///   - error: 错误信息
- (void)didFailToLoadADWithPlacementID:(NSString *)placementID error:(NSError *)error {
    ATDemoLog(@"didFailToLoadADWithPlacementID:%@ error:%@", placementID, error);
    [self showLog:[NSString stringWithFormat:@"didFailToLoadADWithPlacementID:%@ errorCode:%ld", placementID, error.code]];
    
    // 重试已达到 3 次，不再重试加载
    if (self.retryAttempt >= 3) {
       return;
    }
    self.retryAttempt++;
    // Calculate delay time: power of 2, maximum 8 seconds
    NSInteger delaySec = pow(2, MIN(3, self.retryAttempt));

    // Delayed retry loading ad
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delaySec * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self loadAd];
    });
}

/// 获得展示收益
/// - Parameters:
///   - placementID: 广告位ID
///   - extra: 额外信息字典
- (void)didRevenueForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"didRevenueForPlacementID:%@ with extra: %@", placementID,extra);
    [self showLog:[NSString stringWithFormat:@"didRevenueForPlacementID:%@", placementID]];
}

#pragma mark - 原生广告事件回调

/// 原生广告已展示
/// - Parameters:
///   - adView: 广告视图对象
///   - placementID: 广告位ID
///   - extra: 额外信息
- (void)didShowNativeAdInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"didShowNativeAdInAdView:%@ extra:%@",placementID,extra);
    [self showLog:[NSString stringWithFormat:@"didShowNativeAdInAdView:%@", placementID]];
}

/// 原生广告点击了关闭按钮
/// - Parameters:
///   - adView: 广告视图对象
///   - placementID: 广告位ID
///   - extra: 额外信息
- (void)didTapCloseButtonInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"didTapCloseButtonInAdView:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"didTapCloseButtonInAdView:%@", placementID]];
    
    // 销毁广告
    [self removeAd];
    // 预加载下一个广告
    [self loadAd];
}

/// 原生广告开始播放视频
/// - Parameters:
///   - adView: 广告视图对象
///   - placementID: 广告位ID
///   - extra: 额外信息字典
- (void)didStartPlayingVideoInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"didStartPlayingVideoInAdView:%@ extra: %@", placementID,extra);
    [self showLog:[NSString stringWithFormat:@"didStartPlayingVideoInAdView:%@", placementID]];
}

/// 原生广告视频播放结束
/// - Parameters:
///   - adView: 广告视图对象
///   - placementID: 广告位ID
///   - extra: 额外信息字典
- (void)didEndPlayingVideoInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"didEndPlayingVideoInAdView:%@ extra: %@", placementID,extra);
    [self showLog:[NSString stringWithFormat:@"didEndPlayingVideoInAdView:%@", placementID]];
}

/// 原生广告用户已点击
/// - Parameters:
///   - adView: 广告视图对象
///   - placementID: 广告位ID
///   - extra: 额外信息字典
- (void)didClickNativeAdInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"didClickNativeAdInAdView:%@ extra:%@",placementID,extra);
    [self showLog:[NSString stringWithFormat:@"didClickNativeAdInAdView:%@", placementID]];
}
 
/// 原生广告已打开或跳转深链接页面
/// - Parameters:
///   - adView: 广告视图对象
///   - placementID: 广告位ID
///   - extra: 额外信息
///   - success: 是否成功
- (void)didDeepLinkOrJumpInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra result:(BOOL)success {
    ATDemoLog(@"didDeepLinkOrJumpInAdView:placementID:%@ with extra: %@, success:%@", placementID,extra, success ? @"YES" : @"NO");
    [self showLog:[NSString stringWithFormat:@"didDeepLinkOrJumpInAdView:%@, success:%@", placementID, success ? @"YES" : @"NO"]];
}
 
/// 原生广告已进入全屏视频播放，通常是点击视频meidaView后自动跳转至一个播放落地页
/// - Parameters:
///   - adView: 广告视图对象
///   - placementID: 广告位ID
///   - extra: 额外信息
- (void)didEnterFullScreenVideoInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra{
    ATDemoLog(@"didEnterFullScreenVideoInAdView:%@", placementID);
    [self showLog:[NSString stringWithFormat:@"didEnterFullScreenVideoInAdView:%@", placementID]];
}

/// 原生广告已退出全屏视频播放
/// - Parameters:
///   - adView: 广告视图对象
///   - placementID: 广告位ID
///   - extra: 额外信息
- (void)didExitFullScreenVideoInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"didExitFullScreenVideoInAdView:%@", placementID);
    [self showLog:[NSString stringWithFormat:@"didExitFullScreenVideoInAdView:%@", placementID]];
}
 
/// 原生广告已退出详情页面
/// - Parameters:
///   - adView: 广告视图对象
///   - placementID: 广告位ID
///   - extra: 额外信息
- (void)didCloseDetailInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"didCloseDetailInAdView:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"didCloseDetailInAdView:%@", placementID]];
}
 

@end
