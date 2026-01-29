//
//  SelfRenderView.swift
//  SwiftDemo
//
//  Created by ltz on 2025/1/11.
//

import UIKit
import SnapKit
import SDWebImage
import AnyThinkSDK

// Define random color function
func randomColor() -> UIColor {
    return UIColor(red: CGFloat(arc4random_uniform(256))/255.0,
                   green: CGFloat(arc4random_uniform(256))/255.0,
                   blue: CGFloat(arc4random_uniform(256))/255.0,
                   alpha: CGFloat(arc4random_uniform(256))/255.0)
}

class SelfRenderView: UIView {
    
    // MARK: - Properties
    private var nativeAdOffer: ATNativeAdOffer?
    
    // UI Components
    var advertiserLabel: UILabel!
    var titleLabel: UILabel!
    var textLabel: UILabel!
    var ctaLabel: UILabel!
    var ratingLabel: UILabel!
    var domainLabel: UILabel!
    var warningLabel: UILabel!
    var iconImageView: UIImageView!
    var mainImageView: UIImageView!
    var dislikeButton: UIButton!
    var mediaView: UIView? {
        didSet {
            if let mediaView = mediaView {
                addSubview(mediaView)
                // Set constraints for mediaView
                mediaView.snp.updateConstraints { make in
                    make.edges.equalTo(self.mainImageView)
                }
            }
        }
    }
    
    // MARK: - Initialization
    init(offer: ATNativeAdOffer) {
        super.init(frame: .zero)
        nativeAdOffer = offer
        backgroundColor = randomColor()
        addView()
        makeConstraintsForSubviews()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        ATDemoLog("🔥---SelfRenderView--deinit")
    }
    
    // MARK: - Public Methods
    func destory() {
        // Destroy offer timely
        nativeAdOffer = nil
    }
    
    // MARK: - Private Methods
    private func addView() {
        advertiserLabel = UILabel()
        advertiserLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        advertiserLabel.textColor = UIColor.black
        advertiserLabel.textAlignment = .left
        addSubview(advertiserLabel)
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .left
        addSubview(titleLabel)
        
        textLabel = UILabel()
        textLabel.font = UIFont.systemFont(ofSize: 15.0)
        textLabel.textColor = UIColor.black
        addSubview(textLabel)
        
        ctaLabel = UILabel()
        ctaLabel.font = UIFont.systemFont(ofSize: 15.0)
        ctaLabel.textColor = UIColor.white
        ctaLabel.backgroundColor = UIColor.blue
        ctaLabel.textAlignment = .center
        addSubview(ctaLabel)
        
        ratingLabel = UILabel()
        ratingLabel.font = UIFont.systemFont(ofSize: 15.0)
        ratingLabel.textColor = UIColor.yellow
        addSubview(ratingLabel)
        
        domainLabel = UILabel()
        domainLabel.font = UIFont.systemFont(ofSize: 15.0)
        domainLabel.textColor = UIColor.black
        addSubview(domainLabel)
        
        warningLabel = UILabel()
        warningLabel.font = UIFont.systemFont(ofSize: 15.0)
        warningLabel.textColor = UIColor.black
        addSubview(warningLabel)
        
        iconImageView = UIImageView()
        iconImageView.layer.cornerRadius = 4.0
        iconImageView.layer.masksToBounds = true
        iconImageView.contentMode = .scaleAspectFit
        addSubview(iconImageView)
        
        mainImageView = UIImageView()
        mainImageView.contentMode = .scaleAspectFit
        addSubview(mainImageView)
         
        // Close button image can use example's, or you can use your own imported image
        let closeImg = UIImage(named: "offer_video_close", in: Bundle(path: Bundle.main.path(forResource: "AnyThinkSDK", ofType: "bundle") ?? ""), compatibleWith: nil)
        dislikeButton = UIButton(type: .custom)
        dislikeButton.backgroundColor = randomColor()
        dislikeButton.setImage(closeImg, for: .normal)
        addSubview(dislikeButton)
        
        addUserInteraction()
    }
    
    private func addUserInteraction() {
        ctaLabel.isUserInteractionEnabled = true
        advertiserLabel.isUserInteractionEnabled = true
        titleLabel.isUserInteractionEnabled = true
        textLabel.isUserInteractionEnabled = true
        ratingLabel.isUserInteractionEnabled = true
        domainLabel.isUserInteractionEnabled = true
        warningLabel.isUserInteractionEnabled = true
        iconImageView.isUserInteractionEnabled = true
        mainImageView.isUserInteractionEnabled = true
    }
    
