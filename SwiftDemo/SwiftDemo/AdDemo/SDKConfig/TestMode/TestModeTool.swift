//
//  TestModeTool.swift
//  SwiftDemo
//
//  Created by ltz on 2025/2/12.
//

import Foundation
import UIKit
import AnyThinkSDK 

// DebugUI SDK，此为可选接入，上线后建议移除
// import AnyThinkDebuggerUISDK

class TestModeTool: NSObject {
    
    /// 在指定vc上展示Debug UI，建议直接使用系统的UIViewController，传入继承或者自定义的vc可能导致显示异常
    /// 需要 pod 'TPNDebugUISDK' 测试完毕请移除⚠️
    /// - Parameter vc: 目标vc
    static func showDebugUI(_ vc: UIViewController) {
        //Swift需要桥接使用，引入头文件 import AnyThinkDebuggerUISDK
        //请注意，showType支持.present和.push，如果遇到push不出来的情况，请保证您的导航控制器没有多余的继承.
        //唤起条件：
        //window - rootNavigation - viewController -> push debugUI
        //1.iOS SDK已经成功初始化
        //2.还未加载(load)任一广告
        //3.关闭调试模式，即移除 ATSDKGlobalSetting.setDebuggerConfig 相关代码
        ATDebuggerAPI.sharedInstance().showDebugger(in: vc, show: .present, debugkey: "填入您的DebugKey，DebugKey在后台->账号管理->Key中获取，DebugKey需要与AppID，AppKey对应")
    }
    
    /// 开启测试模式(每次只能指定一个广告平台，不一定100%填充广告)
    /// 关闭测试模式，只需要注释掉相关方法即可关闭
    /// 上线前请移除⚠️测试完毕请移除⚠️
    /// - Parameters:
    ///   - type: 本次需要测试广告平台类型
    ///   - currentIDFAStr: 当前测试机器的idfa，必须传入有效值
    static func enableTestMode(with3rdSDKType type: ATAdNetWorkType, currentIDFAStr: String) {
        
        ATSDKGlobalSetting.sharedManager().setDebuggerConfig { debuggerConfig in
            debuggerConfig?.deviceIdfaStr = currentIDFAStr
            //指定需要测试的广告平台名称类型
            debuggerConfig?.netWorkType = .applovinType
            
            //        指定广告平台的某一种类型
            //        debuggerConfig?.adx_nativeAdType = .selfRender //原生自渲染
        }
    }
    
    /// 开启竞价广告源的测试模式
    /// 测试完毕请移除⚠️
    /// - Parameter currentIDFAStr: 当前测试机器的idfa，必须传入有效值
    static func enableHeaderBiddingTestMode(withCurrentIDFAStr currentIDFAStr: String) {
        //必须开启日志
        ATAPI.setLogEnabled(true)
        //测试完毕请移除⚠️
        ATSDKGlobalSetting.sharedManager().headerBiddingTestModeDeviceID = currentIDFAStr
    }
}
