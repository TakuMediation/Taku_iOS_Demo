//
//  AppDelegate.swift
//  SwiftDemo
//
//  Created by ltz on 2025/1/5.
//

import UIKit
import AnyThinkSDK
import AppTrackingTransparency

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Demo Log switch
        DemoLogAccess(1)
  
        setupDemoUI()
         
        // Initialize SDK.
        AdSDKManager.shared.initSDK()
        // Start splash ad
        AdSDKManager.shared.startSplashAd()
        
        //For apps published in non-EU regions, use this method to initialize SDK integration. For EU region initialization, replace with AdSDKManager.shared.initSDK_EU
//        AdSDKManager.shared.initSDK_EU {
//            // Start splash ad
//            AdSDKManager.shared.startSplashAd()
//        }
        
        return true
    }
  
    // MARK: - Demo UI
    private func setupDemoUI() {
        window = UIWindow()
        window?.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) // kHexColor(0xffffff)
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
 
        let nav = BaseNavigationController(rootViewController: HomeViewController())
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
}

