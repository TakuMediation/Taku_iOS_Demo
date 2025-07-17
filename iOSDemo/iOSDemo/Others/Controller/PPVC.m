//
//  PPVC.m
//  iOSDemo
//
//  Created by Developer on 2024.
//  Copyright © 2024 AnyThink. All rights reserved.
//

#import "PPVC.h"
#import <AnyThinkSDK/AnyThinkSDK.h>

typedef NS_ENUM(NSInteger, PPVCDisplayMode) {
    PPVCDisplayModeList,        // 显示选项列表
    PPVCDisplayModePrivacyPolicy // 显示隐私政策
};

@interface PPVC () <WKNavigationDelegate, UITableViewDataSource, UITableViewDelegate>

// 列表模式相关
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISwitch *personalizedAdSwitch;
@property (nonatomic, assign) BOOL isSDKInitialized;
@property (nonatomic, assign) BOOL isPersonalizedAdEnabled;

// 隐私政策模式相关
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIButton *agreeButton;
@property (nonatomic, strong) UIButton *rejectButton;

// 通用属性
@property (nonatomic, copy) void(^agreementCallback)(void);
@property (nonatomic, strong) UIWindow *presentWindow;
@property (nonatomic, assign) PPVCDisplayMode displayMode;
@property (nonatomic, strong) UIView *containerView;

@end

@implementation PPVC

+ (void)showSDKManagementWithAgreementCallback:(void(^)(void))agreementCallback {
    
    // 访问苹果开发者官网，触发网络授权弹窗
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"https://developer.apple.com"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 无需处理返回结果
    }] resume];
    
    // 检查是否为首次启动
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL hasShownSDKManagement = [userDefaults boolForKey:@"HasShownSDKManagement"];
    
    if (hasShownSDKManagement) {
        // 非首次启动，直接执行回调
        if (agreementCallback) {
            agreementCallback();
        }
        return;
    }
    
    // 首次启动，展示SDK管理页面
    PPVC *ppvc = [[PPVC alloc] init];
    ppvc.agreementCallback = agreementCallback;
    ppvc.displayMode = PPVCDisplayModeList;
    
    // 创建新的window来展示SDK管理页面，兼容Scene方式
    UIWindow *window = [self createPresentationWindow];
    window.windowLevel = UIWindowLevelAlert;
    window.backgroundColor = [UIColor clearColor];
    window.rootViewController = ppvc;
    ppvc.presentWindow = window;
    
    [window makeKeyAndVisible];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    // 初始化状态
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.isSDKInitialized = [userDefaults boolForKey:@"IsSDKInitialized"];
    self.isPersonalizedAdEnabled = [userDefaults boolForKey:@"IsPersonalizedAdEnabled"];
    
    [self setupContainerView];
    
    if (self.displayMode == PPVCDisplayModeList) {
        [self setupListUI];
    } else {
        [self setupPrivacyPolicyUI];
        [self loadPrivacyPolicy];
    }
}

