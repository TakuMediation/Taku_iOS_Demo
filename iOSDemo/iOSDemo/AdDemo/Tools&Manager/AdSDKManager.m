//
//  AdSDKManager.m
//  iOSDemo
//
//  Created by ltz on 2025/3/26.
//

#import "AdSDKManager.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import "LaunchLoadingView.h"
#import "AdLoadConfigTool.h"
#import "SDKGlobalConfigTool.h"
#import "TestModeTool.h"
 
static AdSDKManager *sharedManager = nil;

@interface AdSDKManager() <ATAdLoadingDelegate, ATSplashDelegate>
 
@end

@implementation AdSDKManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[AdSDKManager alloc] init];
    });
    return sharedManager;
}

#pragma mark - public func
/// GDPR/UMP flow
- (void)initSDK_EU:(AdManagerInitFinishBlock)block {
    [[ATAPI sharedInstance] showGDPRConsentDialogInViewController:[UIApplication sharedApplication].keyWindow.rootViewController dismissalCallback:^{
        // Example of requesting ATT permission on non-first launch when user consents or data consent is unknown. Adjust according to your app's actual situation.

        if (([ATAPI sharedInstance].dataConsentSet == ATDataConsentSetUnknown && ([[NSUserDefaults standardUserDefaults] boolForKey:@"GDPR_First_Flag"] == YES))
            
            || [ATAPI sharedInstance].dataConsentSet == ATDataConsentSetPersonalized) {
            
            if (@available(iOS 14, *)) {
                [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                    
                }];
            }
        }
        
        //若有集成并使用Admob UMP弹窗，当用户做出选择后，则在此回调中[ATAPI sharedInstance].dataConsentSet 在 App 首次启动时无法获得结果
        //如果您想获得结果，可以参考以下代码：
//        NSString *purposeConsents = [[NSUserDefaults standardUserDefaults] stringForKey:@"IABTCF_PurposeConsents"];
//        NSLog(@"purposeConsents:%@", purposeConsents);
//        if (![purposeConsents containsString:@"1"]) {
//           //用户不同意
//        } else {
//           //用户不同意
//        }
        
//        //若没有集成使用Admob UMP，则在此回调中可以获得用户选择的结果。
//        if ([ATAPI sharedInstance].dataConsentSet == ATDataConsentSetPersonalized) {
//            //用户同意了
//        }else {
//            //用户不同意
//        }
         
        [self initSDK];
        if (block) {
            block();
        }
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"GDPR_First_Flag"];
    }];
}
 
/// 初始化SDK，此方法不会同时初始化广告平台SDK
- (void)initSDK {
    
    // 日志开关
    [ATAPI setLogEnabled:YES];
    // 检测集成
    [ATAPI integrationChecking];
    
    // 可选接入，设置开屏广告预置策略
    // [[ATSDKGlobalSetting sharedManager] setPresetPlacementConfigPathBundle:[NSBundle mainBundle]];
    
    //SDK自定义参数配置，单项
    [SDKGlobalConfigTool setCustomChannel:@"渠道xxx"];
    
    //可选接入，若使用了Pangle广告平台，设置海外隐私项目
//    [SDKGlobalConfigTool pangleCOPPACCPASetting];

    //SDK自定义参数配置，多项一起，其他配置在SDKGlobalConfigTool类中查看
//    [SDKGlobalConfigTool setCustomData:@{kATCustomDataUserIDKey:@"test_custom_user_id",
//                                         kATCustomDataChannelKey:@"custom_data_channel",//设置渠道字符串，可在设备维度报表中看到对应的
//                                         kATCustomDataSubchannelKey:@"custom_data_subchannel",
//                                         kATCustomDataAgeKey:@18,
//                                         kATCustomDataGenderKey:@1,//流量分组的时候填写的值，需要跟该传入的值一致
//                                         kATCustomDataNumberOfIAPKey:@19,
//                                         kATCustomDataIAPAmountKey:@20.0f,
//                                         kATCustomDataIAPCurrencyKey:@"usd",}];
 
    //调试模式相关工具 TestModeTool
//    [TestModeTool showDebugUI:]
    
    //初始化SDK
    NSError * initError = nil;
    [[ATAPI sharedInstance] startWithAppID:kTakuAppID appKey:kTakuAppKey error:&initError];
    if (initError) {
        //初始化失败
        NSLog(@"init failed : %@",initError);
    }
}
 
#pragma mark - 开屏广告相关

- (void)startSplashAd {
    //开屏广告展示启动图
    [self addLaunchLoadingView];
    
    [self loadSplashWithPlacementID:FirstAppOpen_PlacementID];
}

- (void)addLaunchLoadingView {
    //添加启动页
    LaunchLoadingView *loadingView = [LaunchLoadingView sharedInstance];
    [loadingView show];
}

