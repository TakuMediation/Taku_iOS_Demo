//
//  ATNativeShowViewController.m
//  AnyThingSDKDemo
//
//  Created by mac on 2021/12/7.
//

#import "ATNativeShowViewController.h"
#import <AnyThinkNative/ATNativeADView.h>
#import "ATNativeRenderView.h"

@interface ATNativeShowViewController () <ATAdLoadingDelegate, ATNativeADDelegate>

@property (nonatomic, weak) ATNativeADView *adView;

@property (nonatomic, strong) UIButton *voiceChange;

@property (nonatomic, strong) UIButton *voiceProgress;

@property (nonatomic, strong) UIButton *voicePause;

@property (nonatomic, strong) UIButton *voicePlay;

@property(nonatomic, assign) BOOL mute;

@property(nonatomic, assign) BOOL isPlaying;

@property(nonatomic, strong) ATNativeAdOffer *adOffer;

@end

@implementation ATNativeShowViewController

- (instancetype)initWithAdView:(ATNativeADView *)adView placementID:(NSString *)placementID offer:(ATNativeAdOffer *)offer{
    if (self = [super init]) {
        _adOffer = offer;
        _adView = adView;
    }
    return self;
    
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
}

- (void)setupUI
{
    [self.view addSubview:self.voiceChange];
    [self.view addSubview:self.voiceProgress];
    [self.view addSubview:self.voicePause];
    [self.view addSubview:self.voicePlay];
    [self.view addSubview:self.adView];
    
    [self.voicePlay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((kScreenW - kScaleW(26) * 4) / 3);
        make.height.mas_equalTo((kScreenW - kScaleW(26) * 4) / 6);
        make.left.equalTo(self.view.mas_left).offset(kScaleW(26));
        make.bottom.equalTo(self.view.mas_bottom).offset(-kScaleW(26));
    }];
    
    [self.voiceChange mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((kScreenW - kScaleW(26) * 4) / 3);
        make.height.mas_equalTo((kScreenW - kScaleW(26) * 4) / 6);
        make.left.equalTo(self.view.mas_left).offset(kScaleW(26));
        make.bottom.equalTo(self.voicePlay.mas_top).offset(-kScaleW(26));
    }];
    
    [self.voiceProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((kScreenW - kScaleW(26) * 4) / 3);
        make.height.mas_equalTo((kScreenW - kScaleW(26) * 4) / 6);
        make.left.equalTo(self.voiceChange.mas_right).offset(kScaleW(26));
        make.bottom.equalTo(self.voiceChange.mas_bottom);
    }];
    
    [self.voicePause mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((kScreenW - kScaleW(26) * 4) / 3);
        make.height.mas_equalTo((kScreenW - kScaleW(26) * 4) / 6);
        make.left.equalTo(self.voiceProgress.mas_right).offset(kScaleW(26));
        make.bottom.equalTo(self.voiceChange.mas_bottom);
    }];
}


#pragma mark - Action
- (void)clickChange
{
    NSLog(@"ATNativeViewController:getNativeAdType:%ld,getCurrentNativeAdRenderType:%ld",[self.adView getNativeAdType],[self.adView getCurrentNativeAdRenderType]);
    [self.adView muteEnable:self.mute];
    self.mute = !self.mute;
}

- (void)clickProgress
{
    NSLog(@"ATNativeViewController:videoDuration:%f,videoPlayTime:%f",[self.adView videoDuration],[self.adView videoPlayTime]);
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
        _voiceChange.layer.borderWidth = kScaleW(3);
        [_voiceChange setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_voiceChange setTitleColor:kRGB(73, 109, 255) forState:UIControlStateNormal];
        [_voiceChange setBackgroundImage:[self imageWithColor:kRGB(73, 109, 255)] forState:UIControlStateHighlighted];
        [_voiceChange setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
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
        _voiceProgress.layer.borderWidth = kScaleW(3);
        [_voiceProgress setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_voiceProgress setTitleColor:kRGB(73, 109, 255) forState:UIControlStateNormal];
        [_voiceProgress setBackgroundImage:[self imageWithColor:kRGB(73, 109, 255)] forState:UIControlStateHighlighted];
        [_voiceProgress setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
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
        _voicePause.layer.borderWidth = kScaleW(3);
        [_voicePause setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_voicePause setTitleColor:kRGB(73, 109, 255) forState:UIControlStateNormal];
        [_voicePause setBackgroundImage:[self imageWithColor:kRGB(73, 109, 255)] forState:UIControlStateHighlighted];
        [_voicePause setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
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
        _voicePlay.layer.borderWidth = kScaleW(3);
        [_voicePlay setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_voicePlay setTitleColor:kRGB(73, 109, 255) forState:UIControlStateNormal];
        [_voicePlay setBackgroundImage:[self imageWithColor:kRGB(73, 109, 255)] forState:UIControlStateHighlighted];
        [_voicePlay setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        _voicePlay.layer.masksToBounds = YES;
        _voicePlay.layer.cornerRadius = 5;
        [_voicePlay setTitle:@"Voice Play" forState:UIControlStateNormal];
        _voicePlay.titleLabel.font = [UIFont systemFontOfSize:14];
        [_voicePlay addTarget:self action:@selector(clickPlay) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voicePlay;
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}
@end
