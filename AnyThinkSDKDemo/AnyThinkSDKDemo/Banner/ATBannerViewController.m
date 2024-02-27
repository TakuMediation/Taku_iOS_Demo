//
//  ATBannerViewController.m
//  AnyThinkSDKDemo
//
//  Created by Martin Lau on 19/09/2018.
//  Copyright © 2018 Martin Lau. All rights reserved.
//

#import "ATBannerViewController.h"
#import <AnyThinkBanner/AnyThinkBanner.h>

#import "ATADFootView.h"
#import "ATModelButton.h"
#import "ATMenuView.h"

//#import <GoogleMobileAds/GoogleMobileAds.h>


@interface ATBannerViewController ()<ATBannerDelegate>

@property (nonatomic, strong) ATADFootView *footView;

@property (nonatomic, strong) UIView *modelBackView;

@property (nonatomic, strong) ATModelButton *modelButton;

@property (nonatomic, strong) ATMenuView *menuView;

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UIView *adView;

@property (copy, nonatomic) NSDictionary<NSString *, NSString *> *placementIDs;

@property (copy, nonatomic) NSString *placementID;

@property(nonatomic, readonly) CGSize adSize;

@property (nonatomic, strong) ATBannerView *bannerView;

@end

@implementation ATBannerViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kRGB(245, 245, 245);
  
    self.title = @"Banner";
  
    [self setupData];
    [self setupUI];
}

- (NSDictionary<NSString *,NSString *> *)placementIDs {
    return @{
        @"ADX":               @"b62b4192930123",
        @"All":               @"b62b420af2495a",
        @"Applovin":          @"b62b420ae88f2d",
        @"AdMob":             @"b62b420ae05bb4",
        @"CSJ":               @"b62b420ad701a7",
        @"Facebook":          @"b62b41f04bf88e",
        @"Inmobi":            @"b62b41f0477eeb",
        @"Baidu":             @"b62b41ef2d8032",
        @"Unity Ads":         @"b62b41eeed7c11",
        @"Nend":              @"b62b41c939ccd6",
        @"HeaderBidding":     @"b62b41c8e4b841",
        @"Mintegral":         @"b62b41c866b80b",
        @"Fyber":             @"b62b41c7e08ddc",
        @"Start.io":          @"b62b41c7d0076f",
        @"Chartboost":        @"b62b41c79c29a0",
        @"Vungle":            @"b62b41c799f611",
        @"Adcolony":          @"b62b41c7913cee",
        @"Cross Promotion":   @"b62b4192bc2351",
        @"Kidoz":             @"b62b41920adccf",
        @"Pangle":            @"b62b41522d24a3",
        @"MyTarget":          @"b62b4191d37ee7",
        @"GDT":               @"b62ea19b2d10b7",
        @"Yandex":            @"b62ea19cb6e482",
        @"Bigo":                @"b63909d6ca2269",
    };
}

- (void)setupData {
    self.placementID = self.placementIDs.allValues.firstObject;
}

- (void)setupUI {
    UIButton *clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
    [clearBtn setTitle:@"clear log" forState:UIControlStateNormal];
    [clearBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(clearLog) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:clearBtn];
    self.navigationItem.rightBarButtonItem = btnItem;
    
    [self.view addSubview:self.modelBackView];
    [self.view addSubview:self.modelButton];
    [self.view addSubview:self.menuView];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.footView];
    
    _adSize = CGSizeMake(CGRectGetWidth(self.view.bounds), 250.0f);
    
    [self.modelBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(kScreenW - kScaleW(52));
        make.height.mas_equalTo(kScaleW(360));
        make.top.equalTo(self.view.mas_top).offset(kNavigationBarHeight + kScaleW(20));
    }];
    
    [self.modelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(kScaleW(340));
        make.height.mas_equalTo(kScaleW(360));
        make.top.equalTo(self.modelBackView.mas_top);
    }];

    [self.menuView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenW - kScaleW(52));
        make.height.mas_equalTo(kScaleW(242));
        make.top.equalTo(self.modelBackView.mas_bottom).offset(kScaleW(20));
        make.centerX.equalTo(self.view.mas_centerX);
    }];

    [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.menuView.mas_bottom).offset(kScaleW(20));
        make.bottom.equalTo(self.footView.mas_top).offset(kScaleW(-20));
        make.width.mas_equalTo(kScreenW - kScaleW(52));
        make.centerX.equalTo(self.view.mas_centerX);
    }];

    [self.footView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(kScaleW(340));
    }];
}

