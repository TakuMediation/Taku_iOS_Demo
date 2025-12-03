//
//  NaviBarView.swift
//  SwiftDemo
//
//  Created by ltz on 2025/8/20.
//

import UIKit
import SnapKit
import AppTrackingTransparency
import AdSupport
import AnyThinkSDK

class NaviBarView: UIView {
    
    var bgImgView: UIImageView!
    var titleLbl: UILabel!
    var versionLbl: UILabel!
    var idfaLbl: UILabel!
    var logoImgView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = UIColor.clear
        
        bgImgView = UIImageView()
        bgImgView.backgroundColor = UIColor.red
        bgImgView.image = kImg("BG")
        addSubview(bgImgView)
        
        bgImgView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        logoImgView = UIImageView()
        logoImgView.image = kImg("logo")
        addSubview(logoImgView)
        
        logoImgView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(kAdaptH(132, 132))
            make.width.equalTo(kAdaptH(64, 64))
            make.height.equalTo(kAdaptH(64, 64))
            make.left.equalTo(self.snp.left).offset(kAdaptW(32, 32))
        }
        
        titleLbl = UILabel()
        titleLbl.text = "SDK Demo"
        titleLbl.textColor = kHexColor(0x1F2126)
        titleLbl.font = UIFont.boldSystemFont(ofSize: 18)
        titleLbl.textAlignment = .center
        titleLbl.adjustsFontSizeToFitWidth = true
        addSubview(titleLbl)
        
        titleLbl.snp.makeConstraints { make in
            make.centerY.equalTo(logoImgView.snp.centerY)
            make.left.equalTo(logoImgView.snp.right).offset(10)
            make.height.equalTo(titleLbl.font.lineHeight)
        }
        
        versionLbl = UILabel()
        // 注意：这里需要根据实际的SDK导入情况调整
        versionLbl.text = String(format: "%@", ATAPI.sharedInstance().version())
        versionLbl.textColor = kHexColor(0x8B94A3)
        versionLbl.font = UIFont.systemFont(ofSize: 12)
        versionLbl.textAlignment = .center
        versionLbl.layer.borderColor = kHexColor(0x8B94A3).cgColor
        versionLbl.layer.borderWidth = 0.5
        versionLbl.layer.cornerRadius = 5
        addSubview(versionLbl)
        
        versionLbl.snp.makeConstraints { make in
            make.centerY.equalTo(titleLbl.snp.centerY)
            make.left.equalTo(titleLbl.snp.right).offset(10)
            make.height.equalTo(titleLbl)
            make.width.equalTo(kAdaptW(131, 131))
        }
        
        idfaLbl = UILabel()
        idfaLbl.text = String(format: "IDFA:%@", advertisingIdentifier())
        idfaLbl.textColor = kHexColor(0x8B94A3)
        idfaLbl.font = UIFont.systemFont(ofSize: 12)
        addSubview(idfaLbl)
        
        idfaLbl.snp.makeConstraints { make in
            make.top.equalTo(logoImgView.snp.bottom)
            make.right.bottom.equalTo(self)
            make.left.equalTo(logoImgView)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.idfaLbl.text = String(format: "IDFA:%@", self?.advertisingIdentifier() ?? "")
        }
    }
    
    private func advertisingIdentifier() -> String {
        if #available(iOS 14, *) {
            let status = ATTrackingManager.trackingAuthorizationStatus
            if status == .notDetermined {
                return ""
            } else if status == .authorized {
                return ASIdentifierManager.shared().advertisingIdentifier.uuidString
            }
        } else {
            // Fallback on earlier versions
            return ASIdentifierManager.shared().advertisingIdentifier.uuidString
        }
        return ""
    }
}
