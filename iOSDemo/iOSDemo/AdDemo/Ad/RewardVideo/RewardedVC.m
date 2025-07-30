//
//  RewardedVC.m
//  iOSDemo
//
//  Created by ltz on 2025/1/7.
//

#import "RewardedVC.h"
#import <AnyThinkSDK/AnyThinkSDK.h>
#import <AnyThinkRewardedVideo/AnyThinkRewardedVideo.h>
#import "AdLoadConfigTool.h"

@interface RewardedVC () <ATRewardedVideoDelegate>

@property (nonatomic, assign) NSInteger retryAttempt;

@end

@implementation RewardedVC

//广告位ID
#define RewardedPlacementID @"b67f4ab93eb3a7"

//场景ID，可选，可在后台生成。没有可传入空字符串
#define RewardedSceneID @""

#pragma mark - Load Ad 加载广告
/// 加载广告按钮被点击
- (void)loadAd {
 
    [self showLog:kLocalizeStr(@"点击了加载广告")];
      
    NSMutableDictionary * loadConfigDict = [NSMutableDictionary dictionary];
    // 可选接入，以下几个key参数适用于广告平台的服务端激励验证，将被透传
    [loadConfigDict setValue:@"media_val_RewardedVC" forKey:kATAdLoadingExtraMediaExtraKey];
    [loadConfigDict setValue:@"rv_test_user_id" forKey:kATAdLoadingExtraUserIDKey];
    [loadConfigDict setValue:@"reward_Name" forKey:kATAdLoadingExtraRewardNameKey];
    [loadConfigDict setValue:@3 forKey:kATAdLoadingExtraRewardAmountKey];
 
    //(可选接入)如果使用了游可赢(Klevin)广告平台，可添加以下配置
    //[AdLoadConfigTool rewarded_loadExtraConfigAppend_Klevin:loadConfigDict];
    
    //(可选接入)若开启共享广告位，对其进行相关设置
    //[AdLoadConfigTool setInterstitialSharePlacementConfig:loadConfigDict];
    
    [[ATAdManager sharedManager] loadADWithPlacementID:RewardedPlacementID extra:loadConfigDict delegate:self];
}
 
#pragma mark - Show Ad 展示广告
/// 展示广告按钮被点击
- (void)showAd {
    
    //场景统计功能(可选接入)
    [[ATAdManager sharedManager] entryRewardedVideoScenarioWithPlacementID:RewardedPlacementID scene:RewardedSceneID];
    
//    //查询可用于展示的广告缓存(可选接入)
//    NSArray <NSDictionary *> * adCaches = [[ATAdManager sharedManager] getRewardedVideoValidAdsForPlacementID:RewardedPlacementID];
//    ATDemoLog(@"getValidAds : %@",adCaches);
//     
//    //查询广告加载状态(可选接入)
//    ATCheckLoadModel * status = [[ATAdManager sharedManager] checkRewardedVideoLoadStatusForPlacementID:RewardedPlacementID];
//    ATDemoLog(@"checkLoadStatus : %d",status.isLoading);
//     
    //检查是否有就绪
    if (![[ATAdManager sharedManager] rewardedVideoReadyForPlacementID:RewardedPlacementID]) {
        [self loadAd];
        return;
    }
    
    //展示配置，Scene传入后台的场景ID，没有可传入空字符串，showCustomExt参数可传入自定义参数字符串
    ATShowConfig *config = [[ATShowConfig alloc] initWithScene:RewardedSceneID showCustomExt:@"testShowCustomExt"];
 
    //展示广告
    [[ATAdManager sharedManager] showRewardedVideoWithPlacementID:RewardedPlacementID config:config inViewController:self delegate:self];
}

#pragma mark - ATAdLoadingDelegate
/// 广告位加载完成
/// - Parameter placementID: 广告位ID
- (void)didFinishLoadingADWithPlacementID:(NSString *)placementID {
    BOOL isReady = [[ATAdManager sharedManager] rewardedVideoReadyForPlacementID:placementID];
    [self showLog:[NSString stringWithFormat:@"didFinishLoadingADWithPlacementID:%@ Rewarded 是否准备好:%@", placementID,isReady ? @"YES":@"NO"]];
    
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

#pragma mark - ATRewardedVideoDelegate
/// 激励成功
/// - Parameters:
///   - placementID: 广告位ID
///   - extra: 额外信息字典
- (void)rewardedVideoDidRewardSuccessForPlacemenID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"rewardedVideoDidRewardSuccessForPlacemenID:%@ extra:%@",placementID,extra);
    [self showLog:[NSString stringWithFormat:@"rewardedVideoDidRewardSuccess:%@", placementID]];
    
}

/// 激励广告视频开始播放
/// - Parameters:
///   - placementID: 广告位ID
///   - extra: 额外信息字典
- (void)rewardedVideoDidStartPlayingForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"rewardedVideoDidStartPlayingForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"rewardedVideoDidStartPlaying:%@", placementID]];
    
}
 
