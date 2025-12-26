//
//  FeedSelfRenderVC.swift
//  SwiftDemo
//
//  Created by ltz on 2025/1/21.
//

import UIKit
import AnyThinkNative
import MJRefresh
import SnapKit

// MARK: - Constants
private let SelfRenderViewWidth: CGFloat = kScreenW
private let SelfRenderViewHeight: CGFloat = 350
private let SelfRenderViewMediaViewWidth: CGFloat = kScreenW
private let SelfRenderViewMediaViewHeight: CGFloat = 175

private let Feed_Native_SelfRender_PlacementID = "b67fdd0d08be70"
private let Feed_Native_SelfRender_SceneID = ""

// MARK: - Models
class DemoOfferAdModel: NSObject {
    var nativeADView: ATNativeADView?
    var offer: ATNativeAdOffer?
    var isNativeAd: Bool = false
}

class FeedSelfRenderVC: BaseNormalBarVC {
    
    // MARK: - Properties
    private var dataSourceArray: [DemoOfferAdModel] = []
    
    private lazy var feedTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.register(FeedCustomCell.self, forCellReuseIdentifier: "FeedCustomCell")
        tableView.register(AdCell.self, forCellReuseIdentifier: "AdCell")
        tableView.estimatedRowHeight = SelfRenderViewHeight
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    deinit {
        ATDemoLog("FeedSelfRenderVC dealloc")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(feedTableView)
 
        feedTableView.snp.makeConstraints { make in
            make.top.equalTo(self.nbar!.snp.bottom)
            make.left.right.bottom.equalTo(view)
        }
         
        footerRefresh()
    }
    
