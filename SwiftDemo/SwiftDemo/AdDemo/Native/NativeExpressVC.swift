//
//  ExpressVC.swift
//  SwiftDemo
//
//  Created by ltz on 2025/1/18.
//

import UIKit
import AnyThinkSDK

// MARK: - Constants
private let ExpressAdWidth: CGFloat = kScreenW
private let ExpressAdHeight: CGFloat = kScreenW / 2.0
private let ExpressMediaViewWidth: CGFloat = kScreenW
private let ExpressMediaViewHeight: CGFloat = 350 - kNavigationBarHeight - 150

class NativeExpressVC: BaseNormalBarVC {
    
    // MARK: - Properties
    private var adView: ATNativeADView?
    private var nativeAdOffer: ATNativeAdOffer?
    // Retry attempts counter
    private var retryAttempt: Int = 0
    
    // Placement ID
    // Third-party ad platform with native template rendering
    private let nativeExpressPlacementID = "b680af46e13e5c"
    
    // SDK rendering - actual third-party ad is self-rendered placement
    // private let nativeExpressPlacementID = "n67ff515ba1460"
    
    // Scene ID, optional, can be generated in dashboard. Pass empty string if none
    private let nativeExpressSceneID = ""
    
    // MARK: - Load Ad
    /// Load ad
    override func loadAd() {
        
        showLog(kLocalizeStr("Clicked load ad"))
        
        var loadConfigDict: [String: Any] = [:]
        
        // Request template ad with specified size, ad platform will match this size to return ad, not necessarily exact match, depends on template type selected in ad platform dashboard
        loadConfigDict[kATExtraInfoNativeAdSizeKey] = NSValue(cgSize: CGSize(width: ExpressAdWidth, height: ExpressAdHeight))
        
        ATAdManager.shared().loadAD(withPlacementID: nativeExpressPlacementID, extra: loadConfigDict, delegate: self)
    }
    
    // MARK: - Show Ad
    /// Show ad
    override func showAd() {
        
        // Scene statistics feature, optional integration
        ATAdManager.shared().entryNativeScenario(withPlacementID: nativeExpressPlacementID, scene: nativeExpressSceneID)
        
        // Query available ad cache for display (optional integration)
        // let adCaches = ATAdManager.shared().getNativeValidAds(forPlacementID: nativeExpressPlacementID)
        // ATDemoLog("getValidAds : \(adCaches)")
        
        // Query ad loading status (optional integration)
        // let status = ATAdManager.shared().checkNativeLoadStatus(forPlacementID: nativeExpressPlacementID)
        // ATDemoLog("checkLoadStatus : \(status.isLoading)")
        
        // Check if ready
        if !ATAdManager.shared().nativeAdReady(forPlacementID: nativeExpressPlacementID) {
            loadAd()
            return
        }
        
        // Initialize config configuration
        let config = ATNativeADConfiguration()
        // Set size for template ad nativeADView, usually the size set when requesting ad
        config.adFrame = CGRect(x: 0, y: 0, width: ExpressAdWidth, height: ExpressAdHeight)
        config.delegate = self
        // Set display root controller
        config.rootViewController = self
        // Enable template ad adaptive height, when actual returned ad size differs from requested size, SDK will automatically adjust nativeADView size to actual returned ad size.
        config.sizeToFit = true
        // Set auto-play only in WiFi mode, effective for some ad platforms
        config.videoPlayType = .onlyWiFiAutoPlayType
        
        // Get offer ad object, consumes one ad cache after retrieval
        guard let offer = ATAdManager.shared().getNativeAdOffer(withPlacementID: nativeExpressPlacementID, scene: nativeExpressSceneID) else {
            return
        }
    
        let offerInfoDict = Tools.getOfferInfo(offer)
        ATDemoLog("🔥🔥🔥--Express ad material, before display: \(offerInfoDict)")
        self.nativeAdOffer = offer
        
        // Create ad nativeADView
        let nativeADView = ATNativeADView(configuration: config, currentOffer: offer, placementID: nativeExpressPlacementID)
        
        // Print information for debugging
        // printNativeAdInfoAfterRenderer(offer: offer, nativeADView: nativeADView)
         
        // Render ad
        offer.renderer(with: config, selfRenderView: nil, nativeADView: nativeADView)
        
        // Reference
        self.adView = nativeADView
        
        var trueExpressWidth : CGFloat = offer.nativeAd.nativeExpressAdViewWidth
        var trueExpressHeight : CGFloat = offer.nativeAd.nativeExpressAdViewHeight
        
        if (trueExpressWidth == 0) {
            trueExpressWidth = nativeADView.frame.size.width
        }
        
        if (trueExpressHeight == 0) {
            trueExpressHeight = nativeADView.frame.size.height
        }
        
        //use trueExpressWidth，trueExpressHeight
        nativeADView.frame.size = CGSizeMake(trueExpressWidth, trueExpressHeight)
        
        // Show ad
        let showVc = AdDisplayVC(adView: nativeADView, offer: offer, adViewSize: CGSize(width: ExpressAdWidth, height: ExpressAdHeight))
        navigationController?.pushViewController(showVc, animated: true)
    }
    
