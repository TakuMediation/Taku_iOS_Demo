//
//  TakuAdManager.m
//  TakuSDKDemo
//
//  Created by Martin Lau on 2020/1/10.
//  Copyright © 2020 AnyThink. All rights reserved.
//

#import "TaKuAdManager.h"
#import <AnyThinkSDK/AnyThinkSDK.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import "ATBaiduTemplateRenderingAttribute.h"

//#import <AnyThinkMintegralAdapter/ATMintegralConfigure.h>
//#import <AnyThinkVungleAdapter/AnyThinkVungleAdapter.h>
//#import <AnyThinkAdColonyAdapter/ATAdColonyConfigure.h>
//#import <AnyThinkMyTargetAdapter/ATMyTargetConfigure.h>
//#import <AnyThinkFacebookAdapter/ATFacebookConfigure.h>
//#import <AnyThinkKuaiShouAdapter/ATKSExtraConfig.h>

//#import <AnyThinkKlevinAdapter/AnyThinkKlevinAdapter.h>
//#import <AnyThinkTTAdapter/AnyThinkTTAdapter.h>
//#import <AnyThinkBaiduAdapter/AnyThinkBaiduAdapter.h>
//#import <AnyThinkGDTAdapter/AnyThinkGDTAdapter.h>
//
//
//#import <BaiduMobAdSDK/BaiduMobAdSetting.h>
//#import <KlevinAdSDK/KlevinAdSDK.h>
//#import <GDTSDKConfig.h>
//#import <VungleSDK/VungleSDK.h>



@implementation TaKuAdManager
+(instancetype) sharedManager {
    static TaKuAdManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[TaKuAdManager alloc] init];
        
    });
    return sharedManager;
}

