//
//  SplashVC.m
//  iOSDemo
//
//  Created by ltz on 2025/1/18.
//

#import "SplashVC.h"

#import <AnyThinkSplash/AnyThinkSplash.h>

#import "AdLoadConfigTool.h"

#import "AppDelegate.h"

#import "LaunchLoadingView.h"

@interface SplashVC () <ATSplashDelegate>

/// 加载页面，使用自己的加载图
@property (strong, nonatomic) LaunchLoadingView * launchLoadingView;

@end
 
@implementation SplashVC

//广告位ID
#define SplashPlacementID @"b67f4ab43d2fe1"

//场景ID，可选，可在后台生成。没有可传入空字符串
#define SplashSceneID @""
 
- (void)viewDidLoad {
    [super viewDidLoad];

    //添加加载页面，当广告显示完毕后需要在代理中移除
    self.launchLoadingView = [LaunchLoadingView new];
    [self.launchLoadingView show];
     
    //为了加快开屏广告效率，建议在进入当前页面之前发起开屏广告加载请求，例如初始化SDK之后，demo此处为了方便演示，在viewDidLoad进入时请求
    [self loadAd];
}

/// 进入首页
- (void)enterHomeVC {
    [self.launchLoadingView dismiss];
}

#pragma mark - Load Ad 加载广告
/// 加载广告
- (void)loadAd {
    
    NSMutableDictionary *loadConfigDict = [NSMutableDictionary dictionary];
    
    //开屏超时时间
    [loadConfigDict setValue:@(5) forKey:kATSplashExtraTolerateTimeoutKey];
    //自定义load参数
    [loadConfigDict setValue:@"media_val_SplashVC" forKey:kATAdLoadingExtraMediaExtraKey];
    
    //可选接入，如果使用了Pangle广告平台，可添加以下配置
    //[AdLoadConfigTool splash_loadExtraConfigAppend_Pangle:loadConfigDict];
    
    //若选择使用优量汇(GDT)，建议接入
    //[AdLoadConfigTool splash_loadExtraConfigAppend_Tencent:loadConfigDict];
    
    [[ATAdManager sharedManager] loadADWithPlacementID:SplashPlacementID
                                                 extra:loadConfigDict
                                              delegate:self
                                         containerView:[self footLogoView]];
}
 
/// 可选接入开屏底部LogoView
- (UIView *)footLogoView {
    
    //宽度为屏幕宽度,高度<=25%的屏幕高度(根据广告平台要求而定)
    UIView * footerCtrView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kOrientationScreenWidth, 120)];
    footerCtrView.backgroundColor = UIColor.whiteColor;
    
    //添加图片
    UIImageView * logoImageView = [UIImageView new];
    logoImageView.image = [UIImage imageNamed:@"logo"];
    logoImageView.contentMode = UIViewContentModeCenter;
    logoImageView.frame = footerCtrView.frame;
    [footerCtrView addSubview:logoImageView];
    
    //添加点击事件
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(footerImgClick:)];
    logoImageView.userInteractionEnabled = YES;
    [logoImageView addGestureRecognizer:tap];
     
    return footerCtrView;
}
 
/// footer点击事件
- (void)footerImgClick:(UITapGestureRecognizer *)tap {
    ATDemoLog(@"footer click !!");
}
 
