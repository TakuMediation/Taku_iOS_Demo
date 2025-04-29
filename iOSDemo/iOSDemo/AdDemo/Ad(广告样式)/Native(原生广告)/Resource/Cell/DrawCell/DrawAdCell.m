//
//  DrawAdCell.m
//  iOSDemo
//
//  Created by ltz on 2025/2/14.
//

#import "DrawAdCell.h"

@implementation DrawAdCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setDrawAdView:(ATNativeADView *)drawAdView {
    if (_drawAdView == drawAdView) {
        return;
    }
    [_drawAdView removeFromSuperview];
    
    self.contentView.backgroundColor = UIColor.blueColor;
    drawAdView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    [self.contentView addSubview:drawAdView];
    _drawAdView = drawAdView;
}

@end
