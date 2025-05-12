//
//  InterstitialVC.m
//  iOSDemo
//
//  Created by ltz on 2025/1/6.
//

#import "InterstitialVC.h"

#import <AnyThinkSDK/AnyThinkSDK.h>
#import <AnyThinkInterstitial/AnyThinkInterstitial.h>

#import "AdLoadConfigTool.h"
#import "AdLoadConfigTool.h"

//@import AnyThinkInterstitial;
 
@interface InterstitialVC () <ATAdLoadingDelegate, ATInterstitialDelegate>

@end

@implementation InterstitialVC
 
//广告位ID
#define InterstitialPlacementID @"b680a1e0ae7a43"

//场景ID，可选，可在后台生成。没有可传入空字符串
#define InterstitialSceneID @""

#pragma mark - Load Ad 加载广告
/// 加载广告按钮被点击
- (void)loadAdButtonClickAction {
 
    [self showLog:kLocalizeStr(@"点击了加载广告")];
      
    NSMutableDictionary * loadConfigDict = [NSMutableDictionary dictionary];
    
    //可选接入，设置加载透传参数
    [loadConfigDict setValue:@"media_val_InterstitialVC" forKey:kATAdLoadingExtraMediaExtraKey];
    
    //可选接入，如果使用了快手平台，可添加半屏插屏广告大小配置
//    [AdLoadConfigTool interstitial_loadExtraConfigAppend_KuaiShou:loadConfigDict];
    
    //可选接入，若开启共享广告位，对其进行相关设置
//    [AdLoadConfigTool setInterstitialSharePlacementConfig:loadConfigDict];
    
    [[ATAdManager sharedManager] loadADWithPlacementID:InterstitialPlacementID extra:loadConfigDict delegate:self];
}
 
#pragma mark - Show Ad 展示广告
/// 展示广告按钮被点击
- (void)showAdButtonClickAction {
    
    //场景统计功能，可选接入
    [[ATAdManager sharedManager] entryInterstitialScenarioWithPlacementID:InterstitialPlacementID scene:InterstitialSceneID];
    
    //查询可用于展示的广告缓存(可选接入)
    //[AdCheckTool getValidAdsForPlacementID:InterstitialPlacementID adType:AdTypeInterstitial];
    
    //查询广告加载状态(可选接入)
    //[AdCheckTool adLoadingStatusWithPlacementID:InterstitialPlacementID adType:AdTypeInterstitial];
    
    //检查是否有就绪
    if (![[ATAdManager sharedManager] interstitialReadyForPlacementID:InterstitialPlacementID]) {
        [self notReadyAlert];
        return;
    }
    
    //展示配置，Scene传入后台的场景ID，没有可传入空字符串，showCustomExt参数可传入自定义参数字符串
    ATShowConfig *config = [[ATShowConfig alloc] initWithScene:InterstitialSceneID showCustomExt:@"testShowCustomExt"];
 
    //展示广告
    //若是全屏插屏，inViewController可传入根控制器，如tabbarController或navigationController，让广告遮挡住tabbar或navigationBar
    [[ATAdManager sharedManager] showInterstitialWithPlacementID:InterstitialPlacementID
                                                      showConfig:config
                                                inViewController:self
                                                        delegate:self
                                              nativeMixViewBlock:nil];
}

#pragma mark - 广告位代理回调
/// 广告位加载完成
/// - Parameter placementID: 广告位ID
- (void)didFinishLoadingADWithPlacementID:(NSString *)placementID {
    BOOL isReady = [[ATAdManager sharedManager] interstitialReadyForPlacementID:placementID];
    [self showLog:[NSString stringWithFormat:@"didFinishLoadingADWithPlacementID:%@ interstitial 是否准备好:%@", placementID,isReady ? @"YES":@"NO"]];
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

#pragma mark - 插屏广告事件代理回调
/// 广告已经展示
/// - Parameters:
///   - placementID: 广告位ID
///   - extra: 额外信息字典
- (void)interstitialDidShowForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"interstitialDidShowForPlacementID:%@ extra:%@", placementID, extra);
    
    [self showLog:[NSString stringWithFormat:@"interstitialDidShowForPlacementID:%@", placementID]];
}

/// 广告展示失败
/// - Parameters:
///   - placementID: 广告位ID
///   - error: 错误信息
///   - extra: 额外信息字典
- (void)interstitialFailedToShowForPlacementID:(NSString *)placementID error:(NSError *)error extra:(NSDictionary *)extra {
    ATDemoLog(@"interstitialFailedToShowForPlacementID:%@ error:%@ extra:%@", placementID, error, extra);
    
    [self showLog:[NSString stringWithFormat:@"interstitialFailedToShowForPlacementID:%@ error:%@", placementID, error]];
}

/// 视频播放失败
/// - Parameters:
///   - placementID: 广告位ID
///   - error: 错误信息
///   - extra: 额外信息字典
- (void)interstitialDidFailToPlayVideoForPlacementID:(NSString *)placementID error:(NSError *)error extra:(NSDictionary *)extra {
    ATDemoLog(@"interstitialDidFailToPlayVideoForPlacementID:%@ error:%@ extra:%@", placementID, error, extra);
    
    [self showLog:[NSString stringWithFormat:@"interstitialDidFailToPlayVideoForPlacementID:%@ errorCode:%ld", placementID, error.code]];
}

/// 视频开始播放
/// - Parameters:
///   - placementID: 广告位ID
///   - extra: 额外信息字典
- (void)interstitialDidStartPlayingVideoForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"interstitialDidStartPlayingVideoForPlacementID:%@ extra:%@", placementID, extra);
    
    [self showLog:[NSString stringWithFormat:@"interstitialDidStartPlayingVideoForPlacementID:%@", placementID]];
}

/// 视频结束播放
/// - Parameters:
///   - placementID: 广告位ID
///   - extra: 额外信息字典
- (void)interstitialDidEndPlayingVideoForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"interstitialDidEndPlayingVideoForPlacementID:%@ extra:%@", placementID, extra);
    
    [self showLog:[NSString stringWithFormat:@"interstitialDidEndPlayingVideoForPlacementID:%@", placementID]];
}

/// 广告已经关闭
/// - Parameters:
///   - placementID: 广告位ID
///   - extra: 额外信息字典
- (void)interstitialDidCloseForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"interstitialDidCloseForPlacementID:%@ extra:%@", placementID, extra);
    
    [self showLog:[NSString stringWithFormat:@"interstitialDidCloseForPlacementID:%@", placementID]];
}

/// 广告已被点击(跳转)
/// - Parameters:
///   - placementID: 广告位ID
///   - extra: 额外信息字典
- (void)interstitialDidClickForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"interstitialDidClickForPlacementID:%@ extra:%@", placementID, extra);
    
    [self showLog:[NSString stringWithFormat:@"interstitialDidClickForPlacementID:%@", placementID]];
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

@end
