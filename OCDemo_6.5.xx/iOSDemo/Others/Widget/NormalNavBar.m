//
//  NormalNavBar.m
//  iOSDemo
//
//  Created by ltz on 2025/1/7.
//

#import "NormalNavBar.h"

@implementation NormalNavBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = UIColor.clearColor;
         
        self.bgImgView = [UIImageView new];
        self.bgImgView.backgroundColor = UIColor.redColor;
        self.bgImgView.image = kImg(@"BG");
        [self addSubview:self.bgImgView];
        
        [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];

        self.arrowImgView = [[WildClickButton alloc] init];
        [self.arrowImgView setImage:kImg(@"arrow_back") forState:0];
        [self addSubview:self.arrowImgView];
        
        [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-kAdaptH(35, 35));
            make.width.mas_equalTo(25);
            make.height.mas_equalTo(25);
            make.left.mas_equalTo(self.mas_left).mas_offset(kAdaptW(32, 32));
        }];
        
        self.titleLbl = [UILabel new]; 
        self.titleLbl.textColor = kHexColor(0x1F2126);
        self.titleLbl.font = [UIFont boldSystemFontOfSize:18];
        self.titleLbl.textAlignment = NSTextAlignmentCenter;
        self.titleLbl.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.titleLbl];
        
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.arrowImgView.mas_centerY);
            make.centerX.mas_equalTo(self);
            make.height.mas_equalTo(self.titleLbl.font.lineHeight);
        }];
    }
    return self;
}

@end