- (void)setupContainerView {
    if (self.displayMode == PPVCDisplayModeList) {
        // SDK管理页面 - 全屏显示
        self.view.backgroundColor = [UIColor whiteColor];
        
        self.containerView = [[UIView alloc] init];
        self.containerView.backgroundColor = [UIColor whiteColor];
        self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:self.containerView];
        
        // 全屏约束
        [NSLayoutConstraint activateConstraints:@[
            [self.containerView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
            [self.containerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
            [self.containerView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
            [self.containerView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
        ]];
    } else {
        // 隐私政策页面 - 非全屏显示
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        
        self.containerView = [[UIView alloc] init];
        self.containerView.backgroundColor = [UIColor whiteColor];
        self.containerView.layer.cornerRadius = 12.0;
        self.containerView.layer.masksToBounds = YES;
        self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:self.containerView];
        
        // 获取屏幕尺寸
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        CGFloat containerWidth = screenWidth * 0.85;  // 屏幕宽度的85%
        CGFloat containerHeight = screenHeight * 0.7; // 屏幕高度的70%
        
        // 设置容器视图约束 - 基于屏幕尺寸的百分比
        [NSLayoutConstraint activateConstraints:@[
            [self.containerView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
            [self.containerView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
            [self.containerView.widthAnchor constraintEqualToConstant:containerWidth],
            [self.containerView.heightAnchor constraintEqualToConstant:containerHeight]
        ]];
    }
}

- (void)setupListUI {
    // 创建标题标签
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"iOS Demo";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    [self.containerView addSubview:titleLabel];
    
    // 创建表格视图
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.rowHeight = 80;
    [self.containerView addSubview:self.tableView];
    
    // 设置约束
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        // 标题约束
        [titleLabel.topAnchor constraintEqualToAnchor:self.containerView.topAnchor constant:20],
        [titleLabel.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor constant:20],
        [titleLabel.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor constant:-20],
        [titleLabel.heightAnchor constraintEqualToConstant:30],
        
        // 表格视图约束
        [self.tableView.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:10],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.containerView.bottomAnchor]
    ]];
}

- (void)setupPrivacyPolicyUI {
    // 创建标题标签
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"隐私政策";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    [self.containerView addSubview:titleLabel];
    
    // 创建WebView
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    self.webView.navigationDelegate = self;
    self.webView.backgroundColor = [UIColor whiteColor];
    [self.containerView addSubview:self.webView];
    
    // 创建按钮容器
    UIView *buttonContainer = [[UIView alloc] init];
    [self.containerView addSubview:buttonContainer];
    
    // 创建同意按钮
    self.agreeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.agreeButton setTitle:@"同意" forState:UIControlStateNormal];
    [self.agreeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.agreeButton.backgroundColor = [UIColor systemBlueColor];
    self.agreeButton.layer.cornerRadius = 8.0;
    self.agreeButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.agreeButton addTarget:self action:@selector(agreeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [buttonContainer addSubview:self.agreeButton];
    
    // 创建拒绝按钮
    self.rejectButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.rejectButton setTitle:@"拒绝" forState:UIControlStateNormal];
    [self.rejectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.rejectButton.backgroundColor = [UIColor lightGrayColor];
    self.rejectButton.layer.cornerRadius = 8.0;
    self.rejectButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.rejectButton addTarget:self action:@selector(rejectButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [buttonContainer addSubview:self.rejectButton];
    
    // 设置约束
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    buttonContainer.translatesAutoresizingMaskIntoConstraints = NO;
    self.agreeButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.rejectButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        // 标题约束
        [titleLabel.topAnchor constraintEqualToAnchor:self.containerView.topAnchor constant:20],
        [titleLabel.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor constant:20],
        [titleLabel.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor constant:-20],
        [titleLabel.heightAnchor constraintEqualToConstant:30],
        
        // WebView约束
        [self.webView.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:10],
        [self.webView.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor constant:20],
        [self.webView.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor constant:-20],
        [self.webView.bottomAnchor constraintEqualToAnchor:buttonContainer.topAnchor constant:-10],
        
        // 按钮容器约束
        [buttonContainer.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor constant:20],
        [buttonContainer.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor constant:-20],
        [buttonContainer.bottomAnchor constraintEqualToAnchor:self.containerView.bottomAnchor constant:-20],
        [buttonContainer.heightAnchor constraintEqualToConstant:50],
        
        // 同意按钮约束（左边）
        [self.agreeButton.leadingAnchor constraintEqualToAnchor:buttonContainer.leadingAnchor],
        [self.agreeButton.topAnchor constraintEqualToAnchor:buttonContainer.topAnchor],
        [self.agreeButton.bottomAnchor constraintEqualToAnchor:buttonContainer.bottomAnchor],
        [self.agreeButton.widthAnchor constraintEqualToAnchor:buttonContainer.widthAnchor multiplier:0.45],
        
        // 拒绝按钮约束（右边）
        [self.rejectButton.trailingAnchor constraintEqualToAnchor:buttonContainer.trailingAnchor],
        [self.rejectButton.topAnchor constraintEqualToAnchor:buttonContainer.topAnchor],
        [self.rejectButton.bottomAnchor constraintEqualToAnchor:buttonContainer.bottomAnchor],
        [self.rejectButton.widthAnchor constraintEqualToAnchor:buttonContainer.widthAnchor multiplier:0.45]
    ]];
}

- (void)loadPrivacyPolicy {
    // 隐私政策URL - 开发人员请在此处填入您的隐私政策页面URL
    NSString *privacyPolicyURL = @"https://www.takuad.com/zh-cn/privacy-policy";
    
    // 加载隐私政策网页
    NSURL *url = [NSURL URLWithString:privacyPolicyURL];
    if (url) {
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    } else {
        NSLog(@"隐私政策URL格式错误: %@", privacyPolicyURL);
        // 如果URL无效，显示错误信息
        NSString *errorHTML = @"<html><body><h1>加载失败</h1><p>隐私政策页面无法加载，请检查网络连接或联系开发者。</p></body></html>";
        [self.webView loadHTMLString:errorHTML baseURL:nil];
    }
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SDKManagementCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    
    switch (indexPath.row) {
        case 0: {
            cell.textLabel.text = @"初始化SDK";
            cell.detailTextLabel.text = @"用户同意隐私协议后，进行SDK初始化";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        case 1: {
            cell.textLabel.text = @"展示广告";
            cell.detailTextLabel.text = @"需要初始化SDK后才能进行广告展示";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        case 2: {
            cell.textLabel.text = @"个性化广告服务开关";
            NSString *status = self.isPersonalizedAdEnabled ? @"开" : @"关";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"当前状态：%@", status];
            
            // 添加开关控件
            if (!self.personalizedAdSwitch) {
                self.personalizedAdSwitch = [[UISwitch alloc] init];
                [self.personalizedAdSwitch addTarget:self action:@selector(personalizedAdSwitchChanged:) forControlEvents:UIControlEventValueChanged];
            }
            self.personalizedAdSwitch.on = self.isPersonalizedAdEnabled;
            cell.accessoryView = self.personalizedAdSwitch;
            break;
        }
    }
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0: {
            // 初始化SDK
            [self initializeSDK];
            break;
        }
        case 1: {
            // 展示广告
            [self showAdvertisement];
            break;
        }
        case 2: {
            // 个性化广告服务开关 - 点击行也可以切换开关
            self.personalizedAdSwitch.on = !self.personalizedAdSwitch.on;
            [self personalizedAdSwitchChanged:self.personalizedAdSwitch];
            break;
        }
    }
}

#pragma mark - Actions

- (void)initializeSDK {
    if (self.isSDKInitialized) {
        [self showAlert:@"提示" message:@"SDK已经初始化完成"];
        return;
    }
    
    // 切换到隐私政策页面
    self.displayMode = PPVCDisplayModePrivacyPolicy;
    
    // 清除当前UI
    for (UIView *subview in self.containerView.subviews) {
        [subview removeFromSuperview];
    }
    
    // 设置隐私政策UI
    [self setupPrivacyPolicyUI];
    [self loadPrivacyPolicy];
}

- (void)showAdvertisement {
    if (!self.isSDKInitialized) {
        [self showAlert:@"提示" message:@"请先进行SDK初始化"];
        return;
    }
    
    [self dismissSDKManagement];
    // 执行回调并关闭SDK管理页面
    if (self.agreementCallback) {
        self.agreementCallback();
    }
}

- (void)personalizedAdSwitchChanged:(UISwitch *)sender {
    self.isPersonalizedAdEnabled = sender.on;
    
    // 保存状态
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:self.isPersonalizedAdEnabled forKey:@"IsPersonalizedAdEnabled"];
    [userDefaults synchronize];
    
    [[ATAPI sharedInstance] setPersonalizedAdState:self.isPersonalizedAdEnabled?ATPersonalizedAdStateType:ATNonpersonalizedAdStateType];

    // 更新对应cell的副标题文本
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    NSString *status = self.isPersonalizedAdEnabled ? @"开" : @"关";
    cell.detailTextLabel.text = [NSString stringWithFormat:@"当前状态：%@", status];
}