    /// Print related information for testing
    /// - Parameters:
    ///   - offer: Ad material
    ///   - nativeADView: Ad object view
    func printNativeAdInfoAfterRenderer(offer: ATNativeAdOffer, nativeADView: ATNativeADView) {
        let nativeAdRenderType = nativeADView.getCurrentNativeAdRenderType()
        if nativeAdRenderType == .express {
            ATDemoLog("✅✅✅--Template ad")
            ATDemoLog("🔥--Template ad width/height: \(offer.nativeAd.nativeExpressAdViewWidth), \(offer.nativeAd.nativeExpressAdViewHeight), requested width/height: \(ExpressAdWidth),\(ExpressAdHeight), if size difference is too large, check dashboard template configuration")
        } else {
            ATDemoLog("⚠️⚠️⚠️--This is self-rendered ad")
        }
        let isVideoContents = nativeADView.isVideoContents()
        ATDemoLog("🔥--Is native video ad: \(isVideoContents)")
    }
    
    // MARK: - Remove Ad
    func removeAd() {
        if let adView = self.adView, adView.superview != nil {
            adView.removeFromSuperview()
        }
        adView?.destroyNative()
        adView = nil
    }
    
    deinit {
        // Purpose is to correctly release: adView.destroyNative()
        removeAd()
    }
}

// MARK: - ATNativeADDelegate
extension NativeExpressVC: ATNativeADDelegate {
    
    // MARK: - Placement Delegate Callbacks
    /// Placement loading completed
    /// - Parameter placementID: Placement ID
    func didFinishLoadingAD(withPlacementID placementID: String) {
        let isReady = ATAdManager.shared().nativeAdReady(forPlacementID: placementID)
        showLog("didFinishLoadingADWithPlacementID:\(placementID) Express is ready:\(isReady ? "YES" : "NO")")
        
        // Reset retry attempts
        retryAttempt = 0
    }
    
    /// Placement loading failed
    /// - Parameters:
    ///   - placementID: Placement ID
    ///   - error: Error information
    func didFailToLoadAD(withPlacementID placementID: String, error: Error) {
        ATDemoLog("didFailToLoadADWithPlacementID:\(placementID) error:\(error)")
        showLog("didFailToLoadADWithPlacementID:\(placementID) errorCode:\((error as NSError).code)")
        
        // Retry has reached 3 times, no more retry loading
        if retryAttempt >= 3 {
            return
        }
        retryAttempt += 1
        
        // Calculate delay time: power of 2, maximum 8 seconds
        let delaySec = pow(2.0, Double(min(3, retryAttempt)))
        
        // Delayed retry loading ad
        DispatchQueue.main.asyncAfter(deadline: .now() + delaySec) {
            self.loadAd()
        }
    }
    
    /// Received display revenue
    /// - Parameters:
    ///   - placementID: Placement ID
    ///   - extra: Extra information dictionary
    func didRevenue(forPlacementID placementID: String, extra: [AnyHashable : Any]) {
        ATDemoLog("didRevenueForPlacementID:\(placementID) with extra: \(extra)")
        showLog("didRevenueForPlacementID:\(placementID)")
    }
    
    // MARK: - Native Ad Event Callbacks
    
    /// Native ad displayed
    /// - Parameters:
    ///   - adView: Ad view object
    ///   - placementID: Placement ID
    ///   - extra: Extra information
    func didShowNativeAd(in adView: ATNativeADView, placementID: String, extra: [AnyHashable : Any]) {
        ATDemoLog("didShowNativeAdInAdView:\(placementID) extra:\(extra)")
        showLog("didShowNativeAdInAdView:\(placementID)")
        ATDemoLog("🔥--Native ad adInfo information, after display: \(nativeAdOffer?.adOfferInfo ?? [:])")
    }
    
