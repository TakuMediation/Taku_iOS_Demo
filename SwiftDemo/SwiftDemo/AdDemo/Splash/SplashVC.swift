//
//  SplashVC.swift
//  SwiftDemo
//
//  Created by ltz on 2025/8/20.
//

import UIKit
import AnyThinkSDK

class SplashVC: BaseNormalBarNoFootVC {
    
    // MARK: - Properties
 
    // MARK: - Constants
    
    /// Placement ID
    private let splashPlacementID = "b67f4ab43d2fe1"
    
    /// Scene ID, optional, can be generated in backend. Pass empty string if none
    private let splashSceneID = ""
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        // To improve splash ad efficiency, it's recommended to initiate splash ad loading request before entering current page, for example after SDK initialization. Demo here loads in viewDidLoad for convenience
        loadAd()
    }
    
    // MARK: - Navigation
    
    /// Enter home page
    private func enterHomeVC() {
        
    }
    
    // MARK: - Load Ad
    
    /// Load ad
    override func loadAd() {
        let loadConfigDict = NSMutableDictionary()
        
        // Splash timeout duration
        loadConfigDict.setValue(5, forKey: kATSplashExtraTolerateTimeoutKey)
        // Custom load parameters
        loadConfigDict.setValue("media_val_SplashVC", forKey: kATAdLoadingExtraMediaExtraKey)
        
        // Optional integration, if using Pangle ad platform, can add the following configuration
        // AdLoadConfigTool.splash_loadExtraConfigAppend_Pangle(loadConfigDict)
        
        // If choosing to use Tencent GDT, recommended integration
        // AdLoadConfigTool.splash_loadExtraConfigAppend_Tencent(loadConfigDict)
        
        ATAdManager.shared().loadAD(withPlacementID: splashPlacementID,
                                   extra: loadConfigDict as! [AnyHashable : Any],
                                   delegate: self,
                                   containerView: footLogoView())
    }
    
    /// Optional integration splash bottom LogoView
    private func footLogoView() -> UIView {
        // Width is screen width, height <= 25% of screen height (depends on ad platform requirements)
        let footerCtrView = UIView(frame: CGRect(x: 0, y: 0, width: kOrientationScreenWidth, height: 120))
        footerCtrView.backgroundColor = UIColor.white
        
        // Add image
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "logo")
        logoImageView.contentMode = .center
        logoImageView.frame = footerCtrView.frame
        footerCtrView.addSubview(logoImageView)
        
        // Add tap gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(footerImgClick(_:)))
        logoImageView.isUserInteractionEnabled = true
        logoImageView.addGestureRecognizer(tap)
        
        return footerCtrView
    }
    
    /// Footer click event
    @objc private func footerImgClick(_ tap: UITapGestureRecognizer) {
        ATDemoLog("footer click !!")
    }
    
    // MARK: - Show Ad
    
    /// Show splash ad
    private func showSplash() {
        // Scene statistics function (optional integration)
        ATAdManager.shared().entrySplashScenario(withPlacementID: splashPlacementID, scene: splashSceneID)
        
        // Query available ad cache for display (optional integration)
        // let adCaches = ATAdManager.shared().getSplashValidAds(forPlacementID: splashPlacementID)
        // ATDemoLog("getValidAds : \(adCaches)")
        
        // Query ad loading status (optional integration)
        // let status = ATAdManager.shared().checkSplashLoadStatus(forPlacementID: splashPlacementID)
        // ATDemoLog("checkLoadStatus : \(status.isLoading)")
        
        // Check if ready
        if !ATAdManager.shared().splashReady(forPlacementID: splashPlacementID) {
            loadAd()
            return
        }
        
        // Display configuration, Scene passes backend scene ID, pass empty string if none, showCustomExt parameter can pass custom parameter string
        let config = ATShowConfig(scene: splashSceneID, showCustomExt: "testShowCustomExt")
        
        // Splash related parameter configuration
        let configDict: [String: Any] = [:]
        
        // Optional integration, custom skip button, most platforms no longer support custom skip buttons, currently supporting custom skip button changes are CSJ(TT), ADX, specific needs to run to see actual effect
        // AdLoadConfigTool.splash_loadExtraConfigAppend_CustomSkipButton(&configDict)
        
        // Show ad, display in App's original window
        ATAdManager.shared().showSplash(withPlacementID: splashPlacementID, config: config, window: UIApplication.shared.keyWindow!, in: tabBarController!, extra: configDict, delegate: self)
    }
}