    private func setupUI() {
        guard let nativeAdOffer = nativeAdOffer else { return }
        
        if let icon = nativeAdOffer.nativeAd.icon {
            iconImageView.image = icon
        }
        
        if let iconUrl = nativeAdOffer.nativeAd.iconUrl {
            iconImageView.sd_setImage(with: URL(string: iconUrl))
        }
  
        if let mainImage = nativeAdOffer.nativeAd.mainImage {
            mainImageView.image = mainImage
        }
        
        if let imageUrl = nativeAdOffer.nativeAd.imageUrl {
            mainImageView.sd_setImage(with: URL(string: imageUrl))
        }
        
 
        advertiserLabel.text = nativeAdOffer.nativeAd.advertiser
        titleLabel.text = nativeAdOffer.nativeAd.title
        textLabel.text = nativeAdOffer.nativeAd.mainText
        
        if let ctaText = nativeAdOffer.nativeAd.ctaText {
            ctaLabel.text = ctaText
        }else {
            ctaLabel.text = "View Details"
        }
        
        ratingLabel.text = "Rating: \(nativeAdOffer.nativeAd.rating?.stringValue ?? "No Rating")"
        
        // Yandex platform support, must render when returned
        domainLabel.text = nativeAdOffer.nativeAd.domain
        warningLabel.text = nativeAdOffer.nativeAd.warning
        ATDemoLog("🔥AnythinkDemo::native domain:\(nativeAdOffer.nativeAd.domain ?? "") ; warning:\(nativeAdOffer.nativeAd.warning ?? "") ;")
        
        ATDemoLog("🔥AnythinkDemo::native text content title:\(nativeAdOffer.nativeAd.title ?? "") ; text:\(nativeAdOffer.nativeAd.mainText ?? "") ; cta:\(nativeAdOffer.nativeAd.ctaText ?? "")")
    }
    
    private func makeConstraintsForSubviews() {
        backgroundColor = randomColor()
        titleLabel.backgroundColor = randomColor()
        textLabel.backgroundColor = randomColor()
         
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(self).offset(100)
            make.right.equalTo(self).offset(-50)
            make.height.equalTo(20)
            make.top.equalTo(self).offset(20)
        }
        
        textLabel.snp.makeConstraints { make in
            make.left.equalTo(self).offset(100)
            make.right.equalTo(self).offset(-50)
            make.height.equalTo(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        ctaLabel.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(5)
            make.width.equalTo(100)
            make.height.equalTo(ctaLabel.font.lineHeight)
            make.left.equalTo(textLabel.snp.left)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.left.equalTo(ctaLabel.snp.right).offset(20)
            make.height.equalTo(ratingLabel.font.lineHeight)
            make.top.equalTo(ctaLabel.snp.top).offset(0)
        }
        
        domainLabel.snp.makeConstraints { make in
            make.left.equalTo(ratingLabel.snp.right).offset(20)
            make.right.equalTo(self).offset(-40)
            make.top.equalTo(ctaLabel.snp.top).offset(0)
            make.height.equalTo(40)
        }
        
        advertiserLabel.snp.makeConstraints { make in
            make.height.equalTo(advertiserLabel.font.lineHeight)
            make.left.equalTo(ctaLabel)
            make.top.equalTo(ctaLabel.snp.bottom).offset(5)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.left.equalTo(self).offset(20)
            make.height.width.equalTo(75)
            make.top.equalTo(self).offset(20)
        }
        
        mainImageView.snp.makeConstraints { make in
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
            make.top.equalTo(iconImageView.snp.bottom).offset(25)
            make.bottom.equalTo(self).offset(-5)
        }
        
        warningLabel.snp.makeConstraints { make in
            make.left.equalTo(self).offset(5)
            make.right.equalTo(self.snp.right).offset(-5)
            make.bottom.equalTo(self).offset(-5)
            make.height.equalTo(40)
        }
        
        dislikeButton.snp.makeConstraints { make in
            make.height.width.equalTo(30)
            make.top.equalTo(self).offset(5)
            make.right.equalTo(self.snp.right).offset(-15)
        }
    }
}
