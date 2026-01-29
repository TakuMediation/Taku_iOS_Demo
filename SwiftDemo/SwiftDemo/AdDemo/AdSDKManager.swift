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
 
/// Application ID in the backend
let kAppID = "a67f4ab312d2be"

/// Application-level AppKey or account-level AppKey in the backend
let kAppKey = "7eae0567827cfe2b22874061763f30c9"

/// Cold start splash timeout duration
let FirstAppOpen_Timeout = 8

/// Cold start splash placement ID
let FirstAppOpen_PlacementID = "b67f4ab43d2fe1"

class AdSDKManager: NSObject {
     
    static let shared = AdSDKManager()
     
    /// Loading page, using custom loading image
    private var launchLoadingView: LaunchLoadingView?
 
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
    
    // MARK: - Splash Ad Related
    
    /// Add launch page, add before SDK initialization, used for cold start splash
    func addLaunchLoadingView() {
        // Add launch page
        // Add loading page, needs to be removed in ad delegate when ad display is completed
        launchLoadingView = LaunchLoadingView()
        launchLoadingView?.show()
    }
    
    /// Splash ad
    func startSplashAd() {
         
        // Splash ad displays launch image
        addLaunchLoadingView()
        launchLoadingView?.startTimer()
        
        loadSplash(withPlacementID: FirstAppOpen_PlacementID)
    }
    
    func loadSplash(withPlacementID placementID: String) {
        var loadConfigDict: [String: Any] = [:]
        
        // Splash timeout duration
        loadConfigDict[kATSplashExtraTolerateTimeoutKey] = FirstAppOpen_Timeout
        
        // Custom load parameters
        loadConfigDict[kATAdLoadingExtraMediaExtraKey] = "Your custom string"
        
        // Custom user id parameter, used to pass to ad platform SDK
        loadConfigDict[kATAdLoadingExtraUserIDKey] = "Your custom user ID"
         
        // Optional integration, if using Pangle ad platform, can add the following configuration
        // AdLoadConfigTool.splash_loadExtraConfigAppend_Pangle(&loadConfigDict)
        
        // If choosing to use Tencent GDT, recommended to integrate
        // AdLoadConfigTool.splash_loadExtraConfigAppend_Tencent(&loadConfigDict)
        
        ATAdManager.shared().loadAD(withPlacementID: placementID,
                                          extra: loadConfigDict,
                                          delegate: self,
                                          containerView: footLogoView())
    }
    