// MARK: - ATSplashDelegate
extension SplashVC: ATSplashDelegate {
    
    /// Splash ad loading completed
    /// - Parameters:
    ///   - placementID: Placement ID
    ///   - isTimeout: Whether timeout occurred
    func didFinishLoadingSplashAD(withPlacementID placementID: String, isTimeout: Bool) {
        ATDemoLog("Splash loading success:%@ ---- Is timeout:%d", placementID, isTimeout)
        if !isTimeout {
            // No timeout, show splash ad
            // 没超时，可以展示广告
            showSplash()
        } else {
            // Loading successful, but timeout occurred
            // 加载成功超时了，直接进入首页
            enterHomeVC()
        }
    }
    
    /// Placement loading failed
    /// - Parameters:
    ///   - placementID: Placement ID
    ///   - error: Error information
    func didFailToLoadAD(withPlacementID placementID: String, error: Error) {
        ATDemoLog("didFailToLoadADWithPlacementID:%@ error:%@", placementID, error.localizedDescription)
        showLog(String(format: "didFailToLoadADWithPlacementID:%@ errorCode:%ld", placementID, (error as NSError).code))
        
        // All ad sources failed to load, enter home page
        enterHomeVC()
    }
    
    /// Splash ad loading timeout
    /// - Parameter placementID: Placement ID
    func didTimeoutLoadingSplashAD(withPlacementID placementID: String) {
        ATDemoLog("didTimeoutLoadingSplashADWithPlacementID:%@", placementID)
        // Timeout occurred, enter home page after home page loading completes
        showLog("Splash timeout occurred")
        // Enter home page
        enterHomeVC()
    }
    
    /// Received display revenue
    /// - Parameters:
    ///   - placementID: Placement ID
    ///   - extra: Extra information dictionary
    func didRevenue(forPlacementID placementID: String, extra: [AnyHashable : Any]) {
        ATDemoLog("didRevenueForPlacementID:%@ with extra: %@", placementID, extra)
        showLog(String(format: "didRevenueForPlacementID:%@", placementID))
    }
    
    /// Callback when the successful loading of the ad
    /// Loading successful and loading process completed
    func didFinishLoadingAD(withPlacementID placementID: String) {
        ATDemoLog("didFinishLoadingADWithPlacementID:%@", placementID)
        showLog(String(format: "didFinishLoadingADWithPlacementID:%@", placementID))
    }
    
    /// Splash ad displayed
    /// - Parameters:
    ///   - placementID: Placement ID
    ///   - extra: Extra information
    func splashDidShow(forPlacementID placementID: String, extra: [AnyHashable : Any]) {
        ATDemoLog("splashDidShowForPlacementID:%@", placementID)
        showLog(String(format: "splashDidShowForPlacementID:%@", placementID))
 
    }
    
    /// Splash ad closed
    /// - Parameters:
    ///   - placementID: Placement ID
    ///   - extra: Extra information
    func splashDidClose(forPlacementID placementID: String, extra: [AnyHashable : Any]) {
        ATDemoLog("splashDidCloseForPlacementID:%@ extra:%@", placementID, extra)
        showLog(String(format: "splashDidCloseForPlacementID:%@", placementID))
        
        // Enter home page
        enterHomeVC()
        
        // Hot start preload (optional)
        // loadAd()
        
        // Can get close reason here: dismiss_type
        // typedef NS_OPTIONS(NSInteger, ATAdCloseType) {
        //     ATAdCloseUnknow = 1,            // ad close type unknow
        //     ATAdCloseSkip = 2,              // ad skip to close
        //     ATAdCloseCountdown = 3,         // ad countdown to close
        //     ATAdCloseClickcontent = 4,      // ad clickcontent to close
        //     ATAdCloseShowfail = 99          // ad showfail to close
        // };
        // let closeType = extra[kATADDelegateExtraDismissTypeKey] as? Int
    }
    