    // MARK: - TableView Refresh
    private func footerRefresh() {
        let footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(upFreshLoadMoreData))
        feedTableView.mj_footer = footer
        feedTableView.mj_footer?.beginRefreshing()
    }
    
    @objc private func upFreshLoadMoreData() {
        loadNativeAd()
    }
    
    // MARK: - Data Handling
    private func setData(isSuccess: Bool) {
        if isSuccess {
            // Load ad successfully, get offer and add data model
            if let offer = getOfferAndLoadNext() {
                let offerModel = DemoOfferAdModel()
                offerModel.nativeADView = getNativeADView(offer: offer)
                offerModel.offer = offer
                offerModel.isNativeAd = true
                dataSourceArray.append(offerModel)
            }
        }
        
        // Add non-ad models, simulate developer's own business cells
        for _ in 0..<3 {
            let offerModel = DemoOfferAdModel()
            offerModel.isNativeAd = false
            dataSourceArray.append(offerModel)
        }
        feedTableView.reloadData()
    }
    
    private func getOfferAndLoadNext() -> ATNativeAdOffer? {
        // Scene statistics, optional integration
        ATAdManager.shared().entryNativeScenario(withPlacementID: Feed_Native_SelfRender_PlacementID, scene: Feed_Native_SelfRender_SceneID)
        
        let offer = ATAdManager.shared().getNativeAdOffer(withPlacementID: Feed_Native_SelfRender_PlacementID)
        // load next
        loadNativeAd()
        
        return offer
    }
    
    private func removeAd(nativeADView: ATNativeADView?) {
        guard let nativeADView = nativeADView else { return }
        
        for (index, offerModel) in dataSourceArray.enumerated() {
            if offerModel.isNativeAd && offerModel.nativeADView == nativeADView {
                
                if nativeADView.superview != nil {
                    nativeADView.removeFromSuperview()
                }
                // Destroy ad view
                nativeADView.destroyNative()
                // Destroy offer
                offerModel.offer = nil
                offerModel.nativeADView = nil
                
                dataSourceArray.remove(at: index)
                feedTableView.reloadData()
                break
            }
        }
    }
    
    // MARK: - Ad Loading and Rendering
    private func loadNativeAd() {
        var loadConfigDict: [String: Any] = [:]
        
        // Set ad request size
        loadConfigDict[kATExtraInfoNativeAdSizeKey] = NSValue(cgSize: CGSize(width: SelfRenderViewWidth, height: SelfRenderViewHeight))
        // Request self-adapting size native ad (available for some ad platforms) (optional integration)
        AdLoadConfigTool.native_loadExtraConfigAppend_SizeToFit(&loadConfigDict)
        
        ATAdManager.shared().loadAD(withPlacementID: Feed_Native_SelfRender_PlacementID, extra: loadConfigDict, delegate: self)
    }
    
    private func getNativeADView(offer: ATNativeAdOffer) -> ATNativeADView {
        // Initialize config configuration
        let config = ATNativeADConfiguration()
        // Pre-layout for native ad
        config.adFrame = CGRect(x: 0, y: 0, width: SelfRenderViewWidth, height: SelfRenderViewHeight)
        // Pre-layout for video player, please re-layout after getMediaView()
        config.mediaViewFrame = CGRect(x: 0, y: 0, width: SelfRenderViewMediaViewWidth, height: SelfRenderViewMediaViewHeight)
        config.delegate = self
        config.rootViewController = self
        // Make ad view container fit the ad
        config.sizeToFit = true
        // Set auto-play only in WiFi mode
        config.videoPlayType = .onlyWiFiAutoPlayType
        
        // Set ad platform logo position preference
        ATAPI.sharedInstance().preferredAdLogoPosition = .bottomRightCorner
        
        let offerInfoDict = Tools.getOfferInfo(offer)
        ATDemoLog("🔥🔥🔥--Self-render ad material, before display: \(offerInfoDict)")
        
        // Create self-render view and assign values
        let selfRenderView = SelfRenderView(offer: offer)
        
        // Create ad nativeADView
        let nativeADView = ATNativeADView(configuration: config, currentOffer: offer, placementID: Feed_Native_SelfRender_PlacementID)
        
        // Create clickable views array
        var clickableViewArray: [UIView] = []
        
        // Get mediaView
        if let mediaView = nativeADView.getMediaView() {
            selfRenderView.mediaView = mediaView
        }
        
        // Add clickable views
        clickableViewArray.append(contentsOf: [selfRenderView.iconImageView,
                                               selfRenderView.titleLabel,
                                               selfRenderView.textLabel,
                                               selfRenderView.ctaLabel,
                                               selfRenderView.mainImageView])
        
        // Register click events
        nativeADView.registerClickableViewArray(clickableViewArray)
        
        // Bind components
        prepareWithNativePrepareInfo(selfRenderView: selfRenderView, nativeADView: nativeADView)
        
        // Render ad
        offer.renderer(with: config, selfRenderView: selfRenderView, nativeADView: nativeADView)
        
        // Set logo size and position
        if let logoImageView = nativeADView.logoImageView() {
            logoImageView.snp.remakeConstraints { make in
                make.right.bottom.equalTo(nativeADView).offset(-25)
                make.width.height.equalTo(15)
            }
        }
        
        return nativeADView
    }
    
    private func prepareWithNativePrepareInfo(selfRenderView: SelfRenderView, nativeADView: ATNativeADView) {
        let info = ATNativePrepareInfo.load { prepareInfo in
            prepareInfo.textLabel = selfRenderView.textLabel
            prepareInfo.advertiserLabel = selfRenderView.advertiserLabel
            prepareInfo.titleLabel = selfRenderView.titleLabel
            prepareInfo.ratingLabel = selfRenderView.ratingLabel
            prepareInfo.iconImageView = selfRenderView.iconImageView
            prepareInfo.mainImageView = selfRenderView.mainImageView
            prepareInfo.ctaLabel = selfRenderView.ctaLabel
            prepareInfo.dislikeButton = selfRenderView.dislikeButton
            if let mediaView = selfRenderView.mediaView {
                prepareInfo.mediaView = mediaView
            }
        }
        nativeADView.prepare(with: info)
    }
    
    private func printNativeAdInfoAfterRenderer(offer: ATNativeAdOffer, nativeADView: ATNativeADView) {
        let nativeAdRenderType = nativeADView.getCurrentNativeAdRenderType()
        if nativeAdRenderType == .express {
            ATDemoLog("⚠️⚠️⚠️--Template ad")
        } else {
            ATDemoLog("✅✅✅--Self-render ad")
        }
        let isVideoContents = nativeADView.isVideoContents()
        
        // Print all material content
        Tools.printNativeAdOffer(offer)
        ATDemoLog("🔥--Is native video ad: \(isVideoContents)")
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension FeedSelfRenderVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = dataSourceArray[indexPath.row]
        if model.isNativeAd {
            return UITableView.automaticDimension
        }
        return 156
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let offerModel = dataSourceArray[indexPath.row]
        
        if offerModel.isNativeAd {
            // New ad available, refresh
            if let offer = getOfferAndLoadNext() {
                offerModel.nativeADView = getNativeADView(offer: offer)
                offerModel.offer = offer
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AdCell", for: indexPath) as! AdCell
            cell.adView = offerModel.nativeADView
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCustomCell", for: indexPath) as! FeedCustomCell
            return cell
        }
    }
}

