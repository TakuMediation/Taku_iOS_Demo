//
//  SplashInNewWindowVC.m
//  iOSDemo
//
//  Created by ltz on 2025/1/16.
//

#import "SplashInNewWindowVC.h"

#import <AnyThinkSplash/AnyThinkSplash.h>

#import "AdLoadConfigTool.h"

#import "AppDelegate.h"

#import "SplashInNewWindowContainerVC.h"

@interface SplashInNewWindowVC () <ATSplashDelegate>

@property (weak, nonatomic) UIViewController * splashVC;

@property (assign, nonatomic) BOOL isSplashDetailDidClosedFlag;

@end

@implementation SplashInNewWindowVC

//广告位ID
#define SplashPlacementID @"b67f4ab43d2fe1"

//场景ID，可选，可在后台生成。没有可传入空字符串
#define SplashSceneID @""

#pragma mark - Load Ad 加载广告
/// 加载广告按钮被点击
- (void)loadAdButtonClickAction {
 
    [self showLog:kLocalizeStr(@"点击了加载广告")];
      
    NSMutableDictionary *loadConfigDict = [NSMutableDictionary dictionary];
    
    //开屏超时时间
    [loadConfigDict setValue:@(5) forKey:kATSplashExtraTolerateTimeoutKey];
    //自定义load参数
    [loadConfigDict setValue:@"media_val_SplashVC" forKey:kATAdLoadingExtraMediaExtraKey];
     
    //可选接入，如果使用了Pangle广告平台，可添加以下配置
//    [AdLoadConfigTool splash_loadExtraConfigAppendPangle:loadConfigDict];
     
    [[ATAdManager sharedManager] loadADWithPlacementID:SplashPlacementID
                                                 extra:loadConfigDict
                                              delegate:self
                                         containerView:[self footLogoView]];
}
 
#pragma mark - Show Ad 展示广告
/// 展示广告按钮被点击
- (void)showAdButtonClickAction {
    //模拟原window上可能出现的弹窗逻辑
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"这是一个模拟弹窗，开屏广告将在2秒后展示" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * actOK = [UIAlertAction actionWithTitle:@"请在广告关闭后点击我" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:actOK];
    @WeakObj(self);
    [self presentViewController:alert animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //在开屏专用window中展示开屏广告，需要自行管理window创建和指定/恢复keyWindow逻辑，不影响原window中的逻辑，请您的弹窗指定原应用的window，不要指定keyWindow
            @StrongObj(self);
            [self showSplashInNewWindow];
        });
    }];
}

/// 在当前的keywindow下的当前控制器展示开屏广告
- (void)showSplashInNewWindow {
    //场景统计功能，可选接入
    [[ATAdManager sharedManager] entrySplashScenarioWithPlacementID:SplashPlacementID scene:SplashSceneID];
    
    //检查是否有就绪
    if (![[ATAdManager sharedManager] splashReadyForPlacementID:SplashPlacementID]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ad Not Ready!" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alert dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return;
    }
    
    //展示配置，Scene传入后台的场景ID，没有可传入空字符串，showCustomExt参数可传入自定义参数字符串
    ATShowConfig *config = [[ATShowConfig alloc] initWithScene:SplashSceneID showCustomExt:@"testShowCustomExt"];
    
    //开屏相关参数配置
    NSMutableDictionary *configDict = [NSMutableDictionary dictionary];
    
    //可选接入，自定义跳过按钮，多数平台已经不支持自定义跳过按钮，目前支持更改自定义跳过按钮有穿山甲(TT)，直投、ADX、原生作开屏和游可盈，具体需要运行看实际效果
//    [AdLoadConfigTool splash_loadExtraConfigAppend_CustomSkipButton:configDict];
    
    //获取window管理类中的开屏专用window，避免与原window弹窗逻辑产生冲突
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate initSplashWindow];
    
    //⚠️需要在SplashInNewWindowContainerVC添加逻辑，恢复原来应用的keyWindow
    //展示广告
    [[ATAdManager sharedManager] showSplashWithPlacementID:SplashPlacementID config:config window:delegate.splashWindow inViewController:delegate.splashWindow.rootViewController extra:configDict delegate:self];
    
    //模拟应用自身弹窗业务逻辑
    [self addBlockView];
}

