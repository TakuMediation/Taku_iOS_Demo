//
//  ATSplashViewController.m
//  TakuSDKDemo
//
//  Created by Jason on 2020/12/3.
//  Copyright © 2020 AnyThink. All rights reserved.
//

#import "ATSplashViewController.h"
#import <AnyThinkSplash/AnyThinkSplash.h>
#import "ATADFootView.h"
#import "ATModelButton.h"
#import "ATMenuView.h"

@interface ATSplashViewController ()<ATSplashDelegate>

@property (nonatomic, strong) ATADFootView *footView;

@property (nonatomic, strong) UIView *modelBackView;

@property (nonatomic, strong) ATModelButton *modelButton;

@property (nonatomic, strong) ATMenuView *menuView;

@property (nonatomic, strong) UITextView *textView;

@property(nonatomic, strong) UIButton *skipButton;

@property (copy, nonatomic) NSDictionary<NSString *, NSString *> *placementIDs;

@property (copy, nonatomic) NSString *placementID;

@property(nonatomic, strong) NSString *defaultAdSourceConfigStr;

@end

@implementation ATSplashViewController

-(instancetype)init{
    self = [super init];
    
    return  self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Splash";
    self.view.backgroundColor = kRGB(245, 245, 245);
    
    [self setupData];
    [self setupUI];
}

- (NSDictionary<NSString *,NSString *> *)placementIDs {
    
    return @{
        @"ADX":                   @"b62b419273e429",
        @"All":                   @"b62b40ff8aed6a",
        @"AdMob":                 @"b62e9ee8eb2d0b",
        @"Kuaishou":              @"b62b41922b6663",
        @"GDT":                   @"b62b41ef152d42",
        @"Baidu":                 @"b62b41ef0b0e1b",
        @"CSJ":                   @"b62b41eefa70a8",
        @"Sigmob":                @"b62b41c8d7ac74",
        @"Mintegral":             @"b62b41c7818614",
        @"Cross Promotion":       @"b62b4192b9efaa",
        @"Pangle":                @"b62b41521d52d1",
        @"Klevin":                @"b62b415211bd15",
        @"HeaderBidding":         @"b62b4126caa479",
        @"Bigo":                @"b63909d7b39cac",
        @"vungle":                @"b63a5518f4820c",
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
    [self.modelBackView addSubview:self.modelButton];
    [self.view addSubview:self.menuView];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.footView];
    
    [self.modelBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(kScreenW - kScaleW(52));
        make.height.mas_equalTo(kScaleW(360));
        make.top.equalTo(self.view.mas_top).offset(kNavigationBarHeight + kScaleW(20));
    }];
    

    [self.modelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(kScaleW(340));
        make.height.mas_equalTo(kScaleW(360));
        make.top.equalTo(self.modelBackView.mas_top);
    }];
    
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenW - kScaleW(52));
        make.height.mas_equalTo(kScaleW(242));
        make.top.equalTo(self.modelBackView.mas_bottom).offset(kScaleW(20));
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.menuView.mas_bottom).offset(kScaleW(20));
        make.bottom.equalTo(self.footView.mas_top).offset(kScaleW(-20));
        make.width.mas_equalTo(kScreenW - kScaleW(52));
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(kScaleW(340));
    }];
}

- (void)clearLog {
    self.textView.text = @"";
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

- (UIInterfaceOrientation)currentInterfaceOrientation {
    if (@available(iOS 13.0, *)) {
        UIWindow *firstWindow = [[[UIApplication sharedApplication] windows] firstObject];
        if (firstWindow == nil) { return UIInterfaceOrientationUnknown; }
        
        UIWindowScene *windowScene = firstWindow.windowScene;
        if (windowScene == nil){ return UIInterfaceOrientationUnknown; }
        
        return windowScene.interfaceOrientation;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return UIApplication.sharedApplication.statusBarOrientation;
#pragma clang diagnostic pop
    }
}

// 由于系统的变动，提供两个获取 keyWindow的方法，选择一个适合来
- (UIWindow *)getKeyWindowMethodOne {
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive)
            {
                for (UIWindow *window in windowScene.windows)
                {
                    if (window.isKeyWindow)
                    {
                        return window;
                    }
                }
            }
        }
    } else {
        // 添加到当前window上，并置顶到最上层
        UIWindow * window = [UIApplication sharedApplication].delegate.window;
        if (window) {
            return window;
        }
        return [UIApplication sharedApplication].keyWindow;
    }
    return nil;
}

