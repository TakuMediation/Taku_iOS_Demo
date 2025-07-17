//
//  TestModeTool.m
//  iOSDemo
//
//  Created by ltz on 2025/2/12.
//

#import "TestModeTool.h"
#import <AnyThinkSDK/ATDebuggerConfigDefine.h>
 
@implementation TestModeTool

/// 在指定vc上展示Debug UI，建议直接使用系统的UIViewController，传入继承或者自定义的vc可能导致显示异常
/// 需要 pod 'AnyThinkDebugUISDK','1.0.3' 测试完毕请移除⚠️
/// - Parameter vc: 目标vc
+ (void)showDebugUI:(UIViewController *)vc {
    //引入头文件 #import <AnyThinkDebuggerUISDK/ATDebuggerAPI.h>
    //请注意，showType支持ATShowDebugUIPresent和ATShowDebugUIPush，如果遇到push不出来的情况，请保证您的导航控制器没有多余的继承.
    //唤起条件：
    //window - rootNavigation - viewController -> push debugUI
    //1.iOS SDK已经成功初始化
    //2.还未加载(load)任一广告
    //3.关闭调试模式，即移除 -[ATSDKGlobalSetting setDebuggerConfig:] 相关代码
    [[ATDebuggerAPI sharedInstance] showDebuggerInViewController:vc showType:ATShowDebugUIPresent debugkey:@"填入您的DebugKey，DebugKey在后台->账号管理->Key中获取，DebugKey需要与AppID，AppKey对应"];
}

/// 开启测试模式(每次只能指定一个广告平台，不一定100%填充广告)
/// 关闭测试模式，只需要注释掉相关方法即可关闭
/// 上线前请移除⚠️测试完毕请移除⚠️
/// - Parameters:
///   - type: 本次需要测试广告平台类型
///   - currentIDFAStr: 当前测试机器的idfa，必须传入有效值
+ (void)enableTestModeWith3rdSDKType:(ATAdNetWorkType)type currentIDFAStr:(NSString *)currentIDFAStr {

    [[ATSDKGlobalSetting sharedManager] setDebuggerConfig:^(ATDebuggerConfig * _Nullable debuggerConfig) {
        debuggerConfig.deviceIdfaStr = currentIDFAStr;
        //指定需要测试的广告平台名称类型
        debuggerConfig.netWorkType = ATAdNetWorkApplovinType;
        
//        指定广告平台的某一种类型
//        debuggerConfig.adx_nativeAdType = ATADXNativeAdTypeSelfRender;//原生自渲染
    }];
}

/// 开启竞价广告源的测试模式
/// 测试完毕请移除⚠️
/// - Parameters:
///   - currentIDFAStr: 当前测试机器的idfa，必须传入有效值
+ (void)enableHeaderBiddingTestModeWithCurrentIDFAStr:(NSString *)currentIDFAStr {
    //必须开启日志
    [ATAPI setLogEnabled:YES];
    //测试完毕请移除⚠️
    [ATSDKGlobalSetting sharedManager].headerBiddingTestModeDeviceID = currentIDFAStr;
}

@end

