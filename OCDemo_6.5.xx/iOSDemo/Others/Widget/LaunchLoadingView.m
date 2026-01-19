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
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, assign) NSInteger seconds;
@property (nonatomic, strong) dispatch_queue_t timerQueue;

@end

@implementation LaunchLoadingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 创建专用的串行队列用于计时器
        self.timerQueue = dispatch_queue_create("com.launchloadingview.timer", DISPATCH_QUEUE_SERIAL);
        
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
    // 先停止之前的计时器
    [self stopTimer];
    
    // 重置计时器
    self.seconds = 0;
    
    // 在主线程更新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        self.timerLabel.text = [NSString stringWithFormat:@"%@ 00:00 ,%@:%d",kLocalizeStr(@"当前"),kLocalizeStr(@"总超时时间"),FirstAppOpen_Timeout];
    });

    // 创建高精度计时器
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.timerQueue);
    
    if (self.timer) {
        // 设置计时器：立即开始，每1秒触发一次，允许0.1秒的误差
        dispatch_source_set_timer(self.timer, 
                                 dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), 
                                 1.0 * NSEC_PER_SEC, 
                                 0.1 * NSEC_PER_SEC);
        
        // 设置计时器事件处理
        __weak typeof(self) weakSelf = self;
        dispatch_source_set_event_handler(self.timer, ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf updateTimer];
            }
        });
        
        // 启动计时器
        dispatch_resume(self.timer);
    }
}

- (void)updateTimer {
    self.seconds++;
    NSInteger minutes = self.seconds / 60;
    NSInteger remainingSeconds = self.seconds % 60;
    
    // 确保UI更新在主线程执行
    dispatch_async(dispatch_get_main_queue(), ^{
        self.timerLabel.text = [NSString stringWithFormat:@"%@ %02ld:%02ld ,%@:%d",kLocalizeStr(@"当前") ,(long)minutes, (long)remainingSeconds,kLocalizeStr(@"总超时时间"),FirstAppOpen_Timeout];
    });
}

- (void)stopTimer {
    if (self.timer) {
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
}

- (void)dismiss {
    // 停止计时器
    [self stopTimer];
    
    [self removeFromSuperview]; // 从父视图中移除
}

- (void)dealloc {
    // 确保在对象销毁时停止计时器
    [self stopTimer];
}

@end
