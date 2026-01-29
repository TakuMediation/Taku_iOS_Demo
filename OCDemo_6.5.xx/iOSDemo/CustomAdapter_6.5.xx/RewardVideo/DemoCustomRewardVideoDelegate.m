//
//  DemoCustomRewardVideoDelegate.m
//  AnyThinkSDKDemo
//
//  Created by ltz on 2025/7/22.
//

#import "DemoCustomRewardVideoDelegate.h"

@implementation DemoCustomRewardVideoDelegate
 
/**
 视频数据下载成功回调，已经下载过的视频会直接回调,在该回调中调用show接口
 @param msRewardVideoAd MSRewardVideoAd 实例
 */
- (void)msRewardVideoCached:(MSRewardVideoAd *)msRewardVideoAd {
    [ATAdLogger logMessage:@"ATMSRewardedVideoCustomEvent::msRewardVideoCached" type:ATLogTypeExternal];
    NSDictionary * extraDic = [DemoCustomBaseAdapter getC2SInfo:[msRewardVideoAd ecpm]];
    //自定义参数
    [extraDic setValue:@"custom params value" forKey:@"custom params key"];
    [self.adStatusBridge atOnRewardedAdLoadedExtra:extraDic];
}

/**
 广告数据加载成功回调
 @param msRewardVideoAd MSRewardVideoAd 实例
 */
- (void)msRewardVideoLoaded:(MSRewardVideoAd *)msRewardVideoAd {
    [ATAdLogger logMessage:@"ATMSRewardedVideoCustomEvent::msRewardVideoLoaded" type:ATLogTypeExternal];
}
 
/**
 激励视频渲染成功
 */
- (void)msRewardVideoRenderSuccess:(MSRewardVideoAd *)msRewardVideoAd {
    [ATAdLogger logMessage:@"ATMSRewardedVideoCustomEvent::msRewardVideoRenderSuccess" type:ATLogTypeExternal];
}

/**
 激励视频渲染失败
 */
- (void)msRewardVideoRenderFail:(MSRewardVideoAd *)msRewardVideoAd error:(NSError *)error {
    [ATAdLogger logMessage:@"ATMSRewardedVideoCustomEvent::msRewardVideoRenderFail" type:ATLogTypeExternal];
    [self.adStatusBridge atOnAdShowFailed:error extra:nil];
}

/**
 视频播放页即将展示回调
 @param msRewardVideoAd MSRewardVideoAd 实例
 */
- (void)msRewardVideoWillShow:(MSRewardVideoAd *)msRewardVideoAd {
    [ATAdLogger logMessage:@"ATMSRewardedVideoCustomEvent::msRewardVideoWillShow" type:ATLogTypeExternal];
}

/**
 视频广告曝光回调
 @param msRewardVideoAd MSRewardVideoAd 实例
 */
- (void)msRewardVideoShow:(MSRewardVideoAd *)msRewardVideoAd {
    [ATAdLogger logMessage:@"ATMSRewardedVideoCustomEvent::msRewardVideoShow" type:ATLogTypeExternal];
    // 广告展示成功回调
    [self.adStatusBridge atOnAdShow:nil];
}

/**
 视频广告开始播放回调
 @param msRewardVideoAd MSRewardVideoAd 实例
 */
- (void)msRewardVideoStartPlaying:(MSRewardVideoAd *)msRewardVideoAd {
    [ATAdLogger logMessage:@"ATMSRewardedVideoCustomEvent::msRewardVideoStartPlaying" type:ATLogTypeExternal];
    // 视频开始播放回调
    [self.adStatusBridge atOnAdVideoStart:nil];
}

/**
 视频广告暂停播放回调
 @param msRewardVideoAd MSRewardVideoAd 实例
 */
- (void)msRewardVideoStopPlaying:(MSRewardVideoAd *)msRewardVideoAd {
    [ATAdLogger logMessage:@"ATMSRewardedVideoCustomEvent::msRewardVideoStopPlaying" type:ATLogTypeExternal];
}

/**
 视频广告恢复播放回调
 @param msRewardVideoAd MSRewardVideoAd 实例
 用户触发某些跳转逻辑后再次回到当前页面观看视频时触发，比如点击广告跳转落地页、跳出应用再次回到应用等场景
 */
- (void)msRewardVideoResumePlaying:(MSRewardVideoAd *)msRewardVideoAd {
    [ATAdLogger logMessage:@"ATMSRewardedVideoCustomEvent::msRewardVideoResumePlaying" type:ATLogTypeExternal];
}

