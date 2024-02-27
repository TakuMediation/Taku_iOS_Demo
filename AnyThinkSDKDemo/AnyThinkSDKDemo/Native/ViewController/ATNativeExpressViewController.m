//
//  ATNativeExpressViewController.m
//  AnyThinkSDKDemo
//
//  Created by Taku on 7/28/22.
//  Copyright © 2022 抽筋的灯. All rights reserved.
//

#import "ATNativeExpressViewController.h"
#import "ATNativeShowViewController.h"
#import "MTAutolayoutCategories.h"
#import "ATADFootView.h"
#import "ATModelButton.h"
#import "ATMenuView.h"
#import "ATUtilitiesTool.h"

@interface ATNativeExpressViewController()<ATNativeADDelegate>

@property (nonatomic, strong) ATADFootView *footView;

@property (nonatomic, strong) ATModelButton *nativeBtn;

@property (nonatomic, strong) ATMenuView *menuView;

@property (nonatomic, strong) UITextView *textView;

@property(nonatomic) ATNativeADView *adView;

@property (copy, nonatomic) NSDictionary<NSString *, NSString *> *placementIDs;
@property (copy, nonatomic) NSString *placementID;

@end

@implementation ATNativeExpressViewController


- (void)dealloc {
    NSLog(@"🔥----ATNativeExpressViewController销毁%@", NSStringFromSelector(_cmd));
    [self removeAd];
}

- (NSDictionary<NSString *,NSString *> *)placementIDs {
    return @{
        @"All":                       @"b62e797b5727c0",
        @"Facebook(NativeBanner)":    @"b62b41c7781130",
        @"Mintegral(Template)":       @"b62b41c7a6ecd5",
        @"GDT(Template)":             @"b62b420b01bcd6",
        @"CSJ(Template)":             @"b62ea1cad196bd",
        @"Baidu(Template)":           @"b62ea1d100d9ba",
        @"Kuaishou(Template)":        @"b62ea1d6c5b92f",
        @"Klevin(Template)":          @"b62ea1e3f2a62b",
        @"MyTarget(Template)":        @"b62ea1e8da3189",
    };
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Native Express";
    self.view.backgroundColor = kRGB(245, 245, 245);
    
    self.placementID = self.placementIDs.allValues.firstObject;
    [self setupUI];
}

- (void)setupUI {
    UIButton *clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
    [clearBtn setTitle:@"clear log" forState:UIControlStateNormal];
    [clearBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(clearLog) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:clearBtn];
    self.navigationItem.rightBarButtonItem = btnItem;
    
    [self.view addSubview:self.nativeBtn];
    [self.view addSubview:self.menuView];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.footView];
    
    [self.nativeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenW - kScaleW(52));
        make.height.mas_equalTo(kScaleW(360));
        make.top.equalTo(self.view.mas_top).offset(kNavigationBarHeight + kScaleW(20));
        make.centerX.equalTo(self.view.mas_centerX);
    }];

    [self.menuView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenW - kScaleW(52));
        make.height.mas_equalTo(kScaleW(242));
        make.top.equalTo(self.nativeBtn.mas_bottom).offset(kScaleW(20));
        make.centerX.equalTo(self.view.mas_centerX);
    }];

    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.menuView.mas_bottom).offset(kScaleW(20));
        make.bottom.equalTo(self.footView.mas_top).offset(kScaleW(-20));
        make.width.mas_equalTo(kScreenW - kScaleW(52));
        make.centerX.equalTo(self.view.mas_centerX);
    }];

    [self.footView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(kScaleW(340));
    }];
}

- (void)clearLog {
    self.textView.text = @"";
}

#pragma mark - Action
//广告加载
- (void)loadAd {
    CGSize size = CGSizeMake(kScreenW, 350);

    NSDictionary *extra = @{
        // 模板广告size，透传给广告平台，广告平台会返回相近尺寸的最优模板广告
        kATExtraInfoNativeAdSizeKey:[NSValue valueWithCGSize:size],
        // 是否开启自适应高度，默认关闭，设置为yes时打开
        kATNativeAdSizeToFitKey:@YES,
    };
    [[ATAdManager sharedManager] loadADWithPlacementID:self.placementID extra:extra delegate:self];
}

