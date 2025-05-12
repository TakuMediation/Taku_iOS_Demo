//
//  DrawSelfRenderView.h
//  iOSDemo
//
//  Created by ltz on 2025/2/17.
//

#import <UIKit/UIKit.h>
#import <AnyThinkNative/AnyThinkNative.h>
 
@interface DrawSelfRenderView : UIView

/// 广告主
@property(nonatomic, strong) UILabel *advertiserLabel;

/// 内容
@property(nonatomic, strong) UILabel *textLabel;

/// 标题
@property(nonatomic, strong) UILabel *titleLabel;

/// 类似"点我下载"按钮上面的口号
@property(nonatomic, strong) UILabel *ctaLabel;

/// 评分
@property(nonatomic, strong) UILabel *ratingLabel;

/// 推广应用icon
@property(nonatomic, strong) UIImageView *iconImageView;

/// 主图
@property(nonatomic, strong) UIImageView *mainImageView;

/// 广告平台logo标识
@property(nonatomic, strong) UIImageView *logoImageView;

/// 关闭按钮
@property(nonatomic, strong) UIButton *dislikeButton;

/// 媒体视图
@property(nonatomic, strong) UIView *mediaView;

/// yandex native needed，yandex平台必须渲染
@property(nonatomic, strong) UILabel *domainLabel;
/// yandex native needed，yandex平台必须渲染
@property(nonatomic, strong) UILabel *warningLabel;

- (instancetype)initWithOffer:(ATNativeAdOffer *)offer;
- (void)destory;

@end
