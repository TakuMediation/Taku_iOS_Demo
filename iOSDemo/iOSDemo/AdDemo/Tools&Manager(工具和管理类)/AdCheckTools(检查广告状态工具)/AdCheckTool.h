//
//  AdCheckTool.h
//  iOSDemo
//
//  Created by ltz on 2025/4/27.
//

#import <Foundation/Foundation.h>
#import <AnyThinkSDK/AnyThinkSDK.h>

typedef enum AdType {
    AdTypeUnknown = 0,
    AdTypeInterstitial,
    AdTypeRewardVideo,
    AdTypeSplash,
    AdTypeBanner,
    AdTypeNative,
}AdType;

@interface AdCheckTool : NSObject
 
/// 查询广告加载状态
/// - Parameters:
///   - placementID: 目标广告位ID
///   - adType: 目标广告位ID对应的广告类型
+ (ATCheckLoadModel *)adLoadingStatusWithPlacementID:(NSString *)placementID adType:(AdType)adType;
  
/// 查询可用于展示的广告缓存
/// - Parameters:
///   - placementID: 目标广告位ID
///   - adType: 目标广告位ID对应的广告类型
+ (NSArray <NSDictionary *> *)getValidAdsForPlacementID:(NSString *)placementID adType:(AdType)adType;

@end