- (void)clearLog {
    self.textView.text = @"";
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self removeAdButtonTapped];
}

- (void)removeAdButtonTapped {
    [[self.view viewWithTag:3333] removeFromSuperview];
    NSLog(@"banner removed");
}

- (void)dealloc {
    NSLog(@"ATBannerViewController::dealloc");
}

#pragma mark - Action
// 加载广告
- (void)loadBannerAdView {
    /* Admob自适应横幅设置，需要先引入头文件：#import <GoogleMobileAds/GoogleMobileAds.h>
    //GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth 自适应
    //GADPortraitAnchoredAdaptiveBannerAdSizeWithWidth 竖屏
    //GADLandscapeAnchoredAdaptiveBannerAdSizeWithWidth 横屏
    GADAdSize admobSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(CGRectGetWidth(self.view.bounds));
    */
    
    /*
     注意不同平台的横幅广告有一定限制，例如配置的穿山甲横幅广告640*100，为了能填充完屏幕宽，计算高度H = (屏幕宽 *100)/640；那么在load的extra的size为（屏幕宽：H）。
     
     Note that banner ads on different platforms have certain restrictions. For example, the configured CSJ(TT) banner AD is 640*100. In order to fill the screen width, the height H = (screen width *100)/640 is calculated. Then the extra size of the load is (screen width: H).
     */

    NSDictionary *dict = @{
        // 设置请求的广告尺寸大小
        kATAdLoadingExtraBannerAdSizeKey:[NSValue valueWithCGSize:_adSize],
        // 仅Nend平台支持
//        kATAdLoadingExtraBannerSizeAdjustKey:@NO,
//        // 仅Admob平台支持，自适应横幅大小
//        kATAdLoadingExtraAdmobBannerSizeKey:[NSValue valueWithCGSize:admobSize.size],
//        kATAdLoadingExtraAdmobAdSizeFlagsKey:@(admobSize.flags)
    };
    [[ATAdManager sharedManager] loadADWithPlacementID:self.placementID extra:dict delegate:self];
}

// 检查广告缓存，是否iReady
- (void)checkAd {
    // 获取广告位的状态对象
    ATCheckLoadModel *checkLoadModel = [[ATAdManager sharedManager] checkBannerLoadStatusForPlacementID:self.placementID];
    NSLog(@"CheckLoadModel.isLoading:%d--- isReady:%d",checkLoadModel.isLoading,checkLoadModel.isReady);

    // 查询该广告位的所有缓存信息
    NSArray *array = [[ATAdManager sharedManager] getBannerValidAdsForPlacementID:self.placementID];
    NSLog(@"ValidAds.count:%ld--- ValidAds:%@",array.count,array);

    // 判断当前是否存在可展示的广告
    BOOL isReady = [[ATAdManager sharedManager] bannerAdReadyForPlacementID:self.placementID];
    
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
    [[ATAdManager sharedManager] entryBannerScenarioWithPlacementID:self.placementID scene:KTaKuBannerSceneID];
}

