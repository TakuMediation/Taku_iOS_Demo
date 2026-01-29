//
//  AdDisplayVC.swift
//  SwiftDemo
//
//  Created by ltz on 2025/1/11.
//

import UIKit
import SnapKit
import AnyThinkSDK

class AdDisplayVC: BaseVC {
    
    // MARK: - Properties
    private weak var adView: ATNativeADView?
    private var mute: Bool = false
    private var isPlaying: Bool = false
    private var adOffer: ATNativeAdOffer?
    private var adSize: CGSize = .zero
    
    // MARK: - Initialization
    init(adView: ATNativeADView, offer: ATNativeAdOffer, adViewSize size: CGSize) {
        super.init(nibName: nil, bundle: nil)
        self.adOffer = offer
        self.adView = adView
        self.adSize = size
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        ATDemoLog("\(#function)")
    }
    
    // MARK: - Demo Needed - No need to integrate
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Ad"
        
        setupDemoUI()
    }
    
    private func setupDemoUI() {
        addNormalBar(withTitle: title)
        
        view.addSubview(voiceChange)
        view.addSubview(voiceProgress)
        view.addSubview(voicePause)
        view.addSubview(voicePlay)
        
        if let adView = adView {
            view.addSubview(adView)
        }
        
        // Re-layout to adjust position and size, consistent with previous settings
        adView?.snp.makeConstraints { make in
            make.top.equalTo(nbar!.snp.bottom).offset(15)
            make.centerX.equalTo(view)
            make.width.equalTo(adSize.width)
            make.height.equalTo(adSize.height)
        }
        
        voicePlay.snp.makeConstraints { make in
            make.width.equalTo((kScreenW - kAdaptW(26, 26) * 4) / 3)
            make.height.equalTo((kScreenW - kAdaptW(26, 26) * 4) / 6)
            make.left.equalTo(view.snp.left).offset(kAdaptW(26, 26))
            make.bottom.equalTo(view.snp.bottom).offset(-kAdaptW(26, 26))
        }
        
        voiceChange.snp.makeConstraints { make in
            make.width.equalTo((kScreenW - kAdaptW(26, 26) * 4) / 3)
            make.height.equalTo((kScreenW - kAdaptW(26, 26) * 4) / 6)
            make.left.equalTo(view.snp.left).offset(kAdaptW(26, 26))
            make.bottom.equalTo(voicePlay.snp.top).offset(-kAdaptW(26, 26))
        }
        
        voiceProgress.snp.makeConstraints { make in
            make.width.equalTo((kScreenW - kAdaptW(26, 26) * 4) / 3)
            make.height.equalTo((kScreenW - kAdaptW(26, 26) * 4) / 6)
            make.left.equalTo(voiceChange.snp.right).offset(kAdaptW(26, 26))
            make.bottom.equalTo(voiceChange.snp.bottom)
        }
        
        voicePause.snp.makeConstraints { make in
            make.width.equalTo((kScreenW - kAdaptW(26, 26) * 4) / 3)
            make.height.equalTo((kScreenW - kAdaptW(26, 26) * 4) / 6)
            make.left.equalTo(voiceProgress.snp.right).offset(kAdaptW(26, 26))
            make.bottom.equalTo(voiceChange.snp.bottom)
        }
    }
    
    // MARK: - Actions
    @objc private func clickChange() {
        guard let adView = adView else { return }
        ATDemoLog("AdDisplayVC:getNativeAdType:\(adView.getNativeAdType()),getCurrentNativeAdRenderType:\(adView.getCurrentNativeAdRenderType().rawValue)")
        adView.muteEnable(mute)
        mute = !mute
    }
    
    @objc private func clickProgress() {
        guard let adView = adView else { return }
        ATDemoLog("AdDisplayVC:videoDuration:\(adView.videoDuration()),videoPlayTime:\(adView.videoPlayTime())")
    }
    
    @objc private func clickPause() {
        if isPlaying {
            adView?.videoPause()
            isPlaying = false
        }
    }
    
    @objc private func clickPlay() {
        if !isPlaying {
            adView?.videoPlay()
            isPlaying = true
        }
    }
    
    // MARK: - Lazy Properties
    private lazy var voiceChange: UIButton = {
        let button = UIButton()
        button.layer.borderColor = kRGB(73, 109, 255).cgColor
        button.layer.borderWidth = kAdaptX(3, 3)
        button.setTitleColor(UIColor.white, for: .highlighted)
        button.setTitleColor(kRGB(73, 109, 255), for: .normal)
        button.setBackgroundImage(Tools.image(with: kRGB(73, 109, 255)), for: .highlighted)
        button.setBackgroundImage(Tools.image(with: UIColor.white), for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        button.setTitle("Voice Change", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(clickChange), for: .touchUpInside)
        return button
    }()
    
    private lazy var voiceProgress: UIButton = {
        let button = UIButton()
        button.layer.borderColor = kRGB(73, 109, 255).cgColor
        button.layer.borderWidth = kAdaptX(3, 3)
        button.setTitleColor(UIColor.white, for: .highlighted)
        button.setTitleColor(kRGB(73, 109, 255), for: .normal)
        button.setBackgroundImage(Tools.image(with: kRGB(73, 109, 255)), for: .highlighted)
        button.setBackgroundImage(Tools.image(with: UIColor.white), for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        button.setTitle("Voice Progress", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(clickProgress), for: .touchUpInside)
        return button
    }()
    
    private lazy var voicePause: UIButton = {
        let button = UIButton()
        button.layer.borderColor = kRGB(73, 109, 255).cgColor
        button.layer.borderWidth = kAdaptX(3, 3)
        button.setTitleColor(UIColor.white, for: .highlighted)
        button.setTitleColor(kRGB(73, 109, 255), for: .normal)
        button.setBackgroundImage(Tools.image(with: kRGB(73, 109, 255)), for: .highlighted)
        button.setBackgroundImage(Tools.image(with: UIColor.white), for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        button.setTitle("Voice Pause", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(clickPause), for: .touchUpInside)
        return button
    }()
    
    private lazy var voicePlay: UIButton = {
        let button = UIButton()
        button.layer.borderColor = kRGB(73, 109, 255).cgColor
        button.layer.borderWidth = kAdaptX(3, 3)
        button.setTitleColor(UIColor.white, for: .highlighted)
        button.setTitleColor(kRGB(73, 109, 255), for: .normal)
        button.setBackgroundImage(Tools.image(with: kRGB(73, 109, 255)), for: .highlighted)
        button.setBackgroundImage(Tools.image(with: UIColor.white), for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        button.setTitle("Voice Play", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(clickPlay), for: .touchUpInside)
        return button
    }()
}
