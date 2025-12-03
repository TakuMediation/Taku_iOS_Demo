//
//  Tools.swift
//  SwiftDemo
//
//  Created by ltz on 2025/8/20.
//

import Foundation
import UIKit
import AppTrackingTransparency
import AdSupport
// import AnyThinkNative // 需要根据实际SDK导入

class Tools: NSObject {
    
    // 注意：这里使用Any来代替ATNativeAdOffer，实际使用时需要替换为正确的类型
    static func getOfferInfo(_ nativeAdOffer: Any) -> [String: Any] {
        let extraDic = NSMutableDictionary()
        // 注意：以下代码需要根据实际的ATNativeAdOffer类型进行调整
        /*
        setDict(extraDic, value: nativeAdOffer.networkFirmID, key: "networkFirmID")
        setDict(extraDic, value: nativeAdOffer.nativeAd.title, key: "title")
        setDict(extraDic, value: nativeAdOffer.nativeAd.mainText, key: "mainText")
        setDict(extraDic, value: nativeAdOffer.nativeAd.ctaText, key: "ctaText")
        setDict(extraDic, value: nativeAdOffer.nativeAd.advertiser, key: "advertiser")
        setDict(extraDic, value: nativeAdOffer.nativeAd.videoUrl, key: "videoUrl")
        setDict(extraDic, value: nativeAdOffer.nativeAd.logoUrl, key: "logoUrl")
        setDict(extraDic, value: nativeAdOffer.nativeAd.iconUrl, key: "iconUrl")
        setDict(extraDic, value: nativeAdOffer.nativeAd.imageUrl, key: "imageUrl")
        setDict(extraDic, value: nativeAdOffer.nativeAd.mainImageWidth, key: "mainImageWidth")
        setDict(extraDic, value: nativeAdOffer.nativeAd.mainImageHeight, key: "mainImageHeight")
        setDict(extraDic, value: nativeAdOffer.nativeAd.imageList, key: "imageList")
        setDict(extraDic, value: nativeAdOffer.nativeAd.videoDuration, key: "videoDuration")
        setDict(extraDic, value: nativeAdOffer.nativeAd.videoAspectRatio, key: "videoAspectRatio")
        setDict(extraDic, value: nativeAdOffer.nativeAd.nativeExpressAdViewWidth, key: "nativeExpressAdViewWidth")
        setDict(extraDic, value: nativeAdOffer.nativeAd.nativeExpressAdViewHeight, key: "nativeExpressAdViewHeight")
        setDict(extraDic, value: nativeAdOffer.nativeAd.interactionType, key: "interactionType")
        setDict(extraDic, value: nativeAdOffer.nativeAd.mediaExt, key: "mediaExt")
        setDict(extraDic, value: nativeAdOffer.nativeAd.source, key: "source")
        setDict(extraDic, value: nativeAdOffer.nativeAd.rating, key: "rating")
        setDict(extraDic, value: nativeAdOffer.nativeAd.commentNum, key: "commentNum")
        setDict(extraDic, value: nativeAdOffer.nativeAd.appSize, key: "appSize")
        setDict(extraDic, value: nativeAdOffer.nativeAd.appPrice, key: "appPrice")
        setDict(extraDic, value: nativeAdOffer.nativeAd.isExpressAd, key: "isExpressAd")
        setDict(extraDic, value: nativeAdOffer.nativeAd.isVideoContents, key: "isVideoContents")
        setDict(extraDic, value: nativeAdOffer.nativeAd.icon, key: "iconImage")
        setDict(extraDic, value: nativeAdOffer.nativeAd.logo, key: "logoImage")
        setDict(extraDic, value: nativeAdOffer.nativeAd.mainImage, key: "mainImage")
        */
        return extraDic as! [String: Any]
    }
    
    private static func setDict(_ dict: inout [String: Any], value: Any?, key: String) {
        guard !key.isEmpty else {
            assertionFailure("key must not equal to nil")
            return
        }
        
        if !isEmpty(value) {
            dict[key] = value
        }
    }
    
    private static func isEmpty(_ object: Any?) -> Bool {
        if object == nil {
            return true
        }
        
        if let obj = object, obj is NSNull {
            return true
        }
        
        if let string = object as? String {
            return string == "(null)" || string.isEmpty
        }
        
        if let obj = object, let lengthMethod = obj as? NSObjectProtocol {
            if lengthMethod.responds(to: #selector(getter: NSString.length)) {
                let length = (obj as AnyObject).perform(#selector(getter: NSString.length))?.takeUnretainedValue() as? Int ?? 0
                return length == 0
            }
        }
        
        if let collection = object as? any Collection {
            return collection.isEmpty
        }
        
        return false
    }
    
    static func getIdfaString() -> String? {
        if #available(iOS 14, *) {
            let status = ATTrackingManager.trackingAuthorizationStatus
            if status == .notDetermined {
                return nil
            } else if status == .authorized {
                return ASIdentifierManager.shared().advertisingIdentifier.uuidString
            }
        } else {
            // Fallback on earlier versions
            return ASIdentifierManager.shared().advertisingIdentifier.uuidString
        }
        return ""
    }
    
