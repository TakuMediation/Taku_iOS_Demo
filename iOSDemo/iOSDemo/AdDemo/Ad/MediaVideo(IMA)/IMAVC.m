//
//  IMAVC.m
//  iOSDemo
//
//  Created by ltz on 2025/1/18.
//

#import "IMAVC.h"

#import <AnyThinkMediaVideo/ATAdManager+ATMediaVideo.h>

//插播广告所需谷歌依赖
#import <GoogleInteractiveMediaAds/GoogleInteractiveMediaAds.h>

@interface IMAVC () <ATMediaVideoDelegate>

@property (nonatomic, weak)   IMAAVPlayerContentPlayhead * contentPlayhead;
@property (nonatomic, strong) AVPlayer * contentPlayer;
@property (nonatomic, strong) ATMediaVideoOffer * offer;
@property (nonatomic, assign) BOOL isContentPlayerPlaying;
@property (nonatomic, strong) UIView * videoView;

@end

@implementation IMAVC
 
//广告位ID vast
#define MediaVideoPlacementID @"b680af5b7d6e47"
//广告位ID vmap
//#define MediaVideoPlacementID @"b680b0f24cbd6e"

//场景ID，可选，可在后台生成。没有可传入空字符串
#define MediaVideoSceneID @""

// The content URL to play. 播放视频的链接
#define TestAppContentUrl_MP4 @"https://storage.googleapis.com/gvabox/media/samples/stock.mp4"
  
#pragma mark - Load Ad 加载广告
/// 加载广告按钮被点击
- (void)loadAd {
 
    [self showLog:kLocalizeStr(@"点击了加载广告")];
      
    self.contentPlayhead = [self setUpContentPlayer];
     
    [self.contentPlayer seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        
    }];
    NSMutableDictionary *extra = [NSMutableDictionary dictionary];
    
    //内部浏览器打开
    [extra setValue:self forKey:kATAdMediaVideoExtraKeyInternalBrowserViewController];
    //隐藏倒计时
    [extra setValue:@NO forKey:kATAdMediaVideoExtraKeyHideCountDown];
    //加载视频广告超时时间
    [extra setValue:@8 forKey:kATAdMediaVideoExtraKeyLoadVideoTimeout];
    //广告要不要自动播放，对VMAP才有效
    [extra setValue:@NO forKey:kATAdMediaVideoExtraKeyAutoPlayAdBreaks];
    //关闭当前播放信息
    [extra setValue:@YES forKey:kATAdMediaVideoExtraKeyDisableNowPlayingInfo];
    
    [[ATAdManager sharedManager] loadADWithPlacementID:MediaVideoPlacementID extra:extra controlDataParam:@{@"description_url":@"description_url"} delegate:self mediaVideoContainerView:self.videoView viewController:self];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
     
    [self.offer unregisterAllFriendlyObstructions];
    [self.videoView removeFromSuperview];
    [self.offer destory];
    [self.contentPlayer pause];
}

- (void)dealloc { 
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
  
#pragma mark - Show Ad 展示广告
/// 展示广告按钮被点击
- (void)showAd {
    
    //场景统计功能，可选接入
    [[ATAdManager sharedManager] entryMediaVideoScenarioWithPlacementID:MediaVideoPlacementID scene:MediaVideoSceneID];
    
    //检查是否有就绪
    if (![[ATAdManager sharedManager] adReadyForPlacementID:MediaVideoPlacementID]) {
        [self notReadyAlert];
        return;
    }
    
    //展示配置，Scene传入后台的场景ID，没有可传入空字符串，showCustomExt参数可传入自定义参数字符串
    ATShowConfig *config = [[ATShowConfig alloc] initWithScene:MediaVideoPlacementID showCustomExt:@"testShowCustomExt"];
 
    self.offer = [[ATAdManager sharedManager] mediaVideoObjectWithPlacementID:MediaVideoPlacementID showConfig:config delegate:self];
    
    [[ATAdManager sharedManager] entryMediaVideoScenarioWithPlacementID:MediaVideoPlacementID scene:MediaVideoSceneID];
    
//    id customNetworkObj = [self.offer customNetworkObj];
//    id adsManager = [self.offer adsManager];
//    
    [self.contentPlayer seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        
    }];
    
    UIView *myTransparentTapOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 250)];
    myTransparentTapOverlay.backgroundColor = [UIColor yellowColor];
    UIButton *myPauseButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 10)];
    // Substitute "myTransparentTapOverlay" and "myPauseButton" with the elements
    // you want to register as video controls overlays.
    // Make sure to register before ad playback starts.
    IMAFriendlyObstruction *overlayObstruction =
          [[IMAFriendlyObstruction alloc] initWithView:myTransparentTapOverlay
                                               purpose:IMAFriendlyObstructionPurposeNotVisible
                                        detailedReason:@"This overlay is transparent"];
    IMAFriendlyObstruction *pauseButtonObstruction =
          [[IMAFriendlyObstruction alloc] initWithView:myPauseButton
                                               purpose:IMAFriendlyObstructionPurposeMediaControls
                                        detailedReason:@"This is the video player pause button"];
    
    [self.offer registerFriendlyObstruction:overlayObstruction];
    [self.offer registerFriendlyObstruction:pauseButtonObstruction];
    [self.offer unregisterAllFriendlyObstructions];
    if (self.offer.type == ATMediaVideoOfferTypeVMAP) {
        [self.offer contentPlayhead:self.contentPlayhead];
    } else if (self.offer.type == ATMediaVideoOfferTypeVAST) {
        [self.offer start];
    }
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleApplicationDidBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleApplicationDidEnterBackgroundNotification:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)handleApplicationDidEnterBackgroundNotification:(NSNotification*)notification {
    [self pauseVideo];
}

