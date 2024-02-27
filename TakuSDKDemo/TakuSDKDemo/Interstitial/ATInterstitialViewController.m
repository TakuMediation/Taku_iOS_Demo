//
//  ATInterstitialViewController.m
//  TakuSDKDemo
//
//  Created by Martin Lau on 21/09/2018.
//  Copyright © 2018 Martin Lau. All rights reserved.
//

#import "ATInterstitialViewController.h"
#import <AnyThinkSDK/AnyThinkSDK.h>
#import <AnyThinkInterstitial/AnyThinkInterstitial.h>

#import "ATModelButton.h"
#import "ATADFootView.h"
#import "ATMenuView.h"


@interface ATInterstitialViewController ()<ATInterstitialDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) ATADFootView *footView;
@property (nonatomic, strong) ATMenuView *menuView;
@property (copy, nonatomic) NSDictionary<NSString *, NSString *> *placementIDs_inter;
@property (copy, nonatomic) NSDictionary<NSString *, NSString *> *placementIDs_fullScreen;
@property(nonatomic, strong) NSDictionary<NSString*, NSString*>* placementIDs;
@property (copy, nonatomic) NSString *placementID;

@property (nonatomic, strong) ATModelButton *fullScreenBtn;
@property (nonatomic, strong) ATModelButton *interstitialBtn;
@property(nonatomic,assign) BOOL isAuto;

@end

@implementation ATInterstitialViewController

-(instancetype)init {
    self =[super init];
    return  self;
}

- (NSDictionary<NSString *,NSString *> *)placementIDs_fullScreen {
    
    return  @{
        @"ADX":                   @"b62b419284c817",
        @"All":                   @"b62ea0f6f852d5",
        @"AdMob":                 @"b62b41f080cfc5",
        @"Mintegral":             @"b62ea0e75a82b1",
        @"Mintegral(Video)":      @"b62b41f097c8db",
        @"CSJ":                   @"b62b41f07070f3",
        @"CSJ(Video)":            @"b62b41f063412d",
        @"Facebook":              @"b62b41f0553690",
        @"Inmobi":                @"b62b41f030901b",
        @"Chartboost":            @"b62b41eff5b54d",
        @"Tapjoy":                @"b62b41efdde828",
        @"Ironsource":            @"b62b41efcdbc79",
        @"Vungle":                @"b62b41efbf3ef5",
        @"Adcolony":              @"b62b41efb0e9c1",
        @"Baidu":                 @"b62b41ef1e9eee",
        @"Unity Ads":             @"b62b41eed9ad16",
        @"Maio":                  @"b62b41eeac0263",
        @"Nend":                  @"b62b41c92cac3c",
        @"Nend(Video)":           @"b62ea0fb0be9d4",
        @"Nend(Full Screen)":     @"b62b41c91ab1f5",
        @"HeaderBidding":         @"b62b41c90295eb",
        @"Sigmob":                @"b62b41c7c855f2",
        @"Sigmob(RV)":            @"b62b41c8b3c4bc",
        @"Kuaishou":              @"b62b41c8970e49",
        @"Cross Promotion":       @"b62b41c87a5a53",
        @"Ogury":                 @"b62b41c84a8af2",
        @"Start.io":              @"b62b41c813565a",
        @"Start.io(Video)":       @"b62b41c80658a7",
        @"Fyber":                 @"b62b41c7e9cb9a",
        @"Helium":                @"b62b41929728f3",
        @"Kidoz":                 @"b62b4191fbc981",
        @"MyTarget":              @"b62b4191d5d73b",
        @"Pangle":                @"b62b4152262689",
        @"Klevin":                @"b62b4151fb009a",
        @"GDT":                   @"b62ea0e42354d1",
        @"Applovin":              @"b62b40f9335d25",
        @"Bigo":                   @"b63909d52edaa2",
    };
}