/**
 视频广告播放异常回调，当广告无效时或播放途中出现错误时调用
 @param msRewardVideoAd MSRewardVideoAd 实例
 @param error 播放错误信息
 */
- (void)msRewardVideoPlayingError:(MSRewardVideoAd *)msRewardVideoAd error:(NSError *)error {
    [ATAdLogger logMessage:@"ATMSRewardedVideoCustomEvent::msRewardVideoPlayingError" type:ATLogTypeExternal];
    [self.adStatusBridge atOnAdDidFailToPlayVideo:error extra:nil];
}

/**
 视频播放页关闭回调
 @param msRewardVideoAd MSRewardVideoAd 实例
 */
- (void)msRewardVideoClosed:(MSRewardVideoAd *)msRewardVideoAd {
    [ATAdLogger logMessage:@"ATMSRewardedVideoCustomEvent::msRewardVideoClosed" type:ATLogTypeExternal];
    [self.adStatusBridge atOnAdClosed:nil];
}

/**
 视频广告信息点击回调
 @param msRewardVideoAd MSRewardVideoAd 实例
 */
- (void)msRewardVideoClicked:(MSRewardVideoAd *)msRewardVideoAd {
    [ATAdLogger logMessage:@"ATMSRewardedVideoCustomEvent::msRewardVideoClicked" type:ATLogTypeExternal];
    [self.adStatusBridge atOnAdClick:nil];
}

/**
 视频广告点击跳过回调
 @param msRewardVideoAd MSRewardVideoAd 实例
 @param currentTime 当前播放时间
 */
- (void)msRewardVideoClickSkip:(MSRewardVideoAd *)msRewardVideoAd currentTime:(NSTimeInterval)currentTime {
    [ATAdLogger logMessage:@"ATMSRewardedVideoCustomEvent::msRewardVideoClickSkip" type:ATLogTypeExternal];
}

/**
 视频广告各种错误信息回调
 回调说明：如收到该回调说明本次请求已失败
 @param msRewardVideoAd MSRewardVideoAd 实例
 @param error 具体错误信息
 */
- (void)msRewardVideoError:(MSRewardVideoAd *)msRewardVideoAd error:(NSError *)error {
    [ATAdLogger logMessage:@"ATMSRewardedVideoCustomEvent::msRewardVideoError" type:ATLogTypeExternal];
    // 广告加载失败回调
    [self.adStatusBridge atOnAdLoadFailed:error adExtra:nil];
}

/**
 视频广告播放达到激励条件回调
 @param msRewardVideoAd MSRewardVideoAd 实例
 @param adInfo 激励信息包含的内容格式示例如下：
 {
  @"GDTRewardInfo" : 字典，//广点通返回的信息,注意此字段只有广点通平台激励视频才会返回，媒体获取时务必检查是否为空
  @"rewardVerify"  : @"1",//是否达到发放奖励条件，此值为必传项，取值范围【0-1】，0:未达到，1:达到
  @"rewardName"    : @"各种豆",//奖励名称，该值可能为空，可在ms平台进行配置
  @"rewardAmount"  : @"10",//奖励数量，该值可能为空，可在ms平台进行配置
  @"rewardVerifyError" : @"未知错误",//服务端验证错误信息，该值可能为空
 }
 详解：是否支持服务端验证都会触发激励回调，其他详解请查看接入文档
 */
- (void)msRewardVideoReward:(MSRewardVideoAd *)msRewardVideoAd extInfo:(NSDictionary *)adInfo {
    [ATAdLogger logMessage:@"ATMSRewardedVideoCustomEvent::msRewardVideoReward" type:ATLogTypeExternal];
    
    if ([[adInfo valueForKey:@"rewardVerify"] intValue] == 1) {
        [self.adStatusBridge atOnRewardedVideoAdRewarded];
    }
}
/**
 视频广告视频播放完成
 @param msRewardVideoAd MSRewardVideoAd 实例
 */
- (void)msRewardVideoFinish:(MSRewardVideoAd *)msRewardVideoAd {
    [ATAdLogger logMessage:@"ATMSRewardedVideoCustomEvent::msRewardVideoFinish" type:ATLogTypeExternal];
    // 视频播放完成回调
    [self.adStatusBridge atOnAdVideoEnd:nil];
}
 
@end