- (void)handleApplicationDidBecomeActiveNotification:(NSNotification*)notification {
    [self resumeVideo];
}

- (void)playVideo {
    [self.contentPlayer play];
}

- (void)pauseVideo {
    [self.contentPlayer pause];
    [self.offer pause];
}

- (void)resumeVideo {
    [self.offer resume];
}

- (IMAAVPlayerContentPlayhead *)setUpContentPlayer {
    // Load AVPlayer with path to our content.
    NSURL *contentURL = [NSURL URLWithString:TestAppContentUrl_MP4];
    self.contentPlayer = [AVPlayer playerWithURL:contentURL];
    
    // Create a player layer for the player.
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.contentPlayer];
    
    // Size, position, and display the AVPlayer.
    playerLayer.frame = self.videoView.layer.bounds;
    [self.videoView.layer addSublayer:playerLayer];
    
    // Set up our content playhead and contentComplete callback.
    IMAAVPlayerContentPlayhead *contentPlayhead = [[IMAAVPlayerContentPlayhead alloc] initWithAVPlayer:self.contentPlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(contentDidFinishPlaying:)
                                          name:AVPlayerItemDidPlayToEndTimeNotification
                                          object:self.contentPlayer.currentItem];
    return contentPlayhead;
}

- (void)contentDidFinishPlaying:(NSNotification *)notification {
    // Make sure we don't call contentComplete as a result of an ad completing.
    if (notification.object == self.contentPlayer.currentItem) {
        [self.offer contentComplete];
    }
}
 