- (UIWindow *)getKeyWindowMethodTwo {
    if ( @available(iOS 13.0, *) ) {
        UIWindow *mainWindow = [UIApplication sharedApplication].windows.firstObject;
        [mainWindow makeKeyWindow];
        return mainWindow;
    } else {
        UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
        return mainWindow;
    }
}

#pragma mark - Action
// 加载广告
- (void)loadSplashAd {
    UIInterfaceOrientation deviceOrientaion = [self currentInterfaceOrientation];
    BOOL landscape = UIInterfaceOrientationIsLandscape(deviceOrientaion);
    
    // 开屏广告底部自定义的containerView
    UILabel *label = nil;
    label = [[UILabel alloc] initWithFrame:CGRectMake(.0f, .0f, landscape ? 120 : UIScreen.mainScreen.bounds.size.width, landscape ? UIScreen.mainScreen.bounds.size.height : 100.0f)];
    label.text = @"Container";
    label.textColor = [UIColor redColor];
    label.backgroundColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    // 设置开屏广告中支持广告源设置加载超时时间，并不是整个广告位请求的时间
    [mutableDict setValue:@5.5 forKey:kATSplashExtraTolerateTimeoutKey];
    
    [[ATAdManager sharedManager] loadADWithPlacementID:self.placementID
                                                 extra:mutableDict
                                              delegate:self
                                         containerView:label];
    
    // 从你们的Taku后台导出的兜底广告源进行设置
    //导出格式如：{\"unit_id\":1331013,\"nw_firm_id\":22,\"adapter_class\":\"ATBaiduSplashAdapter\",\"content\":\"{\\\"button_type\\\":\\\"0\\\",\\\"ad_place_id\\\":\\\"7852632\\\",\\\"app_id\\\":\\\"e232e8e6\\\"}\"}
    // [[ATAdManager sharedManager] loadADWithPlacementID:self.placementID extra:extra delegate:self containerView:label defaultAdSourceConfig:self.defaultAdSourceConfigStr];
}

// 检查广告缓存，是否iReady
- (void)checkAd {
    // 获取广告位的状态对象
    ATCheckLoadModel *checkLoadModel = [[ATAdManager sharedManager] checkSplashLoadStatusForPlacementID:self.placementID];
    NSLog(@"CheckLoadModel.isLoading:%d--- isReady:%d",checkLoadModel.isLoading,checkLoadModel.isReady);

    // 查询该广告位的所有缓存信息
    NSArray *caches = [[ATAdManager sharedManager] getSplashValidAdsForPlacementID:self.placementID];
    NSLog(@"ValidAds.count:%ld--- ValidAds:%@",caches.count,caches);

    // 判断当前是否存在可展示的广告
    BOOL ready = [[ATAdManager sharedManager] splashReadyForPlacementID:self.placementID];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:ready ? @"Ready!" : @"Not Yet!" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
    [[ATAdManager sharedManager] entrySplashScenarioWithPlacementID:self.placementID scene:KTaKuSplashSceneID];
}

// show展示开屏广告
- (void)showSplashAd {
    // 到达场景
    [self entryAdScenario];

    if ([[ATAdManager sharedManager] splashReadyForPlacementID:self.placementID]) {
        // 根据实际情况选择获取到的keyWindow的方法 getKeyWindowMethodOne 和 getKeyWindowMethodTwo
        UIWindow *mainWindow = [self getKeyWindowMethodOne];
        // 自定义跳过按钮，注意需要在广告倒计时 splashCountdownTime: 回调中实现按钮文本的变化处理
    //    self.skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    self.skipButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    //    self.skipButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 80 - 20, 50, 80, 21);
    //    self.skipButton.layer.cornerRadius = 10.5;
    //    self.skipButton.titleLabel.font = [UIFont systemFontOfSize:14];
        
        NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
        
        /* 多数平台已经不支持自定义跳过按钮，目前支持更改自定义跳过按钮有穿山甲(TT)，直投、ADX、原生作开屏和游可盈，具体需要运行看实际效果
        // 自定义跳过按钮倒计时时长，毫秒单位
        [mutableDict setValue:@50000 forKey:kATSplashExtraCountdownKey];
        // 自定义跳过按钮
        [mutableDict setValue:self.skipButton forKey:kATSplashExtraCustomSkipButtonKey];
        // 自定义跳过按钮倒计时回调间隔
        [mutableDict setValue:@500 forKey:kATSplashExtraCountdownIntervalKey];
        */
        
        [[ATAdManager sharedManager] showSplashWithPlacementID:self.placementID scene:KTaKuSplashSceneID window:mainWindow extra:mutableDict delegate:self];
    }
}

