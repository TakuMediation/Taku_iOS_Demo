//
//  NaviBarView.m
//  iOSDemo
//
//  Created by ltz on 2025/1/5.
//

#import "NaviBarView.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>
#import <AnyThinkSDK/ATAPI.h>

@interface NaviBarView()
 
@end

@implementation NaviBarView

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

        self.logoImgView = [UIImageView new];
        self.logoImgView.image = kImg(@"logo");
        [self addSubview:self.logoImgView];
        
        [self.logoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).mas_offset(kAdaptH(132, 132));
            make.width.mas_equalTo(kAdaptH(64, 64));
            make.height.mas_equalTo(kAdaptH(64, 64));
            make.left.mas_equalTo(self.mas_left).mas_offset(kAdaptW(32, 32));
        }];
        
        self.titleLbl = [UILabel new];
        self.titleLbl.text = @"Taku SDK Demo";//kLocalizeStr(@"Taku SDK Demo");
        self.titleLbl.textColor = kHexColor(0x1F2126);
        self.titleLbl.font = [UIFont boldSystemFontOfSize:18];
        self.titleLbl.textAlignment = NSTextAlignmentCenter;
        self.titleLbl.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.titleLbl];
        
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.logoImgView.mas_centerY);
            make.left.mas_equalTo(self.logoImgView.mas_right).mas_offset(10);
            make.height.mas_equalTo(self.titleLbl.font.lineHeight);
        }];
        
        self.versionLbl = [UILabel new];
        self.versionLbl.text = [NSString stringWithFormat:@"%@",[[ATAPI sharedInstance] version]];
        self.versionLbl.textColor = kHexColor(0x8B94A3);
        self.versionLbl.font = [UIFont systemFontOfSize:12];
        self.versionLbl.textAlignment = NSTextAlignmentCenter;
        self.versionLbl.layer.borderColor = kHexColor(0x8B94A3).CGColor;
        self.versionLbl.layer.borderWidth = .5;
        self.versionLbl.layer.cornerRadius = 5;
        [self addSubview:self.versionLbl];
        
        [self.versionLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.titleLbl.mas_centerY);
            make.left.mas_equalTo(self.titleLbl.mas_right).mas_offset(10);
            make.height.mas_equalTo(self.titleLbl);
            make.width.mas_equalTo(kAdaptW(131, 131));
        }];
        
        self.idfaLbl = [UILabel new];
        self.idfaLbl.text = [NSString stringWithFormat:@"IDFA:%@",[self advertisingIdentifier]];
        self.idfaLbl.textColor = kHexColor(0x8B94A3);
        self.idfaLbl.font = [UIFont systemFontOfSize:12];
//        self.versionLbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.idfaLbl];
        
        [self.idfaLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.logoImgView.mas_bottom);
            make.right.bottom.mas_equalTo(self);
            make.left.mas_equalTo(self.logoImgView);
        }];
 
        @WeakObj(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @StrongObj(self);
            self.idfaLbl.text = [NSString stringWithFormat:@"IDFA:%@",[self advertisingIdentifier]];
        });
    }
    return self;
}

- (NSString *)advertisingIdentifier {
    if (@available(iOS 14, *)) {
        ATTrackingManagerAuthorizationStatus status = ATTrackingManager.trackingAuthorizationStatus;
        if (status == ATTrackingManagerAuthorizationStatusNotDetermined) {
            return @"";
        } else if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
            return [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString != nil ? [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString : @"";
        }
    } else {
        // Fallback on earlier versions
        return [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString != nil ? [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString : @"";
    }
    return @"";
}

@end
