//
//  ATPasterVideoViewController.m
//  AnyThinkSDKDemo
//
//  Created by Taku on 7/26/22.
//  Copyright © 2022 抽筋的灯. All rights reserved.
//

#import "ATPasterVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AnyThinkNative/AnyThinkNative.h>
#import "ATPasterSelfRenderView.h"
#import "ATUtilitiesTool.h"

@interface ATPasterVideoViewController ()<ATNativeADDelegate>
@property (nonatomic , strong) AVPlayer *player;
@property (nonatomic , strong) AVPlayerItem *playerItem;
@property (nonatomic , strong) UIView *playerContainer;  // player container view
@property (nonatomic , strong) UIButton *voiceBtn;
@property (nonatomic , assign) BOOL isPlaying;
@property (nonatomic , strong) id playerObserver;
@property (nonatomic , assign) CGFloat totalTime;

@property (nonatomic) ATPasterSelfRenderView *selfRenderView;
@property (nonatomic) ATNativeADView *adView;
@property (nonatomic , strong) ATNativeAdOffer *nativeAdOffer;

@property(nonatomic, strong) NSString *placementID;

@property (nonatomic, strong) NSTimer *pasterTimer;
@property (nonatomic, assign) NSInteger remainingTime;

@end

@implementation ATPasterVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    self.placementID = @"b62ea134005961";
    
    [self loadNativeAd];
    
    [self layoutAVPlayer];
    [self layoutTopView];
}

#pragma mark - layout
-(void)layoutAVPlayer {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"testvideo0" ofType:@"mp4"];
    NSLog(@"url=%@",path);
    NSURL *url = [NSURL fileURLWithPath:path];
    AVURLAsset *asset = [AVURLAsset assetWithURL:url];
    self.totalTime = (asset.duration.value * 1.0 / asset.duration.timescale * 1.0);

    self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
    self.player = [[AVPlayer alloc]initWithPlayerItem:self.playerItem];
    
    AVPlayerLayer *playerlayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    playerlayer.videoGravity = AVLayerVideoGravityResizeAspect;
    
    CGRect playerFrame = CGRectMake(0, 0, kScreenW, kScreenH);
    playerlayer.frame = playerFrame;
    [self.view.layer addSublayer:playerlayer];
    
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    self.view.translatesAutoresizingMaskIntoConstraints = YES;
}

-(void)layoutTopView {
    self.playerContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    [self.view addSubview:self.playerContainer];
    UITapGestureRecognizer *tapsVideo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapVideo:)];
    tapsVideo.numberOfTapsRequired = 1;
    [self.playerContainer addGestureRecognizer:tapsVideo];
    
    [self.view addSubview:self.voiceBtn];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, kNavigationBarHeight, 30, 30);
    [btn setImage:[UIImage imageNamed:@"returnImage"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(closeVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view bringSubviewToFront:btn];
    [self.view addSubview:btn];
}

- (void)closeVC{
    [self invalidateTimer];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)playVideo {
    [self.player play];
    self.isPlaying = YES;
}

- (void)pauseVideo {
    [self.player pause];
    self.isPlaying = NO;
}

- (void)loadNativeAd
{
    CGSize size = CGSizeMake(kScreenW, 350);

    NSDictionary *extra = @{
        kATExtraInfoNativeAdSizeKey:[NSValue valueWithCGSize:size],
        kATNativeAdSizeToFitKey:@YES,
    };
    
    [[ATAdManager sharedManager] loadADWithPlacementID:self.placementID extra:extra delegate:self];
}

- (void)showAd
{
    BOOL ready = [[ATAdManager sharedManager] nativeAdReadyForPlacementID:self.placementID];
    if (ready == NO) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Not Yet!" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alert animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alert dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return;
    }
    ATNativeAdOffer *offer = [[ATAdManager sharedManager] getNativeAdOfferWithPlacementID:self.placementID];
    NSDictionary *offerDict = [ATUtilitiesTool getNativeAdOfferExtraDic:offer];
    NSLog(@"🔥--原生广告素材：%@",offerDict);
    self.nativeAdOffer = offer;

    ATNativeADConfiguration *config = [self getNativeADConfiguration];
    
    ATPasterSelfRenderView *selfRenderView = [self getSelfRenderViewOffer:offer];
    
    ATNativeADView *nativeADView = [self getNativeADView:config offer:offer selfRenderView:selfRenderView];
    
    [self prepareWithNativePrepareInfo:selfRenderView nativeADView:nativeADView];
    
    [offer rendererWithConfiguration:config selfRenderView:selfRenderView nativeADView:nativeADView];
            
    
    ATNativeAdRenderType nativeAdRenderType = [nativeADView getCurrentNativeAdRenderType];
    
    if (nativeAdRenderType == ATNativeAdRenderExpress) {
        NSLog(@"🔥--原生模板");
        NSLog(@"🔥--原生模板广告宽高：%lf，%lf",offer.nativeAd.nativeExpressAdViewWidth,offer.nativeAd.nativeExpressAdViewHeight);
    }else{
        NSLog(@"🔥--原生自渲染");
    }
    
    BOOL isVideoContents = [nativeADView isVideoContents];
    NSLog(@"🔥--是否为原生视频广告：%d",isVideoContents);
    
    if ([offer.adOfferInfo[@"network_firm_id"] integerValue] == 67) {
        CGFloat adViewH = kScreenW/(16.0f/9.0f);
        config.mediaViewFrame = CGRectMake(0, 0, adViewH, 350);
    }
    
    self.selfRenderView = selfRenderView;
    self.adView = nativeADView;
    [self.view addSubview:self.adView];
}