/// 激励广告视频播放完毕
/// - Parameters:
///   - placementID: 广告位ID
///   - extra: 额外信息字典
- (void)rewardedVideoDidEndPlayingForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"rewardedVideoDidEndPlayingForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"rewardedVideoDidEndPlaying:%@", placementID]];
    
}

/// 激励广告视频播放失败
/// - Parameters:
///   - placementID: 广告位ID
///   - error: 错误信息
///   - extra: 额外信息字典
- (void)rewardedVideoDidFailToPlayForPlacementID:(NSString*)placementID error:(NSError *)error extra:(NSDictionary *)extra {
    ATDemoLog(@"rewardedVideoDidFailToPlayForPlacementID:%@ error:%@ extra:%@", placementID, error, extra);
    [self showLog:[NSString stringWithFormat:@"rewardedVideoDidFailToPlay:%@ errorCode:%ld", placementID, (long)error.code]];
    
    // 预加载
    [self loadAd];
}

/// 激励广告已关闭
/// - Parameters:
///   - placementID: 广告位ID
///   - rewarded: 是否已经激励成功，YES表示已经回调了激励成功
///   - extra: 额外信息字典
- (void)rewardedVideoDidCloseForPlacementID:(NSString *)placementID rewarded:(BOOL)rewarded extra:(NSDictionary *)extra {
    ATDemoLog(@"rewardedVideoDidCloseForPlacementID:%@, rewarded:%@ extra:%@", placementID, rewarded ? @"yes" : @"no", extra);
    [self showLog:[NSString stringWithFormat:@"rewardedVideoDidClose:%@, rewarded:%@", placementID, rewarded ? @"yes" : @"no"]];
    
    // 预加载
    [self loadAd];
}
 
/// 激励广告已点击
/// - Parameters:
///   - placementID: 广告位ID
///   - extra: 额外信息字典
- (void)rewardedVideoDidClickForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"rewardedVideoDidClickForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"rewardedVideoDidClick:%@", placementID]];
    
}

/// 激励广告已打开或跳转深链接页面
/// - Parameters:
///   - placementID: 广告位ID
///   - extra: 广告位ID
///   - success: 是否成功
- (void)rewardedVideoDidDeepLinkOrJumpForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra result:(BOOL)success {
    ATDemoLog(@"rewardedVideoDidDeepLinkOrJumpForPlacementID:placementID:%@ with extra: %@, success:%@", placementID,extra, success ? @"YES" : @"NO");
    [self showLog:[NSString stringWithFormat:@"rewardedVideoDidDeepLinkOrJump:%@, success:%@", placementID, success ? @"YES" : @"NO"]];
    
}

#pragma mark - 激励视频再看一个相关代理 Rewarded video again delegate
//支持激励视频“再看一个”能力（简称激励再得），开启该功能后聚合维度会自动缓存一条激励视频广告，并在首次广告展示后且收到奖励回调后，渲染挽留弹窗引导用户“再看一个获取更多奖励”，用户点击后将自动播放缓存广告，有利于提升用户的广告价值和活跃时长。
//如果您在后台配置中开启了"再看一个"功能，请实现相关回调。

/// 激励广告再看一个激励成功
/// - Parameters:
///   - placementID: 广告位ID
///   - extra: 额外信息字典
- (void)rewardedVideoAgainDidRewardSuccessForPlacemenID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"rewardedVideoAgainDidRewardSuccessForPlacemenID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"rewardedVideoAgainDidRewardSuccess:%@", placementID]];
}

/// 激励广告再看一个视频已开始播放
/// - Parameters:
///   - placementID: 广告位ID
///   - extra: 额外信息字典
- (void)rewardedVideoAgainDidStartPlayingForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"rewardedVideoAgainDidStartPlayingForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"rewardedVideoAgainDidStartPlaying:%@", placementID]];
}

/// 激励广告再看一个视频播放完毕
/// - Parameters:
///   - placementID: 广告位ID
///   - extra: 额外信息字典
- (void)rewardedVideoAgainDidEndPlayingForPlacementID:(NSString*)placementID extra:(NSDictionary*)extra {
    ATDemoLog(@"rewardedVideoAgainDidEndPlayingForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"rewardedVideoAgainDidEndPlaying:%@", placementID]];
}

/// 激励广告再看一个视频播放失败
/// - Parameters:
///   - placementID: 广告位ID
///   - error: 错误信息
///   - extra: 额外信息字典
- (void)rewardedVideoAgainDidFailToPlayForPlacementID:(NSString *)placementID error:(NSError *)error extra:(NSDictionary *)extra {
    ATDemoLog(@"rewardedVideoAgainDidFailToPlayForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"rewardedVideoAgainDidFailToPlay:%@ errorCode:%ld", placementID, (long)error.code]];
}

/// 激励广告再看一个已点击
/// - Parameters:
///   - placementID: 广告位ID
///   - extra: 额外信息字典
- (void)rewardedVideoAgainDidClickForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"rewardedVideoAgainDidClickForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"rewardedVideoAgainDidClick:%@", placementID]];
}

@end
