//
//  SDKGlobalConfigTool.swift
//  SwiftDemo
//
//  Created by ltz on 2025/2/12.
//

import Foundation
import AnyThinkSDK

class SDKGlobalConfigTool: NSObject {
    
    /// 自定义流量分组规则，规则 key=value，请在参数广告位ID加载广告之前调用本方法进行设置
    /// 后台修改流量分组规则后, 5分钟左右生效 ; 本地流量分组策略缓存沙盒30分钟
    /// - Parameters:
    ///   - key: 规则的key
    ///   - value: 规则value
    ///   - placementID: 广告位ID
    static func joinSegmentRule(withKey key: String, value: String, placementID: String) {
        // 因广告位策略会有30min沙盒缓存，测试时可以尝试删除重装，在加载广告（load）之前通过本方法设置自定义流量分组规则。
        // 例：
        // 后台配置的流量分组自定义规则为：isTest=1
        // 那么使用本方法: SDKGlobalConfigTool.joinSegmentRule(withKey: "isTest", value: "1", placementID: placementID)
        ATSDKGlobalSetting.sharedManager().setCustomData([key: value], forPlacementID: placementID)
    }
    
    /// 设置自定义配置，报表或特殊功能中使用
    /// - Parameter dataDict: 自定义数据字典
    static func setCustomData(_ dataDict: [String: Any]) {
        // 常用的Key 可在报表体现
        // kATCustomDataUserIDKey: 用户ID 值是String
        // kATCustomDataAgeKey: 用户年龄 值是Integer
        // kATCustomDataGenderKey: 用户性别 值是Integer
        
        ATSDKGlobalSetting.sharedManager().customData = dataDict
    }
    
    /// 用户自定义上传的iOS的设备ID(可在报表体现，对应set_idfa字段)
    /// - Parameter idfaString: IDFA字符串
    static func setCustomDeviceIDFA(_ idfaString: String) {
        // let UID2Info = ATUID2Info()
        // UID2Info.UID2Token = "text_UID2Token"
        
        ATSDKGlobalSetting.sharedManager().setDeviceInfoConfig { deviceInfoConfig in
            deviceInfoConfig?.idfaStr = idfaString
            // deviceInfoConfig?.UID2Info = UID2Info
        }
    }
    
    /// 设置自定义渠道字符串(可在报表体现，对应channel字段)
    /// - Parameter channelStr: 渠道字符串
    static func setCustomChannel(_ channelStr: String) {
        ATSDKGlobalSetting.sharedManager().channel = channelStr
    }
    
    /// 设置禁止SDK上报的项目
    static func setDeniedUploadInfo() {
        ATSDKGlobalSetting.sharedManager().setDeniedUploadInfoArray([
            kATDeviceDataInfoBatteryKey
            // ATSDKGlobalSetting.h 中的其他可选项：
            // kATDeviceDataInfoOSVersionNameKey,
            // kATDeviceDataInfoOSVersionCodeKey,
            // kATDeviceDataInfoPackageNameKey,
            // kATDeviceDataInfoAppVersionCodeKey,
            // kATDeviceDataInfoAppVersionNameKey,
            // kATDeviceDataInfoBrandKey,
            // kATDeviceDataInfoModelKey,
            // kATDeviceDataInfoScreenKey,
            // kATDeviceDataInfoNetworkTypeKey,
            // kATDeviceDataInfoMNCKey,
            // kATDeviceDataInfoMCCKey,
            // kATDeviceDataInfoLanguageKey,
            // kATDeviceDataInfoTimeZoneKey,
            // kATDeviceDataInfoUserAgentKey,
            // kATDeviceDataInfoOrientKey,
            // kATDeviceDataInfoIDFAKey,
            // kATDeviceDataInfoIDFVKey,
            // kATDeviceDataInfoSIMCardStateKey,
        ])
    }
    
    /// 设置应用维度过滤
    /// - Parameter appleIdArr: 例如: ["id529479190"]
    static func enableAppFilter(_ appleIdArr: [String]) {
        ATSDKGlobalSetting.sharedManager().setExludeAppleIdArray(appleIdArr)
    }
    
    /// 设置广告位维度过滤
    /// - Parameter placementIDArr: 例如: ["b5bacad26a752a"]，需要替换为您期望过滤的广告位ID
    static func enablePlacementFilter(_ placementIDArr: [String]) {
        ATAdManager.shared().setAdSourceCustomizeFillterPlacementIDArray(placementIDArr)
    }
    
    /// 开启广告源维度过滤
    /// - Parameter adSourceIDArr: 需要替换为您期望过滤的广告源ID
    static func enableAdSourceFilter(_ adSourceIDArr: [String]) {
        ATAdManager.shared().adSourceCustomizeFillter = { extra in
            guard let extraDict = extra as? [String: Any],
                  let adSourceID = extraDict["adsource_id"] as? String else {
                return false
            }
            
            if adSourceIDArr.contains(adSourceID) {
                ATDemoLog("AdSourceFilter 过滤: \(extra)")
                return true
            } else {
                print("AdSourceFilter 不过滤: \(extra)")
                return false
            }
        }
    }
    
    /// 开启广告位下的某些广告平台过滤
    /// - Parameters:
    ///   - placementID: 广告位ID
    ///   - networkFirmIDArr: 广告平台编号ID
    static func enableAdPlatformFilter(withPlacementID placementID: String, networkFirmIDArray: [NSNumber]) {
        ATAdManager.shared().setExludePlacementid(placementID, networkFirmIDArray: networkFirmIDArray)
    }
    
    /// 海外Pangle隐私配置
    /// Pangle SDK 在v7.1+ 移除了 COPPA及CCPA设置，统一使用 PAConsent 。SDK 在 v6.4.56 及以上版本中增加了对应的API来方便您根据情况自行设置。
    /// 注：未设置时 Pangle SDK 默认状态为 Consent。
    static func pangleCOPPACCPASetting() {
        // import AnyThinkPangleAdapter
        
        /*
        enum ATPAGPAConsentType: Int {
            case consent = 0      // User has granted the consent
            case noConsent = 1    // User doesn't grant consent
        }
        */
        
        // 想要填充广告用此方法
        // ATPangleConfigure.setPAGPAConsentType(.consent)
        
        // 不填充广告用此方法
        // ATPangleConfigure.setPAGPAConsentType(.noConsent)
    }
}
