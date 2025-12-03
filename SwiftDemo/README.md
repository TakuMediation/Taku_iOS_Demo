# iOS_Demo_Swift

Demo使用说明：
如您需要使用自己的配置，请调整以下内容：

1. **Podfile 调整**

更换Adapter适配器，调整为您自己需要的之后，重新执行：
```bash
pod install --repo-update
```

当前Demo中已集成的Adapter：
- TPNVungleSDKAdapter
- TPNAdmobSDKAdapter  
- TPNMintegralSDKAdapter
- TPNYandexSDKAdapter

更多广告平台Adapter请访问SDK下载中心：https://portal.toponad.net/m/sdk/download?type=iOS

2. **AdSDKManager.swift 更换AppKey和AppId**

在 `SwiftDemo/AdDemo/AdSDKManager.swift` 文件中修改：
```swift
/// 后台应用ID
let kAppID = "您的AppID"

/// 后台应用级AppKey或账户级AppKey  
let kAppKey = "您的AppKey"
```

3. **具体广告类型示例代码.swift文件中，修改广告位ID**

各广告类型对应的文件和广告位ID：
- **开屏广告**: `AdSDKManager.swift` 中的 `FirstAppOpen_PlacementID`
- **横幅广告**: `BannerVC.swift` 中的 `bannerPlacementID`
- **插屏广告**: `InterstitialVC.swift` 中的 `interstitialPlacementID`
- **激励视频**: `RewardedVC.swift` 中的 `rewardedPlacementID`
- **原生模板**: `NativeExpressVC.swift` 中的 `nativeExpressPlacementID`
- **原生自渲染**: `NativeSelfRenderVC.swift` 中的 `nativeSelfRenderPlacementID`

======================================================================

Demo Usage Instructions:
If you need to use your own configurations, please modify the following:

1. **Podfile Adjustment**

Replace the Adapter dependencies with those required for your own setup.

After modification, run:
```bash
pod install --repo-update
```

Current integrated Adapters in Demo:
- TPNVungleSDKAdapter
- TPNAdmobSDKAdapter
- TPNMintegralSDKAdapter
- TPNYandexSDKAdapter

For more advertising platform Adapters, please visit SDK download center: https://portal.toponad.net/m/sdk/download?type=iOS

2. **AdSDKManager.swift - Replace AppKey and AppId**

Modify in `SwiftDemo/AdDemo/AdSDKManager.swift` file:
```swift
/// Application ID in the backend
let kAppID = "Your AppID"

/// Application-level AppKey or account-level AppKey in the backend
let kAppKey = "Your AppKey"
```

3. **Ad Example Code (.swift Files) - Modify Placement IDs**

Ad type files and corresponding placement IDs:
- **Splash Ad**: `FirstAppOpen_PlacementID` in `AdSDKManager.swift`
- **Banner Ad**: `bannerPlacementID` in `BannerVC.swift`
- **Interstitial Ad**: `interstitialPlacementID` in `InterstitialVC.swift`
- **Rewarded Video**: `rewardedPlacementID` in `RewardedVC.swift`
- **Native Express**: `nativeExpressPlacementID` in `NativeExpressVC.swift`
- **Native Self-Render**: `nativeSelfRenderPlacementID` in `NativeSelfRenderVC.swift`

======================================================================

## 项目结构 / Project Structure

```
SwiftDemo/
├── AdDemo/                          # 广告示例代码 / Ad demo code
│   ├── AdSDKManager.swift          # SDK管理器和开屏广告 / SDK manager and splash ad
│   ├── BannerVC.swift              # 横幅广告示例 / Banner ad example
│   ├── InterstitialVC.swift        # 插屏广告示例 / Interstitial ad example
│   ├── RewardedVC.swift            # 激励视频示例 / Rewarded video example
│   ├── NativeExpressVC.swift       # 原生模板广告示例 / Native express ad example
│   ├── NativeSelfRenderVC.swift    # 原生自渲染广告示例 / Native self-render ad example
│   ├── SplashVC.swift              # 开屏广告页面 / Splash ad page
│   └── SDKConfig/                  # SDK配置工具 / SDK configuration tools
└── Others/                         # 其他工具类 / Other utilities
```

## 技术要求 / Technical Requirements

- **iOS版本**: 13.0+
- **Swift版本**: 5.0+
- **Xcode版本**: 12.0+
- **TopOn SDK版本**: 6.4.92

## 集成文档 / Integration Documentation

https://help.takuad.com/docs/bPMOE6

## 注意事项 / Notes

1. 首次运行前请确保执行 `pod install --repo-update`
2. 如需测试真实广告，请替换为您自己的AppID、AppKey和广告位ID
3. 发布前请移除 `TPNDebugUISDK` 调试工具
4. 建议在真机上测试广告功能

1. Please run `pod install --repo-update` before first launch
2. Replace with your own AppID, AppKey and Placement IDs for real ad testing
3. Remove `TPNDebugUISDK` debug tool before release
4. Recommend testing ad functionality on real devices