-(void) initSDK {
    
    [self setNetworkDeviceInfo];
    
//    [ATAPI setDebuggerConfig:^(ATDebuggerConfig *debuggerConfig) {
//
//        debuggerConfig.deviceIdfaStr = @"56A0A11B-D6D9-482D-83AD-AA8513E0D34C";
//
//        debuggerConfig.netWorkType = ATAdNetWorkMetaType;
//
//        // GDT
//        debuggerConfig.gdt_nativeAdType = ATGDTNativeAdVideoTemplateType;
//        debuggerConfig.gdt_interstitialAdType = ATGDTInterstitialAdFullScreenVideoType;
//
//        // Meta
//        debuggerConfig.meta_nativeAdType = ATMetaNativeAdNativeBannerSelfRenderType;
//
//        // 快手
//        debuggerConfig.kuaiShou_nativeAdType = ATKuaiShouNativeAdDrawFeedType;
//
//        // Nend
//        debuggerConfig.nend_interstitialAdType = ATNendInterstitialAdFullScreenType;
//
//        // 穿山甲
//        debuggerConfig.csj_nativeAdType = ATCSJNativeAdFeedSelfRenderType;
//
//        // MTG
//        debuggerConfig.mintegral_nativeAdType = ATMintegralNativeAdSelfRenderType;
//        debuggerConfig.mintegral_interstitialAdType = ATMintegralInterstitialAdVideoType;

//        // 百度
//        debuggerConfig.baidu_nativeAdType = ATBaiduNativeAdTemplateType;
//        debuggerConfig.baidu_interstitialAdType = ATBaiduInterstitialAdFullScreenVideoType;
//
//        // admob
//        debuggerConfig.adMob_nativeAdType = ATAdMobNativeAdPictureType;
//        debuggerConfig.adMob_interstitialAdType = ATAdMobInterstitialAdPictureType;
//
//    }];
    
    [ATAPI setLogEnabled:YES];
        
    [ATAPI integrationChecking];

    [ATAPI setHeaderBiddingTestModeWithDeviceID:@"1F7DB84C-5DCF-4095-B059-F18A7D17946C"];
    // set personaliz state
    [[ATAPI sharedInstance] setPersonalizedAdState:ATPersonalizedAdStateType];

    //channel&subchannle -> customData.channel&subchannel
    [ATAPI sharedInstance].customData = @{kATCustomDataUserIDKey:@"test_custom_user_id",
                                          kATCustomDataChannelKey:@"custom_data_channel",
                                          kATCustomDataSubchannelKey:@"custom_data_subchannel",
                                          kATCustomDataAgeKey:@18,
                                          kATCustomDataGenderKey:@1,//流量分组的时候填写的值，需要跟该传入的值一致
                                          kATCustomDataNumberOfIAPKey:@19,
                                          kATCustomDataIAPAmountKey:@20.0f,
                                          kATCustomDataIAPCurrencyKey:@"usd",
    };
    
    [[ATAPI sharedInstance] setCustomData:@{
        kATCustomDataChannelKey:@"placement_custom_data_channel",
        kATCustomDataSubchannelKey:@"placement_custom_data_subchannel"
    } forPlacementID:@"b5c1b048c498b9"];


//    [[ATAPI sharedInstance] setDeniedUploadInfoArray:@[kATDeviceDataInfoOSVersionNameKey,
//                                                       kATDeviceDataInfoOSVersionCodeKey,
//                                                       kATDeviceDataInfoPackageNameKey,
//                                                       kATDeviceDataInfoAppVersionCodeKey,
//                                                       kATDeviceDataInfoAppVersionNameKey,
//                                                       kATDeviceDataInfoBrandKey,
//                                                       kATDeviceDataInfoModelKey,
//                                                       kATDeviceDataInfoScreenKey,
//                                                       kATDeviceDataInfoNetworkTypeKey,
//                                                       kATDeviceDataInfoMNCKey,
//                                                       kATDeviceDataInfoMCCKey,
//                                                       kATDeviceDataInfoLanguageKey,
//                                                       kATDeviceDataInfoTimeZoneKey,
//                                                       kATDeviceDataInfoUserAgentKey,
//                                                       kATDeviceDataInfoOrientKey,
//                                                       kATDeviceDataInfoIDFAKey,
//                                                       kATDeviceDataInfoIDFVKey]];
        
    [[ATAPI sharedInstance] getUserLocationWithCallback:^(ATUserLocation location) {
        if (location == ATUserLocationInEU) {
            NSLog(@"----------ATUserLocationInEU");
            if ([ATAPI sharedInstance].dataConsentSet == ATDataConsentSetUnknown) {
                NSLog(@"----------ATDataConsentSetUnknown");
            }
        }else if (location == ATUserLocationOutOfEU){
            NSLog(@"----------ATUserLocationOutOfEU");
        }else{
            NSLog(@"----------ATUserLocationUnknown");
        }
    }];
                
    [[ATAPI sharedInstance] getAreaSuccess:^(NSString *areaCodeStr) {
        NSLog(@"getArea:%@",areaCodeStr);
    } failure:^(NSError *error) {
            NSLog(@"getArea:%@",error.domain);
    }];
    
    ATBaiduTemplateRenderingAttribute *temp = [[ATBaiduTemplateRenderingAttribute alloc]init];
    temp.iconWidth = @"22";
    [[ATAdManager sharedManager] setBaiduTemplateRenderingAttribute: temp];
        
    // 设置系统平台信息，默认设置IOS=1
//    ATSystemPlatformTypeIOS = 1,
//    ATSystemPlatformTypeUnity = 2,
//    ATSystemPlatformTypeCocos2dx = 3,
//    ATSystemPlatformTypeCocosCreator = 4,
//    ATSystemPlatformTypeReactNative = 5,
//    ATSystemPlatformTypeFlutter = 6,
//    ATSystemPlatformTypeAdobeAir = 7
    [[ATAPI sharedInstance] setSystemPlatformType:ATSystemPlatformTypeIOS];
        
    // init SDK
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            [[ATAPI sharedInstance] startWithAppID:kTaKuAppID appKey:kTaKuAppKey error:nil];
        }];
    } else {
        // Fallback on earlier versions
        [[ATAPI sharedInstance] startWithAppID:kTaKuAppID appKey:kTaKuAppKey error:nil];
    }
}

- (void)setNetworkDeviceInfo{
    
//    [ATVungleExtraConfig setExtraConfig:^(VungleSDK * _Nullable configuration) {
//        [VungleSDK setPublishIDFV:YES];
//    }];
//
//    [ATGDTExtraConfig setExtraConfig:^(GDTSDKConfig * _Nullable configuration) {
//        [GDTSDKConfig forbiddenIDFA:YES];
//    }];
//
//    [ATBaiduExtraConfig setExtraConfig:^(BaiduMobAdSetting * _Nullable configuration) {
//        [configuration setBDPermissionEnable:YES];
//    }];
//
//    [ATKSExtraConfig setExtraConfig:^(KSAdSDKManager * _Nullable configuration) {
//
//        [KSAdSDKManager setIdfaBlock:^NSString * _Nullable{
//
//            return @"";
//        }];
//    }];
//
//    [ATKlevinExtraConfig setExtraConfig:^(KlevinAdSDKConfiguration * _Nullable configuration) {
//        configuration.mediaIDFA = @"";
//    }];
//
//
//    [ATCSJExtraConfig setExtraConfig:^(BUAdSDKConfiguration * _Nullable configuration) {
//        configuration.customIdfa = @"";
//    }];
//
//    [ATAPI setDeviceInfoConfig:^(ATDeviceInfoConfig * _Nullable deviceInfoConfig) {
//        deviceInfoConfig.idfaStr = @"56A0A11B-D6D9-482D-83AD-AA8513E0D34C";
//    }];
    

}


@end
