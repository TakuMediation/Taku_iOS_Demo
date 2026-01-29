//
//  SelfRenderVC.swift
//  SwiftDemo
//
//  Created by ltz on 2025/1/11.
//

import UIKit
import AnyThinkSDK

// MARK: - Constants
private let SelfRenderViewWidth: CGFloat = kScreenW
private let SelfRenderViewHeight: CGFloat = 350
private let SelfRenderViewMediaViewWidth: CGFloat = kScreenW
private let SelfRenderViewMediaViewHeight: CGFloat = 175

class NativeSelfRenderVC: BaseNormalBarVC {
    
    // MARK: - Properties
    private var adView: ATNativeADView?
    private var selfRenderView: SelfRenderView?
    private var nativeAdOffer: ATNativeAdOffer?
    // Retry attempt counter
    private var retryAttempt: Int = 0
    
    // Placement ID
    private let nativeSelfRenderPlacementID = "b680af2c216f73"
    
    // Scene ID, optional, can be generated in the backend. Pass empty string if not available
    private let nativeSelfRenderSceneID = ""
    
    // MARK: - Load Ad
    /// Load ad
    override func loadAd() {
        
        showLog(kLocalizeStr("Clicked load ad"))
        
        var loadConfigDict: [String: Any] = [:]
        
        // Set ad request size
        loadConfigDict[kATExtraInfoNativeAdSizeKey] = NSValue(cgSize: CGSize(width: SelfRenderViewWidth, height: SelfRenderViewHeight))
        AdLoadConfigTool.native_loadExtraConfigAppend_SizeToFit(&loadConfigDict)
        
        // KuaiShou native ad swipe and click control
        // AdLoadConfigTool.native_loadExtraConfigAppend_KuaiShou_SlideOrClickAble(loadConfigDict)
        
        ATAdManager.shared().loadAD(withPlacementID: nativeSelfRenderPlacementID, extra: loadConfigDict, delegate: self)
    }
    