///模拟应用自身弹窗业务逻辑
- (void)addBlockView {
    UILabel * blockView = [UILabel new];
    blockView.backgroundColor = UIColor.redColor;
    blockView.textAlignment = NSTextAlignmentCenter;
    blockView.text = @"我是开屏模拟弹窗遮挡，\n我在开屏广告弹出后展示，\n我不会遮挡开屏广告，\n点击我可以关闭";
    blockView.numberOfLines = 0;
    [self.view addSubview:blockView];
    
    [blockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(300);
        make.center.mas_equalTo(self.view);
    }];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blockViewClick:)];
    blockView.userInteractionEnabled = YES;
    [blockView addGestureRecognizer:tap];
}

- (void)blockViewClick:(UITapGestureRecognizer *)tap {
    [tap.view removeFromSuperview];
}

#pragma mark - AppOpen FooterView
/// 可选接入开屏底部LogoView
- (UIView *)footLogoView {
    
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

/// 切换回原来的应用
- (void)enterHomeVC {
    //切换回原来应用的Window
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window makeKeyAndVisible];
}

/// footer点击测试
- (void)footerImgClick:(UITapGestureRecognizer *)tap {
    ATDemoLog(@"footer click !!");
}

#pragma mark - 广告位代理回调
/// 广告位加载完成
/// - Parameter placementID: 广告位ID
- (void)didFinishLoadingADWithPlacementID:(NSString *)placementID {
    BOOL isReady = [[ATAdManager sharedManager] splashReadyForPlacementID:placementID];
    [self showLog:[NSString stringWithFormat:@"didFinishLoadingADWithPlacementID:%@ Splash 是否准备好:%@", placementID,isReady ? @"YES":@"NO"]];
}
 
/// 广告位加载失败
/// - Parameters:
///   - placementID: 广告位ID
///   - error: 错误信息
- (void)didFailToLoadADWithPlacementID:(NSString*)placementID error:(NSError*)error {
    ATDemoLog(@"didFailToLoadADWithPlacementID:%@ error:%@", placementID, error);
    [self showLog:[NSString stringWithFormat:@"didFailToLoadADWithPlacementID:%@ errorCode:%ld", placementID, error.code]];
    
    //切换回去
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

#pragma mark - 开屏广告事件代理回调
- (void)didTimeoutLoadingSplashADWithPlacementID:(NSString *)placementID {
    //超时了，首页加载完成后进入首页
    [self showLog:[NSString stringWithFormat:@"开屏超时了"]];
    [self enterHomeVC];
}

- (void)didFinishLoadingSplashADWithPlacementID:(NSString *)placementID isTimeout:(BOOL)isTimeout {
    ATDemoLog(@"开屏加载成功:%@----是否超时:%d",placementID,isTimeout);
    [self showLog:[NSString stringWithFormat:@"开屏成功:%@----是否超时:%d",placementID,isTimeout]];
}

/// 开屏广告已展示
/// - Parameters:
///   - placementID: 广告位ID
///   - extra: 额外信息
- (void)splashDidShowForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"splashDidShowForPlacementID:%@",placementID);
    [self showLog:[NSString stringWithFormat:@"splashDidShowForPlacementID:%@ ",placementID]];
}

/// 开屏广告已关闭
/// - Parameters:
///   - placementID: 广告位ID
///   - extra: 额外信息
- (void)splashDidCloseForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"splashDidCloseForPlacementID:%@ extra:%@",placementID,extra);
    [self showLog:[NSString stringWithFormat:@"splashDidCloseForPlacementID:%@ ",placementID]];
     
