//
//  BaseVC.swift
//  SwiftDemo
//
//  Created by ltz on 2025/8/20.
//

import UIKit

class BaseVC: UIViewController {
    
    var dataSource: [[String: String]] = []
    var bar: NaviBarView?
    var nbar: NormalNavBar?
    var textView: UITextView!
    var footView: DemoADFootView!
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomTableViewCellIdentifier")
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = kHexColor(0xF2F3F6)
        
        // 初始化数据源
        dataSource = [
            ["title": kLocalizeStr("Interstitial"), "subtitle": kLocalizeStr("Include Interstitial and FullScreen. Appears at natural breaks or transition points.")],
            ["title": kLocalizeStr("Rewarded"), "subtitle": kLocalizeStr("Users can engage with a video ad in exchange for in-app rewards.")],
            ["title": kLocalizeStr("Splash"), "subtitle": kLocalizeStr("Displayed immediately after the application is launched.")],
            ["title": kLocalizeStr("Banner"), "subtitle": kLocalizeStr("Flexible formats which could appear at the top, middle or bottom of your app.")],
            ["title": kLocalizeStr("Native"), "subtitle": kLocalizeStr("Most compatible with your native app code for video ads.")],
            ["title": "DebugUI", "subtitle": kLocalizeStr("Verify the SDK integration, test the connected ad platforms, but cannot test your App's own advertising logic.")]
        ]
        
        setupTextView()
        setupFootView()
    }
    
    // MARK: - UI Setup Methods
    
    func addHomeBar() {
        bar = NaviBarView()
        view.addSubview(bar!)
        
        bar!.snp.makeConstraints { make in
            make.left.right.top.equalTo(view)
            make.height.equalTo(kAdaptH(273, 273))
        }
    }
    
    func addNormalBar(withTitle title: String?) {
        nbar = NormalNavBar()
        view.addSubview(nbar!)
        nbar!.titleLbl.text = title
        nbar!.arrowImgView.addTarget(self, action: #selector(popVC), for: .touchUpInside)
        
        nbar!.snp.makeConstraints { make in
            make.left.right.top.equalTo(view)
            make.height.equalTo(kAdaptH(228, 228))
        }
    }
    
    func addLogTextView() {
        view.addSubview(textView)
        textView.snp.updateConstraints { make in
            if let bar = bar {
                make.top.equalTo(bar.snp.bottom).offset(kAdaptH(15, 15))
            } else if let nbar = nbar {
                make.top.equalTo(nbar.snp.bottom).offset(kAdaptH(15, 15))
            } else {
                make.top.equalTo(view.snp.top).offset(kNavigationBarHeight + kAdaptH(15, 15))
            }
            make.centerX.equalTo(view)
            make.width.equalTo(kAdaptW(740, 740))
            make.height.equalTo(kAdaptH(600, 600))
        }
    }
    
    func addFootView() {
        view.addSubview(footView)
        footView.snp.updateConstraints { make in
            make.bottom.equalTo(view.snp.bottom)
            make.centerX.equalTo(view)
            make.width.equalTo(kAdaptW(740, 740))
            make.height.equalTo(kAdaptH(432, 432))
        }
        
        footView.clickLoadBlock = { [weak self] in
            self?.loadAd()
        }
        
        footView.clickShowBlock = { [weak self] in
            self?.showAd()
        }
        
        footView.clickHidenBlock = { [weak self] in
            self?.hiddenAdButtonClickAction()
        }
        
        footView.clickRemoveBlock = { [weak self] in
            self?.removeAdButtonClickAction()
        }
        
        footView.clickReShowBlock = { [weak self] in
            self?.reshowAd()
        }
        
        footView.clickLogBlock = { [weak self] in
            self?.clearLog()
        }
    }
    
    // MARK: - Private Setup Methods
    
    private func setupTextView() {
        textView = UITextView()
        textView.backgroundColor = UIColor.white
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isEditable = false
    }
    
    private func setupFootView() {
        if self is BannerVC {
            footView = DemoADFootView(withRemoveAndHidenBtn : true)
        } else {
            footView = DemoADFootView()
        }
    }
  
    // MARK: - Action Methods
    
    @objc func popVC() {
        
        if ((self.tabBarController?.isKind(of: BaseTabBarController.self) != nil)) {
            let tabbar : BaseTabBarController = self.tabBarController as! BaseTabBarController
            tabbar.fromController?.popViewController(animated: true)
            return
        }
         
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Ad Methods (to be overridden by subclasses)
    
    func loadAd() {
        // Override in subclasses
    }
    
    func showAd() {
        // Override in subclasses
    }
    
    func hiddenAdButtonClickAction() {
        // Override in subclasses
    }
    
    func removeAdButtonClickAction() {
        // Override in subclasses
    }
    
    func reshowAd() {
        // Override in subclasses
    }
    
    func clearLog() {
        // 显示确认对话框
        let alert = UIAlertController(title: kLocalizeStr("Tips"), message: kLocalizeStr("Are you sure to clear all logs?"), preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: kLocalizeStr("No"), style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: kLocalizeStr("Yes"), style: .default) { [weak self] _ in
            self?.textView.text = ""
        }
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        present(alert, animated: true, completion: nil)
    }
    
    func notReadyAlert() {
        let alert = UIAlertController(title: "Ad Not Ready!", message: nil, preferredStyle: .alert)
        present(alert, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - 日志
    
    func showLog(_ logStr: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let logS = self.textView.text ?? ""
            let log: String
            if !logS.isEmpty {
                log = "\(logS)\n\n\(logStr)"
            } else {
                log = logStr
            }
            self.textView.text = log
            
            let range = NSRange(location: self.textView.text.count, length: 1)
            self.textView.scrollRangeToVisible(range)
        }
    }
    
    
}