    // MARK: - Show Ad
    /// Show ad
    override func showAd() {
        
        // Scene statistics feature, optional integration
        ATAdManager.shared().entryNativeScenario(withPlacementID: nativeSelfRenderPlacementID, scene: nativeSelfRenderSceneID)
        
        // Query available ad cache for display (optional integration)
        // let adCaches = ATAdManager.shared().getNativeValidAds(forPlacementID: nativeSelfRenderPlacementID)
        // ATDemoLog("getValidAds : \(adCaches)")
        
        // Query ad loading status (optional integration)
        // let status = ATAdManager.shared().checkNativeLoadStatus(forPlacementID: nativeSelfRenderPlacementID)
        // ATDemoLog("checkLoadStatus : \(status.isLoading)")
        
        // Check if ready
        if !ATAdManager.shared().nativeAdReady(forPlacementID: nativeSelfRenderPlacementID) {
            loadAd()
            return
        }
        
        // Initialize config configuration
        let config = ATNativeADConfiguration()
        // Pre-layout for native ad
        config.adFrame = CGRect(x: 0, y: 0, width: SelfRenderViewWidth, height: SelfRenderViewHeight)
        // Pre-layout for video player, recommend to layout again after adding to custom view
        config.mediaViewFrame = CGRect(x: 0, y: 0, width: SelfRenderViewMediaViewWidth, height: SelfRenderViewMediaViewHeight)
        config.delegate = self
        config.rootViewController = self
        // Make ad view container fit the ad
        config.sizeToFit = true
        // Set auto-play only in WiFi mode, effective for some ad platforms
        config.videoPlayType = .onlyWiFiAutoPlayType
        
        // Custom logo frame
//        config.logoViewFrame = CGRect(x: , y: , width: , height: )
        
        // Set ad platform logo position preference (some ad platforms cannot be precisely set, use the code below, Demo examples all show bottom-right corner)
        // Only when logoUrl or logo has value in material offer, can be set through SelfRenderView layout, otherwise use examples in this method for precise control or preference position setting.
        ATAPI.sharedInstance().preferredAdLogoPosition = .bottomRightCorner
        
        // Set ad identifier coordinates x and y, effective for some ad platforms, set outside screen to achieve hiding effect
        // config.adChoicesViewOrigin = CGPoint(x: 10, y: 10)
        
        // Get offer ad object, consumes one ad cache after retrieval
        guard let offer = ATAdManager.shared().getNativeAdOffer(withPlacementID: nativeSelfRenderPlacementID, scene: nativeSelfRenderSceneID) else {
            return
        }
        
        let offerInfoDict = Tools.getOfferInfo(offer)
        ATDemoLog("🔥🔥🔥--Self-render ad material, before display: \(offerInfoDict)")
        self.nativeAdOffer = offer
        
        // Create self-render view and assign values based on offer information
        let selfRenderView = SelfRenderView(offer: offer)
        
        // Create ad nativeADView
        // Get native ad display container view
        let nativeADView = ATNativeADView(configuration: config, currentOffer: offer, placementID: nativeSelfRenderPlacementID)
        
        // Create container array for clickable components
        var clickableViewArray: [UIView] = []
        
        // Get mediaView, need to add to self-render view manually, must call
        if let mediaView = nativeADView.getMediaView() {
            // Assign and layout
            selfRenderView.mediaView = mediaView
        }
        
        // Set UI controls that need to register click events, better not to add the entire parent view of the feed to click events, otherwise clicking the close button may still trigger the feed click event.
        // Close button (dislikeButton) does not need to register click events
        clickableViewArray.append(contentsOf: [selfRenderView.iconImageView,
                                               selfRenderView.titleLabel,
                                               selfRenderView.textLabel,
                                               selfRenderView.ctaLabel,
                                               selfRenderView.mainImageView])
        
        // Register click events for UI controls
        nativeADView.registerClickableViewArray(clickableViewArray)
        
        // Bind components
        let info = ATNativePrepareInfo.load { prepareInfo in
            prepareInfo.textLabel = selfRenderView.textLabel
            prepareInfo.advertiserLabel = selfRenderView.advertiserLabel
            prepareInfo.titleLabel = selfRenderView.titleLabel
            prepareInfo.ratingLabel = selfRenderView.ratingLabel
            prepareInfo.iconImageView = selfRenderView.iconImageView
            prepareInfo.mainImageView = selfRenderView.mainImageView
            prepareInfo.ctaLabel = selfRenderView.ctaLabel
            prepareInfo.dislikeButton = selfRenderView.dislikeButton
            if selfRenderView.mediaView != nil {
                prepareInfo.mediaView = selfRenderView.mediaView!
            }
        }
        nativeADView.prepare(with: info)
        
        // Render ad
        offer.renderer(with: config, selfRenderView: selfRenderView, nativeADView: nativeADView)
        
        // Custom logo position and frame , plz call after offer.renderer
        // if let logoImageView = nativeADView.logoImageView, logoImageView.superview != nil {
        //     logoImageView.mas_remakeConstraints { make in
        //         make?.right.bottom.mas_equalTo()(nativeADView).mas_offset()(-10)
        //         make?.width.height.mas_equalTo()(20)
        //     }
        // }
        
        // For testing print
        // printNativeAdInfoAfterRenderer(offer: offer, nativeADView: nativeADView)
        
        self.adView = nativeADView
        
        // Show ad
        let showVc = AdDisplayVC(adView: nativeADView, offer: offer, adViewSize: CGSize(width: SelfRenderViewWidth, height: SelfRenderViewHeight))
        navigationController?.pushViewController(showVc, animated: true)
    }
    
    /// Print related information for testing
    /// - Parameters:
    ///   - offer: Ad material
    ///   - nativeADView: Ad object view
    func printNativeAdInfoAfterRenderer(offer: ATNativeAdOffer, nativeADView: ATNativeADView) {
        let nativeAdRenderType = nativeADView.getCurrentNativeAdRenderType()
        if nativeAdRenderType == .express {
            ATDemoLog("⚠️⚠️⚠️--This is native template")
        } else {
            ATDemoLog("✅✅✅--This is native self-render")
        }
        let isVideoContents = nativeADView.isVideoContents()
        
        // Print all material content
        Tools.printNativeAdOffer(offer)
        ATDemoLog("🔥--Is native video ad: \(isVideoContents)")
    }
    
    // MARK: - Remove Ad
    func removeAd() {
        if let adView = self.adView, adView.superview != nil {
            adView.removeFromSuperview()
        }
        adView?.destroyNative()
        adView = nil
        // Destroy offer more timely
        selfRenderView?.destory()
        selfRenderView = nil
    }
    
    deinit {
        // Purpose is to correctly release: adView.destroyNative()
        removeAd()
    }
}

// MARK: - ATNativeADDelegate
extension NativeSelfRenderVC: ATNativeADDelegate {
    
    // MARK: - Placement Delegate Callbacks
    /// Placement loading completed
    /// - Parameter placementID: Placement ID
    func didFinishLoadingAD(withPlacementID placementID: String) {
        let isReady = ATAdManager.shared().nativeAdReady(forPlacementID: placementID)
        showLog("didFinishLoadingADWithPlacementID:\(placementID) SelfRender is ready:\(isReady ? "YES" : "NO")")
        
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
        // Preload the next ad
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