/// 加载开屏广告
- (void)loadSplashWithPlacementID:(NSString *)placementID {
    NSMutableDictionary *loadConfigDict = [NSMutableDictionary dictionary];
    
    //开屏超时时间，本流程使用SDK的kATSplashExtraTolerateTimeoutKey（内置超时计时器）来演示加载超时不展示广告的情形，如果你需要超时也展示广告，则请根据您自己的定时器自定义展示逻辑
    [loadConfigDict setValue:@(FirstAppOpen_Timeout) forKey:kATSplashExtraTolerateTimeoutKey];
    //自定义load参数
    [loadConfigDict setValue:@"media_val_SplashVC" forKey:kATAdLoadingExtraMediaExtraKey];
    
    //可选接入，如果使用了Pangle广告平台，可添加以下配置
    //[AdLoadConfigTool splash_loadExtraConfigAppend_Pangle:loadConfigDict];
    
    //若选择使用优量汇(GDT)，建议接入
    [AdLoadConfigTool splash_loadExtraConfigAppend_Tencent:loadConfigDict];
    
    [[ATAdManager sharedManager] loadADWithPlacementID:placementID
                                                 extra:loadConfigDict
                                              delegate:self
                                         containerView:[self footLogoView]];
}

/// 展示开屏广告
- (void)showSplashWithPlacementID:(NSString *)placementID {
    //检查是否有就绪
    if (![[ATAdManager sharedManager] splashReadyForPlacementID:placementID]) {
        return;
    }
    
    //场景统计功能，可选接入
    [[ATAdManager sharedManager] entrySplashScenarioWithPlacementID:placementID scene:@""];
     
    //展示配置，Scene传入后台的场景ID，没有可传入空字符串，showCustomExt参数可传入自定义参数字符串
    ATShowConfig *config = [[ATShowConfig alloc] initWithScene:placementID showCustomExt:@"testShowCustomExt"];
    
    //开屏相关参数配置
    NSMutableDictionary *configDict = [NSMutableDictionary dictionary];
    
    //可选接入，自定义跳过按钮，多数平台已经不支持自定义跳过按钮，目前支持更改自定义跳过按钮有穿山甲(TT)，直投、ADX、原生作开屏和游可盈，具体需要运行看实际效果
//    [AdLoadConfigTool splash_loadExtraConfigAppend_CustomSkipButton:configDict];
    
    //展示广告
    [[ATAdManager sharedManager] showSplashWithPlacementID:placementID config:config window:[UIApplication sharedApplication].keyWindow inViewController:[UIApplication sharedApplication].keyWindow.rootViewController extra:configDict delegate:self];
}

#pragma mark - Private Methods

/// 开屏广告加载回调判断
- (void)showSplashOrEnterHomePageWithPlacementID:(NSString *)placementID loadResult:(BOOL)loadResult {
    if (loadResult) {
        [self showSplashWithPlacementID:placementID];
    } else {
        [[LaunchLoadingView sharedInstance] dismiss];
    }
}

#pragma mark - AppOpen FooterView
/// 可选接入开屏底部LogoView，仅部分广告平台支持
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

#pragma mark - Ad Loading Delegate
/// 广告位加载失败
/// - Parameters:
///   - placementID: 广告位ID
///   - error: 错误信息
- (void)didFailToLoadADWithPlacementID:(NSString *)placementID error:(NSError *)error {
    //处理开屏回调
    [self showSplashOrEnterHomePageWithPlacementID:placementID loadResult:NO];
}

- (void)didFinishLoadingADWithPlacementID:(NSString *)placementID { 
    // All Ads load finished, please use didFinishLoadingSplashADWithPlacementID:isTimeout first
}

#pragma mark - 开屏广告事件
/// 开屏加载成功，需要判断是否超时
/// - Parameters:
///   - placementID: 广告位ID
///   - isTimeout: 是否超时
- (void)didFinishLoadingSplashADWithPlacementID:(NSString *)placementID isTimeout:(BOOL)isTimeout {
    //处理开屏回调
    [self showSplashOrEnterHomePageWithPlacementID:placementID loadResult:!isTimeout];
}

/// 开屏广告超时
/// - Parameter placementID: 广告位ID
- (void)didTimeoutLoadingSplashADWithPlacementID:(NSString *)placementID {
    //处理开屏回调
    [self showSplashOrEnterHomePageWithPlacementID:placementID loadResult:NO];
}

/// 开屏广告已关闭
/// - Parameters:
///   - placementID: 广告位ID
///   - extra: 额外信息
- (void)splashDidCloseForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    //处理开屏回调
    [self showSplashOrEnterHomePageWithPlacementID:placementID loadResult:NO];
}

/// 开屏广告展示失败
/// - Parameters:
///   - placementID: 广告位ID
///   - error: 错误信息
///   - extra: 额外信息
- (void)splashDidShowFailedForPlacementID:(NSString*)placementID error:(NSError *)error extra:(NSDictionary *)extra {
    //处理开屏回调
    [self showSplashOrEnterHomePageWithPlacementID:placementID loadResult:NO];
}
 
/// 开屏广告用户已点击
/// - Parameters:
///   - placementID: 广告位ID
///   - extra: 额外信息
- (void)splashDidClickForPlacementID:(nonnull NSString *)placementID extra:(nonnull NSDictionary *)extra {
    
}
 
/// 开屏广告已曝光
/// - Parameters:
///   - placementID: 广告位ID
///   - extra: 额外信息
- (void)splashDidShowForPlacementID:(nonnull NSString *)placementID extra:(nonnull NSDictionary *)extra {
    [[LaunchLoadingView sharedInstance] dismiss];
}


#pragma mark - life
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
