//
//  AdDisplayVC.m
//  iOSDemo
//
//  Created by ltz on 2025/1/11.
//

#import "AdDisplayVC.h"
#import "SelfRenderView.h"

@interface AdDisplayVC ()

@property (nonatomic, weak) ATNativeADView *adView;
@property (nonatomic, strong) UIButton *voiceChange;
@property (nonatomic, strong) UIButton *voiceProgress;
@property (nonatomic, strong) UIButton *voicePause;
@property (nonatomic, strong) UIButton *voicePlay;
@property(nonatomic, assign) BOOL mute;
@property(nonatomic, assign) BOOL isPlaying;
@property(nonatomic, strong) ATNativeAdOffer *adOffer;
@property (assign, nonatomic) CGSize adSize;

@end

@implementation AdDisplayVC

- (instancetype)initWithAdView:(ATNativeADView *)adView offer:(ATNativeAdOffer *)offer adViewSize:(CGSize)size {
    if (self = [super init]) {
        _adOffer = offer;
        _adView = adView;
        _adSize = size;
    }
    return self;
}

- (void)dealloc {
    ATDemoLog(@"%s", __func__);
}
 
#pragma mark - Demo Needed 不用接入
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Ad";
     
    [self setupDemoUI];
}

- (void)setupDemoUI {
    [self addNormalBarWithTitle:self.title];
 
    [self.view addSubview:self.voiceChange];
    [self.view addSubview:self.voiceProgress];
    [self.view addSubview:self.voicePause];
    [self.view addSubview:self.voicePlay];
    [self.view addSubview:self.adView];
    
    //再布局调整位置与大小，与之前设置的一致
    [self.adView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nbar.mas_bottom).mas_offset(15);
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(self.adSize.width);
        make.height.mas_equalTo(self.adSize.height);
    }];
    
    [self.voicePlay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((kScreenW - kAdaptW(26, 26) * 4) / 3);
        make.height.mas_equalTo((kScreenW - kAdaptW(26, 26) * 4) / 6);
        make.left.equalTo(self.view.mas_left).offset(kAdaptW(26, 26));
        make.bottom.equalTo(self.view.mas_bottom).offset(-kAdaptW(26, 26));
    }];
    
    [self.voiceChange mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((kScreenW - kAdaptW(26, 26) * 4) / 3);
        make.height.mas_equalTo((kScreenW - kAdaptW(26, 26) * 4) / 6);
        make.left.equalTo(self.view.mas_left).offset(kAdaptW(26, 26));
        make.bottom.equalTo(self.voicePlay.mas_top).offset(-kAdaptW(26, 26));
    }];
    
    [self.voiceProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((kScreenW - kAdaptW(26, 26) * 4) / 3);
        make.height.mas_equalTo((kScreenW - kAdaptW(26, 26) * 4) / 6);
        make.left.equalTo(self.voiceChange.mas_right).offset(kAdaptW(26, 26));
        make.bottom.equalTo(self.voiceChange.mas_bottom);
    }];
    
    [self.voicePause mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((kScreenW - kAdaptW(26, 26) * 4) / 3);
        make.height.mas_equalTo((kScreenW - kAdaptW(26, 26) * 4) / 6);
        make.left.equalTo(self.voiceProgress.mas_right).offset(kAdaptW(26, 26));
        make.bottom.equalTo(self.voiceChange.mas_bottom);
    }];
}
 
#pragma mark - Action
- (void)clickChange
{
    ATDemoLog(@"AdDisplayVC:getNativeAdType:%ld,getCurrentNativeAdRenderType:%ld",[self.adView getNativeAdType],[self.adView getCurrentNativeAdRenderType]);
    [self.adView muteEnable:self.mute];
    self.mute = !self.mute;
}

- (void)clickProgress
{
    ATDemoLog(@"AdDisplayVC:videoDuration:%f,videoPlayTime:%f",[self.adView videoDuration],[self.adView videoPlayTime]);
}

- (void)clickPause
{
    if (self.isPlaying) {
        [self.adView videoPause];
        self.isPlaying = NO;
    }
}

