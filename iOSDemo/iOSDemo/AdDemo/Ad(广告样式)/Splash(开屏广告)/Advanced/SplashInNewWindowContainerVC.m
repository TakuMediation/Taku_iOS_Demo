//
//  SplashInNewWindowContainerVC.m
//  iOSDemo
//
//  Created by ltz on 2025/2/28.
//

#import "SplashInNewWindowContainerVC.h"
#import "AppDelegate.h"
#import <StoreKit/StoreKit.h>

//开屏专用Window的根视图控制器
@interface SplashInNewWindowContainerVC () <SKStoreProductViewControllerDelegate>

//解决落地页不显示直接进入首页的逻辑标记
@property (assign, nonatomic) BOOL didJumpToDetailVC;

@end

@implementation SplashInNewWindowContainerVC

- (void)dealloc {
    //不用时移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.didJumpToDetailVC = NO;
    
    // 注册通知监听应用进入后台
    [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(appDidEnterBackground:)
                                          name:UIApplicationWillResignActiveNotification
                                          object:nil];
}
 
// AppDelegate.m
- (void)appDidEnterBackground:(UIApplication *)application {
    //点击广告后，用户没有进入应用内的落地页，且进入后台时，就跳转首页
    //即使用户自行进入后台，但由于点击标记限制和跳转应用内落地页条件限制，因此不会随意进入首页
    if (self.isUserClickAd && !self.didJumpToDetailVC) {
        [self enterHome];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    //这里getVisibleChildViewController是检测是否有push或者present的控制器了
    UIViewController * detailVC = [Tools getVisibleChildViewController:self];
    if (detailVC) {
        ATDemoLog(@"!!!走符合情况逻辑");
        //标记当用户从应用内的落地页返回时，需要进入首页
        self.didJumpToDetailVC = YES;
    }else {
        [self enterHome];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //根据标记，当再次展示此页面时，进入首页
    if (self.didJumpToDetailVC) {
        [self enterHome];
    }
}

- (void)enterHome {
    //切换回原来应用的Window
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window makeKeyAndVisible];
}
 
@end
