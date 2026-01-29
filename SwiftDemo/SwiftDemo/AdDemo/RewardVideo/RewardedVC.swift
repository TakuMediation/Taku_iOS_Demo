//
//  RewardedVC.swift
//  SwiftDemo
//
//  Created by ltz on 2025/8/20.
//

import UIKit
import AnyThinkSDK

class RewardedVC: BaseNormalBarVC {
    
    // MARK: - Properties
    
    /// Retry attempt counter
    private var retryAttempt: Int = 0
    
    // MARK: - Constants
    
    /// Placement ID
    private let rewardedPlacementID = "b67f4ab93eb3a7"
    
    /// Scene ID, optional, can be generated in backend. Pass empty string if none
    private let rewardedSceneID = ""
    
    // MARK: - Load Ad
    
    /// Load ad button clicked
    override func loadAd() {
        showLog(kLocalizeStr("Load ad clicked"))
        
        var loadConfigDict: [String: Any] = [:]
        // Optional integration, the following key parameters are applicable to server-side reward verification of ad platforms and will be passed through
        loadConfigDict[kATAdLoadingExtraMediaExtraKey] = "media_val_RewardedVC"
        loadConfigDict[kATAdLoadingExtraUserIDKey] = "rv_test_user_id"
        loadConfigDict[kATAdLoadingExtraRewardNameKey] = "reward_Name"
        loadConfigDict[kATAdLoadingExtraRewardAmountKey] = 3
        
        // (Optional integration) If using Klevin ad platform, can add the following configuration
        // AdLoadConfigTool.rewarded_loadExtraConfigAppend_Klevin(&loadConfigDict)
        
        // (Optional integration) If shared placement is enabled, configure related settings
        // AdLoadConfigTool.setInterstitialSharePlacementConfig(loadConfigDict)
        
        ATAdManager.shared().loadAD(withPlacementID: rewardedPlacementID, extra: loadConfigDict, delegate: self)
    }
    
    // MARK: - Show Ad
    
    /// Show ad button clicked
    override func showAd() {
        // Scene statistics function (optional integration)
        ATAdManager.shared().entryRewardedVideoScenario(withPlacementID: rewardedPlacementID, scene: rewardedSceneID)
        
        // Query available ad cache for display (optional integration)
        // let adCaches = ATAdManager.shared().getRewardedVideoValidAds(forPlacementID: rewardedPlacementID)
        // ATDemoLog("getValidAds : \(adCaches)")
        
        // Query ad loading status (optional integration)
        // let status = ATAdManager.shared().checkRewardedVideoLoadStatus(forPlacementID: rewardedPlacementID)
        // ATDemoLog("checkLoadStatus : \(status.isLoading)")
        
        // Check if ready
        if !ATAdManager.shared().rewardedVideoReady(forPlacementID: rewardedPlacementID) {
            loadAd()
            return
        }
        
        // Display configuration, Scene passes backend scene ID, pass empty string if none, showCustomExt parameter can pass custom parameter string
        let config = ATShowConfig(scene: rewardedSceneID, showCustomExt: "testShowCustomExt")
        
        // Show ad
        ATAdManager.shared().showRewardedVideo(withPlacementID: rewardedPlacementID, config: config, in: self, delegate: self)
    }
}

// MARK: - ATAdLoadingDelegate

extension RewardedVC: ATAdLoadingDelegate {
    
