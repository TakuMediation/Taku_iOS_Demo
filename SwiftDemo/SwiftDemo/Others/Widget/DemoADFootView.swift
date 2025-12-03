//
//  DemoADFootView.swift
//  SwiftDemo
//
//  Created by ltz on 2025/8/20.
//

import UIKit
import SnapKit

class DemoADFootView: UIView {
    
    // MARK: - Closures
    var clickLoadBlock: (() -> Void)?
    var clickLogBlock: (() -> Void)?
    var clickShowBlock: (() -> Void)?
    var clickRemoveBlock: (() -> Void)?
    var clickReShowBlock: (() -> Void)?
    var clickHidenBlock: (() -> Void)?
    var clickLeftMoveBlock: (() -> Void)?
    var clickRightMoveBlock: (() -> Void)?
    
    // MARK: - UI Properties
//    var loadBtn: UIButton!
//    var showBtn: UIButton!
//    var logBtn: UIButton!
//    var removeBtn: UIButton!
//    var reShowBtn: UIButton!
//    var hidenBtn: UIButton!
    
    // MARK: - Private Properties
    private var isNeetRemove: Bool = false
    private var isNeetHidenAndMove: Bool = false
    
    // MARK: - Initializers
    convenience init(withRemoveBtn: Bool) {
        self.init()
        setupUI(withRemoveBtn: true, hidenBtn: false)
    }
    
    convenience init(withRemoveAndHidenBtn: Bool) {
        self.init()
        setupUI(withRemoveBtn: true, hidenBtn: true)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI(withRemoveBtn: false, hidenBtn: false)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI(withRemoveBtn: false, hidenBtn: false)
    }
    
