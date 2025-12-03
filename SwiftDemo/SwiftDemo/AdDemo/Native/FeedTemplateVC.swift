//
//  FeedTemplateVC.swift
//  SwiftDemo
//
//  Created by ltz on 2025/2/8.
//

import UIKit
import AnyThinkNative
import MJRefresh
import SnapKit

// MARK: - Constants
private let Feed_Native_Express_PlacementID = "b680af4b2bb0a9"
private let Feed_Native_Express_SceneID = ""

private let Feed_Cell_ExpressAdWidth: CGFloat = kScreenW - 30
private let Feed_Cell_ExpressAdHeight: CGFloat = 168.0

// MARK: - Models
class FeedTemplateAdModel: NSObject {
    var nativeADView: ATNativeADView?
    var offer: ATNativeAdOffer?
    var isNativeAd: Bool = false
}

class FeedTemplateVC: BaseNormalBarVC {
    
    // MARK: - Properties
    private var dataSourceArray: [FeedTemplateAdModel] = []
    
    private lazy var feedTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.register(FeedCustomCell.self, forCellReuseIdentifier: "FeedCustomCell")
        tableView.register(AdCell.self, forCellReuseIdentifier: "AdCell")
        tableView.estimatedRowHeight = Feed_Cell_ExpressAdHeight
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    deinit {
        ATDemoLog("FeedTemplateVC dealloc")
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
                let offerModel = FeedTemplateAdModel()
                offerModel.nativeADView = getNativeADView(offer: offer)
                offerModel.offer = offer
                offerModel.isNativeAd = true
                dataSourceArray.append(offerModel)
            }
        }
        
        // Add non-ad models, simulate developer's own business cells
        for _ in 0..<3 {
            let offerModel = FeedTemplateAdModel()
            offerModel.isNativeAd = false
            dataSourceArray.append(offerModel)
        }
        feedTableView.reloadData()
    }
    
    private func getOfferAndLoadNext() -> ATNativeAdOffer? {
        // Scene statistics, optional integration
        ATAdManager.shared().entryNativeScenario(withPlacementID: Feed_Native_Express_PlacementID, scene: Feed_Native_Express_SceneID)
        
        let offer = ATAdManager.shared().getNativeAdOffer(withPlacementID: Feed_Native_Express_PlacementID)
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
        
        // Request template ad with specified size
        loadConfigDict[kATExtraInfoNativeAdSizeKey] = NSValue(cgSize: CGSize(width: Feed_Cell_ExpressAdWidth, height: Feed_Cell_ExpressAdHeight))
        
        ATAdManager.shared().loadAD(withPlacementID: Feed_Native_Express_PlacementID, extra: loadConfigDict, delegate: self)
    }
    
    private func getNativeADView(offer: ATNativeAdOffer) -> ATNativeADView {
        // Initialize config configuration
        let config = ATNativeADConfiguration()
        // Set size for template ad nativeADView
        config.adFrame = CGRect(x: 0, y: 0, width: Feed_Cell_ExpressAdWidth, height: Feed_Cell_ExpressAdHeight)
        config.delegate = self
        config.rootViewController = self
        // Enable template ad adaptive height
        config.sizeToFit = true
        // Set auto-play only in WiFi mode
        config.videoPlayType = .onlyWiFiAutoPlayType
        
        // Create ad nativeADView
        let nativeADView = ATNativeADView(configuration: config, currentOffer: offer, placementID: Feed_Native_Express_PlacementID)
        
        // Render ad
        offer.renderer(with: config, selfRenderView: nil, nativeADView: nativeADView)
        
        return nativeADView
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension FeedTemplateVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = dataSourceArray[indexPath.row]
        if model.isNativeAd {
            if let nativeAd = model.offer?.nativeAd, nativeAd.isExpressAd, nativeAd.nativeExpressAdViewHeight != 0 {
                // Use template height
                return nativeAd.nativeExpressAdViewHeight
            }
            return UITableView.automaticDimension
        }
        // Other cells, custom height
        return 200
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
            ATDemoLog("Before adView--\(String(describing: cell.adView))")
            cell.adView = offerModel.nativeADView
            ATDemoLog("After adView--\(String(describing: cell.adView))")
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCustomCell", for: indexPath) as! FeedCustomCell
            return cell
        }
    }
}

// MARK: - ATNativeADDelegate
extension FeedTemplateVC: ATNativeADDelegate {
    func didFinishLoadingAD(withPlacementID placementID: String) {
        let isReady = ATAdManager.shared().nativeAdReady(forPlacementID: placementID)
        showLog("didFinishLoadingADWithPlacementID:\(placementID) Template isReady:\(isReady ? "YES" : "NO")")
        
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

