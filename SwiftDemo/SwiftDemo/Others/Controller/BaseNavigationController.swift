//
//  BaseNavigationController.swift
//  SwiftDemo
//
//  Created by ltz on 2025/8/20.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        setupNavigationController()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupNavigationController()
    }
    
    private func setupNavigationController() {
        navigationBar.isTranslucent = false
        setNavigationBarHidden(true, animated: false)
        interactivePopGestureRecognizer?.delegate = self
        interactivePopGestureRecognizer?.isEnabled = true
    }
}

// MARK: - UIGestureRecognizerDelegate
extension BaseNavigationController: UIGestureRecognizerDelegate {
    
}
