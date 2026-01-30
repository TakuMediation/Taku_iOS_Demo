//
//  BannerVC.swift
//  SwiftDemo
//
//  Created by ltz on 2025/1/11.
//

import UIKit
import AnyThinkSDK
import SnapKit

class BannerVC: BaseNormalBarVC {
    
    // MARK: - Properties
    
    /// Banner ad view
    private var bannerView: ATBannerView?
    
    /// Ad loading status flag
    private var hasLoaded: Bool = false
    
    // MARK: - Constants
    
    /// Placement ID
    private let bannerPlacementID = "b680a1e7874fce"
    
    /// Scene ID, optional, can be generated in dashboard. Pass empty string if none
    private let bannerSceneID = ""
    
    /// Note: banner size must match the ratio configured in dashboard
    private let bannerSize = CGSize(width: 320, height: 50)
    
    // MARK: - Load Ad
    
    /// Load ad
    override func loadAd() {
        showLog(kLocalizeStr("Clicked load ad"))
        
        var loadConfigDict: [String: Any] = [:]
        
        /*
         Note that banner ads on different platforms have certain restrictions. For example, the configured banner AD is 640*100. In order to fill the screen width, the height H = (screen width *100)/640 is calculated. Then the extra size of the load is (screen width: H).
         */
        loadConfigDict[kATAdLoadingExtraBannerAdSizeKey] = NSValue(cgSize: bannerSize)
        
        // Set custom parameters
        loadConfigDict[kATAdLoadingExtraMediaExtraKey] = "media_val_BannerVC"
        
        // Optional integration, add following config if using Admob ad platform
        // AdLoadConfigTool.banner_loadExtraConfigAppendAdmob(&loadConfigDict)
        
        // Start loading
        ATAdManager.shared().loadAD(withPlacementID: bannerPlacementID, extra: loadConfigDict, delegate: self)
    }
    
    // MARK: - Show Ad
    
    /// Show ad
    override func showAd() {
        // Scene statistics feature, optional integration
        ATAdManager.shared().entryBannerScenario(withPlacementID: bannerPlacementID, scene: bannerSceneID)
        
        // Query available ad cache for display (optional integration)
        // let adCaches = ATAdManager.shared().getBannerValidAds(forPlacementID: bannerPlacementID)
        // ATDemoLog("getValidAds : %@", adCaches)
        
        // Query ad loading status (optional integration)
        // let status = ATAdManager.shared().checkBannerLoadStatus(forPlacementID: bannerPlacementID)
        // ATDemoLog("checkLoadStatus : %d", status.isLoading)
        
        // Check if ready
        if !ATAdManager.shared().bannerAdReady(forPlacementID: bannerPlacementID) {
            loadAd()
            return
        }
        
        // Show config, Scene passes dashboard scene ID, pass empty string if none, showCustomExt parameter can pass custom parameter string
        let config = ATShowConfig(scene: bannerSceneID, showCustomExt: "testShowCustomExt")
        
        // Show ad
        if let bannerView = ATAdManager.shared().retrieveBannerView(forPlacementID: bannerPlacementID, config: config) {
            // Assignment
            bannerView.delegate = self
            bannerView.presentingViewController = self
            bannerView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(bannerView)
            self.bannerView = bannerView
            
            // Layout using SnapKit
            bannerView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.height.equalTo(bannerSize.height)
                make.width.equalTo(bannerSize.width)
                make.top.equalTo(textView.snp.bottom).offset(5)
            }
        }
    }
    
    // MARK: - Destroy Ad
    
    /// Remove banner ad
    private func removeAd() {
        bannerView?.destroyBanner()
        bannerView?.removeFromSuperview()
        bannerView = nil
        hasLoaded = false
    }
    
    // MARK: - Demo Button Actions
    
    /// Remove banner ad through demo remove button click
    internal override func removeAdButtonClickAction() {
        removeAd()
    }
    
    /// Temporarily hide, auto-loading will stop after hiding
    internal override func hiddenAdButtonClickAction() {
        bannerView?.isHidden = true
    }
    
    /// Re-show after hiding
    internal override func reshowAd() {
        bannerView?.isHidden = false
    }
}

// MARK: - ATAdLoadingDelegate

extension BannerVC: ATAdLoadingDelegate {
    
    /// Placement loading completed
    /// - Parameter placementID: Placement ID
    func didFinishLoadingAD(withPlacementID placementID: String) {
        let isReady = ATAdManager.shared().bannerAdReady(forPlacementID: placementID)
        showLog(String(format: "didFinishLoadingADWithPlacementID:%@ Banner ready:%@", placementID, isReady ? "YES" : "NO"))
        
        hasLoaded = true
    }
    
