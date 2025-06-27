//
//  AppDelegate.m
//  iOSDemo
//
//  Created by ltz on 2025/1/5.
//

#import "AppDelegate.h"

#import <AnyThinkSDK/AnyThinkSDK.h>
#import "TestModeTool.h"
#import "BaseNavigationController.h"
#import "AdSDKManager.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import "PPVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
 
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //开启Demo日志打印
    DemoLogAccess(1);
 
    // iOS 13以下版本仍使用传统方式
    if (@available(iOS 13.0, *)) {
        // iOS 13及以上版本使用Scene Delegate
        // 在这里只进行SDK初始化，UI创建交给SceneDelegate处理
        // PPVC的调用将在SceneDelegate中进行
    } else {
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
    }
      
    return YES;
}

#pragma mark - UISceneSession lifecycle

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options API_AVAILABLE(ios(13.0)) {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    UISceneConfiguration *configuration = [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
    configuration.delegateClass = NSClassFromString(@"SceneDelegate");
    return configuration;
}

- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions API_AVAILABLE(ios(13.0)) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}
 
- (void)applicationDidBecomeActive:(UIApplication *)application {
    if (@available(iOS 14, *)) {
        //申请ATT权限 - 注意！若使用含欧盟地区初始化流程，请在initSDK_EU方法中调用申请ATT权限
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            
        }];
    } else {
        // Fallback on earlier versions
    }
}
  
#pragma mark - Demo UI 可忽略
- (void)setupDemoUI {
    self.window = [UIWindow new];
    self.window.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]; // kHexColor(0xffffff)
    if (@available(iOS 13.0, *)) {
       self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
    
    // 访问苹果开发者官网，触发网络授权弹窗
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"https://developer.apple.com"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 无需处理返回结果
    }] resume];
      
    BaseNavigationController * nav = [[BaseNavigationController alloc] initWithRootViewController:[HomeViewController new]];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
}

@end
