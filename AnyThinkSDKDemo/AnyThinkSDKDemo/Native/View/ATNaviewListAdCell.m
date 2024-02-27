//
//  ATNaviewListAdCell.m
//  AnyThinkSDKDemo
//
//  Created by GUO PENG on 2022/6/30.
//  Copyright © 2022 抽筋的灯. All rights reserved.
//

#import "ATNaviewListAdCell.h"

@interface ATNaviewListAdCell()

@end

@implementation ATNaviewListAdCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setAdView:(ATNativeADView *)adView{
    
    if (_adView == adView) {
        return;
    }
    
    [_adView removeFromSuperview];

    [self.contentView addSubview:adView];
    
    [adView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self);
    }];
    
    _adView = adView;
    
}


@end