    /// Placement loading failed
    /// - Parameters:
    ///   - placementID: Placement ID
    ///   - error: Error information
    func didFailToLoadAD(withPlacementID placementID: String, error: Error) {
        ATDemoLog("didFailToLoadADWithPlacementID:%@ error:%@", placementID, error.localizedDescription)
        showLog(String(format: "didFailToLoadADWithPlacementID:%@ errorCode:%ld", placementID, (error as NSError).code))
        
        hasLoaded = false
    }
    
    /// Received display revenue
    /// - Parameters:
    ///   - placementID: Placement ID
    ///   - extra: Extra information dictionary
    func didRevenue(forPlacementID placementID: String, extra: [AnyHashable : Any]) {
        ATDemoLog("didRevenueForPlacementID:%@ with extra: %@", placementID, extra)
        showLog(String(format: "didRevenueForPlacementID:%@", placementID))
    }
}

// MARK: - ATBannerDelegate

extension BannerVC: ATBannerDelegate {
    
    /// Close button clicked (when user clicks close button on banner)
    /// - Parameters:
    ///   - bannerView: Banner ad view object
    ///   - placementID: Placement ID
    ///   - extra: Extra information dictionary
    func bannerView(_ bannerView: ATBannerView, didTapCloseButtonWithPlacementID placementID: String, extra: [AnyHashable : Any]) {
        ATDemoLog("didTapCloseButtonWithPlacementID:%@ extra: %@", placementID, extra)
        showLog(String(format: "bannerView:didTapCloseButtonWithPlacementID:%@", placementID))
        
        // Received close button click callback, remove bannerView
        removeAd()
    }
    
    /// Banner ad displayed
    /// - Parameters:
    ///   - bannerView: Banner ad view object
    ///   - placementID: Placement ID
    ///   - extra: Extra information dictionary
    func bannerView(_ bannerView: ATBannerView, didShowAdWithPlacementID placementID: String, extra: [AnyHashable : Any]) {
        ATDemoLog("didShowAdWithPlacementID:%@ with extra: %@", placementID, extra)
        showLog(String(format: "bannerView:didShowAdWithPlacementID:%@", placementID))
    }
    
    /// Banner ad clicked
    /// - Parameters:
    ///   - bannerView: Banner ad view object
    ///   - placementID: Placement ID
    ///   - extra: Extra information dictionary
    func bannerView(_ bannerView: ATBannerView, didClickWithPlacementID placementID: String, extra: [AnyHashable : Any]) {
        ATDemoLog("didClickWithPlacementID:%@ with extra: %@", placementID, extra)
        showLog(String(format: "bannerView:didClickWithPlacementID:%@", placementID))
    }
    
    /// Banner ad auto-refreshed
    /// - Parameters:
    ///   - bannerView: Banner ad view object
    ///   - placementID: Placement ID
    ///   - extra: Extra information dictionary
    func bannerView(_ bannerView: ATBannerView, didAutoRefreshWithPlacement placementID: String, extra: [AnyHashable : Any]) {
        ATDemoLog("didAutoRefreshWithPlacement:%@ with extra: %@", placementID, extra)
        showLog(String(format: "bannerView:didAutoRefreshWithPlacement:%@", placementID))
    }
    
    /// Banner ad auto-refresh failed
    /// - Parameters:
    ///   - bannerView: Banner ad view object
    ///   - placementID: Placement ID
    ///   - error: Error information
    func bannerView(_ bannerView: ATBannerView, failedToAutoRefreshWithPlacementID placementID: String, error: Error) {
        ATDemoLog("failedToAutoRefreshWithPlacementID:%@ error:%@", placementID, error.localizedDescription)
        showLog(String(format: "bannerView:failedToAutoRefreshWithPlacementID:%@ errorCode:%ld", placementID, (error as NSError).code))
    }
    
    /// Banner ad opened or jumped to deep link page
    /// - Parameters:
    ///   - bannerView: Banner ad view object
    ///   - placementID: Placement ID
    ///   - extra: Extra information
    ///   - success: Whether successful
    func bannerView(_ bannerView: ATBannerView, didDeepLinkOrJumpForPlacementID placementID: String, extra: [AnyHashable : Any], result success: Bool) {
        ATDemoLog("didDeepLinkOrJumpForPlacementID:placementID:%@ with extra: %@, success:%@", placementID, extra, success ? "YES" : "NO")
        showLog(String(format: "didDeepLinkOrJumpForPlacementID:%@, success:%@", placementID, success ? "YES" : "NO"))
    }
}