#pragma mark - 广告位代理回调
/// 广告位加载完成
/// - Parameter placementID: 广告位ID
- (void)didFinishLoadingADWithPlacementID:(NSString *)placementID {
    BOOL isReady = [[ATAdManager sharedManager] adReadyForPlacementID:placementID];
    [self showLog:[NSString stringWithFormat:@"didFinishLoadingADWithPlacementID:%@ MediaVideo 是否准备好:%@", placementID,isReady ? @"YES":@"NO"]];
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

#pragma mark - 插播广告事件代理回调
/// ad play starts
- (void)mediaVideoDidStartPlayingForPlacementID:(NSString *)placementID
                                          extra:(NSDictionary *)extra {
    ATDemoLog(@"mediaVideoDidStartPlayingForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"mediaVideoDidStartPlayingForPlacementID:%@", placementID]];
}

/// ad play ends
- (void)mediaVideoDidEndPlayingForPlacementID:(NSString *)placementID
                                        extra:(NSDictionary *)extra {
    ATDemoLog(@"mediaVideoDidEndPlayingForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"mediaVideoDidEndPlayingForPlacementID:%@", placementID]];
}

- (void)mediaVideoDidFailToPlayForPlacementID:(NSString *)placementID
                                           error:(NSError *)error
                                        extra:(NSDictionary *)extra {
    ATDemoLog(@"mediaVideoDidFailToPlayForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"mediaVideoDidFailToPlayForPlacementID:%@", placementID]];
}

- (void)mediaVideoAdResumeForPlacementID:(NSString *)placementID
                                   extra:(NSDictionary *)extra {
    ATDemoLog(@"mediaVideoAdResumeForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"mediaVideoAdResumeForPlacementID:%@", placementID]];
}

/// ad play fail
- (void)rewardedVideoDidFailToPlayForPlacementID:(NSString *)placementID
                                           error:(NSError *)error
                                           extra:(NSDictionary *)extra {
    ATDemoLog(@"rewardedVideoDidFailToPlayForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"rewardedVideoDidFailToPlayForPlacementID:%@", placementID]];
}

/// ad clicks
- (void)mediaVideoDidClickForPlacementID:(NSString *)placementID
                                   extra:(NSDictionary *)extra {
    ATDemoLog(@"mediaVideoDidClickForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"mediaVideoDidClickForPlacementID:%@", placementID]];
}

/// ad pause
- (void)mediaVideoAdPauseForPlacementID:(NSString *)placementID
                                  extra:(NSDictionary *)extra {
    ATDemoLog(@"mediaVideoAdPauseForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"mediaVideoAdPauseForPlacementID:%@", placementID]];
}

/// ad skiped
- (void)mediaVideoAdSkipedForPlacementID:(NSString *)placementID
                                   extra:(NSDictionary *)extra {
    ATDemoLog(@"mediaVideoAdSkipedForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"mediaVideoAdSkipedForPlacementID:%@", placementID]];
}

/// IMA callback
- (void)mediaVideoAdForPlacementID:(NSString *)placementID
                             extra:(NSDictionary *)extra event:(id)event {
    IMAAdEventType type = kIMAAdEvent_AD_BREAK_READY;
    IMAAdEvent *adEvent = event;
    if([adEvent isKindOfClass:[IMAAdEvent class]]) {
        type = adEvent.type;
    }
    ATDemoLog(@"mediaVideoAdForPlacementID:%@ event:%ld extra:%@", placementID, type, extra);
    [self showLog:[NSString stringWithFormat:@"mediaVideoAdForPlacementID:%@ event:%ld", placementID, type]];
}

/// video area tap
- (void)mediaVideoAdTappedForPlacementID:(NSString *)placementID
                                   extra:(NSDictionary *)extra {
    ATDemoLog(@"mediaVideoAdTappedForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"mediaVideoAdTappedForPlacementID:%@", placementID]];
}

/// video progress
- (void)mediaVideoAdDidProgressForPlacementID:(NSString *)placementID
                                        extra:(NSDictionary *)extra mediaTime:(NSTimeInterval)mediaTime totalTime:(NSTimeInterval)totalTime {
    ATDemoLog(@"mediaVideoAdDidProgressForPlacementID:%@ extra:%@", placementID, extra);
//    [self showLog:[NSString stringWithFormat:@"mediaVideoAdDidProgressForPlacementID:%@", placementID]];
}

/// video start buffering
- (void)mediaVideoAdDidStartBufferingForPlacementID:(NSString *)placementID
                                              extra:(NSDictionary *)extra {
    ATDemoLog(@"mediaVideoAdDidStartBufferingForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"mediaVideoAdDidStartBufferingForPlacementID:%@", placementID]];
}

/// video did Buffer
- (void)mediaVideoAdDidBufferToMediaTimeForPlacementID:(NSString *)placementID
                                                 extra:(NSDictionary *)extra mediaTime:(NSTimeInterval)mediaTime {
    ATDemoLog(@"mediaVideoAdDidBufferToMediaTimeForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"mediaVideoAdDidBufferToMediaTimeForPlacementID:%@", placementID]];
}

/// video ready
- (void)mediaVideoAdPlaybackReadyForPlacementID:(NSString *)placementID
                                          extra:(NSDictionary *)extra {
    ATDemoLog(@"mediaVideoAdPlaybackReadyForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"mediaVideoAdPlaybackReadyForPlacementID:%@", placementID]];
}

- (void)mediaVideoAdRequestContentPauseForPlacementID:(NSString *)placementID
                                                extra:(NSDictionary *)extra {
    ATDemoLog(@"mediaVideoAdRequestContentPauseForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"mediaVideoAdRequestContentPauseForPlacementID:%@", placementID]];
     
    [self.contentPlayer pause];
    self.isContentPlayerPlaying = NO;
}

- (void)mediaVideoAdRequestContentResumeForPlacementID:(NSString *)placementID
                                                 extra:(NSDictionary *)extra {
    ATDemoLog(@"mediaVideoAdRequestContentResumeForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"mediaVideoAdRequestContentResumeForPlacementID:%@", placementID]];
     
    [self.contentPlayer play];
    self.isContentPlayerPlaying = YES;
}

/// return IMA kIMAAdEvent_AD_BREAK_READY event
- (void)mediaVideoAdBreakReadyForPlacementID:(NSString *)placementID
                                       extra:(NSDictionary *)extra {
    ATDemoLog(@"mediaVideoAdBreakReadyForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"mediaVideoAdBreakReadyForPlacementID:%@", placementID]];
    
    [self.offer start];
}

#pragma mark - getter
- (UIView *)videoView {
    if (!_videoView) {
        _videoView = [[UIView alloc] init];
        _videoView.backgroundColor = [UIColor lightGrayColor];
    }
    return _videoView;
}

#pragma mark - Demo Needed 不用接入
- (void)viewDidLoad {
    [super viewDidLoad];
     
    [self setupDemoUI];
    
    [self addNotification];
}

- (void)setupDemoUI {
    [self addNormalBarWithTitle:self.title];
    [self addLogTextView];
    [self addFootView];
    
    [self.view addSubview:self.videoView];

    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.textView);
        make.centerX.mas_equalTo(self.textView);
        make.top.mas_equalTo(self.textView.mas_bottom).mas_offset(10);
        make.bottom.mas_equalTo(self.footView.loadBtn.mas_top).mas_offset(-10);
    }];
}
 
@end