- (NSDictionary<NSString *,NSString *> *)placementIDs_inter {
    return @{
        @"All":                   @"b62ea0f6f852d5",
        @"AdMob":                 @"b62b41f080cfc5",
        @"Mintegral":             @"b62ea0e75a82b1",
        @"Mintegral-(Video)":     @"b62b41f097c8db",
        @"CSJ":                   @"b62b41f07070f3",
        @"CSJ-(Video)":           @"b62b41f063412d",
        @"Facebook":              @"b62b41f0553690",
        @"Inmobi":                @"b62b41f030901b",
        @"Chartboost":            @"b62b41eff5b54d",
        @"Tapjoy":                @"b62b41efdde828",
        @"Ironsource":            @"b62b41efcdbc79",
        @"Vungle":                @"b62b41efbf3ef5",
        @"Adcolony":              @"b62b41efb0e9c1",
        @"Baidu":                 @"b62b41ef1e9eee",
        @"Unity Ads":             @"b62b41eed9ad16",
        @"Maio":                  @"b62b41eeac0263",
        @"Nend":                  @"b62b41c92cac3c",
        @"Nend-(Video)":          @"b62ea0fb0be9d4",
        @"Nend-(Full Screen)":    @"b62b41c91ab1f5",
        @"HeaderBidding":         @"b62b41c90295eb",
        @"Sigmob":                @"b62b41c7c855f2",
        @"Sigmob-(RV)":           @"b62b41c8b3c4bc",
        @"Kuaishou":              @"b62b41c8970e49",
        @"Cross Promotion":       @"b62b41c87a5a53",
        @"Ogury":                 @"b62b41c84a8af2",
        @"StartApp":              @"b62b41c813565a",
        @"StartApp-(Video)":      @"b62b41c80658a7",
        @"Fyber":                 @"b62b41c7e9cb9a",
        @"Helium":                @"b62b41929728f3",
        @"Kidoz":                 @"b62b4191fbc981",
        @"MyTarget":              @"b62b4191d5d73b",
        @"Pangle":                @"b62b4152262689",
        @"Klevin":                @"b62b4151fb009a",
        @"GDT":                   @"b62ea0e42354d1",
        @"Applovin":              @"b62b40f9335d25",
        @"Bigo":                   @"b63909d52edaa2",
    };
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Intersitial";
    self.view.backgroundColor =  kRGB(245, 245, 245);
  
    [self setupUI];
    
    [ATInterstitialAutoAdManager sharedInstance].delegate = self;
}

- (void)setupUI {
    UIButton *clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
    [clearBtn setTitle:@"clear log" forState:UIControlStateNormal];
    [clearBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(clearLog) forControlEvents:UIControlEventTouchUpInside];
   
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:clearBtn];
    self.navigationItem.rightBarButtonItem = btnItem;
    
    
    [self.view addSubview:self.fullScreenBtn];
    [self.view addSubview:self.interstitialBtn];
    [self.view addSubview:self.menuView];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.footView];
  
    [self.fullScreenBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((kScreenW - kScaleW(26) * 3) / 2);
        make.height.mas_equalTo(kScaleW(360));
        make.top.equalTo(self.view.mas_top).offset(kNavigationBarHeight + kScaleW(20));
        make.left.equalTo(self.view.mas_left).offset(kScaleW(26));
    }];

    [self.interstitialBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(kScaleW(-26));
        make.width.mas_equalTo((kScreenW - kScaleW(26) * 3) / 2);
        make.height.mas_equalTo(kScaleW(360));
        make.top.equalTo(self.view.mas_top).offset(kNavigationBarHeight + kScaleW(20));
    }];

    [self.menuView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenW - kScaleW(52));
        make.height.mas_equalTo(kScaleW(242));
        make.top.equalTo(self.fullScreenBtn.mas_bottom).offset(kScaleW(20));
        make.centerX.equalTo(self.view.mas_centerX);
    }];

    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.menuView.mas_bottom).offset(kScaleW(20));
        make.bottom.equalTo(self.footView.mas_top).offset(kScaleW(-20));
        make.width.mas_equalTo(kScreenW - kScaleW(52));
        make.centerX.equalTo(self.view.mas_centerX);
    }];

    [self.footView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(kScaleW(340));
    }];
    
    [self changeModel:self.fullScreenBtn];
}

