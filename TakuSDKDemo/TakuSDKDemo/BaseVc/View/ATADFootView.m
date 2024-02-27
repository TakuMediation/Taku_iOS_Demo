//
//  ATADFootView.m
//  AnyThingSDKDemo
//
//  Created by mac on 2021/12/6.
//

#import "ATADFootView.h"

@interface ATADFootView()

@end

@implementation ATADFootView

- (instancetype)initWithRemoveBtn
{
    if (self = [super init]) {
        [self setupUIWithRemovebtn:YES];
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self setupUIWithRemovebtn:NO];
    }
    return self;
}

- (void)setupUIWithRemovebtn:(BOOL)haveRemove
{
    [self addSubview:self.loadBtn];
    [self addSubview:self.readyBtn];
    [self addSubview:self.showBtn];
    if (haveRemove) {
        [self addSubview:self.removeBtn];
    }
}

- (void)layoutSubviews
{
    [self.loadBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kScaleW(26));
        make.right.equalTo(self.mas_right).offset(kScaleW(-26));
        make.height.mas_equalTo(kScaleW(90));
        make.top.equalTo(self.mas_top).offset(kScaleW(10));
    }];
    
    [self.readyBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kScaleW(26));
        make.right.equalTo(self.mas_right).offset(kScaleW(-26));
        make.height.mas_equalTo(kScaleW(90));
        make.top.equalTo(self.loadBtn.mas_bottom).offset(kScaleW(20));
    }];
    
    if (self.removeBtn && self.removeBtn.superview) {
        [self.showBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(kScaleW(26));
            make.width.mas_equalTo((kScreenW - kScaleW(26 * 3)) / 2);
            make.height.mas_equalTo(kScaleW(90));
            make.top.equalTo(self.readyBtn.mas_bottom).offset(kScaleW(20));
        }];
        
        [self.removeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.showBtn.mas_right).offset(kScaleW(26));
            make.right.equalTo(self.mas_right).offset(kScaleW(-26));
            make.height.mas_equalTo(kScaleW(90));
            make.top.equalTo(self.showBtn.mas_top);
        }];
    } else {
        [self.showBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(kScaleW(26));
            make.right.equalTo(self.mas_right).offset(kScaleW(-26));
            make.height.mas_equalTo(kScaleW(90));
            make.top.equalTo(self.readyBtn.mas_bottom).offset(kScaleW(20));
        }];
    }
}

#pragma mark - Action
- (void)clickLoadBtn
{
    if (self.clickLoadBlock) {
        self.clickLoadBlock();
    }
}

- (void)clickReadyBtn
{
    if (self.clickReadyBlock) {
        self.clickReadyBlock();
    }
}

- (void)clickShowBtn
{
    if (self.clickShowBlock) {
        self.clickShowBlock();
    }
}

- (void)clickRemoveBtn
{
    if (self.clickRemoveBlock) {
        self.clickRemoveBlock();
    }
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - lazy
- (UIButton *)loadBtn
{
    if (!_loadBtn) {
        _loadBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScaleW(26), kScaleW(10), kScreenW - kScaleW(52), kScaleW(90))];
        _loadBtn.layer.masksToBounds = YES;
        _loadBtn.layer.cornerRadius = 5;
        [_loadBtn setTitle:@"Load" forState:UIControlStateNormal];
        _loadBtn.layer.borderColor = kRGB(73, 109, 255).CGColor;
        _loadBtn.layer.borderWidth = kScaleW(3);
        [_loadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_loadBtn setTitleColor:kRGB(73, 109, 255) forState:UIControlStateNormal];
        [_loadBtn setBackgroundImage:[self imageWithColor:kRGB(73, 109, 255)] forState:UIControlStateHighlighted];
        [_loadBtn setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_loadBtn addTarget:self action:@selector(clickLoadBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loadBtn;
}

- (UIButton *)readyBtn
{
    if (!_readyBtn) {
        _readyBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScaleW(26), kScaleW(120), kScreenW - kScaleW(52), kScaleW(90))];
        _readyBtn.layer.masksToBounds = YES;
        _readyBtn.layer.cornerRadius = 5;
        [_readyBtn setTitle:@"Is Ready?" forState:UIControlStateNormal];
        _readyBtn.layer.borderColor = kRGB(73, 109, 255).CGColor;
        _readyBtn.layer.borderWidth = kScaleW(3);
        [_readyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_readyBtn setTitleColor:kRGB(73, 109, 255) forState:UIControlStateNormal];
        [_readyBtn setBackgroundImage:[self imageWithColor:kRGB(73, 109, 255)] forState:UIControlStateHighlighted];
        [_readyBtn setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_readyBtn addTarget:self action:@selector(clickReadyBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _readyBtn;
}

- (UIButton *)showBtn
{
    if (!_showBtn) {
        _showBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScaleW(26), kScaleW(230), (kScreenW - kScaleW(26 * 3)) / 2, kScaleW(90))];
        _showBtn.layer.masksToBounds = YES;
        _showBtn.layer.cornerRadius = 5;
        [_showBtn setTitle:@"Show" forState:UIControlStateNormal];
        _showBtn.layer.borderColor = kRGB(73, 109, 255).CGColor;
        _showBtn.layer.borderWidth = kScaleW(3);
        [_showBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_showBtn setTitleColor:kRGB(73, 109, 255) forState:UIControlStateNormal];
        [_showBtn setBackgroundImage:[self imageWithColor:kRGB(73, 109, 255)] forState:UIControlStateHighlighted];
        [_showBtn setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_showBtn addTarget:self action:@selector(clickShowBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showBtn;
}

- (UIButton *)removeBtn
{
    if (!_removeBtn) {
        _removeBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScaleW(26 * 2) + (kScreenW - kScaleW(26 * 3)) / 2, kScaleW(230), (kScreenW - kScaleW(26 * 3)) / 2, kScaleW(90))];
        _removeBtn.layer.masksToBounds = YES;
        _removeBtn.layer.cornerRadius = 5;
        [_removeBtn setTitle:@"Remove" forState:UIControlStateNormal];
        _removeBtn.layer.borderColor = kRGB(73, 109, 255).CGColor;
        _removeBtn.layer.borderWidth = kScaleW(3);
        [_removeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_removeBtn setTitleColor:kRGB(73, 109, 255) forState:UIControlStateNormal];
        [_removeBtn setBackgroundImage:[self imageWithColor:kRGB(73, 109, 255)] forState:UIControlStateHighlighted];
        [_removeBtn setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        
        [_removeBtn addTarget:self action:@selector(clickRemoveBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _removeBtn;
}

@end
