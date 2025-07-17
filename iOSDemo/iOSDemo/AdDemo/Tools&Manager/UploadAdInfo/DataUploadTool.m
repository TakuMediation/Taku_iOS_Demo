//
//  DataUploadTool.m
//  iOSDemo
//
//  Created by ltz on 2025/3/26.
//

#import "DataUploadTool.h"

//#import <AppsFlyerLib/AppsFlyerLib.h>
//
//#import <AdjustSdk/Adjust.h>
//#import <AdjustSdk/ADJAdRevenue.h>
//
//#import <FirebaseAnalytics/FirebaseAnalytics.h>
 
// extra参数示例以及说明:
//{
//    id = 84c3c5940e4fab2d8712299d631e09b3; // 每一次展示生成的展示id
//    "publisher_revenue" = "0.0015"; //每次展示带来的收益
//    "ad_source_id" = 9805; //广告源ID,可在开发者后台或SDK Open API通过广告源ID查询具体Network信息
//    "network_firm_id" = 8;   //参考Network Firm Id Table
//    "adsource_isHeaderBidding" = 0;  //是否为Heaer Bidding广告源，1为Header Bidding广告源
//    "adsource_price" = 1.5;  // eCPM 货币单位
//    precision = "publisher_defined"; // eCPM精度 publisher_defined:开发者自定义ecpm; exact:HB 实时竞价的ecpm estimated: 预估ecpm
//    "adsource_index" = 0;  //广告源优先级，从0开始优先级最高
//    "ecpm_level" = 1; //以eCPM为层级的排序
//    "segment_id" = 0; // 流量分组id
//    "adunit_format" = Splash; //广告类型
//    "adunit_id" = b5e65ad3ab084b; // 广告位id (Placement ID)
//    country = CN; // 国家
//    currency = USD; // 货币单位
//    "network_placement_id" = 887305510; // 第三方平台的unitid
//    "network_type" = Network; // network：三方广告 Corss_Promotion:交叉推广
//    "scenario_id" = f5e549727efc49;//广告场景id
//    "scenario_reward_name" = rewardedSence; // 广告场景激励名称
//    "scenario_reward_number" = 0; // 广告场景激励数量
//    channel = "test_channel"; //渠道号
//    "sub_channel" = "test_subchannel";//子渠道号
//    "custom_rule" =     {
//        "custom_data_key" = "custom_data_val";
//    };//自定义规则
//    "ext_info" =     {
//        "creative_id" = "42-348448957";//Offer的素材 ID
//        "is_deeplink" = 0;//是否为Deeplink或JumpURL的单子，1为Deeplink或JumpURL的单子
//        "offer_id" = "GDTONLINE-348448957";//Offer的广告 ID
//        "currencyCode" = "USD", // admob 展示收益货币单位
//        "precision" = 0, // admob 展示收益精度,0:未知 1:估算,2:发布商提供 3:精准
//        "value" = 0.1, // admob 展示收益具体值
//        "en_p" = "5GWtXa-X-sazi-xluLlqMyBCGWIIAZQ_8p7bM2-LqeQ", //百度价格加密字段,需TakuSDK>6.3.63,百度SDK≥=5.37
//    };//Taku Adx & OnlineAPI Offer & admob 的额外信息
//    "placement_type" = 1; // 广告位类型  1为真实广告位，2为共享广告位
//    "shared_placement_id" = p1en19jjiirsf3;// 共享广告位id
//    "user_load_extra_data" =     {// 在Load前传入自定义参数信息
//        "user_custom_data" = "media_val";
//    };
//}

@implementation DataUploadTool

/// 上报信息给应用App的服务器，例如某一个广告位中的某一个广告源加载失败的信息
/// - Parameters:
///   - placementID: 广告位ID
///   - info: 广告源的信息,搜索参考文档"回调信息说明"，获取详细字段含义
+ (void)uploadAdSourceLoadFailed:(NSString *)placementID info:(NSMutableDictionary *)info {
    //这个方法中可以自行收集广告源加载失败的信息，实现广告源加载，请参考上述或者文档中的字段说明
    //例如，在下面方法中，调用本方法收集error中的失败信息
    
//    /// Ad load fail
//    - (void)didFailToLoadADSourceWithPlacementID:(NSString*)placementID
//                                           extra:(NSDictionary*)extra
//                                           error:(NSError*)error;
//
//    /// Ad bidding fail
//    - (void)didFailBiddingADSourceWithPlacementID:(NSString*)placementID
//                                            extra:(NSDictionary*)extra
//                                            error:(NSError*)error;
    
    //实现您的上报逻辑
}
 
//解开注释前，请使用Cocoapods安装相关SDK
//#第三方数据统计SDK
//#  pod 'AppsFlyerFramework'
//#  pod 'Adjust'
//#  pod 'FirebaseAnalytics'

/// 上报展示收益数据到AF
/// - Parameter extra: 代理回调中的extra参数
+ (void)handleAppsFlyerRevenueReport:(NSDictionary *)extra {
    
//    NSString *unitId = extra[@"network_placement_id"];
//    // 对精度要求较高的开发者需自行进行转换
//    double price = [extra[@"publisher_revenue"] doubleValue];
//    NSString *currency = extra[@"currency"];
//    NSString *country = extra[@"country"];
//    
//    // Appsflyer提供多个key给开发者选用，开发者按自己需求使用，这里作为一个例子。
//    [[AppsFlyerLib shared] logEvent: AFEventPurchase
//    withValues:@{
//        AFEventParamContentId:unitId,
//        AFEventParamRevenue: @(price),
//        AFEventParamCurrency:currency,
//        AFEventParamCountry:country
//    }];
}

/// 上报展示收益数据到Adj
/// - Parameter extra: 代理回调中的extra参数
+ (void)handleAdjustRevenueReport:(NSDictionary *)extra {
    
//    // 对精度要求较高的开发者需自行进行转换
//    double price = [extra[@"publisher_revenue"] doubleValue];
//    NSString *currency = extra[@"currency"];
//    
//    // Source：收入来源(ADJAdRevenueSourceTaku在Adjust v4.37.1版本以上才有)
//    ADJAdRevenue *adRevenue = [[ADJAdRevenue alloc] initWithSource:@"Taku"];
//    // pass revenue and currency values
//    [adRevenue setRevenue:price currency:currency];
//    
//    // track ad revenue
//    [Adjust trackAdRevenue:adRevenue];
}

/// 上报展示收益数据到Fir
/// - Parameter extra: 代理回调中的extra参数
+ (void)handleFirebaseRevenueReport:(NSDictionary *)extra {
 
//    // 对精度要求较高的开发者需自行进行转换
//    double price = [extra[@"publisher_revenue"] doubleValue];
//    NSString *currency = extra[@"currency"];
//    
//    // 创建参数
//    NSDictionary *params = @{
//        //可添加其他键值对
//        kFIRParameterValue: @(price),
//        kFIRParameterCurrency: currency
//    };
//    // 上报收益数据
//    [FIRAnalytics logEventWithName:kFIREventAdImpression parameters:params];
}

@end