- (void)agreeButtonTapped {
    // 用户点击同意按钮，保存已展示SDK管理的标记和SDK初始化状态
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:@"HasShownSDKManagement"];
    [userDefaults setBool:YES forKey:@"IsSDKInitialized"];
    [userDefaults synchronize];
    
    self.isSDKInitialized = YES;
    
    // 显示初始化成功提示，然后返回SDK管理页面
    [self showAlert:@"初始化成功" message:@"SDK初始化完成，现在可以展示广告了" completion:^{
        // 切换回SDK管理页面
        self.displayMode = PPVCDisplayModeList;
        
        // 移除当前容器视图
        [self.containerView removeFromSuperview];
        self.containerView = nil;
        
        // 重新设置容器视图和列表UI
        [self setupContainerView];
        [self setupListUI];
    }];
}

- (void)rejectButtonTapped {
    // 用户点击拒绝按钮，退出应用
    exit(0);
}

- (void)dismissSDKManagement {
    [self.presentWindow resignKeyWindow];
    self.presentWindow.hidden = YES;
    self.presentWindow = nil;
}

- (void)showAlert:(NSString *)title message:(NSString *)message {
    [self showAlert:title message:message completion:nil];
}

- (void)showAlert:(NSString *)title message:(NSString *)message completion:(void(^)(void))completion {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (completion) {
            completion();
        }
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    // WebView加载完成
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"WebView加载失败: %@", error.localizedDescription);
}

