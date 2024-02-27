//
//  ATNativeRenderView.m
//  AnythinkSDKDemo
//
//  Created by Jason on 2021/10/29.
//

#import "ATNativeRenderView.h"
#import "ATAutoLayout.h"

@implementation ATNativeRenderView

-(void) initSubviews {
    [super initSubviews];
    _advertiserLabel = [UILabel autolayoutLabelFont:[UIFont boldSystemFontOfSize:15.0f] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [self addSubview:_advertiserLabel];
    
    _titleLabel = [UILabel autolayoutLabelFont:[UIFont boldSystemFontOfSize:18.0f] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [self addSubview:_titleLabel];
    
    _textLabel = [UILabel autolayoutLabelFont:[UIFont systemFontOfSize:15.0f] textColor:[UIColor blackColor]];
    [self addSubview:_textLabel];
    
    _ctaLabel = [UILabel autolayoutLabelFont:[UIFont systemFontOfSize:15.0f] textColor:[UIColor blackColor]];
    [self addSubview:_ctaLabel];
    
    _ratingLabel = [UILabel autolayoutLabelFont:[UIFont systemFontOfSize:15.0f] textColor:[UIColor blackColor]];
    [self addSubview:_ratingLabel];
    
    _iconImageView = [UIImageView autolayoutView];
    _iconImageView.layer.cornerRadius = 4.0f;
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_iconImageView];
    
    _mainImageView = [UIImageView autolayoutView];
    _mainImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_mainImageView];
    
    _logoImageView = [UIImageView autolayoutView];
    _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_logoImageView];
    
    _dislikeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _dislikeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_dislikeButton];
}

- (NSArray<UIView*>*)clickableViews {
    NSMutableArray<UIView*> *clickableViews = [NSMutableArray<UIView*> arrayWithObjects:_iconImageView, _ctaLabel, _mainImageView, nil];
    if (self.mediaView != nil) { [clickableViews addObject:self.mediaView]; }
    return clickableViews;
}

- (void)layoutMediaView {
    self.mediaView.frame = CGRectMake(0, 120.0f, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - 120.0f);
}

-(void) makeConstraintsForSubviews {
    [super makeConstraintsForSubviews];
}

-(void) makeConstraintsDrawVideoAssets {
    
}
@end
