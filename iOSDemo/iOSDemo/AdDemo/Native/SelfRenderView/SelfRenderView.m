//
//  SelfRenderView.m
//  iOSDemo
//
//  Created by ltz on 2025/1/11.
//

#import "SelfRenderView.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>

#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
 
@interface SelfRenderView()

@property(nonatomic, strong) ATNativeAdOffer *nativeAdOffer;

@end

@implementation SelfRenderView

- (void)dealloc {
    ATDemoLog(@"🔥---SelfRenderView--dealloc");
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
     
    //关闭按钮图片可用示例的，也可以用自己的引入的
    UIImage *closeImg = [UIImage imageNamed:@"offer_video_close" inBundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"AnyThinkSDK" ofType:@"bundle"]] compatibleWithTraitCollection:nil];
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
 
    self.advertiserLabel.text = self.nativeAdOffer.nativeAd.advertiser;
    self.titleLabel.text = self.nativeAdOffer.nativeAd.title;
    self.textLabel.text = self.nativeAdOffer.nativeAd.mainText;
    self.ctaLabel.text = [NSString stringWithFormat:@"%@", self.nativeAdOffer.nativeAd.ctaText.length!=0 ? self.nativeAdOffer.nativeAd.ctaText : @"查看详情"];;
    self.ratingLabel.text = [NSString stringWithFormat:@"评分:%@", self.nativeAdOffer.nativeAd.rating.stringValue ? self.nativeAdOffer.nativeAd.rating.stringValue : @"暂无评分"];
    
    // yandex平台支持，有返回时必须渲染
    self.domainLabel.text = self.nativeAdOffer.nativeAd.domain;
    self.warningLabel.text = self.nativeAdOffer.nativeAd.warning;
    ATDemoLog(@"🔥AnythinkDemo::native domain:%@ ; warning:%@ ;",self.nativeAdOffer.nativeAd.domain,self.nativeAdOffer.nativeAd.warning);
    
    ATDemoLog(@"🔥AnythinkDemo::native文本内容title:%@ ; text:%@ ; cta:%@ ",self.nativeAdOffer.nativeAd.title,self.nativeAdOffer.nativeAd.mainText,self.nativeAdOffer.nativeAd.ctaText);
}

- (void)makeConstraintsForSubviews {
    self.backgroundColor = randomColor;
    self.titleLabel.backgroundColor = randomColor;
    self.textLabel.backgroundColor = randomColor;
 
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(100);
        make.right.equalTo(self).offset(-50);
        make.height.equalTo(@20);
        make.top.equalTo(self).offset(20);
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
    }];
    
    [self.domainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ratingLabel.mas_right).offset(20);
        make.right.equalTo(self).offset(-40);
        make.top.equalTo(self.ctaLabel.mas_top).offset(0);
        make.height.equalTo(@40);
    }];
    
    [self.advertiserLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.advertiserLabel.font.lineHeight);
        make.left.equalTo(self.ctaLabel);
        make.top.equalTo(self.ctaLabel.mas_bottom).offset(5);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.height.width.equalTo(@75);
        make.top.equalTo(self).offset(20);
    }];
    
    [self.mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(25);
        make.bottom.equalTo(self).offset(-5);
    }];

    [self.warningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(5);
        make.right.equalTo(self.mas_right).equalTo(@-5);
        make.bottom.equalTo(self).offset(-5);
        make.height.equalTo(@40);
    }];

    [self.dislikeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@30);
        make.top.equalTo(self).equalTo(@5);
        make.right.equalTo(self.mas_right).equalTo(@-15);
    }];
}

- (void)setMediaView:(UIView *)mediaView {
    _mediaView = mediaView;
    
    if (mediaView) {
        [self addSubview:mediaView];
        // 给mediaView设置约束
        [mediaView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.mainImageView);
        }];
    }
}

@end