#pragma mark - Show Ad 展示广告
- (void)showSplash {
    
    //场景统计功能，可选接入
    [[ATAdManager sharedManager] entrySplashScenarioWithPlacementID:SplashPlacementID scene:SplashSceneID];
    
//    //查询可用于展示的广告缓存(可选接入)
//    NSArray <NSDictionary *> * adCaches = [[ATAdManager sharedManager] getSplashValidAdsForPlacementID:SplashPlacementID];
//    ATDemoLog(@"getValidAds : %@",adCaches);
//     
//    //查询广告加载状态(可选接入)
//    ATCheckLoadModel * status = [[ATAdManager sharedManager] checkSplashLoadStatusForPlacementID:SplashPlacementID];
//    ATDemoLog(@"checkLoadStatus : %d",status.isLoading);
    
    //检查是否有就绪
    if (![[ATAdManager sharedManager] splashReadyForPlacementID:SplashPlacementID]) {
        [self loadAd];
        return;
    }
    
    //展示配置，Scene传入后台的场景ID，没有可传入空字符串，showCustomExt参数可传入自定义参数字符串
    ATShowConfig *config = [[ATShowConfig alloc] initWithScene:SplashSceneID showCustomExt:@"testShowCustomExt"];
    
    //开屏相关参数配置
    NSMutableDictionary *configDict = [NSMutableDictionary dictionary];
    
    //可选接入，自定义跳过按钮，多数平台已经不支持自定义跳过按钮，目前支持更改自定义跳过按钮有穿山甲(TT)，直投、ADX、原生作开屏和游可盈，具体需要运行看实际效果
//    [AdLoadConfigTool splash_loadExtraConfigAppend_CustomSkipButton:configDict];
    
    //展示广告,在App原window中展示
    [[ATAdManager sharedManager] showSplashWithPlacementID:SplashPlacementID config:config window:[UIApplication sharedApplication].keyWindow inViewController:self.tabBarController extra:configDict delegate:self];
}
  

/// 开屏广告加载完成
/// - Parameters:
///   - placementID: 广告位ID
///   - isTimeout: 是否超时
- (void)didFinishLoadingSplashADWithPlacementID:(NSString *)placementID isTimeout:(BOOL)isTimeout {
    ATDemoLog(@"开屏加载成功:%@----是否超时:%d",placementID,isTimeout);
    if (!isTimeout) {
        //没有超时，展示开屏广告
        [self showSplash];
    }else {
        //加载成功，但超时了
        [self enterHomeVC];
    }
}
 
/// 广告位加载失败
/// - Parameters:
///   - placementID: 广告位ID
///   - error: 错误信息
- (void)didFailToLoadADWithPlacementID:(NSString*)placementID error:(NSError*)error {
    ATDemoLog(@"didFailToLoadADWithPlacementID:%@ error:%@", placementID, error);
    [self showLog:[NSString stringWithFormat:@"didFailToLoadADWithPlacementID:%@ errorCode:%ld", placementID, error.code]];
    
    //所有广告源加载失败了，进入首页
    [self enterHomeVC];
}
 
/// 开屏广告加载超时
/// - Parameter placementID: 广告位ID
- (void)didTimeoutLoadingSplashADWithPlacementID:(NSString *)placementID {
    ATDemoLog(@"didTimeoutLoadingSplashADWithPlacementID:%@", placementID);
    //超时了，首页加载完成后进入首页
    [self showLog:[NSString stringWithFormat:@"开屏超时了"]];
    //进入首页
    [self enterHomeVC];
}

/// 获得展示收益
/// - Parameters:
///   - placementID: 广告位ID
///   - extra: 额外信息字典
- (void)didRevenueForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"didRevenueForPlacementID:%@ with extra: %@", placementID,extra);
    [self showLog:[NSString stringWithFormat:@"didRevenueForPlacementID:%@", placementID]];
}

/// Callback when the successful loading of the ad
/// 加载成功且加载流程完毕
- (void)didFinishLoadingADWithPlacementID:(NSString *)placementID {
    ATDemoLog(@"didFinishLoadingADWithPlacementID:%@", placementID);
    [self showLog:[NSString stringWithFormat:@"didFinishLoadingADWithPlacementID:%@", placementID]];
}

/// 开屏广告已展示
/// - Parameters:
///   - placementID: 广告位ID
///   - extra: 额外信息
- (void)splashDidShowForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"splashDidShowForPlacementID:%@",placementID);
    [self showLog:[NSString stringWithFormat:@"splashDidShowForPlacementID:%@ ",placementID]];
    
    //展示广告后可以隐藏，避免遮挡
    [self.launchLoadingView dismiss];
}

