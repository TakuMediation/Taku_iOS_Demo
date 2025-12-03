//
//  NormalNavBar.swift
//  SwiftDemo
//
//  Created by ltz on 2025/8/20.
//

import UIKit
import SnapKit

class NormalNavBar: UIView {
    
    // MARK: - UI Properties
    var arrowImgView: WildClickButton!
    var bgImgView: UIImageView!
    var titleLbl: UILabel!
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        backgroundColor = UIColor.clear
        
        // Background image view
        bgImgView = UIImageView()
        bgImgView.backgroundColor = UIColor.red
        bgImgView.image = kImg("BG")
        addSubview(bgImgView)
        
        bgImgView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        // Arrow button
        arrowImgView = WildClickButton()
        arrowImgView.setImage(kImg("arrow_back"), for: .normal)
        addSubview(arrowImgView)
        
        arrowImgView.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.bottom).offset(-kAdaptH(35, 35))
            make.width.equalTo(25)
            make.height.equalTo(25)
            make.left.equalTo(self.snp.left).offset(kAdaptW(32, 32))
        }
        
        // Title label
        titleLbl = UILabel()
        titleLbl.textColor = kHexColor(0x1F2126)
        titleLbl.font = UIFont.boldSystemFont(ofSize: 18)
        titleLbl.textAlignment = .center
        titleLbl.adjustsFontSizeToFitWidth = true
        addSubview(titleLbl)
        
        titleLbl.snp.makeConstraints { make in
            make.centerY.equalTo(arrowImgView.snp.centerY)
            make.centerX.equalTo(self)
            make.height.equalTo(titleLbl.font.lineHeight)
        }
    }
}