    /// Splash ad clicked
    /// - Parameters:
    ///   - placementID: Placement ID
    ///   - extra: Extra information
    func splashDidClick(forPlacementID placementID: String, extra: [AnyHashable : Any]) {
        ATDemoLog("splashDidClickForPlacementID:%@", placementID)
        showLog(String(format: "splashDidClickForPlacementID:%@", placementID))
    }
    
    /// Splash ad display failed
    /// - Parameters:
    ///   - placementID: Placement ID
    ///   - error: Error information
    ///   - extra: Extra information
    func splashDidShowFailed(forPlacementID placementID: String, error: Error, extra: [AnyHashable : Any]) {
        ATDemoLog("splashDidShowFailedForPlacementID:%@", placementID)
        showLog(String(format: "splashDidShowFailedForPlacementID:%@ error:%@", placementID, error.localizedDescription))
        
        // Failed to display successfully, also enter home page, be careful to control duplicate navigation
        enterHomeVC()
    }
    
    /// Splash ad opened or jumped to deep link page
    /// - Parameters:
    ///   - placementID: Placement ID
    ///   - extra: Extra information
    ///   - success: Whether successful
    func splashDeepLinkOrJump(forPlacementID placementID: String, extra: [AnyHashable : Any], result success: Bool) {
        ATDemoLog("splashDeepLinkOrJumpForPlacementID:placementID:%@", placementID)
        showLog(String(format: "splashDeepLinkOrJumpForPlacementID:placementID:%@", placementID))
    }
    
    /// Splash ad detail page closed
    /// - Parameters:
    ///   - placementID: Placement ID
    ///   - extra: Extra information
    func splashDetailDidClosed(forPlacementID placementID: String, extra: [AnyHashable : Any]) {
        ATDemoLog("splashDetailDidClosedForPlacementID:%@", placementID)
        showLog(String(format: "splashDetailDidClosedForPlacementID:%@", placementID))
        
        // Can get close reason here: dismiss_type
        // typedef NS_OPTIONS(NSInteger, ATAdCloseType) {
        //     ATAdCloseUnknow = 1,            // ad close type unknow
        //     ATAdCloseSkip = 2,              // ad skip to close
        //     ATAdCloseCountdown = 3,         // ad countdown to close
        //     ATAdCloseClickcontent = 4,      // ad clickcontent to close
        //     ATAdCloseShowfail = 99          // ad showfail to close
        // };
        // let closeType = extra[kATADDelegateExtraDismissTypeKey] as? Int
        
        // Hot start preload (optional)
        // loadAd()
    }
    
    /// Splash ad close countdown
    /// - Parameters:
    ///   - countdown: Remaining seconds
    ///   - placementID: Placement ID
    ///   - extra: Extra information
    func splashCountdownTime(_ countdown: Int, forPlacementID placementID: String, extra: [AnyHashable : Any]) {
        ATDemoLog("splashCountdownTime:%ld forPlacementID:%@", countdown, placementID)
        showLog(String(format: "splashCountdownTime:%ld forPlacementID:%@", countdown, placementID))
    }
    
    /// Splash ad zoomout view clicked, only supported by Pangle Tencent GDT V+
    /// - Parameters:
    ///   - placementID: Placement ID
    ///   - extra: Extra information
    func splashZoomOutViewDidClick(forPlacementID placementID: String, extra: [AnyHashable : Any]) {
        ATDemoLog("splashZoomOutViewDidClickForPlacementID:%@", placementID)
        showLog(String(format: "splashZoomOutViewDidClickForPlacementID:%@", placementID))
    }
    
    /// Splash ad zoomout view closed, only supported by Pangle Tencent GDT V+
    /// - Parameters:
    ///   - placementID: Placement ID
    ///   - extra: Extra information
    func splashZoomOutViewDidClose(forPlacementID placementID: String, extra: [AnyHashable : Any]) {
        ATDemoLog("splashZoomOutViewDidCloseForPlacementID:%@", placementID)
        showLog(String(format: "splashZoomOutViewDidCloseForPlacementID:%@", placementID))
    }
}