// MARK:- splash delegate
#pragma mark - ATSplashDelegate
- (void)didStartLoadingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary*)extra{
    NSLog(@"广告源--AD--开始--ATSplashViewController::didStartLoadingADSourceWithPlacementID:%@", placementID);
}

- (void)didFinishLoadingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary*)extra{
    NSLog(@"广告源--AD--完成--ATSplashViewController::didFinishLoadingADSourceWithPlacementID:%@", placementID);
}

- (void)didFailToLoadADSourceWithPlacementID:(NSString*)placementID extra:(NSDictionary*)extra error:(NSError*)error{
    NSLog(@"广告源--AD--失败--ATSplashViewController::didFailToLoadADSourceWithPlacementID:%@---error:%@", placementID,error);
}

// bidding
- (void)didStartBiddingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary*)extra{
    NSLog(@"广告源--bid--开始--ATSplashViewController::didStartBiddingADSourceWithPlacementID:%@", placementID);
}

- (void)didFinishBiddingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary*)extra{
    NSLog(@"广告源--bid--完成--ATSplashViewController::didFinishBiddingADSourceWithPlacementID:%@", placementID);
}

- (void)didFailBiddingADSourceWithPlacementID:(NSString*)placementID extra:(NSDictionary*)extra error:(NSError*)error{
    NSLog(@"广告源--bid--失败--ATSplashViewController::didFailBiddingADSourceWithPlacementID:%@--error:%@", placementID,error);
}

- (void)didFinishLoadingSplashADWithPlacementID:(NSString *)placementID isTimeout:(BOOL)isTimeout {
    NSLog(@"开屏成功:%@----是否超时:%d",placementID,isTimeout);
    NSLog(@"开屏didFinishLoadingSplashADWithPlacementID:");
    [self showLog:[NSString stringWithFormat:@"开屏成功:%@----是否超时:%d",placementID,isTimeout]];
}

- (void)didTimeoutLoadingSplashADWithPlacementID:(NSString *)placementID {
    NSLog(@"开屏超时:%@",placementID);
    NSLog(@"开屏didTimeoutLoadingSplashADWithPlacementID:");
    [self showLog:[NSString stringWithFormat:@"开屏超时:%@",placementID]];
}

- (void)didFailToLoadADWithPlacementID:(NSString *)placementID error:(NSError *)error {
    NSLog(@"开屏ATSplashViewController:: didFailToLoadADWithPlacementID");
    [self showLog:[NSString stringWithFormat:@"开屏加载失败:%@--%@",placementID,error]];
}

- (void)didFinishLoadingADWithPlacementID:(NSString *)placementID {
    NSLog(@"开屏ATSplashViewController:: didFinishLoadingADWithPlacementID");
    [self showLog:[NSString stringWithFormat:@"开屏加载成功:%@",placementID]];
}

- (void)splashDeepLinkOrJumpForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra result:(BOOL)success {
    NSLog(@"开屏ATSplashViewController:: splashDeepLinkOrJumpForPlacementID:placementID:%@", placementID);
    [self showLog:[NSString stringWithFormat:@"splashDeepLinkOrJumpForPlacementID:placementID:%@ ", placementID]];
}

- (void)splashDidClickForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@"开屏ATSplashViewController::splashDidClickForPlacementID:%@",placementID);
    [self showLog:[NSString stringWithFormat:@"splashDidClickForPlacementID:%@",placementID]];
}

- (void)splashDidCloseForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@"开屏ATSplashViewController::splashDidCloseForPlacementID:%@ extra:%@",placementID,extra);
    [self showLog:[NSString stringWithFormat:@"splashDidCloseForPlacementID:%@ ",placementID]];
}

