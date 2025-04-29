//
//  BannerVC.m
//  iOSDemo
//
//  Created by ltz on 2025/1/11.
//

#import "BannerVC.h"
#import <AnyThinkBanner/AnyThinkBanner.h>
#import "AdLoadConfigTool.h"

@interface BannerVC () <ATBannerDelegate>

@property (nonatomic, strong) ATBannerView *bannerView;

@end

@implementation BannerVC

//广告位ID
#define BannerPlacementID @"b680a1e7874fce"

//场景ID，可选，可在后台生成。没有可传入空字符串
#define BannerSceneID @""

//请注意，banner size需要和后台配置的比例一致
#define BannerSize CGSizeMake(320, 50)

#pragma mark - Load Ad 加载广告
/// 加载广告按钮被点击
- (void)loadAdButtonClickAction {
 
    [self showLog:kLocalizeStr(@"点击了加载广告")];
      
    NSMutableDictionary * loadConfigDict = [NSMutableDictionary dictionary];
    
    /*
     注意不同平台的横幅广告有一定限制，例如配置的穿山甲横幅广告640*100，为了能填充完屏幕宽，计算高度H = (屏幕宽 *100)/640；那么在load的extra的size为（屏幕宽：H）。
     
     Note that banner ads on different platforms have certain restrictions. For example, the configured CSJ(TT) banner AD is 640*100. In order to fill the screen width, the height H = (screen width *100)/640 is calculated. Then the extra size of the load is (screen width: H).
     */
    [loadConfigDict setValue:[NSValue valueWithCGSize:BannerSize] forKey:kATAdLoadingExtraBannerAdSizeKey];
    
    [loadConfigDict setValue:@NO forKey:kATAdLoadingExtraBannerSizeAdjustKey];
    [loadConfigDict setValue:@"media_val_BannerVC" forKey:kATAdLoadingExtraMediaExtraKey];
     
    //可选接入，如果使用了Admob广告平台，可添加以下配置
//    [AdLoadConfigTool banner_loadExtraConfigAppendAdmob:loadConfigDict];
    
    //当SDK版本小于v6.4.42+ 如果viewController需要传入其他控制器对象，您需要对其进行引用，SDK内部不会引用
    [[ATAdManager sharedManager] loadADWithPlacementID:BannerPlacementID extra:loadConfigDict viewController:self delegate:self];
}
 
#pragma mark - Show Ad 展示广告
/// 展示广告按钮被点击
- (void)showAdButtonClickAction {
    
    //场景统计功能，可选接入
    [[ATAdManager sharedManager] entryBannerScenarioWithPlacementID:BannerPlacementID scene:BannerSceneID];
    
    //查询可用于展示的广告缓存(可选接入)
    //[AdCheckTool getValidAdsForPlacementID:BannerPlacementID adType:AdTypeBanner];
    
    //查询广告加载状态(可选接入)
    //[AdCheckTool adLoadingStatusWithPlacementID:BannerPlacementID adType:AdTypeBanner];
    
    //检查是否有就绪,showViewController参数需要与loadADWithPlacementID中的viewController对象一样
    if (![[ATAdManager sharedManager] bannerAdReadyForPlacementID:BannerPlacementID showViewController:self]) {
        [self notReadyAlert];
        return;
    }
    
    //展示配置，Scene传入后台的场景ID，没有可传入空字符串，showCustomExt参数可传入自定义参数字符串
    ATShowConfig *config = [[ATShowConfig alloc] initWithScene:BannerSceneID showCustomExt:@"testShowCustomExt"];
    //showViewController参数需要与loadADWithPlacementID、bannerAdReadyForPlacementID中的viewController、showViewController对象一样
    config.showViewController = self;
    
    //移除之前可能存在的banner
    [self removeAd];
    
    //展示广告
    ATBannerView *bannerView = [[ATAdManager sharedManager] retrieveBannerViewForPlacementID:BannerPlacementID config:config];
    if (bannerView != nil) {
        //赋值
        bannerView.delegate = self;
        bannerView.presentingViewController = self;
        bannerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:bannerView];
        self.bannerView = bannerView;
        
        [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view);
            make.height.equalTo(@(BannerSize.height));
            make.width.equalTo(@(BannerSize.width));
            make.top.equalTo(self.textView.mas_bottom).offset(5);
        }];
    }
}
 
#pragma mark - 移除广告
/// 通过demo移除按钮点击来移除banner广告
- (void)removeAdButtonClickAction {
    [self removeAd];
}

#pragma mark - 隐藏广告
- (void)hiddenAdButtonClickAction {
    self.bannerView.hidden = YES;
}

