//
//  DrawSelfRenderView.m
//  iOSDemo
//
//  Created by ltz on 2025/2/17.
//

#import "DrawSelfRenderView.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>

#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

@interface DrawSelfRenderView()

@property(nonatomic, strong) ATNativeAdOffer *nativeAdOffer;

@end

@implementation DrawSelfRenderView

- (void)dealloc {
    ATDemoLog(@"🔥---DrawSelfRenderView--dealloc");
}

- (void)destory {
    //及时销毁 offer
    _nativeAdOffer = nil;
}

- (instancetype)initWithOffer:(ATNativeAdOffer *)offer {
    if (self = [super init]) {
        _nativeAdOffer = offer;
        self.backgroundColor = randomColor;
        [self addView];
        [self makeConstraintsForSubviews];
        [self setupUI];
    }
    return self;
}

- (void)addView {
    self.advertiserLabel = [[UILabel alloc]init];
    self.advertiserLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    self.advertiserLabel.textColor = [UIColor blackColor];
    self.advertiserLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.advertiserLabel];
        
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.titleLabel];
    
    self.textLabel = [[UILabel alloc]init];
    self.textLabel.font = [UIFont systemFontOfSize:15.0f];
    self.textLabel.textColor = [UIColor blackColor];
    [self addSubview:self.textLabel];
    
    self.ctaLabel = [[UILabel alloc]init];
    self.ctaLabel.font = [UIFont systemFontOfSize:15.0f];
    self.ctaLabel.textColor = [UIColor whiteColor];
    self.ctaLabel.backgroundColor = [UIColor blueColor];
    self.ctaLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.ctaLabel];

    self.ratingLabel = [[UILabel alloc]init];
    self.ratingLabel.font = [UIFont systemFontOfSize:15.0f];
    self.ratingLabel.textColor = [UIColor yellowColor];
    [self addSubview:self.ratingLabel];
    
    self.domainLabel = [[UILabel alloc]init];
    self.domainLabel.font = [UIFont systemFontOfSize:15.0f];
    self.domainLabel.textColor = [UIColor blackColor];
    [self addSubview:self.domainLabel];
    
    self.warningLabel = [[UILabel alloc]init];
    self.warningLabel.font = [UIFont systemFontOfSize:15.0f];
    self.warningLabel.textColor = [UIColor blackColor];
    [self addSubview:self.warningLabel];
    
    self.iconImageView = [[UIImageView alloc]init];
    self.iconImageView.layer.cornerRadius = 4.0f;
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.iconImageView];
    
    self.mainImageView = [[UIImageView alloc]init];
    self.mainImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.mainImageView];
    
    self.logoImageView = [[UIImageView alloc]init];
    self.logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.logoImageView.tag = 110220;
    [self addSubview:self.logoImageView];
    
    UIImage *closeImg = [UIImage imageNamed:@"icon_webview_close" inBundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"AnyThinkSDK" ofType:@"bundle"]] compatibleWithTraitCollection:nil];
    self.dislikeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.dislikeButton.backgroundColor = randomColor;
    [self.dislikeButton setImage:closeImg forState:0];
    [self addSubview:self.dislikeButton];
    
    [self addUserInteraction];
}

- (void)addUserInteraction {
    self.ctaLabel.userInteractionEnabled = YES;
    self.advertiserLabel.userInteractionEnabled = YES;
    self.titleLabel.userInteractionEnabled = YES;
    self.textLabel.userInteractionEnabled = YES;
    self.ratingLabel.userInteractionEnabled = YES;
    self.domainLabel.userInteractionEnabled = YES;
    self.warningLabel.userInteractionEnabled = YES;
    self.iconImageView.userInteractionEnabled = YES;
    self.mainImageView.userInteractionEnabled = YES;
    self.logoImageView.userInteractionEnabled = YES;
}