    /// Show splash ad
    /// - Parameter placementID: Placement ID
    func showSplash(withPlacementID placementID: String) {
        // Check if ready
        guard ATAdManager.shared().splashReady(forPlacementID: placementID) else {
            return
        }
        
        // Scene statistics function, optional integration
        ATAdManager.shared().entrySplashScenario(withPlacementID: placementID, scene: "")
        
        // Show configuration, Scene passes backend scene ID, can pass empty string if none, showCustomExt parameter can pass custom parameter string
        let config = ATShowConfig(scene: placementID, showCustomExt: "Your ShowCustomExt String")
        
        // Splash related parameter configuration
        let configDict: [String: Any] = [:]
        
        // Optional integration, custom skip button, most platforms no longer support custom skip buttons, currently supporting custom skip button modification are CSJ(TT), direct investment, ADX, native as splash and YouKeYing, specific effects need to be tested by running
        // AdLoadConfigTool.splash_loadExtraConfigAppend_CustomSkipButton(&configDict)
        
        // Show ad
        ATAdManager.shared().showSplash(withPlacementID: placementID,
                                             config: config,
                                             window: UIApplication.shared.currentKeyWindow!,
                                             in: UIApplication.shared.topMostViewController() ?? UIViewController(),
                                             extra: configDict,
                                             delegate: self)
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
    
    // MARK: - Private Methods
    
    /// Splash ad loading callback judgment
    /// - Parameters:
    ///   - placementID: Placement ID
    ///   - result: Result
    private func showSplashOrEnterHomePage(withPlacementID placementID: String, loadResult: Bool) {
        if loadResult == true {
            showSplash(withPlacementID: placementID)
        }else {
            launchLoadingView?.dismiss()
        }
    }
    
    /// Optional integration splash bottom LogoView, only supported by some ad platforms
    /// - Returns: footer view
    private func footLogoView() -> UIView {
        // Width is screen width, height <= 25% of screen height (depending on ad platform requirements)
        let footerCtrView = UIView(frame: CGRect(x: 0, y: 0, width: kOrientationScreenWidth, height: 120))
        footerCtrView.backgroundColor = .white
        
        // Add image
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "logo")
        logoImageView.contentMode = .center
        logoImageView.frame = footerCtrView.frame
        footerCtrView.addSubview(logoImageView)
        
        // Add click event
        let tap = UITapGestureRecognizer(target: self, action: #selector(footerImgClick(_:)))
        logoImageView.isUserInteractionEnabled = true
        logoImageView.addGestureRecognizer(tap)
        
        return footerCtrView
    }
    
    /// Footer click event
    /// - Parameter tap: Gesture recognizer
    @objc private func footerImgClick(_ tap: UITapGestureRecognizer) {
        ATDemoLog("footer click !!")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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

// MARK: - ATAdLoadingDelegate
extension AdSDKManager: ATAdLoadingDelegate {
    
    /// Placement loading failed
    /// - Parameters:
    ///   - placementID: Placement ID
    ///   - error: Error information
    func didFailToLoadAD(withPlacementID placementID: String, error: Error) {
        // Handle splash callback
        showSplashOrEnterHomePage(withPlacementID: placementID, loadResult: false)
    }
    
    func didFinishLoadingAD(withPlacementID placementID: String) {
        // All Ads load finished, please use didFinishLoadingSplashAD:withPlacementID:isTimeout first
    }
}

// MARK: - ATSplashDelegate
extension AdSDKManager: ATSplashDelegate {
    
    /// Splash ad loading successful, need to check if timeout occurred
    /// - Parameters:
    ///   - placementID: Placement ID
    ///   - isTimeout: Whether timeout occurred
    func didFinishLoadingSplashAD(withPlacementID placementID: String, isTimeout: Bool) {
        // Splash ad loading successful, need to check if timeout occurred
        // Handle splash callback
        showSplashOrEnterHomePage(withPlacementID: placementID, loadResult: !isTimeout)
    }
    
    /// Splash ad loading timeout
    /// - Parameter placementID: Placement ID
    func didTimeoutLoadingSplashAD(withPlacementID placementID: String) {
        // Handle splash callback
        showSplashOrEnterHomePage(withPlacementID: placementID, loadResult: false)
    }
    
    /// Splash ad closed
    /// - Parameters:
    ///   - placementID: Placement ID
    ///   - extra: Extra information
    func splashDidClose(forPlacementID placementID: String, extra: [AnyHashable : Any]) {
        // Handle splash callback
        showSplashOrEnterHomePage(withPlacementID: placementID, loadResult: false)
    }
    
    /// Splash ad display failed
    /// - Parameters:
    ///   - placementID: Placement ID
    ///   - error: Error information
    ///   - extra: Extra information
    func splashDidShowFailed(forPlacementID placementID: String, error: Error, extra: [AnyHashable : Any]) {
        // Handle splash callback
        showSplashOrEnterHomePage(withPlacementID: placementID, loadResult: false)
    }
    
    /// Splash ad clicked
    /// - Parameters:
    ///   - placementID: Placement ID
    ///   - extra: Extra information
    func splashDidClick(forPlacementID placementID: String, extra: [AnyHashable : Any]) {
 
    }
    
    /// Splash ad display successful
    /// - Parameters:
    ///   - placementID: Placement ID
    ///   - extra: Extra information
    func splashDidShow(forPlacementID placementID: String, extra: [AnyHashable : Any]) {
        launchLoadingView?.dismiss()
    }
}