#pragma mark - 隐藏后重新显示广告
- (void)reshowAdButtonClickAction {
    self.bannerView.hidden = NO;
}

#pragma mark - 移除广告
- (void)removeAd {
    //移除视图以及引用
    self.bannerView.delegate = nil;
    [self.bannerView removeFromSuperview];
    self.bannerView = nil;
}
 
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    //彻底退出控制且不再返回时，释放Banner资源
    [self removeAd];
}

#pragma mark - 广告位代理回调
/// 广告位加载完成
/// - Parameter placementID: 广告位ID
- (void)didFinishLoadingADWithPlacementID:(NSString *)placementID {
    BOOL isReady = [[ATAdManager sharedManager] bannerAdReadyForPlacementID:placementID];
    [self showLog:[NSString stringWithFormat:@"didFinishLoadingADWithPlacementID:%@ Banner 是否准备好:%@", placementID,isReady ? @"YES":@"NO"]];
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

#pragma mark - 开屏广告事件代理回调

/// 关闭按钮点击(当用户点击横幅上关闭按钮的情形)
/// - Parameters:
///   - bannerView: 横幅广告视图对象
///   - placementID: 广告位ID
///   - extra: 额外信息字典
- (void)bannerView:(ATBannerView *)bannerView didTapCloseButtonWithPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"didTapCloseButtonWithPlacementID:%@ extra: %@", placementID,extra);
    [self showLog:[NSString stringWithFormat:@"bannerView:didTapCloseButtonWithPlacementID:%@", placementID]];

    // 收到点击关闭按钮回调,移除bannerView
    [self removeAd];
}

/// 横幅广告已展示
/// - Parameters:
///   - bannerView: 横幅广告视图对象
///   - placementID: 广告位ID
///   - extra: 额外信息字典
- (void)bannerView:(ATBannerView *)bannerView didShowAdWithPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"didShowAdWithPlacementID:%@ with extra: %@", placementID,extra);
    [self showLog:[NSString stringWithFormat:@"bannerView:didShowAdWithPlacementID:%@", placementID]];
     
}

/// 横幅广告被点击
/// - Parameters:
///   - bannerView: 横幅广告视图对象
///   - placementID: 广告位ID
///   - extra: 额外信息字典
- (void)bannerView:(ATBannerView *)bannerView didClickWithPlacementID:(NSString *)placementID extra:(NSDictionary *)extra{
    ATDemoLog(@"didClickWithPlacementID:%@ with extra: %@", placementID,extra);
    [self showLog:[NSString stringWithFormat:@"bannerView:didClickWithPlacementID:%@", placementID]];
}

/// 横幅广告已自动刷新
/// - Parameters:
///   - bannerView: 横幅广告视图对象
///   - placementID: 广告位ID
///   - extra: 额外信息字典
- (void)bannerView:(ATBannerView *)bannerView didAutoRefreshWithPlacement:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"didAutoRefreshWithPlacement:%@ with extra: %@", placementID,extra);
    [self showLog:[NSString stringWithFormat:@"bannerView:didAutoRefreshWithPlacement:%@", placementID]];
}

/// 横幅广告自动刷新失败
/// - Parameters:
///   - bannerView: 横幅广告视图对象
///   - placementID: 广告位ID
///   - error: 错误信息
- (void)bannerView:(ATBannerView *)bannerView failedToAutoRefreshWithPlacementID:(NSString *)placementID error:(NSError *)error {
    ATDemoLog(@"failedToAutoRefreshWithPlacementID:%@ error:%@", placementID, error);
    [self showLog:[NSString stringWithFormat:@"bannerView:failedToAutoRefreshWithPlacementID:%@ errorCode:%ld", placementID, error.code]];
}
 
/// 横幅广告已打开或跳转深链接页面
/// - Parameters:
///   - bannerView: 横幅广告视图对象
///   - placementID:  广告位ID
///   - extra: 额外信息
///   - success: 是否成功
- (void)bannerView:(ATBannerView *)bannerView didDeepLinkOrJumpForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra result:(BOOL)success {
    ATDemoLog(@"didDeepLinkOrJumpForPlacementID:placementID:%@ with extra: %@, success:%@", placementID,extra, success ? @"YES" : @"NO");
    [self showLog:[NSString stringWithFormat:@"didDeepLinkOrJumpForPlacementID:%@, success:%@", placementID, success ? @"YES" : @"NO"]];
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

- (void)dealloc {
    NSLog(@"BannerVC dealloc");
}

@end
