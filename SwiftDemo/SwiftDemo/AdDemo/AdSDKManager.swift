//
//  AdSDKManager.swift
//  SwiftDemo
//
//  Created by ltz on 2025/1/5.
//

import Foundation
import UIKit
import AnyThinkSDK
 
import AppTrackingTransparency
 
/// Initialization completion callback
typealias AdManagerInitFinishBlock = () -> Void
/// Splash ad loading callback
typealias AdManagerSplashAdLoadBlock = (Bool) -> Void
 
/// Application ID in the dashboard
let kAppID = "a67f4ab312d2be"

/// Application-level AppKey or account-level AppKey in the dashboard
let kAppKey = "7eae0567827cfe2b22874061763f30c9"

/// Cold start splash timeout duration
let FirstAppOpen_Timeout = 8

/// Cold start splash placement ID
let FirstAppOpen_PlacementID = "b67f4ab43d2fe1"

class AdSDKManager: NSObject {
    
    static let shared = AdSDKManager()
    
    private override init() {
        super.init()
    }
    
    // MARK: - Public Methods
    /// Initialize SDK, this method will not initialize ad platform SDKs simultaneously
    func initSDK() {
        // Log switch
        ATAPI.setLogEnabled(true)
        // Integration detection
        ATAPI.integrationChecking()
        
        // Optional integration, set splash ad preset strategy
        // ATSDKGlobalSetting.sharedManager().setPresetPlacementConfigPathBundle(Bundle.main)
        
        // SDK custom parameter configuration, single item
        SDKGlobalConfigTool.setCustomChannel("Your custom channel string")
        
        // Optional integration, if using Pangle ad platform, set overseas privacy settings
        // SDKGlobalConfigTool.pangleCOPPACCPASetting()
        
        // SDK custom parameter configuration, multiple items together, other configurations can be found in SDKGlobalConfigTool class
        /*
         SDKGlobalConfigTool.setCustomData([
         kATCustomDataUserIDKey: "test_custom_user_id",
         kATCustomDataChannelKey: "custom_data_channel",
         kATCustomDataSubchannelKey: "custom_data_subchannel",
         kATCustomDataAgeKey: 18, //Include used for COPPA
         kATCustomDataGenderKey: 1, // Value filled during traffic grouping, must be consistent with the value passed in
         kATCustomDataNumberOfIAPKey: 19,
         kATCustomDataIAPAmountKey: 20.0,
         kATCustomDataIAPCurrencyKey: "usd"
         ])
         */
        
        // Debug mode related tools TestModeTool
        // TestModeTool.showDebugUI()
        
        // Initialize SDK
        do {
            try ATAPI.sharedInstance().start(withAppID: kAppID, appKey: kAppKey)
        } catch {
            print("AdSDK init error: \(error)")
        }
    }
    
    /// GDPR/UMP process initialization
    /// - Parameter block: Initialization completion callback
    func initSDK_EU(_ block: @escaping AdManagerInitFinishBlock) {
        ATAPI.sharedInstance().showGDPRConsentDialog(in: UIApplication.shared.topMostViewController() ?? UIViewController()) {
            // This example shows requesting ATT permission on non-first launch when user agrees or data consent is unknown. You can adjust according to your app's actual situation.
            let dataConsentSet = ATAPI.sharedInstance().dataConsentSet
            let gdprFirstFlag = UserDefaults.standard.bool(forKey: "GDPR_First_Flag")
            
            if (dataConsentSet == .unknown && gdprFirstFlag) || dataConsentSet == .personalized {
                if #available(iOS 14, *) {
                    ATTrackingManager.requestTrackingAuthorization { status in
                        // Handle authorization status
                    }
                }
            }
            
            //            // If you have integrated and are using the Admob UMP popup, after the user makes a choice, ATAPI.shared().dataConsentSet in this callback cannot obtain results during the app's first launch
            //            // If you want to obtain the results, you can refer to the following code:
            //             let purposeConsents = UserDefaults.standard.string(forKey: "IABTCF_PurposeConsents")
            //             print("purposeConsents: \(purposeConsents ?? "")")
            //             if !(purposeConsents?.contains("1") ?? false) {
            //                 // User did not consent
            //             } else {
            //                 // User consented
            //             }
            //
            //            // // If you have not integrated or are not using Admob UMP, you can obtain the user's selection result in this callback.
            //             if ATAPI.sharedInstance().dataConsentSet == .personalized {
            //                 // User consented
            //             } else {
            //                 // User did not consent
            //             }
            
            self.initSDK()
            block()
            
            UserDefaults.standard.set(true, forKey: "GDPR_First_Flag")
        }
    }
}

// MARK: - UIApplication Extension (Multi-scene safe keyWindow and top-level VC)
extension UIApplication {
    var currentKeyWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            return self.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first?
                .windows
                .first(where: { $0.isKeyWindow })
        } else {
            return self.keyWindow
        }
    }
     
    var currentRootViewController: UIViewController? {
        return currentKeyWindow?.rootViewController
    }
     
    func topMostViewController(base: UIViewController? = nil) -> UIViewController? {
        let baseVC = base ?? currentRootViewController
        if let nav = baseVC as? UINavigationController {
            return topMostViewController(base: nav.visibleViewController)
        }
        if let tab = baseVC as? UITabBarController {
            return topMostViewController(base: tab.selectedViewController)
        }
        if let presented = baseVC?.presentedViewController {
            return topMostViewController(base: presented)
        }
        return baseVC
    }
}
 
