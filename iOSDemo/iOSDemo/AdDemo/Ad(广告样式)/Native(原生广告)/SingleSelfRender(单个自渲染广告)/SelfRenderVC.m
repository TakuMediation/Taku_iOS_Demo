//
//  SelfRenderVC.m
//  iOSDemo
//
//  Created by ltz on 2025/1/11.
//

#import "SelfRenderVC.h"

#import <AnyThinkNative/AnyThinkNative.h>

#import "AdLoadConfigTool.h"
#import "SelfRenderView.h"
#import "AdDisplayVC.h"

@interface SelfRenderVC () <ATNativeADDelegate>

@property (strong, nonatomic) ATNativeADView  * adView;
@property (strong, nonatomic) SelfRenderView  * selfRenderView;
@property (nonatomic, strong) ATNativeAdOffer * nativeAdOffer;
@end

@implementation SelfRenderVC

//广告位ID
#define Native_SelfRender_PlacementID @"b680af2c216f73"

//场景ID，可选，可在后台生成。没有可传入空字符串
#define Native_SelfRender_SceneID @""
 
#pragma mark - Load Ad 加载广告
/// 加载广告按钮被点击
- (void)loadAdButtonClickAction {
 
    [self showLog:kLocalizeStr(@"点击了加载广告")];
     
    NSMutableDictionary * loadConfigDict = [NSMutableDictionary dictionary];
    
    //设置请求广告的尺寸
    [loadConfigDict setValue:[NSValue valueWithCGSize:CGSizeMake(SelfRenderViewWidth, SelfRenderViewHeight)] forKey:kATExtraInfoNativeAdSizeKey];
    //请求自适应尺寸的原生广告(部分广告平台可用)
    [AdLoadConfigTool native_loadExtraConfigAppend_SizeToFit:loadConfigDict];
    
    //快手原生广告滑一滑和点击相关控制
//    [AdLoadConfigTool native_loadExtraConfigAppend_KuaiShou_SlideOrClickAble:loadConfigDict];
  
    [[ATAdManager sharedManager] loadADWithPlacementID:Native_SelfRender_PlacementID extra:loadConfigDict delegate:self];
}
 
