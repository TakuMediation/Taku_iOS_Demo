//
//  CustomTableViewCell.swift
//  SwiftDemo
//
//  Created by ltz on 2025/8/20.
//

import UIKit
import SnapKit

class CustomTableViewCell: UITableViewCell {
    
    var titleLbl: UILabel!
    var subTitleLbl: UILabel!
    private var arrowImgView: UIImageView!
    private var maskLayer: CAShapeLayer?
    private var isTop: Int = 0
    
    var title: String? {
        didSet {
            titleLbl.text = title
        }
    }
    
    var subTitle: String? {
        didSet {
            subTitleLbl.text = subTitle
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        // 初始化标题标签
        titleLbl = UILabel()
        titleLbl.font = UIFont.boldSystemFont(ofSize: 18)
        titleLbl.textColor = UIColor.black
        titleLbl.adjustsFontSizeToFitWidth = true
        contentView.addSubview(titleLbl)
        
        // 初始化副标题标签
        subTitleLbl = UILabel()
        subTitleLbl.font = UIFont.systemFont(ofSize: 14)
        subTitleLbl.textColor = UIColor.lightGray
        subTitleLbl.numberOfLines = 0 // 支持多行
        contentView.addSubview(subTitleLbl)
        
        arrowImgView = UIImageView()
        arrowImgView.image = kImg("arrow_right")
        contentView.addSubview(arrowImgView)
        
        let line = UIView()
        line.backgroundColor = kHexColor(0xF4F4F4)
        contentView.addSubview(line)
        
        // 设置约束
        titleLbl.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(20)
            make.left.equalTo(contentView).offset(30)
            make.height.equalTo(titleLbl.font.lineHeight)
        }
        
        subTitleLbl.snp.makeConstraints { make in
            make.top.equalTo(titleLbl.snp.bottom).offset(15)
            make.left.equalTo(titleLbl)
            make.right.equalTo(contentView.snp.right).offset(-50)
            make.bottom.equalTo(contentView.snp.bottom).offset(-15)
        }
        
        arrowImgView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView.snp.right).offset(-20)
            make.width.height.equalTo(30)
        }
        
        line.snp.makeConstraints { make in
            make.bottom.equalTo(contentView.snp.bottom).offset(-1)
            make.left.equalTo(contentView.snp.left).offset(25)
            make.right.equalTo(contentView.snp.right).offset(-25)
            make.height.equalTo(1)
        }
    }
}
