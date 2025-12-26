# iOS_Demo

Demo使用说明：
如您需要使用自己的配置，请调整一下内容：

1.podfile 调整更换Adapter适配器，调整为您自己需要的之后，重新执行pod install --repo-update

2.AdSDKManager.h 更换Appkey Appid

3.具体广告类型示例代码.m文件中，修改广告位ID

4.v6.4.93及其以前版本迁移至v6.5.xx,请查看迁移指南：https://help.takuad.com/docs/1EeNDDyJ
升级到iOS v6.5.xx 后，如果有自定义广告平台，必须按照以下文档完成新版本的适配，否则将无法请求自定义广告平台的广告。
[自定义广告平台接入说明](https://help.takuad.com/docs/A8t5SJDI)
[自定义基础适配器](https://help.takuad.com/docs/CQuN9eZp)
[自定义横幅广告适配器](https://help.takuad.com/docs/D4WU29qX)
[自定义插屏广告适配器](https://help.takuad.com/docs/XxoJoTHP)
[自定义激励视频广告适配器](https://help.takuad.com/docs/Kr88kUuU)
[自定义开屏广告适配器](https://help.takuad.com/docs/UpnVkNF1)
[自定义原生广告适配器](https://help.takuad.com/docs/HSVTKS6M)
[自定义客户端竞价（C2S）广告](https://help.takuad.com/docs/9IQVOUk5)
 
======================================================================

Demo Usage Instructions:
If you need to use your own configurations, please modify the following:

1.Podfile Adjustment

Replace the Adapter dependencies with those required for your own setup.

After modification, run:
pod install --repo-update
 
2.AdSDKManager.h

Replace the AppKey and AppId with your own credentials.

3.Ad Example Code (.m Files)

Modify the ad placement IDs in the sample ad implementation files.

4.For migration from v6.4.93 and earlier versions to v6.5.xx, please refer to the migration guide: https://help.takuad.com/docs/1EeNDDyJ  
After upgrading to iOS v6.5.xx, if you have a custom ad platform, you must complete the adaptation for the new version according to the following documents. Otherwise, ads from the custom ad platform will not be available.  
[Custom Ad Platform Integration Guide](https://help.takuad.com/docs/A8t5SJDI)  
[Custom Base Adapter](https://help.takuad.com/docs/CQuN9eZp)  
[Custom Banner Ad Adapter](https://help.takuad.com/docs/D4WU29qX)  
[Custom Interstitial Ad Adapter](https://help.takuad.com/docs/XxoJoTHP)  
[Custom Rewarded Video Ad Adapter](https://help.takuad.com/docs/Kr88kUuU)  
[Custom Splash Ad Adapter](https://help.takuad.com/docs/UpnVkNF1)  
[Custom Native Ad Adapter](https://help.takuad.com/docs/HSVTKS6M)  
[Custom Client-to-Server (C2S) Ads](https://help.takuad.com/docs/9IQVOUk5)

======================================================================

## Integration Instructions

https://help.takuad.com/docs/bPMOE6
