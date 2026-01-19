//
//  AdCell.m
//  iOSDemo
//
//  Created by ltz on 2025/2/7.
//

#import "AdCell.h"

@interface AdCell()

@property (strong, nonatomic) UIView * bgView;

@end

@implementation AdCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        //模拟圆角背景
        self.bgView = [UIView new];
        self.bgView.layer.cornerRadius = 9;
        self.bgView.backgroundColor = UIColor.lightGrayColor;
        self.bgView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.bgView];
    }
    return self;
}
 
- (void)setAdView:(ATNativeADView *)adView {
    
    if (_adView == adView) {
        return;
    }
    
    [_adView removeFromSuperview];
    
    [self.bgView addSubview:adView];
    
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).mas_offset(15);
        make.right.mas_equalTo(self.contentView).mas_offset(-15);
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
      
    [adView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView);
        make.bottom.mas_equalTo(self.bgView.mas_bottom);
        make.height.mas_equalTo(adView.frame.size.height);
        make.width.mas_equalTo(adView.frame.size.width);
        make.centerX.mas_equalTo(self.bgView.mas_centerX);
    }];
    
    _adView = adView;
}

@end
