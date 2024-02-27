//
//  ATPasterSelfRenderView.m
//  AnyThinkSDKDemo
//
//  Created by Taku on 7/26/22.
//  Copyright © 2022 抽筋的灯. All rights reserved.
//

#import "ATPasterSelfRenderView.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>

@interface ATPasterSelfRenderView ()

@property(nonatomic, strong) ATNativeAdOffer *nativeAdOffer;

@end

@implementation ATPasterSelfRenderView

- (void)dealloc{
    NSLog(@"🔥---ATPasterSelfRenderView--销毁");
}

- (instancetype) initWithOffer:(ATNativeAdOffer *)offer {

    if (self = [super init]) {
        
        _nativeAdOffer = offer;
        
        [self addView];
        [self makeConstraintsForSubviews];
        
        [self setupUI];
    }
    return self;
}

- (void)addView{
    self.countDownLabel = [[UILabel alloc]init];
    self.countDownLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    self.countDownLabel.textColor = [UIColor whiteColor];
    self.countDownLabel.layer.masksToBounds = YES;
    self.countDownLabel.layer.cornerRadius = 30 * 0.5;
    self.countDownLabel.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:.3f];
    self.countDownLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.countDownLabel];
    
    self.mainImageView = [[UIImageView alloc]init];
    self.mainImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.mainImageView.userInteractionEnabled = YES;
    [self addSubview:self.mainImageView];
    
    self.logoImageView = [[UIImageView alloc]init];
    self.logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.logoImageView.userInteractionEnabled = YES;
    [self addSubview:self.logoImageView];
}


- (void)setupUI {
    if (self.nativeAdOffer.nativeAd.videoDuration == 0) {
        self.countDownLabel.text = @"10";
    } else {
        self.countDownLabel.text = [NSString stringWithFormat:@"%ld",self.nativeAdOffer.nativeAd.videoDuration/1000];
    }
    NSLog(@"🔥----videoDuration:%ld",self.nativeAdOffer.nativeAd.videoDuration);

    [self.mainImageView sd_setImageWithURL:[NSURL URLWithString:self.nativeAdOffer.nativeAd.imageUrl]];
    
    NSLog(@"🔥----imageUrl:%@",self.nativeAdOffer.nativeAd.imageUrl);
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:self.nativeAdOffer.nativeAd.logoUrl]];
   
    NSLog(@"🔥----logoUrl:%@",self.nativeAdOffer.nativeAd.logoUrl);
}

-(void) makeConstraintsForSubviews {
    self.backgroundColor = randomColor;
    
    [self.countDownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@30);
        make.top.equalTo(self).equalTo(@5);
        make.right.equalTo(self).equalTo(@-30);
    }];
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@25);
        make.bottom.equalTo(self).equalTo(@-5);
        make.right.equalTo(self).equalTo(@-30);
    }];
    
    [self.mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self);
    }];
}

@end