- (void)showBanner {
    // 到达场景
    [self entryAdScenario];
    
    // 判断广告ready状态
    if ([[ATAdManager sharedManager] bannerAdReadyForPlacementID:self.placementID]) {
        // 移除可能存在的旧BannerView
        NSInteger tag = 3333;
        [[self.view viewWithTag:tag] removeFromSuperview];
        
        ATBannerView *bannerView = [[ATAdManager sharedManager] retrieveBannerViewForPlacementID:self.placementID scene:KTaKuBannerSceneID];
        if (bannerView != nil) {
            bannerView.delegate = self;
            bannerView.presentingViewController = self;
            bannerView.translatesAutoresizingMaskIntoConstraints = NO;
            bannerView.tag = tag;
            self.bannerView = bannerView;
           
            self.adView = [[UIView alloc]init];
            self.adView.backgroundColor =  randomColor;
            [self.adView addSubview:bannerView];
            
            [self.view insertSubview:self.adView belowSubview:self.footView];
           
            [self.adView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(_adSize.height));
                make.width.equalTo(@(_adSize.width));
                make.top.equalTo(self.view).offset(100);
            }];
            
            [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.adView);
            }];
        } else {
            NSLog(@"BannerView is nil for placementID:%@", self.placementID);
        }
    } else {
        NSLog(@"Banner ad's not ready for placementID:%@", self.placementID);
    }
}

// 移除广告BannerView
- (void)removeAd {
    if (self.adView && self.adView.superview) {
        [self.adView removeFromSuperview];
        self.bannerView = nil;
        self.adView = nil;
    }
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

#pragma mark - delegate method(s)
- (void)didStartLoadingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary*)extra {
    NSLog(@"广告源--AD--开始--ATBannerViewController::didStartLoadingADSourceWithPlacementID:%@---extra:%@", placementID,extra);
}

- (void)didFinishLoadingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary*)extra {
    NSLog(@"广告源--AD--完成--ATBannerViewController::didFinishLoadingADSourceWithPlacementID:%@---extra:%@", placementID,extra);
}

- (void)didFailToLoadADSourceWithPlacementID:(NSString*)placementID extra:(NSDictionary*)extra error:(NSError*)error {
    NSLog(@"广告源--AD--失败--ATBannerViewController::didFailToLoadADSourceWithPlacementID:%@---error:%@", placementID,error);
}

// bidding
- (void)didStartBiddingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary*)extra {
    NSLog(@"广告源--bid--开始--ATBannerViewController::didStartBiddingADSourceWithPlacementID:%@---extra:%@", placementID,extra);
}

- (void)didFinishBiddingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary*)extra {
    NSLog(@"广告源--bid--完成--ATBannerViewController::didFinishBiddingADSourceWithPlacementID:%@--extra:%@", placementID,extra);
}

- (void)didFailBiddingADSourceWithPlacementID:(NSString*)placementID extra:(NSDictionary*)extra error:(NSError*)error {
    NSLog(@"广告源--bid--失败--ATBannerViewController::didFailBiddingADSourceWithPlacementID:%@--error:%@", placementID,error);
}

- (void) didFinishLoadingADWithPlacementID:(NSString *)placementID {
    NSLog(@"ATBannerViewController::didFinishLoadingADWithPlacementID:%@", placementID);
    [self showLog:[NSString stringWithFormat:@"didFinishLoadingADWithPlacementID:%@", placementID]];
}

-(void) didFailToLoadADWithPlacementID:(NSString*)placementID error:(NSError*)error {
    NSLog(@"ATBannerViewController::didFailToLoadADWithPlacementID:%@ error:%@", placementID, error);
    [self showLog:[NSString stringWithFormat:@"ATBannerViewController::didFailToLoadADWithPlacementID:%@ errorCode:%ld", placementID, error.code]];
}

#pragma mark - add networkID and adsourceID delegate
- (void)bannerView:(ATBannerView*)bannerView didShowAdWithPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATBannerViewController::bannerView:didShowAdWithPlacementID:%@ with extra: %@", placementID,extra);
    [self showLog:[NSString stringWithFormat:@"bannerView:didShowAdWithPlacementID:%@", placementID]];
}

