//
//  LaunchLoadingView.m
//  iOSDemo
//
//  Created by ltz on 2025/1/18.
//

#import "LaunchLoadingView.h"
#import "AdSDKManager.h"

@interface LaunchLoadingView()

@property (nonatomic, strong) UILabel *timerLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger seconds;

@end

@implementation LaunchLoadingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 设置背景色为透明或者其他颜色
        self.backgroundColor = [UIColor whiteColor]; // 半透明黑色，根据需求调整
        
        // 创建并设置logo ImageView
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.translatesAutoresizingMaskIntoConstraints = NO; // 使用Auto Layout布局
        
        // 将ImageView添加到自定义视图上
        [self addSubview:imageView];
        
        // 创建计时器标签
        self.timerLabel = [[UILabel alloc] init];
        self.timerLabel.textAlignment = NSTextAlignmentCenter;
        self.timerLabel.textColor = [UIColor blackColor];
        self.timerLabel.font = [UIFont systemFontOfSize:16];
        self.timerLabel.text = @"";
        self.timerLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.timerLabel];
        
        // 居中约束
        NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
        
        // 计时器标签约束
        NSLayoutConstraint *labelCenterXConstraint = [NSLayoutConstraint constraintWithItem:self.timerLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        NSLayoutConstraint *labelTopConstraint = [NSLayoutConstraint constraintWithItem:self.timerLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeBottom multiplier:1 constant:20]; // logo下方20点
        
        // 激活约束
        [NSLayoutConstraint activateConstraints:@[centerXConstraint, centerYConstraint, labelCenterXConstraint, labelTopConstraint]];
    }
    return self;
}

- (void)show {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
     
    UIViewController *rootViewController = keyWindow.rootViewController;
    [rootViewController.view addSubview:self];
    
    self.frame = keyWindow.bounds; // 确保填满整个屏幕
}

- (void)startTimer {
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    // 重置计时器
    self.seconds = 0;
    self.timerLabel.text = [NSString stringWithFormat:@"%@ 00:00 ,%@:%d",kLocalizeStr(@"当前"),kLocalizeStr(@"总超时时间"),FirstAppOpen_Timeout];

    // 启动计时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
}

- (void)updateTimer {
    self.seconds++;
    NSInteger minutes = self.seconds / 60;
    NSInteger remainingSeconds = self.seconds % 60;
    self.timerLabel.text = [NSString stringWithFormat:@"%@ %02ld:%02ld ,%@:%d",kLocalizeStr(@"当前") ,(long)minutes, (long)remainingSeconds,kLocalizeStr(@"总超时时间"),FirstAppOpen_Timeout];
}

- (void)dismiss {
    // 如果有需要清理的资源或者引用，在这里进行
    // 停止计时器
    [self.timer invalidate];
    self.timer = nil;
    
    [self removeFromSuperview]; // 从父视图中移除
}

@end