- (void)reShowAd
{
    if (self.adView) {
        [self.view addSubview:self.adView];
    }
}

- (void)removeAd
{
    if (self.adView && self.adView.superview) {
        [self.adView removeFromSuperview];
    }
}

#pragma mark - Show
- (ATNativeADConfiguration *)getNativeADConfiguration {
    // 设置贴片广告比例
    CGFloat scale = 16.0f/9.0f;
    if (self.nativeAdOffer.nativeAd.nativeExpressAdViewHeight != 0.0f) {
        scale = self.nativeAdOffer.nativeAd.nativeExpressAdViewWidth/self.nativeAdOffer.nativeAd.nativeExpressAdViewHeight;
    }
    CGFloat adViewW = kScreenW;
    CGFloat adViewH = adViewW/scale;
    CGFloat adViewY = (kScreenH - adViewH)/2;
    
    ATNativeADConfiguration *config = [[ATNativeADConfiguration alloc] init];
    config.ADFrame = CGRectMake(0, adViewY, adViewW, adViewH);
    config.mediaViewFrame = CGRectMake(0, 0, adViewW, adViewH - kNavigationBarHeight - 150);
    config.delegate = self;
    config.sizeToFit = YES;
    config.rootViewController = self;
    config.context = @{
        kATNativeAdConfigurationContextAdOptionsViewFrameKey:[NSValue valueWithCGRect:CGRectMake(CGRectGetWidth(self.view.bounds) - 43.0f, .0f, 43.0f, 18.0f)],
        kATNativeAdConfigurationContextAdLogoViewFrameKey:[NSValue valueWithCGRect:CGRectMake(.0f, .0f, 54.0f, 18.0f)],
        kATNativeAdConfigurationContextNetworkLogoViewFrameKey:[NSValue valueWithCGRect:CGRectMake(CGRectGetWidth(config.ADFrame) - 54.0f, CGRectGetHeight(config.ADFrame) - 18.0f, 54.0f, 18.0f)]
    };
    return config;
}

- (ATPasterSelfRenderView *)getSelfRenderViewOffer:(ATNativeAdOffer *)offer {
    
    ATPasterSelfRenderView *selfRenderView = [[ATPasterSelfRenderView alloc] initWithOffer:offer];
                
    selfRenderView.backgroundColor = randomColor;
    
    return selfRenderView;
}

- (ATNativeADView *)getNativeADView:(ATNativeADConfiguration *)config offer:(ATNativeAdOffer *)offer selfRenderView:(ATPasterSelfRenderView *)selfRenderView {
    
    ATNativeADView *nativeADView = [[ATNativeADView alloc] initWithConfiguration:config currentOffer:offer placementID:self.placementID];
    
    UIView *mediaView = [nativeADView getMediaView];

    NSMutableArray *array = [@[selfRenderView.mainImageView] mutableCopy];
    
    if (mediaView) {
        selfRenderView.mediaView = mediaView;
        
        [selfRenderView addSubview:mediaView];
        
        [mediaView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(selfRenderView);
            make.top.equalTo(selfRenderView.mainImageView.mas_top);
        }];
        
        [array addObject:mediaView];
    }
    
    [nativeADView registerClickableViewArray:array];
    
    [selfRenderView bringSubviewToFront:selfRenderView.countDownLabel];

    self.adView = nativeADView;
    
    return nativeADView;
}

