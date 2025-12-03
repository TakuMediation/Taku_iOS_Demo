//
//  BaseTabBarController.swift
//  SwiftDemo
//
//  Created by ltz on 2025/8/20.
//

import UIKit

class BaseTabBarController: UITabBarController {
    
    /// 来源控制器，用于正确处理返回逻辑
    var fromController: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