    /**
     * 检查输入的控制器是否有push或present出来的控制器，并返回当前显示的控制器
     * @param viewController 需要检查的视图控制器
     * @return UIViewController? 如果有push或present出的控制器，则返回该控制器；否则返回nil
     */
    static func getVisibleChildViewController(_ viewController: UIViewController) -> UIViewController? {
        // 1. 首先检查是否有presentedViewController
        if let presentedVC = viewController.presentedViewController {
            // 递归查找最终显示的控制器
            return findFinalVisibleViewController(presentedVC)
        }
        
        // 2. 检查是否有push出来的控制器
        if let navigationController = viewController.navigationController {
            let viewControllers = navigationController.viewControllers
            if let index = viewControllers.firstIndex(of: viewController),
               index < viewControllers.count - 1 {
                // 获取栈顶控制器
                let topVC = viewControllers.last!
                // 递归检查栈顶控制器是否有present出来的控制器
                return findFinalVisibleViewController(topVC)
            }
        }
        
        // 3. 如果控制器是容器控制器，检查其子控制器
        if let tabController = viewController as? UITabBarController {
            if let selectedVC = tabController.selectedViewController {
                // 递归检查选中的标签页控制器
                return getVisibleChildViewController(selectedVC)
            }
        } else if let navController = viewController as? UINavigationController {
            if let visibleVC = navController.visibleViewController, visibleVC != viewController {
                // 递归检查可见的导航控制器子控制器
                return getVisibleChildViewController(visibleVC)
            }
        } else if let splitVC = viewController as? UISplitViewController {
            if !splitVC.viewControllers.isEmpty {
                // 在分屏模式下，检查最后一个控制器（通常是详情视图）
                let detailVC = splitVC.viewControllers.last!
                return getVisibleChildViewController(detailVC)
            }
        }
        
        // 没有找到子控制器，返回nil
        return nil
    }
    
    /**
     * 将一个控制器从当前Window切换到目标Window
     * @param viewController 需要切换的视图控制器
     * @param sourceWindow 源Window(当前显示控制器的Window)
     * @param targetWindow 目标Window
     * @param completion 完成回调
     */
    static func switchViewController(_ viewController: UIViewController,
                                   from sourceWindow: UIWindow?,
                                   to targetWindow: UIWindow?,
                                   completion: @escaping (Bool) -> Void) {
        // 实现控制器切换逻辑
        // 这里需要根据具体需求实现
        completion(true)
    }
    
    /// 打印原生广告素材信息
    /// - Parameter nativeAdOffer: 原生广告素材offer对象
    static func printNativeAdOffer(_ nativeAdOffer: Any) {
        // 实现打印逻辑
        print("Native Ad Offer: \(nativeAdOffer)")
    }
    
    static func image(with color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
    
    // MARK: - Private Methods
    
    /**
     * 递归查找最终显示的控制器
     */
    private static func findFinalVisibleViewController(_ viewController: UIViewController) -> UIViewController {
        if let presentedVC = viewController.presentedViewController {
            return findFinalVisibleViewController(presentedVC)
        }
        
        // 如果是容器控制器，查找其显示的子控制器
        if let navController = viewController as? UINavigationController {
            return findFinalVisibleViewController(navController.visibleViewController!)
        }
        
        if let tabController = viewController as? UITabBarController {
            return findFinalVisibleViewController(tabController.selectedViewController!)
        }
        
        if let splitVC = viewController as? UISplitViewController {
            if !splitVC.viewControllers.isEmpty {
                return findFinalVisibleViewController(splitVC.viewControllers.last!)
            }
        }
        
        return viewController
    }
    
    /**
     * 递归查找最终显示的模态控制器
     */
    private static func findFinalPresentedViewController(_ viewController: UIViewController) -> UIViewController {
        if let presentedVC = viewController.presentedViewController {
            return findFinalPresentedViewController(presentedVC)
        }
        
        // 如果是UINavigationController，返回其可见的控制器
        if let navController = viewController as? UINavigationController {
            return navController.visibleViewController!
        }
        
        // 如果是UITabBarController，返回其选中的控制器
        if let tabController = viewController as? UITabBarController {
            return tabController.selectedViewController!
        }
        
        return viewController
    }
}