//检查广告缓存
- (void)checkAd {
    // 获取广告位的状态对象
    ATCheckLoadModel *checkLoadModel = [[ATAdManager sharedManager] checkNativeLoadStatusForPlacementID:self.placementID];
    NSLog(@"CheckLoadModel.isLoading:%d--- isReady:%d",checkLoadModel.isLoading,checkLoadModel.isReady);
    
    // 查询该广告位的所有缓存信息
    NSArray *array = [[ATAdManager sharedManager] getNativeValidAdsForPlacementID:self.placementID];
    NSLog(@"ValidAds.count:%ld--- ValidAds:%@",array.count,array);

    // 判断当前是否存在可展示的广告
    BOOL isReady = [[ATAdManager sharedManager] nativeAdReadyForPlacementID:self.placementID];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:isReady ? @"Ready!" : @"Not Yet!" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}

- (void)entryAdScenario {
    /* 为了统计场景到达率，相关信息可查阅 iOS高级设置说明 -> 广告场景 在满足广告触发条件时调用“进入广告场景”方法，
    比如： ** 广告场景是在清理结束后弹出广告，则在清理结束时调用；
    * 1、先调用 entryxxx
    * 2、在判断 Ready的状态是否可展示
    * 3、最后调用 show 展示 */
    [[ATAdManager sharedManager] entryNativeScenarioWithPlacementID:self.placementID scene:KTaKuNativeSceneID];
}

//广告展示
- (void)showAd {
    // 到达场景
    [self entryAdScenario];
    
    // 判断广告isReady状态
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
    
    // 获取广告offer对象
    ATNativeAdOffer *offer = [[ATAdManager sharedManager] getNativeAdOfferWithPlacementID:self.placementID scene:KTaKuNativeSceneID];
    NSDictionary *offerDict = [ATUtilitiesTool getNativeAdOfferExtraDic:offer];
    NSLog(@"🔥--原生广告素材：%@",offerDict);
    
    CGFloat adViewWidth = offer.nativeAd.nativeExpressAdViewWidth;
    CGFloat adViewHeight = offer.nativeAd.nativeExpressAdViewHeight;
    // 因部分平台模板广告宽高可能返回0，需要兼容兜底处理
    if (adViewWidth == 0) {
        adViewWidth = kScreenW;
    }
    if (adViewHeight == 0) {
        adViewHeight = 350;
    }
    CGRect adFrame = CGRectMake(.0f, kNavigationBarHeight, adViewWidth, adViewHeight);
    
    // 初始化config配置
    ATNativeADConfiguration *config = [[ATNativeADConfiguration alloc] init];
    config.ADFrame = adFrame;
    config.delegate = self;
    // 开启自适应高度
    config.sizeToFit = YES;
    config.rootViewController = self;
    
    // 创建nativeADView
    ATNativeADView *nativeADView = [[ATNativeADView alloc] initWithConfiguration:config currentOffer:offer placementID:self.placementID];
    self.adView = nativeADView;
    
    // 渲染广告
    [offer rendererWithConfiguration:config selfRenderView:nil nativeADView:nativeADView];
            
    ATNativeAdRenderType nativeAdRenderType = [nativeADView getCurrentNativeAdRenderType];
    if (nativeAdRenderType == ATNativeAdRenderExpress) {
        NSLog(@"🔥--原生模板");
        NSLog(@"🔥--原生模板广告宽高：%lf，%lf",offer.nativeAd.nativeExpressAdViewWidth,offer.nativeAd.nativeExpressAdViewHeight);
    }else{
        NSLog(@"🔥--原生自渲染");
    }
    
    BOOL isVideoContents = [nativeADView isVideoContents];
    NSLog(@"🔥--是否为原生视频广告：%d",isVideoContents);
    
    // 展示广告
    ATNativeShowViewController *showVc = [[ATNativeShowViewController alloc] initWithAdView:nativeADView placementID:self.placementID offer:offer];
    [self.navigationController pushViewController:showVc animated:YES];
}

- (void)removeAd {
    if (self.adView && self.adView.superview) {
        [self.adView removeFromSuperview];
    }
    
    self.adView = nil;
}

