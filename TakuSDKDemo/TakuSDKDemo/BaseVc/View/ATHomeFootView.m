//
//  ATHomeFootView.m
//  AnyThingSDKDemo
//
//  Created by mac on 2021/12/6.
//

#import "ATHomeFootView.h"
#import <AdSupport/AdSupport.h>
//#import "ATAPI.h"
#import <AnyThinkSDK/ATAPI.h>

@interface ATHomeFootView()

@property (nonatomic, strong) UIButton *coButton;

@property (nonatomic, strong) UILabel *versionLabel;

@end

@implementation ATHomeFootView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kRGB(245, 245, 245);
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    [self addSubview:self.coButton];
    [self addSubview:self.versionLabel];
}

- (void)layoutSubviews
{
    [self.coButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(kScaleW(20));
        make.left.equalTo(self.mas_left).offset(kScaleW(120));
        make.right.equalTo(self.mas_right).offset(kScaleW(-120));
        make.height.mas_equalTo(kScaleW(80));
    }];
}

#pragma mark - Action
- (void)clickCopy
{
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    pasteBoard.string = [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Copied" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [[self superViewController] presentViewController:alert animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}

- (UIViewController *)superViewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

#pragma mark - lazy
- (UIButton *)coButton
{
    if (!_coButton) {
        _coButton = [[UIButton alloc] initWithFrame:CGRectMake(kScaleW(120), kScaleW(20), kScreenW - kScaleW(240), kScaleW(80))];
        _coButton.backgroundColor = kRGB(158, 158, 158);
        _coButton.layer.masksToBounds = YES;
        _coButton.layer.cornerRadius = 5;
        [_coButton setTitle:[NSString stringWithFormat:@"点击复制ID：%@", [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString] forState:UIControlStateNormal];
        _coButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _coButton.titleLabel.numberOfLines = 2;
        [_coButton addTarget:self action:@selector(clickCopy) forControlEvents:UIControlEventTouchUpInside];
    }
    return _coButton;
}

- (UILabel *)versionLabel
{
    if (!_versionLabel) {
        _versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScaleW(130), kScaleW(100), kScreenW - kScaleW(240), kScaleW(40))];
        _versionLabel.text = [NSString stringWithFormat:@"%@", [[ATAPI sharedInstance] version]];
        _versionLabel.textColor = [UIColor grayColor];
        _versionLabel.font = [UIFont systemFontOfSize:16];
        _versionLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _versionLabel;
}

@end