- (void)bannerView:(ATBannerView*)bannerView didClickWithPlacementID:(NSString*)placementID extra:(NSDictionary *)extra{
    NSLog(@"ATBannerViewController::bannerView:didClickWithPlacementID:%@ with extra: %@", placementID,extra);
    [self showLog:[NSString stringWithFormat:@"bannerView:didClickWithPlacementID:%@", placementID]];
}

- (void)bannerView:(ATBannerView*)bannerView didAutoRefreshWithPlacement:(NSString*)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATBannerViewController::bannerView:didAutoRefreshWithPlacement:%@ with extra: %@", placementID,extra);
    [self showLog:[NSString stringWithFormat:@"bannerView:didAutoRefreshWithPlacement:%@", placementID]];
}

- (void) bannerView:(ATBannerView *)bannerView failedToAutoRefreshWithPlacementID:(NSString *)placementID error:(NSError *)error {
    NSLog(@"ATBannerViewController::bannerView:failedToAutoRefreshWithPlacementID:%@ error:%@", placementID, error);
    [self showLog:[NSString stringWithFormat:@"bannerView:failedToAutoRefreshWithPlacementID:%@ errorCode:%ld", placementID, error.code]];
}

- (void)bannerView:(ATBannerView*)bannerView didTapCloseButtonWithPlacementID:(NSString*)placementID extra:(NSDictionary*)extra {
    NSLog(@"ATBannerViewController::bannerView:didTapCloseButtonWithPlacementID:%@ extra: %@", placementID,extra);
    [self showLog:[NSString stringWithFormat:@"bannerView:didTapCloseButtonWithPlacementID:%@", placementID]];

    // 收到点击关闭按钮回调,需要自行移除bannerView
    [self removeAd];
}

- (void)bannerView:(ATBannerView *)bannerView didDeepLinkOrJumpForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra result:(BOOL)success {
    NSLog(@"ATBannerViewController:: didDeepLinkOrJumpForPlacementID:placementID:%@ with extra: %@, success:%@", placementID,extra, success ? @"YES" : @"NO");
    [self showLog:[NSString stringWithFormat:@"didDeepLinkOrJumpForPlacementID:%@, success:%@", placementID, success ? @"YES" : @"NO"]];
}

#pragma mark - lazy
- (ATADFootView *)footView {
    if (!_footView) {
        _footView = [[ATADFootView alloc] initWithRemoveBtn];
        __weak typeof(self) weakSelf = self;
        [_footView setClickLoadBlock:^{
            NSLog(@"点击加载");
            [weakSelf loadBannerAdView];
        }];
        [_footView setClickReadyBlock:^{
            NSLog(@"点击准备");
            [weakSelf checkAd];
        }];
        [_footView setClickShowBlock:^{
            NSLog(@"点击展示");
            [weakSelf showBanner];
        }];
        [_footView setClickRemoveBlock:^{
            NSLog(@"点击移除");
            [weakSelf removeAd];
        }];
        
        if (![NSStringFromClass([self class]) containsString:@"Auto"]) {
            [_footView.loadBtn setTitle:@"Load Banner AD" forState:UIControlStateNormal];
            [_footView.readyBtn setTitle:@"Is Banner AD Ready" forState:UIControlStateNormal];
            [_footView.showBtn setTitle:@"Show Banner AD" forState:UIControlStateNormal];
        }
        
    }
    return _footView;
}

- (UIView *)modelBackView {
    if (!_modelBackView) {
        _modelBackView = [[UIView alloc] init];
        _modelBackView.backgroundColor = [UIColor whiteColor];
        _modelBackView.layer.masksToBounds = YES;
        _modelBackView.layer.cornerRadius = 5;
    }
    return _modelBackView;
}

- (ATModelButton *)modelButton {
    if (!_modelButton) {
        _modelButton = [[ATModelButton alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScaleW(532))];
        _modelButton.backgroundColor = [UIColor whiteColor];
        _modelButton.modelLabel.text = @"Banner";
        _modelButton.image.image = [UIImage imageNamed:@"banner"];
    }
    return _modelButton;
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