- (void)prepareWithNativePrepareInfo:(ATPasterSelfRenderView *)selfRenderView nativeADView:(ATNativeADView *)nativeADView{
    
    ATNativePrepareInfo *info = [ATNativePrepareInfo loadPrepareInfo:^(ATNativePrepareInfo * _Nonnull prepareInfo) {
        prepareInfo.mainImageView = selfRenderView.mainImageView;
        prepareInfo.logoImageView = selfRenderView.logoImageView;
        prepareInfo.mediaView = selfRenderView.mediaView;
    }];
    
    [nativeADView prepareWithNativePrepareInfo:info];
}


#pragma mark - application notification
-(void)applicationWillResignActive:(NSNotification *)notification {
    [self pauseVideo];
}

-(void)applicationWillBecomeActive:(NSNotification *)notification {
    [self playVideo];
}

//不可切换横竖屏
-(BOOL)shouldAutorotate {
    return NO;
}

#pragma mark - notification
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if(object == self.playerItem){
        if([keyPath isEqualToString:@"status"]){
            AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
            switch (status) {
                case AVPlayerStatusReadyToPlay:
                    {
                        [self.player setVolume:[AVAudioSession sharedInstance].outputVolume];
                        [self timeObserver];
                    }
                    break;
                case AVPlayerStatusUnknown:
                case AVPlayerStatusFailed:
                    break;
                default:
                    break;
            }
        }
    }
}

//监听视频播放进度
-(void)timeObserver {
    __weak typeof(self) weakself = self;
    _playerObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(50, 1000) queue:NULL usingBlock:^(CMTime time) {
        CGFloat currentime = (time.value * 1.00) / (time.timescale * 1.00) ;
        if (currentime >= weakself.totalTime) {
            // 播放完成，重复播放
            [weakself.player seekToTime:CMTimeMake(0, 1)];
            [weakself.player play];
        }
    }];
}

-(void) startCountdown:(NSTimeInterval)interval {
    self.remainingTime = interval;
    self.pasterTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(pasterTimerCountdown) userInfo:nil repeats:YES];
}

- (void)pasterTimerCountdown {
    if (self.remainingTime == 0) {
        [self invalidateTimer];
        
        // 移除广告
        [self removeAd];
        // 播放视频
        [self playVideo];
    } else {
        self.remainingTime --;
        self.selfRenderView.countDownLabel.text = [NSString stringWithFormat:@"%ld",self.remainingTime];
    }
    NSLog(@"🔥----倒计时:%ld",self.remainingTime);
}

- (void)invalidateTimer {
    if (self.pasterTimer) {
        [self.pasterTimer invalidate];
        self.pasterTimer = nil;
    }
}

-(void)tapVideo:(UITapGestureRecognizer *)gesture {
    NSLog(@"video is click");
    if (self.isPlaying) {
        [self pauseVideo];
    } else {
        [self playVideo];
    }
}

