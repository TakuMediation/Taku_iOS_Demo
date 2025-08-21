//
//  AppDelegate.m
//  iOSDemo
//
//  Created by ltz on 2025/1/5.
//

#import "AppDelegate.h"

#import <AnyThinkSDK/AnyThinkSDK.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import "AdSDKManager.h"

#import "BaseNavigationController.h"
#import "PPVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
 
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //开启Demo日志打印
    DemoLogAccess(1);
 
    //布局demoUI,无需接入
    [self setupDemoUI];
    
    // iOS 13以下版本在这里调用PPVC
    [PPVC showSDKManagementWithAgreementCallback:^{//Demo首次启动展示隐私政策弹窗，可选实际是否需要根据您的产品需求来决定是否显示

        //开屏广告展示启动图
        [[AdSDKManager sharedManager] addLaunchLoadingView];
        //初始化SDK，必须接入，在非欧盟地区发行的应用，需要用此方法初始化SDK接入，欧盟地区初始化替换为[[AdSDKManager sharedManager] initSDK_EU:];
        [[AdSDKManager sharedManager] initSDK];
        //初始化广告SDK完成
        
        //加载开屏广告
        [[AdSDKManager sharedManager] loadSplashAdWithPlacementID:FirstAppOpen_PlacementID result:^(BOOL isSuccess) {
            //加载成功
            if (isSuccess) {
                //展示开屏广告
                [[AdSDKManager sharedManager] showSplashWithPlacementID:FirstAppOpen_PlacementID];
            }
        }];
        
        //含欧盟地区初始化流程
    //    //欧盟地区初始化替换为[[AdSDKManager sharedManager] initSDK_EU:];
    //    [[AdSDKManager sharedManager] initSDK_EU:^{
    //        //初始化广告SDK完成
    //
    //        //加载开屏广告
    //        [[AdSDKManager sharedManager] loadSplashAdWithPlacementID:FirstAppOpen_PlacementID result:^(BOOL isSuccess) {
    //            //加载成功
    //            if (isSuccess) {
    //                //展示开屏广告
    //                [[AdSDKManager sharedManager] showSplashWithPlacementID:FirstAppOpen_PlacementID];
    //            }
    //        }];
    //    }];
    }];
      
    return YES;
}

#pragma mark - lifecycle
- (void)applicationDidBecomeActive:(UIApplication *)application {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 14, *)) {
            //申请ATT权限 - 注意！若使用含欧盟地区初始化流程，请在initSDK_EU方法中调用申请ATT权限
            [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                
            }];
        } else {
            // Fallback on earlier versions
        }
    });
}
  
#pragma mark - Demo UI 可忽略
- (void)setupDemoUI {
    self.window = [UIWindow new];
    self.window.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]; // kHexColor(0xffffff)
    if (@available(iOS 13.0, *)) {
       self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
 
    BaseNavigationController * nav = [[BaseNavigationController alloc] initWithRootViewController:[HomeViewController new]];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
}

@end