- (void)setupUI {
    if (self.nativeAdOffer.nativeAd.icon) {
        self.iconImageView.image = self.nativeAdOffer.nativeAd.icon;
    } else {
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.nativeAdOffer.nativeAd.iconUrl]];
        ATDemoLog(@"🔥AnyThinkDemo::iconUrl:%@",self.nativeAdOffer.nativeAd.iconUrl);
    }

    if (self.nativeAdOffer.nativeAd.mainImage) {
        self.mainImageView.image = self.nativeAdOffer.nativeAd.mainImage;
    } else {
        [self.mainImageView sd_setImageWithURL:[NSURL URLWithString:self.nativeAdOffer.nativeAd.imageUrl]];
        ATDemoLog(@"🔥AnyThinkDemo::imageUrl:%@",self.nativeAdOffer.nativeAd.imageUrl);
    }
    
    if (self.nativeAdOffer.nativeAd.logoUrl.length) {
        ATDemoLog(@"🔥----logoUrl:%@",self.nativeAdOffer.nativeAd.logoUrl);
        [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:self.nativeAdOffer.nativeAd.logoUrl]];
    } else if (self.nativeAdOffer.nativeAd.logo) {
        ATDemoLog(@"🔥----logo:%@",self.nativeAdOffer.nativeAd.logo);
        self.logoImageView.image = self.nativeAdOffer.nativeAd.logo;
    } else { // All of these are nil, set the default platform logo using networkFirmID.
        if (self.nativeAdOffer.networkFirmID == 15) {//CSJ
            self.logoImageView.image = [UIImage imageNamed:@"tt_ad_logo_new"];
        }
    }
        
    self.advertiserLabel.text = [NSString stringWithFormat:@"广告商:%@",self.nativeAdOffer.nativeAd.advertiser];
    self.titleLabel.text = self.nativeAdOffer.nativeAd.title;
    self.textLabel.text = self.nativeAdOffer.nativeAd.mainText;
    self.ctaLabel.text = self.nativeAdOffer.nativeAd.ctaText;
    self.ratingLabel.text = [NSString stringWithFormat:@"评分:%@", self.nativeAdOffer.nativeAd.rating.stringValue ? self.nativeAdOffer.nativeAd.rating.stringValue : @""];
    
    // 仅yandex平台支持，有返回时必须渲染
    self.domainLabel.text = self.nativeAdOffer.nativeAd.domain;
    self.warningLabel.text = self.nativeAdOffer.nativeAd.warning;
    ATDemoLog(@"🔥AnythinkDemo::native文本内容title:%@ ; text:%@ ; cta:%@ ",self.nativeAdOffer.nativeAd.title,self.nativeAdOffer.nativeAd.mainText,self.nativeAdOffer.nativeAd.ctaText);
}

- (void)makeConstraintsForSubviews {
    self.backgroundColor = randomColor;
    self.titleLabel.backgroundColor = randomColor;
    self.textLabel.backgroundColor = randomColor;
    CGFloat topPadding = kNavigationBarHeight;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(100);
        make.right.equalTo(self).offset(-50);
        make.height.equalTo(@20);
        make.top.equalTo(self).offset(20+topPadding);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(100);
        make.right.equalTo(self).offset(-50);
        make.height.equalTo(@20);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
    }];
    
    [self.ctaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textLabel.mas_bottom).equalTo(@5);
        make.width.equalTo(@100);
        make.height.mas_equalTo(self.ctaLabel.font.lineHeight);
        make.left.equalTo(self.textLabel.mas_left);
    }];
    
    [self.ratingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ctaLabel.mas_right).offset(20);
        make.height.mas_equalTo(self.ratingLabel.font.lineHeight);
        make.top.equalTo(self.ctaLabel.mas_top).offset(0);
        make.width.equalTo(@80);
    }];
     
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.height.width.equalTo(@75);
        make.top.equalTo(self.titleLabel);
    }];
    
    [self.mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.centerY.mas_equalTo(self.mas_centerY).mas_offset(50);
        make.height.mas_equalTo(300);
    }];
    
    [self.advertiserLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ctaLabel.mas_bottom).offset(10);
        make.left.equalTo(self.ctaLabel);
        make.height.mas_equalTo(self.advertiserLabel.font.lineHeight);
    }];

    [self.dislikeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@30);
        make.top.equalTo(self.titleLabel);
        make.right.equalTo(self.mas_right).equalTo(@-15);
    }];
    
    //如果广告平台素材返回了logo或logoUrl，那么设置这个才有效果
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@25);
        make.bottom.equalTo(self).equalTo(@-5);
        make.left.equalTo(self).equalTo(@5);
    }];
    
    //yandex平台必须渲染
    [self.warningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.advertiserLabel.mas_bottom).offset(10);
        make.left.equalTo(self.ctaLabel);
        make.height.mas_equalTo(self.advertiserLabel.font.lineHeight);
    }];
    
    //yandex平台必须渲染
    [self.domainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.warningLabel.mas_bottom).offset(10);
        make.left.equalTo(self.ctaLabel);
        make.height.mas_equalTo(self.advertiserLabel.font.lineHeight);
    }];
}

- (void)setMediaView:(UIView *)mediaView {
    _mediaView = mediaView;
    
    if (mediaView) {
        [self addSubview:mediaView];
        // 给mediaView设置约束
        [mediaView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.mainImageView);
        }];
    }
}
 
@end
