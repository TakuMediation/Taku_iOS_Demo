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

/// 加载页面，使用自己的加载图
@property (strong, nonatomic) LaunchLoadingView * launchLoadingView;
/// 保存开屏广告回调block
@property (strong, nonatomic) NSMutableDictionary<NSString *, AdManagerSplashAdLoadBlock> *splashAdCallbacks;

@end

@implementation AdSDKManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[AdSDKManager alloc] init];
        sharedManager.splashAdCallbacks = [NSMutableDictionary dictionary];
    });
    return sharedManager;
}

#pragma mark - public func
/// GDPR/UMP流程初始化
- (void)initSDK_EU:(AdManagerInitFinishBlock)block {
    [[ATAPI sharedInstance] showGDPRConsentDialogInViewController:[UIApplication sharedApplication].keyWindow.rootViewController dismissalCallback:^{
        // 这里示例在用户同意，或者数据同意未知情况下的非首次启动申请ATT权限，您可以根据应用实际情况进行调整。
        if (([ATAPI sharedInstance].dataConsentSet == ATDataConsentSetUnknown && ([[NSUserDefaults standardUserDefaults] boolForKey:@"GDPR_First_Flag"] == YES))
            
            || [ATAPI sharedInstance].dataConsentSet == ATDataConsentSetPersonalized) {
            
            if (@available(iOS 14, *)) {
                [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                    
                }];
            }
        }
        
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
//                                         kATCustomDataChannelKey:@"custom_data_channel",
//                                         kATCustomDataSubchannelKey:@"custom_data_subchannel",
//                                         kATCustomDataAgeKey:@18,
//                                         kATCustomDataGenderKey:@1,//流量分组的时候填写的值，需要跟该传入的值一致
//                                         kATCustomDataNumberOfIAPKey:@19,
//                                         kATCustomDataIAPAmountKey:@20.0f,
//                                         kATCustomDataIAPCurrencyKey:@"usd",}];
 
    //调试模式相关工具 TestModeTool
//    [TestModeTool showDebugUI:]
    
    //初始化SDK
    [[ATAPI sharedInstance] startWithAppID:kTakuAppID appKey:kTakuAppKey error:nil];
}
 
#pragma mark - 开屏广告相关
- (void)addLaunchLoadingView {
    //添加启动页
    //添加加载页面，当广告显示完毕后需要在代理中移除
    self.launchLoadingView = [LaunchLoadingView new];
    [self.launchLoadingView show];
}

/// 加载开屏广告
- (void)loadSplashAdWithPlacementID:(NSString *)placementID result:(AdManagerSplashAdLoadBlock)block {
    
    [self.launchLoadingView startTimer];
    
    // 根据placementID保存回调block
    if (placementID && block) {
        self.splashAdCallbacks[placementID] = block;
    }
     
    NSMutableDictionary *loadConfigDict = [NSMutableDictionary dictionary];
    
    //开屏超时时间
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

#pragma mark - 开屏广告加载回调判断
- (void)splashCallBackWithPlacementID:(NSString *)placementID result:(BOOL)result {
    
    if (result == NO) {
        [self.launchLoadingView dismiss];
    }
    
    AdManagerSplashAdLoadBlock block = self.splashAdCallbacks[placementID];
    if (block) {
        block(result);
        [self.splashAdCallbacks removeObjectForKey:placementID];
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
    [self splashCallBackWithPlacementID:placementID result:NO];
}

- (void)didFinishLoadingADWithPlacementID:(NSString *)placementID { 
    [self splashCallBackWithPlacementID:placementID result:YES];
}

#pragma mark - 开屏广告事件
/// 开屏加载成功，需要判断是否超时
/// - Parameters:
///   - placementID: 广告位ID
///   - isTimeout: 是否超时
- (void)didFinishLoadingSplashADWithPlacementID:(NSString *)placementID isTimeout:(BOOL)isTimeout {
    //处理开屏回调
    [self splashCallBackWithPlacementID:placementID result:!isTimeout];
}

/// 开屏广告超时
/// - Parameter placementID: 广告位ID
- (void)didTimeoutLoadingSplashADWithPlacementID:(NSString *)placementID {
    //处理开屏回调
    [self splashCallBackWithPlacementID:placementID result:NO];
}

/// 开屏广告已关闭
/// - Parameters:
///   - placementID: 广告位ID
///   - extra: 额外信息
- (void)splashDidCloseForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    //处理开屏回调
    [self splashCallBackWithPlacementID:placementID result:NO];
}

/// 开屏广告展示失败
/// - Parameters:
///   - placementID: 广告位ID
///   - error: 错误信息
///   - extra: 额外信息
- (void)splashDidShowFailedForPlacementID:(NSString*)placementID error:(NSError *)error extra:(NSDictionary *)extra {
    //处理开屏回调
    [self splashCallBackWithPlacementID:placementID result:NO];
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
 
}


#pragma mark - life
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
