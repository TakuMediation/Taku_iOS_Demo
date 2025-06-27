//
//  SceneDelegate.m
//  iOSDemo
//
//  Created by ltz on 2025/1/5.
//

#import "SceneDelegate.h"
#import "BaseNavigationController.h"
#import "HomeViewController.h"
#import "PPVC.h"
#import "AdSDKManager.h"

API_AVAILABLE(ios(13.0))
@implementation SceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // 确保是UIWindowScene
    if (![scene isKindOfClass:[UIWindowScene class]]) {
        return;
    }
    
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    
    // 创建window
    self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
    self.window.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]; // kHexColor(0xffffff)
    
    if (@available(iOS 13.0, *)) {
        self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
    
    // 设置根视图控制器
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:[HomeViewController new]];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    // iOS 13+版本在这里调用PPVC，确保Scene已经完全建立
    dispatch_async(dispatch_get_main_queue(), ^{
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
    });
}

- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}

- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}

- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}

- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}

- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}

@end
