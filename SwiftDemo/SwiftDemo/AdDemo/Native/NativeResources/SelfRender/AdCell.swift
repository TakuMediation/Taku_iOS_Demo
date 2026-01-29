//
//  AdCell.swift
//  SwiftDemo
//
//  Created by ltz on 2025/1/21.
//

import UIKit
import AnyThinkSDK
import SnapKit

class AdCell: UITableViewCell {
    
    private lazy var bgView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 9
        view.backgroundColor = .lightGray
        view.layer.masksToBounds = true
        return view
    }()
    
    var adView: ATNativeADView? {
        didSet {
            // If the same ad view, do nothing
            if oldValue == adView {
                return
            }
            
            // Remove old ad view
            oldValue?.removeFromSuperview()
            
            if let adView = adView {
                bgView.addSubview(adView)
                
                // Layout bgView
                bgView.snp.remakeConstraints { make in
                    make.left.equalTo(contentView).offset(15)
                    make.right.equalTo(contentView).offset(-15)
                    make.top.equalTo(contentView)
                    make.bottom.equalTo(contentView.snp.bottom)
                }
                
                // Layout adView
                adView.snp.remakeConstraints { make in
                    make.top.equalTo(bgView)
                    make.bottom.equalTo(bgView.snp.bottom)
                    make.height.equalTo(adView.frame.size.height)
                    make.width.equalTo(adView.frame.size.width)
                    make.centerX.equalTo(bgView.snp.centerX)
                }
                
                // Ensure SelfRenderView expands adView (for self-render ads)
                for subview in adView.subviews {
                    if subview is SelfRenderView {
                        subview.snp.remakeConstraints { make in
                            make.edges.equalToSuperview()
                        }
                    }
                }
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .white
        
        contentView.addSubview(bgView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