    // MARK: - Setup Methods
    private func setupUI(withRemoveBtn haveRemove: Bool, hidenBtn haveHiden: Bool) {
        self.isNeetRemove = haveRemove
        self.isNeetHidenAndMove = haveHiden
        
        addSubview(loadBtn)
        addSubview(showBtn)
        addSubview(logBtn)
        
        if haveRemove {
            addSubview(removeBtn)
        }
        
        if haveHiden {
            addSubview(hidenBtn)
            addSubview(reShowBtn)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isNeetRemove {
            // 需要remove按钮
            if isNeetHidenAndMove {
                // 需要hiden和Move按钮
                loadBtn.snp.updateConstraints { make in
                    make.left.equalTo(self.snp.left).offset(kAdaptW(26, 26))
                    make.width.equalTo((kScreenW - kAdaptW(26 * 3, 26 * 3)) / 2)
                    make.height.equalTo(kAdaptW(90, 90))
                    make.top.equalTo(self.snp.top).offset(kAdaptW(10, 10))
                }
                
                showBtn.snp.updateConstraints { make in
                    make.left.equalTo(self.snp.left).offset(kAdaptW(26, 26))
                    make.width.equalTo((kScreenW - kAdaptW(26 * 3, 26 * 3)) / 2)
                    make.height.equalTo(kAdaptW(90, 90))
                    make.top.equalTo(loadBtn.snp.bottom).offset(kAdaptW(20, 20))
                }
                
                logBtn.snp.updateConstraints { make in
                    make.left.equalTo(self.snp.left).offset(kAdaptW(26, 26))
                    make.width.equalTo((kScreenW - kAdaptW(26 * 3, 26 * 3)) / 2)
                    make.height.equalTo(kAdaptW(90, 90))
                    make.top.equalTo(showBtn.snp.bottom).offset(kAdaptW(20, 20))
                }
                
                removeBtn.snp.updateConstraints { make in
                    make.left.equalTo(loadBtn.snp.right).offset(kAdaptW(26, 26))
                    make.right.equalTo(self.snp.right).offset(kAdaptW(-26, -26))
                    make.height.equalTo(kAdaptW(90, 90))
                    make.top.equalTo(loadBtn.snp.top)
                }
                
                hidenBtn.snp.updateConstraints { make in
                    make.left.equalTo(showBtn.snp.right).offset(kAdaptW(26, 26))
                    make.right.equalTo(self.snp.right).offset(kAdaptW(-26, -26))
                    make.height.equalTo(kAdaptW(90, 90))
                    make.top.equalTo(logBtn.snp.top)
                }
                
                reShowBtn.snp.updateConstraints { make in
                    make.left.equalTo(logBtn.snp.right).offset(kAdaptW(26, 26))
                    make.right.equalTo(self.snp.right).offset(kAdaptW(-26, -26))
                    make.height.equalTo(kAdaptW(90, 90))
                    make.top.equalTo(showBtn.snp.top)
                }
                
            } else {
                loadBtn.snp.updateConstraints { make in
                    make.left.equalTo(self.snp.left).offset(kAdaptW(26, 26))
                    make.right.equalTo(self.snp.right).offset(kAdaptW(-26, -26))
                    make.height.equalTo(kAdaptW(90, 90))
                    make.top.equalTo(self.snp.top).offset(kAdaptW(10, 10))
                }
                
                showBtn.snp.updateConstraints { make in
                    make.left.equalTo(self.snp.left).offset(kAdaptW(26, 26))
                    make.right.equalTo(self.snp.right).offset(kAdaptW(-26, -26))
                    make.height.equalTo(kAdaptW(90, 90))
                    make.top.equalTo(loadBtn.snp.bottom).offset(kAdaptW(20, 20))
                }
                
                logBtn.snp.updateConstraints { make in
                    make.left.equalTo(self.snp.left).offset(kAdaptW(26, 26))
                    make.width.equalTo((kScreenW - kAdaptW(26 * 3, 26 * 3)) / 2)
                    make.height.equalTo(kAdaptW(90, 90))
                    make.top.equalTo(showBtn.snp.bottom).offset(kAdaptW(20, 20))
                }
                
                removeBtn.snp.updateConstraints { make in
                    make.left.equalTo(logBtn.snp.right).offset(kAdaptW(26, 26))
                    make.right.equalTo(self.snp.right).offset(kAdaptW(-26, -26))
                    make.height.equalTo(kAdaptW(90, 90))
                    make.top.equalTo(logBtn.snp.top)
                }
            }
        } else {
            loadBtn.snp.updateConstraints { make in
                make.left.equalTo(self.snp.left).offset(kAdaptW(26, 26))
                make.right.equalTo(self.snp.right).offset(kAdaptW(-26, -26))
                make.height.equalTo(kAdaptW(90, 90))
                make.top.equalTo(self.snp.top).offset(kAdaptW(10, 10))
            }
            
            showBtn.snp.updateConstraints { make in
                make.left.equalTo(self.snp.left).offset(kAdaptW(26, 26))
                make.right.equalTo(self.snp.right).offset(kAdaptW(-26, -26))
                make.height.equalTo(kAdaptW(90, 90))
                make.top.equalTo(loadBtn.snp.bottom).offset(kAdaptW(20, 20))
            }
            
            logBtn.snp.updateConstraints { make in
                make.left.equalTo(self.snp.left).offset(kAdaptW(26, 26))
                make.right.equalTo(self.snp.right).offset(kAdaptW(-26, -26))
                make.height.equalTo(kAdaptW(90, 90))
                make.top.equalTo(showBtn.snp.bottom).offset(kAdaptW(20, 20))
            }
        }
    }
    
    // MARK: - Action Methods
    @objc private func clickLoadBtn() {
        clickLoadBlock?()
    }
    
    @objc private func clickLogBtn() {
        clickLogBlock?()
    }
    
    @objc private func clickShowBtn() {
        clickShowBlock?()
    }
    
    @objc private func clickRemoveBtn() {
        clickRemoveBlock?()
    }
    
    @objc private func clickReShowBtn() {
        clickReShowBlock?()
    }
    
    @objc private func clickHidenBtn() {
        clickHidenBlock?()
    }
    
    // MARK: - Helper Methods
    private func imageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
    
    // MARK: - Lazy Properties
    lazy var loadBtn: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        button.setTitle(kLocalizeStr("Load Ad"), for: .normal)
        button.layer.borderColor = kRGB(73, 109, 255).cgColor
        button.layer.borderWidth = kAdaptW(3, 3)
        button.setTitleColor(.white, for: .highlighted)
        button.setTitleColor(kRGB(73, 109, 255), for: .normal)
        button.setBackgroundImage(imageWithColor(kRGB(73, 109, 255)), for: .highlighted)
        button.setBackgroundImage(imageWithColor(.white), for: .normal)
        button.addTarget(self, action: #selector(clickLoadBtn), for: .touchUpInside)
        return button
    }()
    
    lazy var showBtn: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        button.setTitle(kLocalizeStr("Show Ad"), for: .normal)
        button.layer.borderColor = kRGB(73, 109, 255).cgColor
        button.layer.borderWidth = kAdaptW(3, 3)
        button.setTitleColor(.white, for: .highlighted)
        button.setTitleColor(kRGB(73, 109, 255), for: .normal)
        button.setBackgroundImage(imageWithColor(kRGB(73, 109, 255)), for: .highlighted)
        button.setBackgroundImage(imageWithColor(.white), for: .normal)
        button.addTarget(self, action: #selector(clickShowBtn), for: .touchUpInside)
        return button
    }()
    
    lazy var logBtn: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        button.setTitle(kLocalizeStr("Clear Log"), for: .normal)
        button.layer.borderColor = kRGB(73, 109, 255).cgColor
        button.layer.borderWidth = kAdaptW(3, 3)
        button.setTitleColor(.white, for: .highlighted)
        button.setTitleColor(kRGB(73, 109, 255), for: .normal)
        button.setBackgroundImage(imageWithColor(kRGB(73, 109, 255)), for: .highlighted)
        button.setBackgroundImage(imageWithColor(.white), for: .normal)
        button.addTarget(self, action: #selector(clickLogBtn), for: .touchUpInside)
        return button
    }()
    
    lazy var removeBtn: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        button.setTitle(kLocalizeStr("Remove Ad"), for: .normal)
        button.layer.borderColor = kRGB(73, 109, 255).cgColor
        button.layer.borderWidth = kAdaptW(3, 3)
        button.setTitleColor(.white, for: .highlighted)
        button.setTitleColor(kRGB(73, 109, 255), for: .normal)
        button.setBackgroundImage(imageWithColor(kRGB(73, 109, 255)), for: .highlighted)
        button.setBackgroundImage(imageWithColor(.white), for: .normal)
        button.addTarget(self, action: #selector(clickRemoveBtn), for: .touchUpInside)
        return button
    }()
    
    lazy var reShowBtn: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        button.setTitle(kLocalizeStr("Re-show"), for: .normal)
        button.layer.borderColor = kRGB(73, 109, 255).cgColor
        button.layer.borderWidth = kAdaptW(3, 3)
        button.setTitleColor(.white, for: .highlighted)
        button.setTitleColor(kRGB(73, 109, 255), for: .normal)
        button.setBackgroundImage(imageWithColor(kRGB(73, 109, 255)), for: .highlighted)
        button.setBackgroundImage(imageWithColor(.white), for: .normal)
        button.addTarget(self, action: #selector(clickReShowBtn), for: .touchUpInside)
        return button
    }()
    
    lazy var hidenBtn: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        button.setTitle(kLocalizeStr("Hide Ad"), for: .normal)
        button.layer.borderColor = kRGB(73, 109, 255).cgColor
        button.layer.borderWidth = kAdaptW(3, 3)
        button.setTitleColor(.white, for: .highlighted)
        button.setTitleColor(kRGB(73, 109, 255), for: .normal)
        button.setBackgroundImage(imageWithColor(kRGB(73, 109, 255)), for: .highlighted)
        button.setBackgroundImage(imageWithColor(.white), for: .normal)
        button.addTarget(self, action: #selector(clickHidenBtn), for: .touchUpInside)
        return button
    }()
}