    /// Placement loading completed
    /// - Parameter placementID: Placement ID
    func didFinishLoadingAD(withPlacementID placementID: String) {
        let isReady = ATAdManager.shared().rewardedVideoReady(forPlacementID: placementID)
        showLog(String(format: "didFinishLoadingADWithPlacementID:%@ Rewarded ready:%@", placementID, isReady ? "YES" : "NO"))
        
        // Reset retry attempt
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
        
        // Delayed retry loading ad
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

// MARK: - ATRewardedVideoDelegate

extension RewardedVC: ATRewardedVideoDelegate {
    
    /// Reward success
    /// - Parameters:
    ///   - placementID: Placement ID
    ///   - extra: Extra information dictionary
    func rewardedVideoDidRewardSuccess(forPlacemenID placementID: String, extra: [AnyHashable : Any]) {
        ATDemoLog("rewardedVideoDidRewardSuccessForPlacemenID:%@ extra:%@", placementID, extra)
        showLog(String(format: "rewardedVideoDidRewardSuccess:%@", placementID))
    }
    
    /// Rewarded video started playing
    /// - Parameters:
    ///   - placementID: Placement ID
    ///   - extra: Extra information dictionary
    func rewardedVideoDidStartPlaying(forPlacementID placementID: String, extra: [AnyHashable : Any]) {
        ATDemoLog("rewardedVideoDidStartPlayingForPlacementID:%@ extra:%@", placementID, extra)
        showLog(String(format: "rewardedVideoDidStartPlaying:%@", placementID))
    }
    
    /// Rewarded video finished playing
    /// - Parameters:
    ///   - placementID: Placement ID
    ///   - extra: Extra information dictionary
    func rewardedVideoDidEndPlaying(forPlacementID placementID: String, extra: [AnyHashable : Any]) {
        ATDemoLog("rewardedVideoDidEndPlayingForPlacementID:%@ extra:%@", placementID, extra)
        showLog(String(format: "rewardedVideoDidEndPlaying:%@", placementID))
    }
    
    /// Rewarded video playback failed
    /// - Parameters:
    ///   - placementID: Placement ID
    ///   - error: Error information
    ///   - extra: Extra information dictionary
    func rewardedVideoDidFailToPlay(forPlacementID placementID: String, error: Error, extra: [AnyHashable : Any]) {
        ATDemoLog("rewardedVideoDidFailToPlayForPlacementID:%@ error:%@ extra:%@", placementID, error.localizedDescription, extra)
        showLog(String(format: "rewardedVideoDidFailToPlay:%@ errorCode:%ld", placementID, (error as NSError).code))
        
        // Preload
        loadAd()
    }
    
    /// Rewarded ad closed
    /// - Parameters:
    ///   - placementID: Placement ID
    ///   - rewarded: Whether reward was successful, YES means reward success callback was triggered
    ///   - extra: Extra information dictionary
    func rewardedVideoDidClose(forPlacementID placementID: String, rewarded: Bool, extra: [AnyHashable : Any]) {
        ATDemoLog("rewardedVideoDidCloseForPlacementID:%@, rewarded:%@ extra:%@", placementID, rewarded ? "yes" : "no", extra)
        showLog(String(format: "rewardedVideoDidClose:%@, rewarded:%@", placementID, rewarded ? "yes" : "no"))
        
        // Preload
        loadAd()
    }
    
    /// Rewarded ad clicked
    /// - Parameters:
    ///   - placementID: Placement ID
    ///   - extra: Extra information dictionary
    func rewardedVideoDidClick(forPlacementID placementID: String, extra: [AnyHashable : Any]) {
        ATDemoLog("rewardedVideoDidClickForPlacementID:%@ extra:%@", placementID, extra)
        showLog(String(format: "rewardedVideoDidClick:%@", placementID))
    }
    
    /// Rewarded ad opened or jumped to deep link page
    /// - Parameters:
    ///   - placementID: Placement ID
    ///   - extra: Extra information
    ///   - success: Whether successful
    func rewardedVideoDidDeepLinkOrJump(forPlacementID placementID: String, extra: [AnyHashable : Any], result success: Bool) {
        ATDemoLog("rewardedVideoDidDeepLinkOrJumpForPlacementID:placementID:%@ with extra: %@, success:%@", placementID, extra, success ? "YES" : "NO")
        showLog(String(format: "rewardedVideoDidDeepLinkOrJump:%@, success:%@", placementID, success ? "YES" : "NO"))
    }
    
    // MARK: - Rewarded video again delegate
    
    // Supports rewarded video "watch again" capability (abbreviated as reward again). After enabling this feature, the aggregation dimension will automatically cache a rewarded video ad, and after the first ad display and receiving the reward callback, it will render a retention popup to guide users to "watch again for more rewards". After the user clicks, the cached ad will automatically play, which helps improve user ad value and active duration.
    // If you have enabled the "watch again" feature in the backend configuration, please implement the relevant callbacks. (CSJ platform supported)
    
    /// Rewarded video again reward success
    /// - Parameters:
    ///   - placementID: Placement ID
    ///   - extra: Extra information dictionary
    func rewardedVideoAgainDidRewardSuccess(forPlacemenID placementID: String, extra: [AnyHashable : Any]) {
        ATDemoLog("rewardedVideoAgainDidRewardSuccessForPlacemenID:%@ extra:%@", placementID, extra)
        showLog(String(format: "rewardedVideoAgainDidRewardSuccess:%@", placementID))
    }
    
    /// Rewarded video again started playing
    /// - Parameters:
    ///   - placementID: Placement ID
    ///   - extra: Extra information dictionary
    func rewardedVideoAgainDidStartPlaying(forPlacementID placementID: String, extra: [AnyHashable : Any]) {
        ATDemoLog("rewardedVideoAgainDidStartPlayingForPlacementID:%@ extra:%@", placementID, extra)
        showLog(String(format: "rewardedVideoAgainDidStartPlaying:%@", placementID))
    }
    
    /// Rewarded video again finished playing
    /// - Parameters:
    ///   - placementID: Placement ID
    ///   - extra: Extra information dictionary
    func rewardedVideoAgainDidEndPlaying(forPlacementID placementID: String, extra: [AnyHashable : Any]) {
        ATDemoLog("rewardedVideoAgainDidEndPlayingForPlacementID:%@ extra:%@", placementID, extra)
        showLog(String(format: "rewardedVideoAgainDidEndPlaying:%@", placementID))
    }
    
    /// Rewarded video again playback failed
    /// - Parameters:
    ///   - placementID: Placement ID
    ///   - error: Error information
    ///   - extra: Extra information dictionary
    func rewardedVideoAgainDidFailToPlay(forPlacementID placementID: String, error: Error, extra: [AnyHashable : Any]) {
        ATDemoLog("rewardedVideoAgainDidFailToPlayForPlacementID:%@ extra:%@", placementID, extra)
        showLog(String(format: "rewardedVideoAgainDidFailToPlay:%@ errorCode:%ld", placementID, (error as NSError).code))
    }
    
    /// Rewarded video again clicked
    /// - Parameters:
    ///   - placementID: Placement ID
    ///   - extra: Extra information dictionary
    func rewardedVideoAgainDidClick(forPlacementID placementID: String, extra: [AnyHashable : Any]) {
        ATDemoLog("rewardedVideoAgainDidClickForPlacementID:%@ extra:%@", placementID, extra)
        showLog(String(format: "rewardedVideoAgainDidClick:%@", placementID))
    }
}