#pragma mark - Show Ad 展示广告
/// 展示广告按钮被点击
- (void)showAdButtonClickAction {
    
    //场景统计功能，可选接入
    [[ATAdManager sharedManager] entryNativeScenarioWithPlacementID:Native_SelfRender_PlacementID scene:Native_SelfRender_SceneID];
    
    //查询可用于展示的广告缓存(可选接入)
    //[AdCheckTool getValidAdsForPlacementID:Native_SelfRender_PlacementID adType:AdTypeNative];
    
    //查询广告加载状态(可选接入)
    //[AdCheckTool adLoadingStatusWithPlacementID:Native_SelfRender_PlacementID adType:AdTypeNative];
    
    //检查是否有就绪
    if (![[ATAdManager sharedManager] nativeAdReadyForPlacementID:Native_SelfRender_PlacementID]) {
        [self notReadyAlert];
        return;
    }
    
    // 初始化config配置
    ATNativeADConfiguration *config = [[ATNativeADConfiguration alloc] init];
    // 给原生广告进行预布局
    config.ADFrame = CGRectMake(0, 0, SelfRenderViewWidth, SelfRenderViewHeight);
    // 给视频播放器进行预布局，建议在后面添加到自定义视图后，再次进行一次布局
    config.mediaViewFrame = CGRectMake(0, 0, SelfRenderViewMediaViewWidth, SelfRenderViewMediaViewHeight);
    config.delegate = self;
    config.rootViewController = self;
    //让广告View容器贴合于广告
    config.sizeToFit = YES;
    //设置仅wifi模式才自动播放，部分广告平台有效
    config.videoPlayType = ATNativeADConfigVideoPlayOnlyWiFiAutoPlayType;

    //【手动布局方式】精确设置logo大小以及位置，与下方【Masonry方式】选择一种实现
//    config.logoViewFrame = CGRectMake(kScreenW-50-10, SelfRenderViewHeight-50-10, 50, 50);
    
    //设置广告平台logo位置偏好(部分广告平台无法进行精确设置，则通过下面代码设置，Demo示例中均演示为右下角的情况)
    //若素材offer中logoUrl或logo有值时，才可以通过SelfRenderView中布局进行设置，没有值请使用本方法中的示例进行精确控制或者偏好位置设置。
    [ATAPI sharedInstance].preferredAdLogoPosition = ATAdLogoPositionBottomRightCorner;
    
    // 设置广告标识坐标x和y,部分广告平台有效,设置出屏幕外即可实现隐藏效果
    // config.adChoicesViewOrigin = CGPointMake(10, 10);
    
    // 获取offer广告对象,获取后消耗一条广告缓存
    ATNativeAdOffer *offer = [[ATAdManager sharedManager] getNativeAdOfferWithPlacementID:Native_SelfRender_PlacementID scene:Native_SelfRender_SceneID];
    NSDictionary *offerInfoDict = [Tools getOfferInfo:offer];
    ATDemoLog(@"🔥🔥🔥--自渲染广告素材，展示前：%@",offerInfoDict);
    self.nativeAdOffer = offer;
    
    // 创建自渲染视图view，同时根据offer信息内容去赋值
    SelfRenderView *selfRenderView = [[SelfRenderView alloc] initWithOffer:offer];
    
    // 创建广告nativeADView
    // 获取原生广告展示容器视图
    ATNativeADView *nativeADView = [[ATNativeADView alloc] initWithConfiguration:config currentOffer:offer placementID:Native_SelfRender_PlacementID];
    
    //创建可点击组件的容器数组
    NSMutableArray *clickableViewArray = [NSMutableArray array];
    
    // 获取mediaView，需要自行添加到自渲染视图上，必须调用
    UIView *mediaView = [nativeADView getMediaView];
    if (mediaView) {
        // 赋值并布局
        selfRenderView.mediaView = mediaView;
    }
    
    // 设置需要注册点击事件的UI控件，最好不要把信息流的父视图整体添加到点击事件中，不然可能会出现点击关闭按钮，还触发了点击信息流事件。
    // 关闭按钮(dislikeButton)无需注册点击事件
    [clickableViewArray addObjectsFromArray:@[selfRenderView.iconImageView,
                                              selfRenderView.titleLabel,
                                              selfRenderView.textLabel,
                                              selfRenderView.ctaLabel,
                                              selfRenderView.mainImageView]];
    
    // 给UI控件注册点击事件
    [nativeADView registerClickableViewArray:clickableViewArray];
    
    //绑定组件
    [self prepareWithNativePrepareInfo:selfRenderView nativeADView:nativeADView];
    
    //渲染广告
    [offer rendererWithConfiguration:config selfRenderView:selfRenderView nativeADView:nativeADView];
    
    //【Masonry方式】精确设置logo大小以及位置，与上方【手动布局方式】选择一种实现，请在渲染广告之后调用
    [nativeADView.logoImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(nativeADView).mas_offset(-10);
        make.width.height.mas_equalTo(20);
    }];
    
    //用于测试时打印
//    [self printNativeAdInfoAfterRendererWithOffer:offer nativeADView:nativeADView];
    
    //隐藏logo，谨慎使用，请阅读文档：自渲染广告注意事项
    //nativeADView.logoImageView.hidden = YES;
    
    //引用
    self.adView = nativeADView;
    
    //展示广告
    AdDisplayVC *showVc = [[AdDisplayVC alloc] initWithAdView:nativeADView offer:offer adViewSize:CGSizeMake(SelfRenderViewWidth, SelfRenderViewHeight)];
    [self.navigationController pushViewController:showVc animated:YES];
}

