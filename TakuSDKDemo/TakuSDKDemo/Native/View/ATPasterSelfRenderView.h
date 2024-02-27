//
//  ATPasterSelfRenderView.h
//  TakuSDKDemo
//
//  Created by Taku on 7/26/22.
//  Copyright © 2022 抽筋的灯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AnyThinkNative/AnyThinkNative.h>

NS_ASSUME_NONNULL_BEGIN

@interface ATPasterSelfRenderView : UIView

@property (nonatomic, strong) UILabel *countDownLabel;
@property (nonatomic, strong) UIImageView *mainImageView;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIView *mediaView;

- (instancetype) initWithOffer:(ATNativeAdOffer *)offer;

@end

NS_ASSUME_NONNULL_END
