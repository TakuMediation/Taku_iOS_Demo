//
//  BaseVC.m
//  iOSDemo
//
//  Created by ltz on 2025/1/6.
//

#import "BaseVC.h"
#import "TwoButtonAlertView.h"
#import "BaseTabBarController.h"
#import "BannerVC.h"

@interface BaseVC ()

 
@end

@implementation BaseVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
     
    self.view.backgroundColor = kHexColor(0xF2F3F6);
    
    // 初始化数据源
    self.dataSource = @[
        @{@"title": kLocalizeStr(@"插屏广告"), @"subtitle": kLocalizeStr(@"包含插屏和全屏广告")},
        @{@"title": kLocalizeStr(@"激励广告"), @"subtitle": kLocalizeStr(@"用户可通过观看视频广告来换取应用内奖励")},
        @{@"title": kLocalizeStr(@"开屏广告"), @"subtitle": kLocalizeStr(@"应用冷、热启动后立即显示")},
        @{@"title": kLocalizeStr(@"横幅广告"), @"subtitle": kLocalizeStr(@"灵活的格式，可以出现在应用的顶部、中部或底部")},
        @{@"title": kLocalizeStr(@"原生广告"), @"subtitle": kLocalizeStr(@"与您的原生应用代码兼容性最强的视频广告")},
        @{@"title": kLocalizeStr(@"插播广告"), @"subtitle": kLocalizeStr(@"由您控制内容视频播放，而SDK负责处理广告播放")},
        @{@"title": @"DebugUI", @"subtitle": kLocalizeStr(@"验证SDK的接入情况、测试已接入广告平台")}
    ];
}

- (void)addHomeBar {
    self.bar = [NaviBarView new];
    [self.view addSubview:self.bar];
     
    [self.bar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.height.mas_equalTo(kAdaptH(273, 273));
    }];
}

- (void)addNormalBarWithTitle:(NSString *)title {
    self.nbar = [NormalNavBar new];
    [self.view addSubview:self.nbar];
    self.nbar.titleLbl.text = title;
    [self.nbar.arrowImgView addTarget:self action:@selector(popVC) forControlEvents:UIControlEventTouchUpInside];
    [self.nbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.height.mas_equalTo(kAdaptH(228, 228));
    }];
}

- (void)popVC {
    if ([self.tabBarController isKindOfClass:[BaseTabBarController class]]) {
        BaseTabBarController * tabbar = (BaseTabBarController *)self.tabBarController;
        [tabbar.fromController popViewControllerAnimated:YES];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        [_tableView registerClass:[CustomTableViewCell class] forCellReuseIdentifier:@"CustomTableViewCellIdentifier"];
    }
    return _tableView;
}
 
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView != self.tableView) {
        return;
    }
    // 圆角角度
    CGFloat radius = 12.f;
    // 设置cell 背景色为透明
    cell.backgroundColor = UIColor.clearColor;
    // 创建两个layer
    CAShapeLayer *normalLayer = [[CAShapeLayer alloc] init];
    CAShapeLayer *selectLayer = [[CAShapeLayer alloc] init];
    // 获取显示区域大小
    CGRect bounds = CGRectInset(cell.bounds, kAdaptX(15, 15), 0);
    // cell的backgroundView
    UIView *normalBgView = [[UIView alloc] initWithFrame:bounds];
    // 获取每组行数
    NSInteger rowNum = [tableView numberOfRowsInSection:indexPath.section];
    // 贝塞尔曲线
    UIBezierPath *bezierPath = nil;
    
    if (rowNum == 1) {
        // 一组只有一行（四个角全部为圆角）
        bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
        normalBgView.clipsToBounds = NO;
    }else {
        normalBgView.clipsToBounds = YES;
        if (indexPath.row == 0) {
            normalBgView.frame = UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(-5, 0, 0, 0));
            CGRect rect = UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(5, 0, 0, 0));
            // 每组第一行（添加左上和右上的圆角）
            bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight) cornerRadii:CGSizeMake(radius, radius)];
        }else if (indexPath.row == rowNum - 1) {
            normalBgView.frame = UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 0, -5, 0));
            CGRect rect = UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 0, 5, 0));
            // 每组最后一行（添加左下和右下的圆角）
            bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(radius, radius)];
        }else {
            // 每组不是首位的行不设置圆角
            bezierPath = [UIBezierPath bezierPathWithRect:bounds];
        }
    }
    
    // 阴影
    normalLayer.shadowColor = kHexColor(0x0062FF).CGColor;
    normalLayer.shadowOpacity = 0.35;
    normalLayer.shadowOffset = CGSizeMake(0, 0);
    normalLayer.path = bezierPath.CGPath;
    normalLayer.shadowPath = bezierPath.CGPath;
    
    // 把已经绘制好的贝塞尔曲线路径赋值给图层，然后图层根据path进行图像渲染render
    normalLayer.path = bezierPath.CGPath;
    selectLayer.path = bezierPath.CGPath;
    
    // 设置填充颜色
    normalLayer.fillColor = [UIColor whiteColor].CGColor;
    // 添加图层到nomarBgView中
    [normalBgView.layer insertSublayer:normalLayer atIndex:0];
    normalBgView.backgroundColor = UIColor.clearColor;
    cell.backgroundView = normalBgView;
    
    // 替换cell点击效果
    UIView *selectBgView = [[UIView alloc] initWithFrame:bounds];
    selectLayer.fillColor = [UIColor colorWithWhite:0.95 alpha:1.0].CGColor;
    [selectBgView.layer insertSublayer:selectLayer atIndex:0];
    selectBgView.backgroundColor = UIColor.clearColor;
    cell.selectedBackgroundView = selectBgView;
}

