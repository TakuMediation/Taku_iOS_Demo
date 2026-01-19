//
//  TwoButtonAlertView.m
//  iOSDemo
//
//  Created by ltz on 2025/1/7.
//

#import "TwoButtonAlertView.h"

@interface TwoButtonAlertView()

@property (strong, nonatomic) UIView * blackView;
@property (strong, nonatomic) UIView * ctrView;
@property (strong, nonatomic) UILabel * titleLbl;
@property (strong, nonatomic) UILabel * contentLbl;
@property (strong, nonatomic) UIButton * commitBtn;
@property (strong, nonatomic) UIButton * jixuButton;
@property (strong, nonatomic) UITextField * tf;
@property (assign, nonatomic) NSInteger maxLength;

@end

@implementation TwoButtonAlertView

- (instancetype)initWithTitle:(NSString *)title buttonText1:(NSString *)buttonText1 buttonText2:(NSString *)buttonText2
{
    if (self == [super init]) {
        self.blackView = [UIView new];
        self.blackView.backgroundColor = kHexColorAlpha(0x000000, 0.5);
        [self addSubview:self.blackView];
        
        [self.blackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        self.ctrView = [UIView new];
        self.ctrView.backgroundColor = kHexColor(0xffffff);
        self.ctrView.layer.cornerRadius = 15;
        self.ctrView.layer.masksToBounds = YES;
        [self addSubview:self.ctrView];
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = @[(__bridge id)kHexColorAlpha(0xE5F7F1, 1).CGColor,(__bridge id)kHexColorAlpha(0xF9FDFC, 1).CGColor, (__bridge id)kHexColor(0xFFFFFF).CGColor];
        gradientLayer.locations = @[@0, @0.4,@1];
        gradientLayer.startPoint = CGPointMake(0.5, 0);
        gradientLayer.endPoint = CGPointMake(0.5, 1.0);
        gradientLayer.frame = CGRectMake(0, 0, kAdaptW(336, 336), kAdaptH(164, 164));
        [self.ctrView.layer addSublayer:gradientLayer];
        
        [self.ctrView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.height.mas_equalTo(kAdaptH(240, 240));
            make.width.mas_equalTo(kAdaptW(300, 300));
        }];
         
        self.titleLbl = [UILabel new];
        self.titleLbl.textAlignment = NSTextAlignmentCenter;
        self.titleLbl.textColor = kHexColor(0x333333);
        self.titleLbl.font = [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
        self.titleLbl.text = title;
        self.titleLbl.textAlignment = NSTextAlignmentCenter;
        self.titleLbl.numberOfLines = 0;
        [self.ctrView addSubview:self.titleLbl];
        
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.ctrView.mas_top).mas_offset(kAdaptY(30, 30));
            make.left.mas_equalTo(self.ctrView).mas_offset(kAdaptW(20, 20));
            make.right.mas_equalTo(self.ctrView).mas_offset(-kAdaptW(20, 20));
        }];
         
        self.jixuButton = [TwoButtonAlertView commonButtonLightGrayWithTitle:buttonText1];
        [self.ctrView addSubview:self.jixuButton];
        
        [self.jixuButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.ctrView.mas_bottom).mas_offset(-kAdaptY(20, 20));
            make.left.mas_equalTo(self.ctrView.mas_left).mas_offset(kAdaptX(23, 23));
            make.width.mas_equalTo(kAdaptW(117, 117));
            make.height.mas_equalTo(kAdaptH(42 , 42));
        }];
        
        self.commitBtn = [TwoButtonAlertView commonButtonWithTitle:buttonText2];
        [self.ctrView addSubview:self.commitBtn];
         
        [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.ctrView.mas_bottom).mas_offset(-kAdaptY(20, 20));
            make.right.mas_equalTo(self.ctrView.mas_right).mas_offset(-kAdaptX(23, 23));
            make.width.mas_equalTo(kAdaptW(117, 117));
            make.height.mas_equalTo(kAdaptH(42 , 42));
        }];
          
        [self.commitBtn addTarget:self action:@selector(commitBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.jixuButton addTarget:self action:@selector(jixuBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content buttonText1:(NSString *)buttonText1 buttonText2:(NSString *)buttonText2
{
    if (self == [super init]) {
        self.blackView = [UIView new];
        self.blackView.backgroundColor = kHexColorAlpha(0x000000, 0.5);
        [self addSubview:self.blackView];
        
        [self.blackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        CGSize contentSize = [TwoButtonAlertView textSizeForString:content isAnchorWidth:YES anchorValue:kAdaptW(254, 254) font:[UIFont boldSystemFontOfSize:18]];
        
        self.ctrView = [UIView new];
        self.ctrView.backgroundColor = kHexColor(0xffffff);
        self.ctrView.layer.cornerRadius = 15;
        self.ctrView.layer.masksToBounds = YES;
        [self addSubview:self.ctrView];
        
//        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//        gradientLayer.colors = @[(__bridge id)kHexColorAlpha(0x3E66EB, 1).CGColor,(__bridge id)kHexColorAlpha(0xF4F4F4, 1).CGColor, (__bridge id)kHexColor(0xFFFFFF).CGColor];
//        gradientLayer.locations = @[@0, @0.4,@1];
//        gradientLayer.startPoint = CGPointMake(0.5, 0);
//        gradientLayer.endPoint = CGPointMake(0.5, 1.0);
//        gradientLayer.frame = CGRectMake(0, 0, kAdaptW(608, 608), kAdaptH(388, 388)+kAdaptH(contentSize.height, contentSize.height)+kAdaptY(20, 20)+kAdaptY(24, 24));
//        [self.ctrView.layer addSublayer:gradientLayer];
        
        [self.ctrView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.height.mas_equalTo(kAdaptH(300, 300)+contentSize.height+kAdaptY(20, 20)+kAdaptY(24, 24));
            make.width.mas_equalTo(kAdaptW(608, 608));
        }];
          
        self.titleLbl = [UILabel new];
        self.titleLbl.textAlignment = NSTextAlignmentCenter;
        self.titleLbl.textColor = kHexColor(0x333333);
        self.titleLbl.font = [UIFont boldSystemFontOfSize:18];
        self.titleLbl.text = title;
        self.titleLbl.textAlignment = NSTextAlignmentCenter;
        self.titleLbl.numberOfLines = 0;
        [self.ctrView addSubview:self.titleLbl];
        
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.ctrView.mas_top).mas_offset(kAdaptY(50, 50));
            make.left.mas_equalTo(self.ctrView).mas_offset(kAdaptW(20, 20));
            make.right.mas_equalTo(self.ctrView.mas_right).mas_offset(-kAdaptW(20, 20));
            make.height.mas_equalTo(kAdaptH(50, 50));
        }];
         
        self.contentLbl = [UILabel new];
        self.contentLbl.textAlignment = NSTextAlignmentCenter;
        self.contentLbl.textColor = kHexColor(0x8B94A3);
        self.contentLbl.font = [UIFont systemFontOfSize:16];
        self.contentLbl.text = content;
        self.contentLbl.numberOfLines = 0;
        [self.ctrView addSubview:self.contentLbl];
        
        [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLbl.mas_bottom).mas_offset(kAdaptY(20, 20));
            make.left.mas_equalTo(self.ctrView).mas_offset(kAdaptW(30, 30));
            make.right.mas_equalTo(self.ctrView.mas_right).mas_offset(-kAdaptW(23, 23));
            make.height.mas_equalTo(contentSize.height);
        }];
        
        self.jixuButton = [TwoButtonAlertView commonButtonLightGrayWithTitle:buttonText1];
        [self.ctrView addSubview:self.jixuButton];
        
        [self.jixuButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.ctrView.mas_bottom).mas_offset(-kAdaptY(30, 30));
            make.left.mas_equalTo(self.ctrView.mas_left).mas_offset(kAdaptX(30, 30));
            make.width.mas_equalTo(kAdaptW(240, 240));
            make.height.mas_equalTo(kAdaptH(88 , 88));
        }];
        
        self.commitBtn = [TwoButtonAlertView commonButtonWithTitle:buttonText2];
        [self.ctrView addSubview:self.commitBtn];
         
        [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.ctrView.mas_bottom).mas_offset(-kAdaptY(30, 30));
            make.right.mas_equalTo(self.ctrView.mas_right).mas_offset(-kAdaptX(30, 30));
            make.width.mas_equalTo(kAdaptW(240, 240));
            make.height.mas_equalTo(kAdaptH(88 , 88));
        }];
          
        [self.commitBtn addTarget:self action:@selector(commitBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.jixuButton addTarget:self action:@selector(jixuBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content att:(NSMutableAttributedString *)att buttonText1:(NSString *)buttonText1 buttonText2:(NSString *)buttonText2
{
    if (self == [super init]) {
        self.blackView = [UIView new];
        self.blackView.backgroundColor = kHexColorAlpha(0x000000, 0.5);
        [self addSubview:self.blackView];
        
        [self.blackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        CGSize contentSize = [TwoButtonAlertView textSizeForString:content isAnchorWidth:YES anchorValue:kAdaptW(254, 254) font:[UIFont systemFontOfSize:14]];
        
        self.ctrView = [UIView new];
        self.ctrView.backgroundColor = kHexColor(0xffffff);
        self.ctrView.layer.cornerRadius = 15;
        self.ctrView.layer.masksToBounds = YES;
        [self addSubview:self.ctrView];
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = @[(__bridge id)kHexColorAlpha(0xE5F7F1, 1).CGColor,(__bridge id)kHexColorAlpha(0xF9FDFC, 1).CGColor, (__bridge id)kHexColor(0xFFFFFF).CGColor];
        gradientLayer.locations = @[@0, @0.4,@1];
        gradientLayer.startPoint = CGPointMake(0.5, 0);
        gradientLayer.endPoint = CGPointMake(0.5, 1.0);
        gradientLayer.frame = CGRectMake(0, 0, kAdaptW(300, 300), kAdaptH(148, 148)+kAdaptH(contentSize.height, contentSize.height)+kAdaptY(20, 20)+kAdaptY(24, 24));
        [self.ctrView.layer addSublayer:gradientLayer];
        
        [self.ctrView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.height.mas_equalTo(kAdaptH(148, 148)+kAdaptH(contentSize.height, contentSize.height)+kAdaptY(20, 20)+kAdaptY(24, 24));
            make.width.mas_equalTo(kAdaptW(300, 300));
        }];
          
        self.titleLbl = [UILabel new];
        self.titleLbl.textAlignment = NSTextAlignmentCenter;
        self.titleLbl.textColor = kHexColor(0x333333);
        self.titleLbl.font = [UIFont systemFontOfSize:16];
        self.titleLbl.text = title;
        self.titleLbl.textAlignment = NSTextAlignmentCenter;
        self.titleLbl.numberOfLines = 0;
        [self.ctrView addSubview:self.titleLbl];
        
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.ctrView.mas_top).mas_offset(kAdaptY(30, 30));
            make.left.mas_equalTo(self.ctrView).mas_offset(kAdaptW(20, 20));
            make.right.mas_equalTo(self.ctrView).mas_offset(-kAdaptW(20, 20));
            make.height.mas_equalTo(kAdaptH(22, 22));
        }];
         
        self.contentLbl = [UILabel new];
        self.contentLbl.textAlignment = NSTextAlignmentCenter;
        self.contentLbl.textColor = kHexColor(0x333333);
        self.contentLbl.font = [UIFont boldSystemFontOfSize:14];
        self.contentLbl.attributedText = att;
        self.contentLbl.numberOfLines = 0;
        [self.ctrView addSubview:self.contentLbl];
        
        [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLbl.mas_bottom).mas_offset(kAdaptY(20, 20));
            make.left.mas_equalTo(self.ctrView).mas_offset(kAdaptW(23, 23));
            make.right.mas_equalTo(self.ctrView).mas_offset(-kAdaptW(23, 23));
            make.height.mas_equalTo(kAdaptH(contentSize.height, contentSize.height));
        }];
        
        self.jixuButton = [TwoButtonAlertView commonButtonLightGrayWithTitle:buttonText1];
        [self.ctrView addSubview:self.jixuButton];
        
        [self.jixuButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.ctrView.mas_bottom).mas_offset(-kAdaptY(20, 20));
            make.left.mas_equalTo(self.ctrView.mas_left).mas_offset(kAdaptX(23, 23));
            make.width.mas_equalTo(kAdaptW(117, 117));
            make.height.mas_equalTo(kAdaptH(42 , 42));
        }];
        
        self.commitBtn = [TwoButtonAlertView commonButtonWithTitle:buttonText2];
        [self.ctrView addSubview:self.commitBtn];
         
        [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.ctrView.mas_bottom).mas_offset(-kAdaptY(20, 20));
            make.right.mas_equalTo(self.ctrView.mas_right).mas_offset(-kAdaptX(23, 23));
            make.width.mas_equalTo(kAdaptW(117, 117));
            make.height.mas_equalTo(kAdaptH(42 , 42));
        }];
          
        [self.commitBtn addTarget:self action:@selector(commitBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.jixuButton addTarget:self action:@selector(jixuBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (instancetype)initWithAlert:(NSString *)title content:(NSString *)content buttonText:(NSString *)buttonText
{
    if (self == [super init]) {
        self.blackView = [UIView new];
        self.blackView.backgroundColor = kHexColorAlpha(0x000000, 0.5);
        [self addSubview:self.blackView];
        
        [self.blackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        CGSize contentSize = [TwoButtonAlertView textSizeForString:content isAnchorWidth:YES anchorValue:kAdaptW(244, 244) font:[UIFont systemFontOfSize:20 weight:UIFontWeightBold]];
        
        self.ctrView = [UIView new];
        self.ctrView.backgroundColor = kHexColor(0xffffff);
        self.ctrView.layer.cornerRadius = 15;
        self.ctrView.layer.masksToBounds = YES;
        [self addSubview:self.ctrView];
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = @[(__bridge id)kHexColorAlpha(0xE5F7F1, 1).CGColor,(__bridge id)kHexColorAlpha(0xF9FDFC, 1).CGColor, (__bridge id)kHexColor(0xFFFFFF).CGColor];
        gradientLayer.locations = @[@0, @0.4,@1];
        gradientLayer.startPoint = CGPointMake(0.5, 0);
        gradientLayer.endPoint = CGPointMake(0.5, 1.0);
        gradientLayer.frame = CGRectMake(0, 0, kAdaptW(300, 300), kAdaptH(224, 224));
        [self.ctrView.layer addSublayer:gradientLayer];
        
        
        [self.ctrView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.height.mas_equalTo(kAdaptH(224, 224));
            make.width.mas_equalTo(kAdaptW(300, 300));
        }];
          
        self.titleLbl = [UILabel new];
        self.titleLbl.textAlignment = NSTextAlignmentCenter;
        self.titleLbl.textColor = kHexColor(0x555555);
        self.titleLbl.font = [UIFont systemFontOfSize:16];
        self.titleLbl.text = title;
        self.titleLbl.textAlignment = NSTextAlignmentCenter;
        self.titleLbl.numberOfLines = 0;
        [self.ctrView addSubview:self.titleLbl];
        
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.ctrView.mas_top).mas_offset(kAdaptY(20, 20));
            make.left.mas_equalTo(self.ctrView).mas_offset(kAdaptW(20, 20));
            make.right.mas_equalTo(self.ctrView).mas_offset(-kAdaptW(20, 20));
            make.height.mas_equalTo(kAdaptH(22, 22));
        }];
         
        self.contentLbl = [UILabel new];
        self.contentLbl.textAlignment = NSTextAlignmentCenter;
        self.contentLbl.textColor = kHexColor(0x333333);
        self.contentLbl.font = [UIFont boldSystemFontOfSize:20];
        self.contentLbl.text = content;
        self.contentLbl.numberOfLines = 0;
        [self.ctrView addSubview:self.contentLbl];
        
        [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLbl.mas_bottom).mas_offset(kAdaptY(30, 30));
            make.left.mas_equalTo(self.ctrView).mas_offset(kAdaptW(23, 23));
            make.right.mas_equalTo(self.ctrView).mas_offset(-kAdaptW(23, 23));
            make.height.mas_equalTo(kAdaptH(contentSize.height, contentSize.height));
        }];
 
        self.commitBtn = [TwoButtonAlertView commonButtonWhiteWithTitle:buttonText img:nil];
        [self.ctrView addSubview:self.commitBtn];
         
        [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.ctrView.mas_bottom).mas_offset(0);
            make.right.mas_equalTo(self.ctrView.mas_right).mas_offset(0);
            make.width.mas_equalTo(kAdaptW(300, 300));
            make.height.mas_equalTo(kAdaptH(66 , 66));
        }];
          
        [self.commitBtn addTarget:self action:@selector(commitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder buttonText1:(NSString *)buttonText1 buttonText2:(NSString *)buttonText2 maxLength:(NSInteger)maxLength
{
    if (self == [super init]) {
        self.maxLength = maxLength;
        self.blackView = [UIView new];
        self.blackView.backgroundColor = kHexColorAlpha(0x000000, 0.5);
        [self addSubview:self.blackView];
        
        [self.blackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
         
        self.ctrView = [UIView new];
        self.ctrView.backgroundColor = kHexColor(0xffffff);
        self.ctrView.layer.cornerRadius = 15;
        self.ctrView.layer.masksToBounds = YES;
        [self addSubview:self.ctrView];
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = @[(__bridge id)kHexColorAlpha(0xE5F7F1, 1).CGColor,(__bridge id)kHexColorAlpha(0xF9FDFC, 1).CGColor, (__bridge id)kHexColor(0xFFFFFF).CGColor];
        gradientLayer.locations = @[@0, @0.4,@1];
        gradientLayer.startPoint = CGPointMake(0.5, 0);
        gradientLayer.endPoint = CGPointMake(0.5, 1.0);
        gradientLayer.frame = CGRectMake(0, 0, kAdaptW(300, 300), kAdaptH(198, 198));
        [self.ctrView.layer addSublayer:gradientLayer];
        
        [self.ctrView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.height.mas_equalTo(kAdaptH(198, 198));
            make.width.mas_equalTo(kAdaptW(300, 300));
        }];
          
        self.titleLbl = [UILabel new];
        self.titleLbl.textAlignment = NSTextAlignmentCenter;
        self.titleLbl.textColor = kHexColor(0x333333);
        self.titleLbl.font = [UIFont systemFontOfSize:16];
        self.titleLbl.text = title;
        self.titleLbl.textAlignment = NSTextAlignmentCenter;
        self.titleLbl.numberOfLines = 0;
        [self.ctrView addSubview:self.titleLbl];
        
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.ctrView.mas_top).mas_offset(kAdaptY(30, 30));
            make.left.mas_equalTo(self.ctrView).mas_offset(kAdaptW(20, 20));
            make.right.mas_equalTo(self.ctrView).mas_offset(-kAdaptW(20, 20));
            make.height.mas_equalTo(kAdaptH(22, 22));
        }];
         
        self.tf = [UITextField new];
        self.tf.placeholder = placeholder;
        self.tf.font = [UIFont systemFontOfSize:14];
        self.tf.backgroundColor = kHexColor(0xF6F6F6);
        self.tf.layer.cornerRadius = kAdaptW(6, 6);
        self.tf.layer.masksToBounds = YES;
        [self.ctrView addSubview:self.tf];
        [self.tf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self.tf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLbl.mas_bottom).mas_offset(kAdaptY(20, 20));
            make.left.mas_equalTo(self.ctrView).mas_offset(kAdaptW(23, 23));
            make.right.mas_equalTo(self.ctrView).mas_offset(-kAdaptW(23, 23));
            make.height.mas_equalTo(kAdaptH(44,44));
        }];
        
        self.jixuButton = [TwoButtonAlertView commonButtonLightGrayWithTitle:buttonText1];
        [self.ctrView addSubview:self.jixuButton];
        
        [self.jixuButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.ctrView.mas_bottom).mas_offset(-kAdaptY(20, 20));
            make.left.mas_equalTo(self.ctrView.mas_left).mas_offset(kAdaptX(23, 23));
            make.width.mas_equalTo(kAdaptW(117, 117));
            make.height.mas_equalTo(kAdaptH(42 , 42));
        }];
        
        self.commitBtn = [TwoButtonAlertView commonButtonWithTitle:buttonText2];
        [self.ctrView addSubview:self.commitBtn];
         
        [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.ctrView.mas_bottom).mas_offset(-kAdaptY(20, 20));
            make.right.mas_equalTo(self.ctrView.mas_right).mas_offset(-kAdaptX(23, 23));
            make.width.mas_equalTo(kAdaptW(117, 117));
            make.height.mas_equalTo(kAdaptH(42 , 42));
        }];
          
        [self.commitBtn addTarget:self action:@selector(commitBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.jixuButton addTarget:self action:@selector(jixuBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
 
- (void)show
{
    if (self.superview) {
        [self.superview bringSubviewToFront:self];
        return;
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
 
    [window addSubview:self];
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.superview);
    }];
}

- (void)dismiss
{
    [self removeFromSuperview];
}

- (void)jixuBtnClick
{
    if (self.tf) {
        self.TwoButtonAlertTextStyle1Block(1,self.tf.text);
        [self dismiss];
        return;
    }
 
    if (self.TruelyGGBlock) {
        self.TruelyGGBlock(1);
    }
    [self dismiss];
}

- (void)commitBtnClick
{
    if (self.tf) {
        self.TwoButtonAlertTextStyle1Block(2,self.tf.text);
        [self dismiss];
        return;
    }
 
    if (self.TruelyGGBlock) {
        self.TruelyGGBlock(2);
    }
    [self dismiss];
}

- (void)addTwoButtonAlertBlock:(TwoButtonAlertBlock)block
{
    self.TruelyGGBlock = block;
}

- (void)addTwoButtonAlertTextStyle1Block:(TwoButtonAlertTextStyle1Block)block
{
    self.TwoButtonAlertTextStyle1Block = block;
}

- (void)addTwoButtonAlertSelfIndexBlock:(TwoButtonAlertSelfIndexBlock)block
{
    self.TwoButtonAlertSelfIndexBlock = block;
}

- (void)disableBlackViewClick
{
    self.blackView.userInteractionEnabled = NO;
}

- (void)textFieldDidChange:(UITextField *)tf
{
    NSString  *nsTextContent = tf.text;
    NSInteger existTextNum = nsTextContent.length;
    
    NSInteger maxNum = self.maxLength;
     
    if (tf.markedTextRange == nil)
    {
       // 没有预输入文字
       if (existTextNum > maxNum){
           //截取到最大位置的字符
           NSString *s = [nsTextContent substringToIndex:maxNum];
           tf.text = s;
       }
    }
}

+ (UIButton *)commonButtonWithTitle:(NSString *)title
{
    UIButton * okButton = [UIButton new];
    [okButton setTitleColor:kHexColor(0xffffff) forState:UIFontWeightSemibold];
    okButton.layer.cornerRadius = kAdaptW(6, 6);
    okButton.layer.masksToBounds = YES;
    [okButton setBackgroundColor:kHexColor(0x3E66EB)];
    okButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [okButton setTitle:title forState:UIControlStateNormal];
    return okButton;
}

+ (UIButton *)commonButtonLightGrayWithTitle:(NSString *)title
{
    UIButton * okButton = [UIButton new];
    [okButton setTitleColor:kHexColor(0x333333) forState:UIFontWeightSemibold];
    okButton.layer.cornerRadius = kAdaptW(6, 6);
    okButton.layer.masksToBounds = YES;
    okButton.layer.borderWidth = 1;
    okButton.layer.borderColor = kHexColor(0xF2F3F6).CGColor;
    [okButton setBackgroundColor:UIColor.clearColor];
    okButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [okButton setTitle:title forState:UIControlStateNormal];
    return okButton;
}

+ (UIButton *)commonButtonWhiteWithTitle:(NSString *)title img:(UIImage *)img
{
    UIButton * okButton = [UIButton new];
    [okButton setTitleColor:kHexColor(0x00B277) forState:UIFontWeightSemibold];
    okButton.layer.cornerRadius = kAdaptW(6, 6);
    okButton.layer.masksToBounds = YES;
    okButton.layer.borderColor = kHexColor(0x00B277).CGColor;
    okButton.layer.borderWidth = 1;
    [okButton setImage:img forState:UIControlStateNormal];
    [okButton setBackgroundColor:kHexColor(0xffffff)];
    okButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [okButton setTitle:title forState:UIControlStateNormal];
    return okButton;
}

+ (CGSize)textSizeForString:(NSString *)str isAnchorWidth:(BOOL)flag anchorValue:(CGFloat)value font:(UIFont *)font {
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineSpacing = 2;
    
    NSMutableAttributedString *attibuteStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attibuteStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, str.length)];
    
    UILabel*label = [UILabel new];
    [label setAttributedText:attibuteStr];
    label.numberOfLines = 0;
    CGSize resultSize = [label sizeThatFits:CGSizeMake(flag?value:CGFLOAT_MAX, flag?CGFLOAT_MAX:value)];
    return resultSize;
}

@end

