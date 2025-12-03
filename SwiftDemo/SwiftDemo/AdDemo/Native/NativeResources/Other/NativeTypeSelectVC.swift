//
//  NativeTypeSelectVC.swift
//  SwiftDemo
//
//  Created by ltz on 2025/1/11.
//

import UIKit
import SnapKit

class NativeTypeSelectVC: BaseVC {
     
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNormalBar(withTitle: title)
        
        // 初始化数据源
        dataSource = [
            ["title": kLocalizeStr("Self Render Ad"), "subtitle": kLocalizeStr("Demonstrate basic single self-render ad")],
            ["title": kLocalizeStr("Express Ad"), "subtitle": kLocalizeStr("Demonstrate basic single template ad")],
            ["title": kLocalizeStr("Feed Ads (Self Render)"), "subtitle": kLocalizeStr("Display custom ads in scrollable list cells")],
            ["title": kLocalizeStr("Feed Ads (Template Render)"), "subtitle": kLocalizeStr("Display template-style advertisements in scrolling list units.")],
        ]
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(nbar!.snp.bottom)
        }
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension NativeTypeSelectVC: UITableViewDelegate, UITableViewDataSource {
    
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
        
        if selectedItem == kLocalizeStr("Self Render Ad") {
            let vc = NativeSelfRenderVC()
            vc.title = selectedItem
            navigationController?.pushViewController(vc, animated: true)
        }
        else if selectedItem == kLocalizeStr("Express Ad") {
            let vc = NativeExpressVC()
            vc.title = selectedItem
            navigationController?.pushViewController(vc, animated: true)
        }
        else if selectedItem == kLocalizeStr("Feed Ads (Self Render)") {
            let vc = FeedSelfRenderVC()
            vc.title = selectedItem
            navigationController?.pushViewController(vc, animated: true)
        }
        else if selectedItem == kLocalizeStr("Feed Ads (Template Render)") {
            let vc = FeedTemplateVC()
            vc.title = selectedItem
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