- (void)addLogTextView {
    [self.view addSubview:self.textView];
    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        if (self.bar) {
            make.top.equalTo(self.bar.mas_bottom).offset(kAdaptH(15, 15));
        }
        else if (self.nbar) {
            make.top.equalTo(self.nbar.mas_bottom).offset(kAdaptH(15, 15));
        }else {
            make.top.mas_equalTo(self.view.mas_top).offset(kNavigationBarHeight+kAdaptH(15, 15));
        }
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(kAdaptW(740, 740));
        make.height.mas_equalTo(kAdaptH(600, 600));
    }];
}

- (void)addFootView {
    [self.view addSubview:self.footView];
    [self.footView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(kAdaptW(740, 740));
        make.height.mas_equalTo(kAdaptH(432, 432));
    }];
    @WeakObj(self)
    [self.footView setClickLoadBlock:^{
        @StrongObj(self);
        [self loadAd];
    }];
    [self.footView setClickShowBlock:^{
        @StrongObj(self);
        [self showAd];
    }];
    [self.footView setClickHidenBlock:^{
        @StrongObj(self);
        [self hiddenAdButtonClickAction];
    }];
    [self.footView setClickRemoveBlock:^{
        @StrongObj(self);
        [self removeAdButtonClickAction];
    }];
    [self.footView setClickReShowBlock:^{
        @StrongObj(self);
        [self reshowAd];
    }];
    [self.footView setClickLogBlock:^{
        @StrongObj(self);
        [self clearLog];
    }];
}

- (void)loadAd {
    
}

- (void)showAd {
    
}
 
- (void)hiddenAdButtonClickAction {
    
}

- (void)removeAdButtonClickAction {
    
}

- (void)reshowAd {
    
}

- (void)clearLog {
    TwoButtonAlertView * al =  [[TwoButtonAlertView alloc] initWithTitle:kLocalizeStr(@"温馨提示") content:kLocalizeStr(@"是否要清空日志") buttonText1:kLocalizeStr(@"否") buttonText2:kLocalizeStr(@"是")];
    @WeakObj(self);
    [al addTwoButtonAlertBlock:^(NSInteger index) {
        @StrongObj(self);
        if (index == 2) {
            self.textView.text = @"";
        }
    }];
    [al show];
}

- (void)notReadyAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ad Not Ready!" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}
 
#pragma mark - 日志
- (void)showLog:(NSString *)logStr {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *logS = self.textView.text;
        NSString *log = nil;
        if (![logS isEqualToString:@""]) {
            log = [NSString stringWithFormat:@"%@\n\n%@", logS, logStr];
        } else {
            log = [NSString stringWithFormat:@"%@", logStr];
        }
        self.textView.text = log;
        if(([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeLeft) || ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeRight)){//横屏
            return;
        }
        [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length, 1)];
    });
}

#pragma mark - lazy
- (DemoADFootView *)footView {
    if (!_footView) {
        if ([self isKindOfClass:[BannerVC class]]) {
            _footView = [[DemoADFootView alloc] initWithRemoveAndHidenBtn];
        }else {
            _footView = [[DemoADFootView alloc] init];
        }
    }
    return _footView;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.layer.masksToBounds = YES;
        _textView.layer.cornerRadius = 5;
        _textView.editable = NO;
        _textView.text = @"";
    }
    return _textView;
}


@end