#pragma mark - 绑定组件
- (void)prepareWithNativePrepareInfo:(SelfRenderView *)selfRenderView nativeADView:(ATNativeADView *)nativeADView {
    // 哪些组件需要绑定，哪些不需要，请参考文档：原生广告注意事项
    ATNativePrepareInfo *info = [ATNativePrepareInfo loadPrepareInfo:^(ATNativePrepareInfo * prepareInfo) {
        prepareInfo.textLabel = selfRenderView.textLabel;
        prepareInfo.advertiserLabel = selfRenderView.advertiserLabel;
        prepareInfo.titleLabel = selfRenderView.titleLabel;
        prepareInfo.ratingLabel = selfRenderView.ratingLabel;
        prepareInfo.iconImageView = selfRenderView.iconImageView;
        prepareInfo.mainImageView = selfRenderView.mainImageView;
        prepareInfo.logoImageView = selfRenderView.logoImageView;
        prepareInfo.ctaLabel = selfRenderView.ctaLabel;
        prepareInfo.dislikeButton = selfRenderView.dislikeButton;
        prepareInfo.mediaView = selfRenderView.mediaView;
    }];
    [nativeADView prepareWithNativePrepareInfo:info];
}
 
/// 用于测试时打印相关信息
/// - Parameters:
///   - offer: 广告素材
///   - nativeADView: 广告对象view
- (void)printNativeAdInfoAfterRendererWithOffer:(ATNativeAdOffer *)offer nativeADView:(ATNativeADView *)nativeADView {
    ATNativeAdRenderType nativeAdRenderType = [nativeADView getCurrentNativeAdRenderType];
    if (nativeAdRenderType == ATNativeAdRenderExpress) {
        ATDemoLog(@"⚠️⚠️⚠️--这是原生模板了");
    } else {
        ATDemoLog(@"✅✅✅--这是原生自渲染");
    }
    BOOL isVideoContents = [nativeADView isVideoContents];
    
    //打印所有素材内容
    [Tools printNativeAdOffer:offer];
    ATDemoLog(@"🔥--是否为原生视频广告：%d",isVideoContents);
}

#pragma mark - 移除广告
- (void)removeAd {
    if (self.adView && self.adView.superview) {
        [self.adView removeFromSuperview];
    }
    [self.adView destroyNative];
    self.adView = nil;
    // 更及时销毁offer
    [self.selfRenderView destory];
    self.selfRenderView = nil;
}
 
#pragma mark - 广告位代理回调
/// 广告位加载完成
/// - Parameter placementID: 广告位ID
- (void)didFinishLoadingADWithPlacementID:(NSString *)placementID {
    BOOL isReady = [[ATAdManager sharedManager] nativeAdReadyForPlacementID:placementID];
    [self showLog:[NSString stringWithFormat:@"didFinishLoadingADWithPlacementID:%@ SelfRender 是否准备好:%@", placementID,isReady ? @"YES":@"NO"]];
}
 
/// 广告位加载失败
/// - Parameters:
///   - placementID: 广告位ID
///   - error: 错误信息
- (void)didFailToLoadADWithPlacementID:(NSString *)placementID error:(NSError *)error {
    ATDemoLog(@"didFailToLoadADWithPlacementID:%@ error:%@", placementID, error);
    [self showLog:[NSString stringWithFormat:@"didFailToLoadADWithPlacementID:%@ errorCode:%ld", placementID, error.code]];
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
    
    ATDemoLog(@"🔥--原生广告adInfo信息，展示后：%@",self.nativeAdOffer.adOfferInfo);
    
    //若有视频，且不希望同时展示主图和视频，可隐藏主图
    dispatch_async(dispatch_get_main_queue(), ^{
        self.selfRenderView.mainImageView.hidden = [adView isVideoContents];
    });
}

/// 原生广告点击了关闭按钮
/// - Parameters:
///   - adView: 广告视图对象
///   - placementID: 广告位ID
///   - extra: 额外信息
- (void)didTapCloseButtonInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"didTapCloseButtonInAdView:%@ extra:%@", placementID, extra);
    [self removeAd];
    [self showLog:[NSString stringWithFormat:@"didTapCloseButtonInAdView:%@", placementID]];
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
 
#pragma mark - Demo Needed 不用接入
- (void)viewDidLoad {
    [super viewDidLoad];
     
    [self setupDemoUI];
}

- (void)setupDemoUI {
    [self addNormalBarWithTitle:self.title];
    [self addLogTextView];
    [self addFootView];
}

- (void)dealloc {
    NSLog(@"SelfRenderVC dealloc");
}
   
@end 
