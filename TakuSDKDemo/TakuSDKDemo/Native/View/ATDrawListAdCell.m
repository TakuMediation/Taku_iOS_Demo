//
//  ATDrawListAdCell.m
//  TakuSDKDemo
//
//  Created by Taku on 7/26/22.
//  Copyright © 2022 抽筋的灯. All rights reserved.
//

#import "ATDrawListAdCell.h"

@implementation ATDrawListAdCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setDrawAdView:(ATNativeADView *)drawAdView {
    if (_drawAdView == drawAdView) {
        return;
    }
    [_drawAdView removeFromSuperview];
    
    [self.contentView addSubview:drawAdView];
    [drawAdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self);
    }];
    _drawAdView = drawAdView;
}

@end
