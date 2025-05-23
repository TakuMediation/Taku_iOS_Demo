//
//  AdLoadConfigTool.h
//  iOSDemo
//
//  Created by ltz on 2025/2/12.
//

#import <Foundation/Foundation.h>
//导入头文件
#import <AnyThinkSDK/AnyThinkSDK.h>
 
@interface SDKGlobalConfigTool : NSObject

/// 自定义流量分组规则，规则 key=value，请在参数广告位ID加载广告之前调用本方法进行设置
/// 后台修改流量分组规则后, 5分钟左右生效 ; 本地流量分组策略缓存沙盒30分钟
/// - Parameters:
///   - key: 规则的key
///   - value: 规则value
///   - placementID: 广告位ID
+ (void)joinSegmentRuleWithKey:(NSString *)key value:(NSString *)value placementID:(NSString *)placementID;

/// 设置自定义配置
+ (void)setCustomData:(NSDictionary *)dataDict;

/// 用户自定义上传的iOS的设备ID(可在报表体现，对应set_idfa字段)
/// - Parameter idfaString: 字符串
+ (void)setCustomDeviceIDFA:(NSString *)idfaString;

/// 设置自定义渠道字符串(可在报表体现，对应channel字段)
/// - Parameters:
///   - channelStr: 渠道字符串
+ (void)setCustomChannel:(NSString *)channelStr;

/// 设置禁止SDK上报的项目
+ (void)setDeniedUploadInfo;

/// 开启应用维度过滤
/// - Parameter appleIDArr: 例如: @[@"id529479190"]，需要替换为您期望过滤的应用ID
+ (void)enableAppFilter:(NSArray *)appleIDArr;

/// 开启广告位维度过滤
/// - Parameter appleIdArr: 例如: @[@"b5bacad26a752a"]，需要替换为您期望过滤的广告位ID
+ (void)enablePlacementFilter:(NSArray *)placementIDArr;

/// 开启广告源维度过滤
/// - Parameter placementIDArr: 需要替换为您期望过滤的广告源ID
+ (void)enableAdSourceFilter:(NSArray *)adSourceIDArr;
 
/// 开启广告位下的某些广告平台过滤
/// - Parameters:
///   - placementID: 广告位ID
///   - networkFirmIDArr: 广告平台编号ID，例如@[@(ATNetworkFirmIDTypeFacebook),@(ATNetworkFirmIDTypeAdmob),@(ATNetworkFirmIDTypeCSJ)]
+ (void)enableAdPlatformFilterWithPlacementID:(NSString *)placementID networkFirmIDArray:(NSArray <NSNumber *>*)networkFirmIDArr;
 
/// 海外Pangle隐私配置
/// Pangle SDK 在v7.1+ 移除了 COPPA及CCPA设置，统一使用 PAConsent 。Taku SDK 在 v6.4.56 及以上版本中增加了对应的API来方便您根据情况自行设置。
/// 注：未设置时 Pangle SDK 默认状态为 Consent。
+ (void)pangleCOPPACCPASetting;

@end
 
