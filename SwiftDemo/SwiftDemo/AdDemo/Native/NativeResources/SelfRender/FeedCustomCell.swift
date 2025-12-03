//
//  FeedCustomCell.swift
//  SwiftDemo
//
//  Created by ltz on 2025/2/7.
//

import UIKit
import SnapKit

class FeedCustomCell: UITableViewCell {
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo") // 使用项目中存在的图片资源
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.text = "今天天气真好"
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .default
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(logoImageView)
        contentView.addSubview(contentLabel)
        
        logoImageView.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(29)
            make.centerY.equalTo(contentView)
            make.width.height.equalTo(62)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.left.equalTo(logoImageView.snp.right).offset(55)
            make.centerY.equalTo(contentView)
            make.right.lessThanOrEqualTo(contentView).offset(-15)
            make.height.equalTo(36)
        }
    }
}

