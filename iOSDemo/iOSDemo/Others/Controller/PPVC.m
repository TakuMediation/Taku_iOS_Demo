//
//  PPVC.m
//  iOSDemo
//
//  Created by Developer on 2024.
//  Copyright © 2024 AnyThink. All rights reserved.
//

#import "PPVC.h"

@interface PPVC () <WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIButton *agreeButton;
@property (nonatomic, strong) UIButton *rejectButton;
@property (nonatomic, copy) void(^agreementCallback)(void);
@property (nonatomic, strong) UIWindow *presentWindow;

@end

@implementation PPVC

+ (void)showPrivacyPolicyWithAgreementCallback:(void(^)(void))agreementCallback {
    // 检查是否为首次启动
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL hasShownPrivacyPolicy = [userDefaults boolForKey:@"HasShownPrivacyPolicy"];
    
    if (hasShownPrivacyPolicy) {
        // 非首次启动，直接执行回调
        if (agreementCallback) {
            agreementCallback();
        }
        return;
    }
    
    // 首次启动，展示隐私政策页面
    PPVC *ppvc = [[PPVC alloc] init];
    ppvc.agreementCallback = agreementCallback;
    
    // 创建新的window来展示隐私政策页面
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.windowLevel = UIWindowLevelAlert;
    window.backgroundColor = [UIColor clearColor];
    window.rootViewController = ppvc;
    ppvc.presentWindow = window;
    
    [window makeKeyAndVisible];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    [self setupUI];
    [self loadPrivacyPolicy];
}

- (void)setupUI {
    // 创建容器视图
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor whiteColor];
    containerView.layer.cornerRadius = 12.0;
    containerView.layer.masksToBounds = YES;
    [self.view addSubview:containerView];
    
    // 设置容器视图约束（非全屏，根据屏幕尺寸动态调整）
    containerView.translatesAutoresizingMaskIntoConstraints = NO;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat containerWidth = screenWidth * 0.85;  // 屏幕宽度的85%
    CGFloat containerHeight = screenHeight * 0.7; // 屏幕高度的70%
    
    [NSLayoutConstraint activateConstraints:@[
        [containerView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [containerView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [containerView.widthAnchor constraintEqualToConstant:containerWidth],
        [containerView.heightAnchor constraintEqualToConstant:containerHeight]
    ]];
    
    // 创建标题标签
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"隐私政策";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    [containerView addSubview:titleLabel];
    
    // 创建WebView
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    self.webView.navigationDelegate = self;
    self.webView.backgroundColor = [UIColor whiteColor];
    [containerView addSubview:self.webView];
    
    // 创建按钮容器
    UIView *buttonContainer = [[UIView alloc] init];
    [containerView addSubview:buttonContainer];
    
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
        [titleLabel.topAnchor constraintEqualToAnchor:containerView.topAnchor constant:20],
        [titleLabel.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor constant:20],
        [titleLabel.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor constant:-20],
        [titleLabel.heightAnchor constraintEqualToConstant:30],
        
        // WebView约束
        [self.webView.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:10],
        [self.webView.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor constant:20],
        [self.webView.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor constant:-20],
        [self.webView.bottomAnchor constraintEqualToAnchor:buttonContainer.topAnchor constant:-10],
        
        // 按钮容器约束
        [buttonContainer.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor constant:20],
        [buttonContainer.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor constant:-20],
        [buttonContainer.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor constant:-20],
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

#pragma mark - Button Actions

- (void)agreeButtonTapped {
    // 用户点击同意按钮，保存已展示隐私政策的标记
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:@"HasShownPrivacyPolicy"];
    [userDefaults synchronize];
    
    if (self.agreementCallback) {
        self.agreementCallback();
    }
    [self dismissPrivacyPolicy];
}

- (void)rejectButtonTapped {
    // 用户点击拒绝按钮，退出应用
    exit(0);
}

- (void)dismissPrivacyPolicy {
    [self.presentWindow resignKeyWindow];
    self.presentWindow.hidden = YES;
    self.presentWindow = nil;
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    // WebView加载完成
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"WebView加载失败: %@", error.localizedDescription);
}

@end