#pragma mark - Action
- (void)changeModel:(UIButton *)sender {
    if ((self.fullScreenBtn.isSelected && sender == self.fullScreenBtn) || (self.interstitialBtn.isSelected && sender == self.interstitialBtn)) {
        return;
    }
    
    self.fullScreenBtn.selected = sender == self.fullScreenBtn;
    self.interstitialBtn.selected = sender == self.interstitialBtn;
    
    if (![NSStringFromClass([self class]) containsString:@"Auto"]) {
        if (sender == self.fullScreenBtn) {
            
            [_footView.loadBtn setTitle:@"Load FullScreen AD" forState:UIControlStateNormal];
            [_footView.readyBtn setTitle:@"Is FullScreen AD Ready" forState:UIControlStateNormal];
            [_footView.showBtn setTitle:@"Show FullScreen AD" forState:UIControlStateNormal];
            
        }else{
            [_footView.loadBtn setTitle:@"Load Interstitial AD" forState:UIControlStateNormal];
            [_footView.readyBtn setTitle:@"Is Interstitial AD Ready" forState:UIControlStateNormal];
            [_footView.showBtn setTitle:@"Show Interstitial AD" forState:UIControlStateNormal];
        }
    }
    
    [self.fullScreenBtn setButtonIsSelectBoard];
    [self.interstitialBtn setButtonIsSelectBoard];
    self.placementIDs = sender.tag == 0 ? self.placementIDs_fullScreen : self.placementIDs_inter;
    
    [self resetPlacementID];
}

- (void)resetPlacementID {
    [self.menuView resetMenuList:self.placementIDs.allKeys];
    self.placementID = self.placementIDs.allValues.firstObject;
}

// 加载广告
- (void)loadAd {
    CGSize size = CGSizeMake(CGRectGetWidth(self.view.bounds) - 30.0f, 300.0f);
    NSDictionary *extraDic = @{
        // 设置半屏插屏广告大小，支持平台：快手，可能会影响展示效果
        kATInterstitialExtraAdSizeKey:[NSValue valueWithCGSize:size],
    };

    if (_isAuto) {
        [[ATInterstitialAutoAdManager sharedInstance] showAutoLoadInterstitialWithPlacementID:self.placementID scene:KTaKuInterstitialSceneID inViewController:self delegate:self];
    } else {
        [[ATAdManager sharedManager] loadADWithPlacementID:self.placementID extra:extraDic delegate:self];
    }
}

// 检查广告缓存，是否iReady
- (void)checkAd {
    // 获取广告位的状态对象
    ATCheckLoadModel *checkLoadModel = [[ATAdManager sharedManager] checkInterstitialLoadStatusForPlacementID:self.placementID];
    NSLog(@"CheckLoadModel.isLoading:%d--- isReady:%d",checkLoadModel.isLoading,checkLoadModel.isReady);

    // 查询该广告位的所有缓存信息
    NSArray *array = [[ATAdManager sharedManager] getInterstitialValidAdsForPlacementID:self.placementID];
    NSLog(@"ValidAds.count:%ld--- ValidAds:%@",array.count,array);
    
    // 判断当前是否存在可展示的广告
    BOOL isReady = [[ATAdManager sharedManager] interstitialReadyForPlacementID:self.placementID];
    
    if (_isAuto) {
        isReady = [[ATInterstitialAutoAdManager sharedInstance] autoLoadInterstitialReadyForPlacementID:self.placementID];
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:isReady ? @"Ready!" : @"Not Yet!" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}

// 统计到达场景
- (void)entryAdScenario {
    /* 为了统计场景到达率，相关信息可查阅 iOS高级设置说明 -> 广告场景 在满足广告触发条件时调用“进入广告场景”方法
    比如： ** 广告场景是在清理结束后弹出广告，则在清理结束时调用；
    * 1、先调用 entryxxx
    * 2、在判断 Ready的状态是否可展示
    * 3、最后调用 show 展示 */
    if (self.isAuto) { //Auto loading mode
        [[ATInterstitialAutoAdManager sharedInstance] entryAdScenarioWithPlacementID:self.placementID scenarioID:KTaKuInterstitialSceneID];
    }else { //Manual loading mode
        [[ATAdManager sharedManager] entryInterstitialScenarioWithPlacementID:self.placementID scene:KTaKuInterstitialSceneID];
    }
}

// 展示广告
- (void)showInterstitialAd {
    // 到达场景
    [self entryAdScenario];
    if (self.isAuto) { //Auto loading mode
       if ([[ATInterstitialAutoAdManager sharedInstance] autoLoadInterstitialReadyForPlacementID:self.placementID]) {
           [ [ATInterstitialAutoAdManager sharedInstance] showAutoLoadInterstitialWithPlacementID:self.placementID scene:KTaKuInterstitialSceneID inViewController:self delegate:self];
       }
    } else { //Manual loading mode
       if ([[ATAdManager sharedManager] interstitialReadyForPlacementID:self.placementID]) {
           [[ATAdManager sharedManager] showInterstitialWithPlacementID:self.placementID scene:KTaKuInterstitialSceneID inViewController:self delegate:self];
       } else {
           // reload AD
//           [self loadAd];
       }
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

- (void)clearLog {
    self.textView.text = @"";
}

#pragma mark - ATInterstitialDelegate
- (void)didStartLoadingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary*)extra{
    NSLog(@"广告源--AD--开始--ATInterstitialViewController::didStartLoadingADSourceWithPlacementID:%@---extra:%@", placementID,extra);
}

- (void)didFinishLoadingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary*)extra{
    NSLog(@"广告源--AD--完成--ATInterstitialViewController::didFinishLoadingADSourceWithPlacementID:%@---extra:%@", placementID,extra);
}

- (void)didFailToLoadADSourceWithPlacementID:(NSString*)placementID extra:(NSDictionary*)extra error:(NSError*)error{
    NSLog(@"广告源--AD--失败--ATInterstitialViewController::didFailToLoadADSourceWithPlacementID:%@---error:%@", placementID,error);
}

// bidding
- (void)didStartBiddingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary*)extra{
    NSLog(@"广告源--bid--开始--ATInterstitialViewController::didStartBiddingADSourceWithPlacementID:%@---extra:%@", placementID,extra);
}

