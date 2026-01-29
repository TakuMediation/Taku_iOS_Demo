//
//  InterstitialVC.swift
//  SwiftDemo
//
//  Created by ltz on 2025/1/6.
//

import UIKit
import AnyThinkSDK

class InterstitialVC: BaseNormalBarVC {
    
    // MARK: - Properties
    
    /// Retry attempt counter
    private var retryAttempt: Int = 0
    
    // MARK: - Constants
    
    /// Placement ID
    private let interstitialPlacementID = "b680a1e0ae7a43"
    
    /// Scene ID, optional, can be generated in the backend. Pass empty string if none
    private let interstitialSceneID = ""
 
    // MARK: - Load Ad
    
    /// Load ad button clicked
    override func loadAd() {
        showLog(kLocalizeStr("Load ad clicked"))
        
        var loadConfigDict: [String: Any] = [:]
        
        // Optional integration, set loading pass-through parameters
        loadConfigDict[kATAdLoadingExtraMediaExtraKey] = "media_val_InterstitialVC"
        
        // (Optional integration) If using Kuaishou platform, add half-screen interstitial ad size configuration
        // AdLoadConfigTool.interstitial_loadExtraConfigAppend_KuaiShou(&loadConfigDict)
        
        // (Optional integration) If shared placement is enabled, configure related settings
        // AdLoadConfigTool.setInterstitialSharePlacementConfig(loadConfigDict)
        
        ATAdManager.shared().loadAD(withPlacementID: interstitialPlacementID, extra: loadConfigDict, delegate: self)
    }
    
    // MARK: - Show Ad
    
    /// Show ad button clicked
    override func showAd() {
        // Scene statistics function (optional integration)
        ATAdManager.shared().entryInterstitialScenario(withPlacementID: interstitialPlacementID, scene: interstitialSceneID)
        
        // Query ad cache available for display (optional integration)
        // let adCaches = ATAdManager.shared().getInterstitialValidAds(forPlacementID: interstitialPlacementID)
        // ATDemoLog("getValidAds : %@", adCaches)
        
        // Query ad loading status (optional integration)
        // let status = ATAdManager.shared().checkInterstitialLoadStatus(forPlacementID: interstitialPlacementID)
        // ATDemoLog("checkLoadStatus : %d", status.isLoading)
        
        // Check if ready
        if !ATAdManager.shared().interstitialReady(forPlacementID: interstitialPlacementID) {
            loadAd()
            return
        }
        
        // Show configuration, Scene passes backend scene ID, pass empty string if none, showCustomExt parameter can pass custom parameter string
        let config = ATShowConfig(scene: interstitialSceneID, showCustomExt: "testShowCustomExt")
        
        // Show ad
        // For full-screen interstitial, inViewController can pass root controller like tabbarController or navigationController to let ad cover tabbar or navigationBar
        ATAdManager.shared().showInterstitial(withPlacementID: interstitialPlacementID,
                                            showConfig: config,
                                            in: self,
                                            delegate: self,
                                            nativeMixViewBlock: nil)
    }
}

// MARK: - ATAdLoadingDelegate

extension InterstitialVC: ATAdLoadingDelegate {
    
    /// Placement loading completed
    /// - Parameter placementID: Placement ID
    func didFinishLoadingAD(withPlacementID placementID: String) {
        let isReady = ATAdManager.shared().interstitialReady(forPlacementID: placementID)
        showLog(String(format: "didFinishLoadingADWithPlacementID:%@ interstitial ready:%@", placementID, isReady ? "YES" : "NO"))
        
        // Reset retry attempts
        retryAttempt = 0
    }
    
