//
//  BaseOnlyBarVC.swift
//  SwiftDemo
//
//  Created by ltz on 2025/8/20.
//

import UIKit

class BaseOnlyBarVC: BaseVC {
    
    // MARK: - Demo Needed (No need to integrate)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDemoUI()
    }
    
    func setupDemoUI() {
        addNormalBar(withTitle: title)
    }
}