- (void)clickPlay
{
    if (!self.isPlaying) {
        [self.adView videoPlay];
        self.isPlaying = YES;
    }
}

#pragma mark - lazy
- (UIButton *)voiceChange
{
    if (!_voiceChange) {
        _voiceChange = [[UIButton alloc] init];
        _voiceChange.layer.borderColor = kRGB(73, 109, 255).CGColor;
        _voiceChange.layer.borderWidth = kAdaptX(3, 3);
        [_voiceChange setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_voiceChange setTitleColor:kRGB(73, 109, 255) forState:UIControlStateNormal];
        [_voiceChange setBackgroundImage:[Tools imageWithColor:kRGB(73, 109, 255)] forState:UIControlStateHighlighted];
        [_voiceChange setBackgroundImage:[Tools imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        _voiceChange.layer.masksToBounds = YES;
        _voiceChange.layer.cornerRadius = 5;
        [_voiceChange setTitle:@"Voice Change" forState:UIControlStateNormal];
        _voiceChange.titleLabel.font = [UIFont systemFontOfSize:14];
        [_voiceChange addTarget:self action:@selector(clickChange) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceChange;
}

- (UIButton *)voiceProgress
{
    if (!_voiceProgress) {
        _voiceProgress = [[UIButton alloc] init];
        _voiceProgress.layer.borderColor = kRGB(73, 109, 255).CGColor;
        _voiceProgress.layer.borderWidth = kAdaptX(3, 3);
        [_voiceProgress setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_voiceProgress setTitleColor:kRGB(73, 109, 255) forState:UIControlStateNormal];
        [_voiceProgress setBackgroundImage:[Tools imageWithColor:kRGB(73, 109, 255)] forState:UIControlStateHighlighted];
        [_voiceProgress setBackgroundImage:[Tools imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        _voiceProgress.layer.masksToBounds = YES;
        _voiceProgress.layer.cornerRadius = 5;
        [_voiceProgress setTitle:@"Voice Progress" forState:UIControlStateNormal];
        _voiceProgress.titleLabel.font = [UIFont systemFontOfSize:14];
        [_voiceProgress addTarget:self action:@selector(clickProgress) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceProgress;
}

- (UIButton *)voicePause
{
    if (!_voicePause) {
        _voicePause = [[UIButton alloc] init];
        _voicePause.layer.borderColor = kRGB(73, 109, 255).CGColor;
        _voicePause.layer.borderWidth = kAdaptX(3, 3);
        [_voicePause setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_voicePause setTitleColor:kRGB(73, 109, 255) forState:UIControlStateNormal];
        [_voicePause setBackgroundImage:[Tools imageWithColor:kRGB(73, 109, 255)] forState:UIControlStateHighlighted];
        [_voicePause setBackgroundImage:[Tools imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        _voicePause.layer.masksToBounds = YES;
        _voicePause.layer.cornerRadius = 5;
        [_voicePause setTitle:@"Voice Pause" forState:UIControlStateNormal];
        _voicePause.titleLabel.font = [UIFont systemFontOfSize:14];
        [_voicePause addTarget:self action:@selector(clickPause) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voicePause;
}

- (UIButton *)voicePlay
{
    if (!_voicePlay) {
        _voicePlay = [[UIButton alloc] init];
        _voicePlay.layer.borderColor = kRGB(73, 109, 255).CGColor;
        _voicePlay.layer.borderWidth = kAdaptX(3, 3);
        [_voicePlay setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_voicePlay setTitleColor:kRGB(73, 109, 255) forState:UIControlStateNormal];
        [_voicePlay setBackgroundImage:[Tools imageWithColor:kRGB(73, 109, 255)] forState:UIControlStateHighlighted];
        [_voicePlay setBackgroundImage:[Tools imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        _voicePlay.layer.masksToBounds = YES;
        _voicePlay.layer.cornerRadius = 5;
        [_voicePlay setTitle:@"Voice Play" forState:UIControlStateNormal];
        _voicePlay.titleLabel.font = [UIFont systemFontOfSize:14];
        [_voicePlay addTarget:self action:@selector(clickPlay) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voicePlay;
}
 
@end
