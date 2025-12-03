//
//  HomeViewController.swift
//  SwiftDemo
//
//  Created by ltz on 2025/1/5.
//

import UIKit
import SnapKit
import AppTrackingTransparency

class HomeViewController: BaseVC {
     
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addHomeBar()
        
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(bar!.snp.bottom)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // 申请ATT权限 - 注意！若使用含欧盟地区初始化流程，请在showGDPR方法中调用申请ATT权限
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                // 处理授权状态
            }
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - TableView Cell Display
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView != self.tableView {
            return
        }
        
        // 圆角角度
        let radius: CGFloat = 12.0
        // 设置cell背景色为透明
        cell.backgroundColor = UIColor.clear
        
        // 创建两个layer
        let normalLayer = CAShapeLayer()
        let selectLayer = CAShapeLayer()
        
        // 获取显示区域大小
        let bounds = cell.bounds.insetBy(dx: kAdaptX(15, 15), dy: 0)
        
        // cell的backgroundView
        let normalBgView = UIView(frame: bounds)
        
        // 获取每组行数
        let rowNum = tableView.numberOfRows(inSection: indexPath.section)
        
        // 贝塞尔曲线
        var bezierPath: UIBezierPath
        
        if rowNum == 1 {
            // 一组只有一行（四个角全部为圆角）
            bezierPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius)
            normalBgView.clipsToBounds = false
        } else {
            normalBgView.clipsToBounds = true
            if indexPath.row == 0 {
                // 每组第一行（添加左上和右上的圆角）
                bezierPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: radius, height: radius))
            } else if indexPath.row == rowNum - 1 {
                // 每组最后一行（添加左下和右下的圆角）
                bezierPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: radius, height: radius))
            } else {
                // 每组不是首位的行不设置圆角
                bezierPath = UIBezierPath(rect: bounds)
            }
        }
        
        // 阴影
        normalLayer.shadowColor = kHexColor(0x0062FF).cgColor
        normalLayer.shadowOpacity = 0.35
        normalLayer.shadowOffset = CGSize(width: 0, height: 0)
        normalLayer.path = bezierPath.cgPath
        normalLayer.shadowPath = bezierPath.cgPath
        
        // 把已经绘制好的贝塞尔曲线路径赋值给图层，然后图层根据path进行图像渲染render
        normalLayer.path = bezierPath.cgPath
        selectLayer.path = bezierPath.cgPath
        
        // 设置填充颜色
        normalLayer.fillColor = UIColor.white.cgColor
        // 添加图层到normalBgView中
        normalBgView.layer.insertSublayer(normalLayer, at: 0)
        normalBgView.backgroundColor = UIColor.clear
        cell.backgroundView = normalBgView
        
        // 替换cell点击效果
        let selectBgView = UIView(frame: bounds)
        selectLayer.fillColor = UIColor(white: 0.95, alpha: 1.0).cgColor
        selectBgView.layer.insertSublayer(selectLayer, at: 0)
        selectBgView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = selectBgView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0 // 每个cell的高度
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCellIdentifier", for: indexPath) as! CustomTableViewCell
        
        let data = dataSource[indexPath.row]
        // 配置cell的titleLbl和subTitleLbl的文本
        cell.titleLbl.text = data["title"]
        cell.subTitleLbl.text = data["subtitle"]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let selectedItem = dataSource[indexPath.row]["title"] else { return }
        ATDemoLog("Selected: \(selectedItem)")
        
        // Interstitial Ad Controller
        if selectedItem == kLocalizeStr("Interstitial") {
            let vc = InterstitialVC()
            vc.title = selectedItem
            navigationController?.pushViewController(vc, animated: true)
        }
        
        // RewardVideo Ad Controller
        if selectedItem == kLocalizeStr("Rewarded") {
            let vc = RewardedVC()
            vc.title = selectedItem
            navigationController?.pushViewController(vc, animated: true)
        }
        
        // Splash Ad Controller
        if selectedItem == kLocalizeStr("Splash") {
            let tabbarController = BaseTabBarController()
            tabbarController.tabBar.barTintColor = .white
            tabbarController.tabBar.isTranslucent = false
            
            let firstViewController = SplashVC()
            firstViewController.title = "App Home"
            let navi = BaseNavigationController(rootViewController: firstViewController)
            
            let secondViewController = UIViewController()
            let thirdViewController = UIViewController()
            
            navi.tabBarItem = UITabBarItem(title: "Ad", image: UIImage(named: "home"), tag: 1)
            secondViewController.tabBarItem = UITabBarItem(title: "Empty", image: UIImage(named: ""), tag: 2)
            thirdViewController.tabBarItem = UITabBarItem(title: "Empty", image: UIImage(named: ""), tag: 3)
            
            let viewControllersArray = [navi, secondViewController, thirdViewController]
            tabbarController.viewControllers = viewControllersArray
            tabbarController.fromController = self.navigationController
            navigationController?.pushViewController(tabbarController, animated: false)
        }
        
        // Banner Ad Controller
        if selectedItem == kLocalizeStr("Banner") {
            let vc = BannerVC()
            vc.title = selectedItem
            navigationController?.pushViewController(vc, animated: true)
        }
        
        // Native Ad Controller
        if selectedItem == kLocalizeStr("Native") {
            let vc = NativeTypeSelectVC()
            vc.title = selectedItem
            navigationController?.pushViewController(vc, animated: true)
        }
 
        if selectedItem == "DebugUI" {
            TestModeTool.showDebugUI(self)
        }
    }
}
  