    /// Native ad clicked close button
    /// - Parameters:
    ///   - adView: Ad view object
    ///   - placementID: Placement ID
    ///   - extra: Extra information
    func didTapCloseButton(in adView: ATNativeADView, placementID: String, extra: [AnyHashable : Any]) {
        ATDemoLog("didTapCloseButtonInAdView:\(placementID) extra:\(extra)")
        showLog("didTapCloseButtonInAdView:\(placementID)")
        
        // Destroy ad
        removeAd()
        // Preload next ad
        loadAd()
    }
    
    /// Native ad started playing video
    /// - Parameters:
    ///   - adView: Ad view object
    ///   - placementID: Placement ID
    ///   - extra: Extra information dictionary
    func didStartPlayingVideo(in adView: ATNativeADView, placementID: String, extra: [AnyHashable : Any]) {
        ATDemoLog("didStartPlayingVideoInAdView:\(placementID) extra: \(extra)")
        showLog("didStartPlayingVideoInAdView:\(placementID)")
    }
    
    /// Native ad video playback ended
    /// - Parameters:
    ///   - adView: Ad view object
    ///   - placementID: Placement ID
    ///   - extra: Extra information dictionary
    func didEndPlayingVideo(in adView: ATNativeADView, placementID: String, extra: [AnyHashable : Any]) {
        ATDemoLog("didEndPlayingVideoInAdView:\(placementID) extra: \(extra)")
        showLog("didEndPlayingVideoInAdView:\(placementID)")
    }
    
    /// Native ad user clicked
    /// - Parameters:
    ///   - adView: Ad view object
    ///   - placementID: Placement ID
    ///   - extra: Extra information dictionary
    func didClickNativeAd(in adView: ATNativeADView, placementID: String, extra: [AnyHashable : Any]) {
        ATDemoLog("didClickNativeAdInAdView:\(placementID) extra:\(extra)")
        showLog("didClickNativeAdInAdView:\(placementID)")
    }
    
    /// Native ad opened or jumped to deep link page
    /// - Parameters:
    ///   - adView: Ad view object
    ///   - placementID: Placement ID
    ///   - extra: Extra information
    ///   - success: Whether successful
    func didDeepLinkOrJump(in adView: ATNativeADView, placementID: String, extra: [AnyHashable : Any], result success: Bool) {
        ATDemoLog("didDeepLinkOrJumpInAdView:placementID:\(placementID) with extra: \(extra), success:\(success ? "YES" : "NO")")
        showLog("didDeepLinkOrJumpInAdView:\(placementID), success:\(success ? "YES" : "NO")")
    }
    
    /// Native ad entered fullscreen video playback, usually auto-jumps to a playback landing page after clicking video mediaView
    /// - Parameters:
    ///   - adView: Ad view object
    ///   - placementID: Placement ID
    ///   - extra: Extra information
    func didEnterFullScreenVideo(in adView: ATNativeADView, placementID: String, extra: [AnyHashable : Any]) {
        ATDemoLog("didEnterFullScreenVideoInAdView:\(placementID)")
        showLog("didEnterFullScreenVideoInAdView:\(placementID)")
    }
    
    /// Native ad exited fullscreen video playback
    /// - Parameters:
    ///   - adView: Ad view object
    ///   - placementID: Placement ID
    ///   - extra: Extra information
    func didExitFullScreenVideo(in adView: ATNativeADView, placementID: String, extra: [AnyHashable : Any]) {
        ATDemoLog("didExitFullScreenVideoInAdView:\(placementID)")
        showLog("didExitFullScreenVideoInAdView:\(placementID)")
    }
    
    /// Native ad exited detail page
    /// - Parameters:
    ///   - adView: Ad view object
    ///   - placementID: Placement ID
    ///   - extra: Extra information
    func didCloseDetail(in adView: ATNativeADView, placementID: String, extra: [AnyHashable : Any]) {
        ATDemoLog("didCloseDetailInAdView:\(placementID) extra:\(extra)")
        showLog("didCloseDetailInAdView:\(placementID)")
    }
}