- (void)showLog:(NSString *)logStr {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *logS = self.textView.text;
        NSString *log = nil;
        if (![logS isEqualToString:@""]) {
            log = [NSString stringWithFormat:@"%@\n%@", logS, logStr];
        } else {
            log = [NSString stringWithFormat:@"%@", logStr];
        }
        self.textView.text = log;
        [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length, 1)];
    });
}


#pragma mark - delegate with extra
- (void)didStartLoadingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary*)extra{
    NSLog(@"广告源--AD--开始--ATRewardVideoViewController::didStartLoadingADSourceWithPlacementID:%@---extra:%@", placementID,extra);
}

- (void)didFinishLoadingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary*)extra{
    NSLog(@"广告源--AD--完成--ATRewardVideoViewController::didFinishLoadingADSourceWithPlacementID:%@---extra:%@", placementID,extra);
}

- (void)didFailToLoadADSourceWithPlacementID:(NSString*)placementID extra:(NSDictionary*)extra error:(NSError*)error{
    NSLog(@"广告源--AD--失败--ATRewardVideoViewController::didFailToLoadADSourceWithPlacementID:%@---error:%@", placementID,error);
}

// bidding
- (void)didStartBiddingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary*)extra{
    NSLog(@"广告源--bid--开始--ATRewardVideoViewController::didStartBiddingADSourceWithPlacementID:%@---extra:%@", placementID,extra);
}

- (void)didFinishBiddingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary*)extra{
    NSLog(@"广告源--bid--完成--ATRewardVideoViewController::didFinishBiddingADSourceWithPlacementID:%@--extra:%@", placementID,extra);
}

- (void)didFailBiddingADSourceWithPlacementID:(NSString*)placementID extra:(NSDictionary*)extra error:(NSError*)error{
    NSLog(@"广告源--bid--失败--ATRewardVideoViewController::didFailBiddingADSourceWithPlacementID:%@--error:%@", placementID,error);
}

-(void) didFinishLoadingADWithPlacementID:(NSString *)placementID {
    NSLog(@"ATNativeViewController:: didFinishLoadingADWithPlacementID:%@", placementID);
    [self showLog:[NSString stringWithFormat:@"didFinishLoading:%@", placementID]];
}

-(void) didFailToLoadADWithPlacementID:(NSString *)placementID error:(NSError *)error {
    NSLog(@"ATNativeViewController:: didFailToLoadADWithPlacementID:%@ error:%@", placementID, error);
    [self showLog:[NSString stringWithFormat:@"didFailToLoad:%@ errorCode:%ld", placementID, (long)error.code]];
}

#pragma mark - delegate with extra
-(void) didStartPlayingVideoInAdView:(ATNativeADView*)adView placementID:(NSString*)placementID extra:(NSDictionary *)extra{
    NSLog(@"ATNativeViewController:: didStartPlayingVideoInAdView:placementID:%@with extra: %@", placementID,extra);
    [self showLog:[NSString stringWithFormat:@"didStartPlayingVideoInAdView:%@", placementID]];
}

-(void) didEndPlayingVideoInAdView:(ATNativeADView*)adView placementID:(NSString*)placementID extra:(NSDictionary *)extra{
    NSLog(@"ATNativeViewController:: didEndPlayingVideoInAdView:placementID:%@ extra: %@", placementID,extra);
    [self showLog:[NSString stringWithFormat:@"didEndPlayingVideoInAdView:%@", placementID]];
}

-(void) didClickNativeAdInAdView:(ATNativeADView*)adView placementID:(NSString*)placementID extra:(NSDictionary *)extra{
    NSLog(@"ATNativeViewController:: didClickNativeAdInAdView:placementID:%@ with extra: %@", placementID,extra);
    [self showLog:[NSString stringWithFormat:@"didClickNativeAdInAdView:%@", placementID]];
}

- (void) didDeepLinkOrJumpInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra result:(BOOL)success {
    NSLog(@"ATNativeViewController:: didDeepLinkOrJumpInAdView:placementID:%@ with extra: %@, success:%@", placementID,extra, success ? @"YES" : @"NO");
    [self showLog:[NSString stringWithFormat:@"ATNativeViewController:: didDeepLinkOrJumpInAdView:%@, success:%@", placementID, success ? @"YES" : @"NO"]];
}