-(void)clickVoiceBtn:(UIButton *)btn {
    [self.player setMuted:!self.player.isMuted];
    NSBundle *anyThinkBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"AnyThinkSDK" ofType:@"bundle"]];

    if(self.player.isMuted){
        [_voiceBtn setImage:[UIImage imageNamed:@"offer_voice_muted" inBundle:anyThinkBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    }else{
        [_voiceBtn setImage:[UIImage imageNamed:@"offer_voice_unmuted" inBundle:anyThinkBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    }
}

#pragma mark - dealloc
-(void)dealloc {
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.player removeTimeObserver:_playerObserver];
    [self invalidateTimer];
    NSLog(@"ATPasterVideoViewController dealloc");
}

-(UIButton *)voiceBtn {
    if(!_voiceBtn){
        NSBundle *anyThinkBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"AnyThinkSDK" ofType:@"bundle"]];
        
        _voiceBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW - 30 - 20, kNavigationBarHeight, 30, 30)];
        if (self.player.isMuted) {
            [_voiceBtn setImage:[UIImage imageNamed:@"offer_voice_muted" inBundle:anyThinkBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        }else{
            [_voiceBtn setImage:[UIImage imageNamed:@"offer_voice_unmuted" inBundle:anyThinkBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        }
        [_voiceBtn addTarget:self action:@selector(clickVoiceBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceBtn;
}


#pragma mark - ATAdLoadingDelegate
- (void)didStartLoadingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary*)extra{
    NSLog(@"广告源--AD--开始--ATPasterVideoViewController::didStartLoadingADSourceWithPlacementID:%@---extra:%@", placementID,extra);
}

- (void)didFinishLoadingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary*)extra{
    NSLog(@"广告源--AD--完成--ATPasterVideoViewController::didFinishLoadingADSourceWithPlacementID:%@---extra:%@", placementID,extra);
}

- (void)didFailToLoadADSourceWithPlacementID:(NSString*)placementID extra:(NSDictionary*)extra error:(NSError*)error{
    NSLog(@"广告源--AD--失败--ATPasterVideoViewController::didFailToLoadADSourceWithPlacementID:%@---error:%@", placementID,error);
}

// bidding
- (void)didStartBiddingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary*)extra{
    NSLog(@"广告源--bid--开始--ATPasterVideoViewController::didStartBiddingADSourceWithPlacementID:%@---extra:%@", placementID,extra);
}

- (void)didFinishBiddingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary*)extra{
    NSLog(@"广告源--bid--完成--ATPasterVideoViewController::didFinishBiddingADSourceWithPlacementID:%@--extra:%@", placementID,extra);
}

- (void)didFailBiddingADSourceWithPlacementID:(NSString*)placementID extra:(NSDictionary*)extra error:(NSError*)error{
    NSLog(@"广告源--bid--失败--ATPasterVideoViewController::didFailBiddingADSourceWithPlacementID:%@--error:%@", placementID,error);
}

-(void) didFinishLoadingADWithPlacementID:(NSString *)placementID {
    NSLog(@"广告位--load--成功--ATPasterVideoViewController:: didFinishLoadingADWithPlacementID:%@", placementID);
    
    [self showAd];
}

-(void) didFailToLoadADWithPlacementID:(NSString *)placementID error:(NSError *)error {
    NSLog(@"广告位--load--失败--ATPasterVideoViewController:: didFailToLoadADWithPlacementID:%@ error:%@", placementID, error);
}

#pragma mark - ATNativeADDelegate
-(void) didShowNativeAdInAdView:(ATNativeADView*)adView placementID:(NSString*)placementID extra:(NSDictionary *)extra{
    NSLog(@"ATPasterVideoViewController:: didShowNativeAdInAdView:placementID:%@ with extra: %@", placementID,extra);
    if (self.nativeAdOffer.nativeAd.videoDuration == 0) {
        // 表示当次展示为图片广告，默认倒计时10秒关闭广告
        [self startCountdown:10.0f];
    } else {
        // 开始倒计时
        [self startCountdown:self.nativeAdOffer.nativeAd.videoDuration/1000.0f];
    }
}

-(void) didStartPlayingVideoInAdView:(ATNativeADView*)adView placementID:(NSString*)placementID extra:(NSDictionary *)extra{
    NSLog(@"ATPasterVideoViewController:: didStartPlayingVideoInAdView:placementID:%@with extra: %@", placementID,extra);
}

-(void) didEndPlayingVideoInAdView:(ATNativeADView*)adView placementID:(NSString*)placementID extra:(NSDictionary *)extra{
    NSLog(@"ATPasterVideoViewController:: didEndPlayingVideoInAdView:placementID:%@ extra: %@", placementID,extra);
}

-(void) didClickNativeAdInAdView:(ATNativeADView*)adView placementID:(NSString*)placementID extra:(NSDictionary *)extra{
    NSLog(@"ATPasterVideoViewController:: didClickNativeAdInAdView:placementID:%@ with extra: %@", placementID,extra);
}

-(void) didEnterFullScreenVideoInAdView:(ATNativeADView*)adView placementID:(NSString*)placementID extra:(NSDictionary *)extra{
    NSLog(@"ATPasterVideoViewController:: didEnterFullScreenVideoInAdView:placementID:%@", placementID);
}

-(void) didExitFullScreenVideoInAdView:(ATNativeADView*)adView placementID:(NSString*)placementID extra:(NSDictionary *)extra{
    NSLog(@"ATPasterVideoViewController:: didExitFullScreenVideoInAdView:placementID:%@", placementID);
}

-(void) didTapCloseButtonInAdView:(ATNativeADView*)adView placementID:(NSString*)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATPasterVideoViewController:: didTapCloseButtonInAdView:placementID:%@ extra:%@", placementID, extra);
}

- (void) didDeepLinkOrJumpInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra result:(BOOL)success {
    NSLog(@"ATPasterVideoViewController:: didDeepLinkOrJumpInAdView:placementID:%@ with extra: %@, success:%@", placementID,extra, success ? @"YES" : @"NO");
}

- (void)didCloseDetailInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATPasterVideoViewController:: didCloseDetailInAdView:placementID:%@ extra:%@", placementID, extra);
}



@end