// MARK: - ATNativeADDelegate
extension FeedSelfRenderVC: ATNativeADDelegate {
    func didFinishLoadingAD(withPlacementID placementID: String) {
        let isReady = ATAdManager.shared().nativeAdReady(forPlacementID: placementID)
        showLog("didFinishLoadingADWithPlacementID:\(placementID) SelfRender isReady:\(isReady ? "YES" : "NO")")
        
        if feedTableView.mj_footer?.isRefreshing == true {
            feedTableView.mj_footer?.endRefreshing()
            setData(isSuccess: true)
        }
    }
    
    func didFailToLoadAD(withPlacementID placementID: String, error: Error) {
        ATDemoLog("didFailToLoadADWithPlacementID:\(placementID) error:\(error)")
        showLog("didFailToLoadADWithPlacementID:\(placementID) errorCode:\((error as NSError).code)")
        
        if feedTableView.mj_footer?.isRefreshing == true {
            feedTableView.mj_footer?.endRefreshing()
            setData(isSuccess: false)
        }
    }
    
    func didRevenue(forPlacementID placementID: String, extra: [AnyHashable : Any]) {
        ATDemoLog("didRevenueForPlacementID:\(placementID) with extra: \(extra)")
        showLog("didRevenueForPlacementID:\(placementID)")
    }
    
    func didShowNativeAd(in adView: ATNativeADView, placementID: String, extra: [AnyHashable : Any]) {
        ATDemoLog("didShowNativeAdInAdView:\(placementID) extra:\(extra)")
        showLog("didShowNativeAdInAdView:\(placementID)")
    }
    
    func didTapCloseButton(in adView: ATNativeADView, placementID: String, extra: [AnyHashable : Any]) {
        ATDemoLog("didTapCloseButtonInAdView:\(placementID) extra:\(extra)")
        showLog("didTapCloseButtonInAdView:\(placementID)")
        
        removeAd(nativeADView: adView)
    }
    
    func didStartPlayingVideo(in adView: ATNativeADView, placementID: String, extra: [AnyHashable : Any]) {
        ATDemoLog("didStartPlayingVideoInAdView:\(placementID) extra: \(extra)")
        showLog("didStartPlayingVideoInAdView:\(placementID)")
    }
    
    func didEndPlayingVideo(in adView: ATNativeADView, placementID: String, extra: [AnyHashable : Any]) {
        ATDemoLog("didEndPlayingVideoInAdView:\(placementID) extra: \(extra)")
        showLog("didEndPlayingVideoInAdView:\(placementID)")
    }
    
    func didClickNativeAd(in adView: ATNativeADView, placementID: String, extra: [AnyHashable : Any]) {
        ATDemoLog("didClickNativeAdInAdView:\(placementID) extra:\(extra)")
        showLog("didClickNativeAdInAdView:\(placementID)")
    }
    
    func didDeepLinkOrJump(in adView: ATNativeADView, placementID: String, extra: [AnyHashable : Any], result success: Bool) {
        ATDemoLog("didDeepLinkOrJumpInAdView:placementID:\(placementID) with extra: \(extra), success:\(success ? "YES" : "NO")")
        showLog("didDeepLinkOrJumpInAdView:\(placementID), success:\(success ? "YES" : "NO")")
    }
    
    func didEnterFullScreenVideo(in adView: ATNativeADView, placementID: String, extra: [AnyHashable : Any]) {
        ATDemoLog("didEnterFullScreenVideoInAdView:\(placementID)")
        showLog("didEnterFullScreenVideoInAdView:\(placementID)")
    }
    
    func didExitFullScreenVideo(in adView: ATNativeADView, placementID: String, extra: [AnyHashable : Any]) {
        ATDemoLog("didExitFullScreenVideoInAdView:\(placementID)")
        showLog("didExitFullScreenVideoInAdView:\(placementID)")
    }
    
    func didCloseDetail(in adView: ATNativeADView, placementID: String, extra: [AnyHashable : Any]) {
        ATDemoLog("didCloseDetailInAdView:\(placementID) extra:\(extra)")
        showLog("didCloseDetailInAdView:\(placementID)")
    }
}