#pragma mark - Private Methods

+ (UIWindow *)createPresentationWindow {
    UIWindow *window = nil;
    
    if (@available(iOS 13.0, *)) {
        // iOS 13及以上版本，优先使用Scene方式
        UIWindowScene *windowScene = [self getCurrentWindowScene];
        if (windowScene) {
            window = [[UIWindow alloc] initWithWindowScene:windowScene];
        } else {
            // 如果获取不到WindowScene，降级使用传统方式
            window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        }
    } else {
        // iOS 13以下版本，使用传统方式
        window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    
    return window;
}

+ (UIWindowScene *)getCurrentWindowScene API_AVAILABLE(ios(13.0)) {
    // 方法1: 从当前活跃的场景中获取
    for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
        if ([scene isKindOfClass:[UIWindowScene class]]) {
            UIWindowScene *windowScene = (UIWindowScene *)scene;
            if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                return windowScene;
            }
        }
    }
    
    // 方法2: 从所有连接的场景中获取第一个WindowScene
    for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
        if ([scene isKindOfClass:[UIWindowScene class]]) {
            return (UIWindowScene *)scene;
        }
    }
    
    // 方法3: 从主窗口获取（如果存在）
    UIWindow *keyWindow = [self getKeyWindow];
    if (keyWindow && keyWindow.windowScene) {
        return keyWindow.windowScene;
    }
    
    return nil;
}

+ (UIWindow *)getKeyWindow {
    UIWindow *keyWindow = nil;
    
    if (@available(iOS 13.0, *)) {
        // iOS 13及以上版本
        NSSet<UIScene *> *connectedScenes = [UIApplication sharedApplication].connectedScenes;
        for (UIScene *scene in connectedScenes) {
            if ([scene isKindOfClass:[UIWindowScene class]]) {
                UIWindowScene *windowScene = (UIWindowScene *)scene;
                for (UIWindow *window in windowScene.windows) {
                    if (window.isKeyWindow) {
                        keyWindow = window;
                        break;
                    }
                }
                if (keyWindow) break;
            }
        }
        
        // 如果没有找到keyWindow，尝试获取第一个可见窗口
        if (!keyWindow) {
            for (UIScene *scene in connectedScenes) {
                if ([scene isKindOfClass:[UIWindowScene class]]) {
                    UIWindowScene *windowScene = (UIWindowScene *)scene;
                    for (UIWindow *window in windowScene.windows) {
                        if (!window.isHidden) {
                            keyWindow = window;
                            break;
                        }
                    }
                    if (keyWindow) break;
                }
            }
        }
    } else {
        // iOS 13以下版本
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        keyWindow = [UIApplication sharedApplication].keyWindow;
        if (!keyWindow) {
            // 如果keyWindow为空，尝试从windows数组中获取第一个可见窗口
            for (UIWindow *window in [UIApplication sharedApplication].windows) {
                if (!window.isHidden) {
                    keyWindow = window;
                    break;
                }
            }
        }
#pragma clang diagnostic pop
    }
    
    return keyWindow;
}

@end