- (void)didFinishBiddingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary*)extra{
    NSLog(@"广告源--bid--完成--ATInterstitialViewController::didFinishBiddingADSourceWithPlacementID:%@--extra:%@", placementID,extra);
}

- (void)didFailBiddingADSourceWithPlacementID:(NSString*)placementID extra:(NSDictionary*)extra error:(NSError*)error{
    NSLog(@"广告源--bid--失败--ATInterstitialViewController::didFailBiddingADSourceWithPlacementID:%@--error:%@", placementID,error);
}

-(void) didFinishLoadingADWithPlacementID:(NSString *)placementID {
    NSLog(@"ATInterstitialViewController::didFinishLoadingADWithPlacementID:%@", placementID);
    [self showLog:[NSString stringWithFormat:@"didFinishLoadingADWithPlacementID:%@", placementID]];
}

-(void) didFailToLoadADWithPlacementID:(NSString*)placementID error:(NSError*)error {
    NSLog(@"ATInterstitialViewController::didFailToLoadADWithPlacementID:%@ error:%@", placementID, error);
    [self showLog:[NSString stringWithFormat:@"didFailToLoadADWithPlacementID:%@ errorCode:%ld", placementID, error.code]];
}

-(void) interstitialDidShowForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATInterstitialViewController::interstitialDidShowForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"interstitialDidShowForPlacementID:%@", placementID]];
}

-(void) interstitialFailedToShowForPlacementID:(NSString*)placementID error:(NSError*)error extra:(NSDictionary *)extra {
    NSLog(@"ATInterstitialViewController::interstitialFailedToShowForPlacementID:%@ error:%@ extra:%@", placementID, error, extra);
    [self showLog:[NSString stringWithFormat:@"interstitialFailedToShowForPlacementID:%@ error:%@", placementID, error]];
}

-(void) interstitialDidFailToPlayVideoForPlacementID:(NSString*)placementID error:(NSError*)error extra:(NSDictionary*)extra {
    NSLog(@"ATInterstitialViewController::interstitialDidFailToPlayVideoForPlacementID:%@ error:%@ extra:%@", placementID, error, extra);
    [self showLog:[NSString stringWithFormat:@"interstitialDidFailToPlayVideoForPlacementID:%@ errorCode:%ld", placementID, error.code]];
}

-(void) interstitialDidStartPlayingVideoForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATInterstitialViewController::interstitialDidStartPlayingVideoForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"ATInterstitialViewController::interstitialDidStartPlayingVideoForPlacementID:%@", placementID]];
}

-(void) interstitialDidEndPlayingVideoForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATInterstitialViewController::interstitialDidEndPlayingVideoForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"interstitialDidEndPlayingVideoForPlacementID:%@", placementID]];
}

-(void) interstitialDidCloseForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATInterstitialViewController::interstitialDidCloseForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"interstitialDidCloseForPlacementID:%@", placementID]];
}

-(void) interstitialDidClickForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATInterstitialViewController::interstitialDidClickForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"interstitialDidClickForPlacementID:%@", placementID]];
}

- (void)interstitialDeepLinkOrJumpForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra result:(BOOL)success {
    NSLog(@"ATInterstitialViewController:: interstitialDeepLinkOrJumpForPlacementID:placementID:%@ with extra: %@, success:%@", placementID,extra, success ? @"YES" : @"NO");
    [self showLog:[NSString stringWithFormat:@"interstitialDeepLinkOrJumpForPlacementID:placementID:%@, success:%@", placementID, success ? @"YES" : @"NO"]];
}

#pragma mark - lazy
- (ATADFootView *)footView {
    if (!_footView) {
        _footView = [[ATADFootView alloc] init];
    
        if (![NSStringFromClass([self class]) containsString:@"Auto"]) {
            [_footView.loadBtn setTitle:@"Load FullScreen AD" forState:UIControlStateNormal];
            [_footView.readyBtn setTitle:@"Is FullScreen AD Ready" forState:UIControlStateNormal];
            [_footView.showBtn setTitle:@"Show FullScreen AD" forState:UIControlStateNormal];
        }
        
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
            [weakSelf showInterstitialAd];
        }];
    }
    return _footView;
}

- (ATModelButton *)fullScreenBtn {
    if (!_fullScreenBtn) {
        _fullScreenBtn = [[ATModelButton alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScaleW(532))];
        _fullScreenBtn.tag = 0;
        _fullScreenBtn.backgroundColor = [UIColor whiteColor];
        _fullScreenBtn.layer.borderWidth = kScaleW(5);
        _fullScreenBtn.modelLabel.text = @"FullScreen";
        _fullScreenBtn.image.image = [UIImage imageNamed:@"Interstitial-fullscreen"];
        [_fullScreenBtn addTarget:self action:@selector(changeModel:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullScreenBtn;
}

- (ATModelButton *)interstitialBtn {
    if (!_interstitialBtn) {
        _interstitialBtn = [[ATModelButton alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScaleW(532))];
        _interstitialBtn.tag = 1;
        _interstitialBtn.backgroundColor = [UIColor whiteColor];
        _interstitialBtn.layer.borderWidth = kScaleW(5);
        _interstitialBtn.modelLabel.text = @"Interstitial";
        _interstitialBtn.image.image = [UIImage imageNamed:@"Interstitial"];
        [_interstitialBtn addTarget:self action:@selector(changeModel:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _interstitialBtn;
}

- (ATMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[ATMenuView alloc] initWithMenuList:self.placementIDs.allKeys subMenuList:nil];
        _menuView.turnAuto = true;
        _menuView.layer.masksToBounds = YES;
        _menuView.layer.cornerRadius = 5;
        __weak typeof (self) weakSelf = self;
        [_menuView setSelectMenu:^(NSString * _Nonnull selectMenu) {
            weakSelf.placementID = weakSelf.placementIDs[selectMenu];
            NSLog(@"select placementId:%@", weakSelf.placementID);
            
            if (weakSelf.isAuto) {
                [[ATInterstitialAutoAdManager sharedInstance]addAutoLoadAdPlacementIDArray:@[weakSelf.placementID]];
            }
        }];
        
        [_menuView setTurnOnAuto:^(Boolean isOn) {
            [weakSelf turnOnAuto:isOn];
        }];
    }
    return _menuView;
}

- (void)turnOnAuto:(Boolean)isOn {
    self.footView.loadBtn.hidden = isOn;
    if (isOn) {
        [[ATInterstitialAutoAdManager sharedInstance]addAutoLoadAdPlacementIDArray:@[self.placementID]];
    }
    else{
        [[ATInterstitialAutoAdManager sharedInstance]removeAutoLoadAdPlacementIDArray:@[self.placementID]];
    }
    self.isAuto = isOn;
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