- (void)splashDidShowForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@"开屏ATSplashViewController::splashDidShowForPlacementID:%@",placementID);
    [self showLog:[NSString stringWithFormat:@"splashDidShowForPlacementID:%@ ",placementID]];
}

-(void)splashZoomOutViewDidClickForPlacementID:(NSString*)placementID extra:(NSDictionary *) extra {
    NSLog(@"开屏ATSplashViewController::splashZoomOutViewDidClickForPlacementID:%@",placementID);
    [self showLog:[NSString stringWithFormat:@"splashZoomOutViewDidClickForPlacementID:%@ ",placementID]];
}

-(void)splashZoomOutViewDidCloseForPlacementID:(NSString*)placementID extra:(NSDictionary *) extra {
    NSLog(@"开屏ATSplashViewController::splashZoomOutViewDidCloseForPlacementID:%@",placementID);
    [self showLog:[NSString stringWithFormat:@"splashZoomOutViewDidCloseForPlacementID:%@ ",placementID]];
}

- (void)splashDetailDidClosedForPlacementID:(NSString*)placementID extra:(NSDictionary *) extra {
    NSLog(@"ATSplashViewController::splashDetailDidClosedForPlacementID:%@",placementID);
    [self showLog:[NSString stringWithFormat:@"splashDetailDidClosedForPlacementID:%@ ",placementID]];
}

- (void)splashDidShowFailedForPlacementID:(NSString*)placementID error:(NSError *)error extra:(NSDictionary *) extra {
    NSLog(@"开屏ATSplashViewController::splashDidShowFailedForPlacementID:%@",placementID);
    [self showLog:[NSString stringWithFormat:@"splashDidShowFailedForPlacementID:%@ error:%@ ",placementID,error]];
}

- (void)splashCountdownTime:(NSInteger)countdown forPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@"开屏ATSplashViewController::splashCountdownTime:%ld forPlacementID:%@",countdown,placementID);
    [self showLog:[NSString stringWithFormat:@"splashCountdownTime:%ld forPlacementID:%@",countdown,placementID]];
    
    // 自定义倒计时回调，需要自行处理按钮文本显示
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *title = [NSString stringWithFormat:@"%lds | Skip",countdown/1000];
        if (countdown/1000) {
            [self.skipButton setTitle:title forState:UIControlStateNormal];
        }
    });
}

- (void)defaultAction {
    self.modelButton.selected = !self.modelButton.isSelected;
    self.modelButton.modelLabel.text = self.modelButton.isSelected ? @"Default Splash" : @"Splash";
}

#pragma mark - lazy
- (NSString *)defaultAdSourceConfigStr {
    // 获取开屏广告兜底配置json信息，可通过Taku后台获取，详情可以参考开屏集成文档上的说明
    NSString *str = @"{\"unit_id\":1331013,\"nw_firm_id\":22,\"adapter_class\":\"ATBaiduSplashAdapter\",\"content\":\"{\\\"button_type\\\":\\\"0\\\",\\\"ad_place_id\\\":\\\"7852632\\\",\\\"app_id\\\":\\\"e232e8e6\\\"}\"}";
    return str;
}

- (ATADFootView *)footView {
    if (!_footView) {
        _footView = [[ATADFootView alloc] init];
        
        __weak typeof(self) weakSelf = self;
        [_footView setClickLoadBlock:^{
            NSLog(@"点击加载");
            [weakSelf loadSplashAd];
        }];
        [_footView setClickReadyBlock:^{
            NSLog(@"点击准备");
            [weakSelf checkAd];
        }];
        [_footView setClickShowBlock:^{
            NSLog(@"点击展示");
            [weakSelf showSplashAd];
        }];
        
        if (![NSStringFromClass([self class]) containsString:@"Auto"]) {
            [_footView.loadBtn setTitle:@"Load Splash AD" forState:UIControlStateNormal];
            [_footView.readyBtn setTitle:@"Is Splash AD Ready" forState:UIControlStateNormal];
            [_footView.showBtn setTitle:@"Show Splash AD" forState:UIControlStateNormal];
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
        _modelButton.modelLabel.text = @"Default Splash";
        _modelButton.image.image = [UIImage imageNamed:@"splash"];
        _modelButton.selected = YES;
        [_modelButton addTarget:self action:@selector(defaultAction) forControlEvents:UIControlEventTouchUpInside];
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
        _textView.text = nil;
    }
    return _textView;
}



@end