/// 开屏广告已关闭
/// - Parameters:
///   - placementID: 广告位ID
///   - extra: 额外信息
- (void)splashDidCloseForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"splashDidCloseForPlacementID:%@ extra:%@",placementID,extra);
    [self showLog:[NSString stringWithFormat:@"splashDidCloseForPlacementID:%@ ",placementID]];
    
    //进入首页
    [self enterHomeVC];
    
    // 热启动预加载（可选）
    // [self loadAd];
}

/// 开屏广告已点击
/// - Parameters:
///   - placementID: 广告位ID
///   - extra: 额外信息
- (void)splashDidClickForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"splashDidClickForPlacementID:%@",placementID);
    [self showLog:[NSString stringWithFormat:@"splashDidClickForPlacementID:%@",placementID]];
}

/// 开屏广告展示失败
/// - Parameters:
///   - placementID: 广告位ID
///   - error: 错误信息
///   - extra: 额外信息
- (void)splashDidShowFailedForPlacementID:(NSString*)placementID error:(NSError *)error extra:(NSDictionary *)extra {
    ATDemoLog(@"splashDidShowFailedForPlacementID:%@",placementID);
    [self showLog:[NSString stringWithFormat:@"splashDidShowFailedForPlacementID:%@ error:%@ ",placementID,error]];
    
    //没有展示成功,也进入首页,注意控制重复跳转
    [self enterHomeVC];
}

/// 开屏广告已打开或跳转深链接页面
/// - Parameters:
///   - placementID: 广告位ID
///   - extra: 额外信息
///   - success: 是否成功
- (void)splashDeepLinkOrJumpForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra result:(BOOL)success {
    ATDemoLog(@"splashDeepLinkOrJumpForPlacementID:placementID:%@", placementID);
    [self showLog:[NSString stringWithFormat:@"splashDeepLinkOrJumpForPlacementID:placementID:%@ ", placementID]];
}
  
/// 开屏广告详情页已关闭
/// - Parameters:
///   - placementID: 广告位ID
///   - extra: 额外信息
- (void)splashDetailDidClosedForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"splashDetailDidClosedForPlacementID:%@",placementID);
    [self showLog:[NSString stringWithFormat:@"splashDetailDidClosedForPlacementID:%@ ",placementID]];
    
    //可在此获取关闭原因:dismiss_type
//    typedef NS_OPTIONS(NSInteger, ATAdCloseType) {
//        ATAdCloseUnknow = 1,            // ad close type unknow
//        ATAdCloseSkip = 2,              // ad skip to close
//        ATAdCloseCountdown = 3,         // ad countdown to close
//        ATAdCloseClickcontent = 4,      // ad clickcontent to close
//        ATAdCloseShowfail = 99          // ad showfail to close
//    };
//    ATAdCloseType closeType = [extra[kATADDelegateExtraDismissTypeKey] integerValue];
    
    // 热启动预加载（可选）
    // [self loadAd];
}

/// 开屏广告关闭计时
/// - Parameters:
///   - countdown: 剩余秒数
///   - placementID: 广告位ID
///   - extra: 额外信息
- (void)splashCountdownTime:(NSInteger)countdown forPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"splashCountdownTime:%ld forPlacementID:%@",countdown,placementID);
    [self showLog:[NSString stringWithFormat:@"splashCountdownTime:%ld forPlacementID:%@",countdown,placementID]];
}

/// 开屏广告zoomout view已点击，仅Pangle 腾讯优量汇 V+支持
/// - Parameters:
///   - placementID: 广告位ID
///   - extra: 额外信息
- (void)splashZoomOutViewDidClickForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"splashZoomOutViewDidClickForPlacementID:%@",placementID);
    [self showLog:[NSString stringWithFormat:@"splashZoomOutViewDidClickForPlacementID:%@ ",placementID]];
}

/// 开屏广告zoomout view已关闭，仅Pangle 腾讯优量汇 V+支持
/// - Parameters:
///   - placementID: 广告位ID
///   - extra: 额外信息
- (void)splashZoomOutViewDidCloseForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"splashZoomOutViewDidCloseForPlacementID:%@",placementID);
    [self showLog:[NSString stringWithFormat:@"splashZoomOutViewDidCloseForPlacementID:%@ ",placementID]];
}
  
@end