//    //可在此获取关闭原因:dismiss_type
//    typedef NS_OPTIONS(NSInteger, ATAdCloseType) {
//        ATAdCloseUnknow = 1,            // ad close type unknow 未知
//        ATAdCloseSkip = 2,              // ad skip to close 用户点击跳过
//        ATAdCloseCountdown = 3,         // ad countdown to close 倒计时到了
//        ATAdCloseClickcontent = 4,      // ad clickcontent to close 会产生跳转
//        ATAdCloseShowfail = 99          // ad showfail to close 关闭失败
//    };
    ATAdCloseType closeType = [extra[kATADDelegateExtraDismissTypeKey] integerValue];
    
    //获取新创建的开屏vc
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SplashInNewWindowContainerVC * newWindowRootVC = (SplashInNewWindowContainerVC *)delegate.splashWindow.rootViewController;
     
    //1.不能close就直接进入首页，只有当closeType!=4时进入首页
    //2.closeType == 4会有两种情况，跳转应用内落地页，跳转应用外部,跳转应用内AppStore
    //跳转应用内落地页，应用不会进入后台，rootVC必定触发viewWillAppear、viewDidDisappear，通过这两个生命周期处理
    //跳转应用外部，必定触发UIApplicationDidEnterBackgroundNotification，不会触发viewWillAppear/viewDidDisappear,通过用户点击了广告+closeType == ATAdCloseClickcontent在rootVC的appDidEnterBackground中进入首页
    //跳转应用内AppStore，关闭应用内AppStore时会回调splashDetailDidClosedForPlacementID，设立splashDetailDidClosedForPlacementID标记在此处理进入首页
    if (closeType != ATAdCloseClickcontent) {
        //进入首页
        [newWindowRootVC enterHome];
        return;
    }
    if (self.isSplashDetailDidClosedFlag) {
        [newWindowRootVC enterHome];
    }
}

/// 开屏广告已点击
/// - Parameters:
///   - placementID: 广告位ID
///   - extra: 额外信息
- (void)splashDidClickForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"splashDidClickForPlacementID:%@",placementID);
    [self showLog:[NSString stringWithFormat:@"splashDidClickForPlacementID:%@",placementID]];
    
    //获取开屏新window的rootVC
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SplashInNewWindowContainerVC * newWindowRootVC = (SplashInNewWindowContainerVC *)delegate.splashWindow.rootViewController;
    
    //标记用户已经点击广告
    newWindowRootVC.isUserClickAd = YES;
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
  
/// 开屏广告详情页已关闭，
/// 可能不回调，可能通过splashDidCloseForPlacementID回调extra参数中的closeType区分
/// - Parameters:
///   - placementID: 广告位ID
///   - extra: 额外信息
- (void)splashDetailDidClosedForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"splashDetailDidClosedForPlacementID:%@",placementID);
    [self showLog:[NSString stringWithFormat:@"splashDetailDidClosedForPlacementID:%@ ",placementID]];
    
    self.isSplashDetailDidClosedFlag = YES;
}

/// 开屏广告关闭计时
/// - Parameters:
///   - countdown: 剩余秒数
///   - placementID: 广告位ID
///   - extra: 额外信息
- (void)splashCountdownTime:(NSInteger)countdown forPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"splashCountdownTime:%ld forPlacementID:%@",countdown,placementID);
    [self showLog:[NSString stringWithFormat:@"splashCountdownTime:%ld forPlacementID:%@",countdown,placementID]];
    
    // 如果添加了自定义跳过按钮，可在本回调中设置倒计时，需要自行处理按钮文本显示
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSString *title = [NSString stringWithFormat:@"%lds | Skip",countdown/1000];
//        if (countdown/1000) {
//            [customSkipButton setTitle:title forState:UIControlStateNormal];
//        }
//    });
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

@end
