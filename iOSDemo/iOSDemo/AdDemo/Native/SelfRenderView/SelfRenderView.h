//
//  SelfRenderView.h
//  iOSDemo
//
//  Created by ltz on 2025/1/11.
//

#import <UIKit/UIKit.h>
#import <AnyThinkNative/AnyThinkNative.h>
 
#define SelfRenderViewWidth (kScreenW)
#define SelfRenderViewHeight (350)

#define SelfRenderViewMediaViewWidth (kScreenW)
#define SelfRenderViewMediaViewHeight (350 - kNavigationBarHeight - 150)

@interface SelfRenderView : UIView

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
 
/// 关闭按钮
@property(nonatomic, strong) UIButton *dislikeButton;

/// 媒体视图
@property(nonatomic, strong) UIView *mediaView;

// only for yandex native
@property(nonatomic, strong) UILabel *domainLabel;
@property(nonatomic, strong) UILabel *warningLabel;

- (instancetype)initWithOffer:(ATNativeAdOffer *)offer;
- (void)destory;

@end 
