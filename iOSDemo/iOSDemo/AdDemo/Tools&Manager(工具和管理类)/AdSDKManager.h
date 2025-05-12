//
//  AdSDKManager.h
//  iOSDemo
//
//  Created by ltz on 2025/3/26.
//

#import <Foundation/Foundation.h>
#import <AnyThinkSDK/AnyThinkSDK.h>
#import <AnyThinkInterstitial/AnyThinkInterstitial.h>
#import <AnyThinkSplash/AnyThinkSplash.h>

//初始化完成回调
typedef void (^AdManagerInitFinishBlock)(void);
//开屏加载回调
typedef void (^AdManagerSplashAdLoadBlock)(BOOL isSuccess);

//在后台的应用ID
#define kTakuAppID  @"a67f4ab312d2be"

//在后台的应用维度AppKey，或者是账号维度AppKey
#define kTakuAppKey @"7eae0567827cfe2b22874061763f30c9"

//冷启动开屏超时时间
#define FirstAppOpen_Timeout 8

//冷启动开屏广告位ID
#define FirstAppOpen_PlacementID @"b67f4ab43d2fe1"

@interface AdSDKManager : NSObject

+ (instancetype)sharedManager;
 
/// 应用若在欧盟地区发行，使用本方法初始化
- (void)initSDK_EU:(AdManagerInitFinishBlock)block;

/// 初始化SDK
- (void)initSDK;

#pragma mark - 开屏广告相关

/// 添加启动页,初始化SDK之前添加，用于冷启动开屏
- (void)addLaunchLoadingView;

/// 加载开屏广告
/// - Parameters:
///   - placementID: 广告位ID
///   - block: 结果回调
- (void)loadSplashAdWithPlacementID:(NSString *)placementID result:(AdManagerSplashAdLoadBlock)block;

/// 展示开屏广告
/// - Parameter placementID: 广告位ID
- (void)showSplashWithPlacementID:(NSString *)placementID;
 

@end