    /// Placement loading failed
    /// - Parameters:
    ///   - placementID: Placement ID
    ///   - error: Error information
    func didFailToLoadAD(withPlacementID placementID: String, error: Error) {
        ATDemoLog("didFailToLoadADWithPlacementID:%@ error:%@", placementID, error.localizedDescription)
        showLog(String(format: "didFailToLoadADWithPlacementID:%@ errorCode:%ld", placementID, (error as NSError).code))
        
        // Retry has reached 3 times, no more retry loading
        if retryAttempt >= 3 {
            return
        }
        retryAttempt += 1
        
        // Calculate delay time: power of 2, maximum 8 seconds
        let delaySec = pow(2.0, Double(min(3, retryAttempt)))
        
        // Delay retry loading ad
        DispatchQueue.main.asyncAfter(deadline: .now() + delaySec) { [weak self] in
            self?.loadAd()
        }
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

// MARK: - ATInterstitialDelegate

extension InterstitialVC: ATInterstitialDelegate {
    
    /// Ad displayed
    /// - Parameters:
    ///   - placementID: Placement ID
    ///   - extra: Extra information dictionary
    func interstitialDidShow(forPlacementID placementID: String, extra: [AnyHashable : Any]) {
        ATDemoLog("interstitialDidShowForPlacementID:%@ extra:%@", placementID, extra)
        showLog(String(format: "interstitialDidShowForPlacementID:%@", placementID))
    }
    
    /// Ad failed to display
    /// - Parameters:
    ///   - placementID: Placement ID
    ///   - error: Error information
    ///   - extra: Extra information dictionary
    func interstitialFailedToShow(forPlacementID placementID: String, error: Error, extra: [AnyHashable : Any]) {
        ATDemoLog("interstitialFailedToShowForPlacementID:%@ error:%@ extra:%@", placementID, error.localizedDescription, extra)
        showLog(String(format: "interstitialFailedToShowForPlacementID:%@ error:%@", placementID, error.localizedDescription))
    }
    
    /// Video playback failed
    /// - Parameters:
    ///   - placementID: Placement ID
    ///   - error: Error information
    ///   - extra: Extra information dictionary
    func interstitialDidFailToPlayVideo(forPlacementID placementID: String, error: Error, extra: [AnyHashable : Any]) {
        ATDemoLog("interstitialDidFailToPlayVideoForPlacementID:%@ error:%@ extra:%@", placementID, error.localizedDescription, extra)
        showLog(String(format: "interstitialDidFailToPlayVideoForPlacementID:%@ errorCode:%ld", placementID, (error as NSError).code))
        
        // Preload next ad
        loadAd()
    }
    
    /// Video started playing
    /// - Parameters:
    ///   - placementID: Placement ID
    ///   - extra: Extra information dictionary
    func interstitialDidStartPlayingVideo(forPlacementID placementID: String, extra: [AnyHashable : Any]) {
        ATDemoLog("interstitialDidStartPlayingVideoForPlacementID:%@ extra:%@", placementID, extra)
        showLog(String(format: "interstitialDidStartPlayingVideoForPlacementID:%@", placementID))
    }
    
    /// Video playback completed
    /// - Parameters:
    ///   - placementID: Placement ID
    ///   - extra: Extra information dictionary
    func interstitialDidEndPlayingVideo(forPlacementID placementID: String, extra: [AnyHashable : Any]) {
        ATDemoLog("interstitialDidEndPlayingVideoForPlacementID:%@ extra:%@", placementID, extra)
        showLog(String(format: "interstitialDidEndPlayingVideoForPlacementID:%@", placementID))
    }
    
    /// Ad closed
    /// - Parameters:
    ///   - placementID: Placement ID
    ///   - extra: Extra information dictionary
    func interstitialDidClose(forPlacementID placementID: String, extra: [AnyHashable : Any]) {
        ATDemoLog("interstitialDidCloseForPlacementID:%@ extra:%@", placementID, extra)
        showLog(String(format: "interstitialDidCloseForPlacementID:%@", placementID))
        
        // Preload next ad
        loadAd()
    }
    
    /// Ad clicked (redirect)
    /// - Parameters:
    ///   - placementID: Placement ID
    ///   - extra: Extra information dictionary
    func interstitialDidClick(forPlacementID placementID: String, extra: [AnyHashable : Any]) {
        ATDemoLog("interstitialDidClickForPlacementID:%@ extra:%@", placementID, extra)
        showLog(String(format: "interstitialDidClickForPlacementID:%@", placementID))
    }
}
