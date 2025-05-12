//
//  TestModeTool.h
//  iOSDemo
//
//  Created by ltz on 2025/2/12.
//

#import <Foundation/Foundation.h>
 
//导入头文件
#import <AnyThinkSDK/AnyThinkSDK.h>

//DebugUI SDK，此为可选接入，上线后建议移除
#import <AnyThinkDebuggerUISDK/ATDebuggerAPI.h>

@interface TestModeTool : NSObject

/// 在指定vc上展示Debug UI，建议直接使用系统的UIViewController，传入继承或者自定义的vc可能导致显示异常
/// 需要 pod 'AnyThinkDebugUISDK','1.0.3' 测试完毕请移除⚠️
/// - Parameter vc: 目标vc
+ (void)showDebugUI:(UIViewController *)vc;

/// 开启测试模式(每次只能指定一个广告平台，不一定100%填充广告)
/// 关闭测试模式，只需要注释掉相关方法即可关闭
/// 测试完毕请移除⚠️测试完毕请移除⚠️
/// - Parameters:
///   - type: 本次需要测试广告平台类型
///   - currentIDFAStr: 当前测试机器的idfa，必须传入有效值
+ (void)enableTestModeWith3rdSDKType:(ATAdNetWorkType)type currentIDFAStr:(NSString *)currentIDFAStr;
 

/// 开启竞价广告源的测试模式
/// 测试完毕请移除⚠️
/// - Parameters:
///   - currentIDFAStr: 当前测试机器的idfa，必须传入有效值
+ (void)enableHeaderBiddingTestModeWithCurrentIDFAStr:(NSString *)currentIDFAStr;

@end