-(void) didShowNativeAdInAdView:(ATNativeADView*)adView placementID:(NSString*)placementID extra:(NSDictionary *)extra{
    NSLog(@"ATNativeViewController:: didShowNativeAdInAdView:placementID:%@ with extra: %@", placementID,extra);
    adView.mainImageView.hidden = [adView isVideoContents];
    [self showLog:[NSString stringWithFormat:@"didShowNativeAdInAdView:%@", placementID]];
}

-(void) didEnterFullScreenVideoInAdView:(ATNativeADView*)adView placementID:(NSString*)placementID extra:(NSDictionary *)extra{
    NSLog(@"ATNativeViewController:: didEnterFullScreenVideoInAdView:placementID:%@", placementID);
    [self showLog:[NSString stringWithFormat:@"didEnterFullScreenVideoInAdView:%@", placementID]];
}

-(void) didExitFullScreenVideoInAdView:(ATNativeADView*)adView placementID:(NSString*)placementID extra:(NSDictionary *)extra{
    NSLog(@"ATNativeViewController:: didExitFullScreenVideoInAdView:placementID:%@", placementID);
    [self showLog:[NSString stringWithFormat:@"didExitFullScreenVideoInAdView:%@", placementID]];
}

-(void) didTapCloseButtonInAdView:(ATNativeADView*)adView placementID:(NSString*)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATNativeViewController:: didTapCloseButtonInAdView:placementID:%@ extra:%@", placementID, extra);
    [self.adView removeFromSuperview];
    self.adView = nil;
    adView = nil;
    [self showLog:[NSString stringWithFormat:@"didTapCloseButtonInAdView:placementID:%@", placementID]];
}

- (void)didCloseDetailInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATNativeViewController:: didCloseDetailInAdView:placementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"didCloseDetailInAdView:placementID:%@", placementID]];
}


#pragma mark - lazy
- (ATADFootView *)footView {
    if (!_footView) {
        _footView = [[ATADFootView alloc] init];

        __weak typeof(self) weakSelf = self;
        [_footView setClickLoadBlock:^{
            NSLog(@"点击加载");
            [weakSelf loadAd];
        }];
        [_footView setClickReadyBlock:^{
            NSLog(@"点击准备");
            [weakSelf checkAd];
        }];
        [_footView setClickShowBlock:^{
            NSLog(@"点击展示");
            [weakSelf showAd];
        }];
        
        if (![NSStringFromClass([self class]) containsString:@"Auto"]) {
            [_footView.loadBtn setTitle:@"Load Native AD" forState:UIControlStateNormal];
            [_footView.readyBtn setTitle:@"Is Native AD Ready" forState:UIControlStateNormal];
            [_footView.showBtn setTitle:@"Show Native AD" forState:UIControlStateNormal];
        }
        
    }
    return _footView;
}

- (ATModelButton *)nativeBtn {
    if (!_nativeBtn) {
        _nativeBtn = [[ATModelButton alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScaleW(532))];
        _nativeBtn.backgroundColor = [UIColor whiteColor];
        _nativeBtn.modelLabel.text = @"Native";
        _nativeBtn.image.image = [UIImage imageNamed:@"Native"];
    }
    return _nativeBtn;
}

- (ATMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[ATMenuView alloc] initWithMenuList:self.placementIDs.allKeys subMenuList:nil];
        _menuView.layer.masksToBounds = YES;
        _menuView.layer.cornerRadius = 5;
        __weak typeof (self) weakSelf = self;
        [_menuView setSelectMenu:^(NSString * _Nonnull selectMenu) {
            weakSelf.placementID = weakSelf.placementIDs[selectMenu];
            NSLog(@"select placementId:%@", weakSelf.placementID);
        }];
    }
    return _menuView;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.layer.masksToBounds = YES;
        _textView.layer.cornerRadius = 5;
        _textView.editable = NO;
        _textView.text = @"";
    }
    return _textView;
}


@end
