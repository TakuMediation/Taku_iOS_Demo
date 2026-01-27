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

#pragma mark - Singleton

+ (instancetype)sharedInstance {
    static LaunchLoadingView *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LaunchLoadingView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return instance;
}

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 设置背景色
        self.backgroundColor = [UIColor whiteColor];
        
        // 创建并设置logo ImageView
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        
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
        NSLayoutConstraint *labelTopConstraint = [NSLayoutConstraint constraintWithItem:self.timerLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeBottom multiplier:1 constant:20];
        
        // 激活约束
        [NSLayoutConstraint activateConstraints:@[centerXConstraint, centerYConstraint, labelCenterXConstraint, labelTopConstraint]];
    }
    return self;
}

#pragma mark - Public Methods

- (void)show {
    // 如果已经被添加到视图层级中，直接返回，避免重复添加
    if (self.superview) {
        return;
    }
    
    // 请您确保在主线程执行UI操作
    UIWindow *keyWindow = nil;
    
    // iOS 13及以上使用新API
    if (@available(iOS 13.0, *)) {
        NSArray<UIScene *> *windowScenes = [[[UIApplication sharedApplication] connectedScenes] allObjects];
        for (UIWindowScene *scene in windowScenes) {
            if ([scene isKindOfClass:[UIWindowScene class]]) {
                NSArray<UIWindow *> *windows = scene.windows;
                for (UIWindow *window in windows) {
                    if (window.isKeyWindow) {
                        keyWindow = window;
                        break;
                    }
                }
            }
            if (keyWindow) break;
        }
    }
    
    // 兼容iOS 13以下或上述方法未获取到的情况
    if (!keyWindow) {
        keyWindow = [UIApplication sharedApplication].keyWindow;
    }
    
    // 最后的兼容方案：尝试获取第一个window
    if (!keyWindow) {
        keyWindow = [[UIApplication sharedApplication].windows firstObject];
    }
    
    if (!keyWindow) {
        NSLog(@"LaunchLoadingView: Failed to get keyWindow");
        return;
    }
    
    @try {
        // 更新frame确保填满整个屏幕
        self.frame = keyWindow.bounds;
        
        // 添加到window上，确保在最顶层
        [keyWindow addSubview:self];
        [keyWindow bringSubviewToFront:self];
         
        NSLog(@"LaunchLoadingView: Successfully added to window");
    } @catch (NSException *exception) {
        // 捕获异常，记录日志
        NSLog(@"LaunchLoadingView show exception: %@", exception);
    }
    
    [self startTimer];
}

- (void)dismiss {
    // 先停止计时器，避免继续触发
    [self stopTimer];
    
    // 请您确保在主线程执行UI操作
    if (!self.superview) {
        return;
    }
    
    @try {
        // 兼容性处理：先从父视图移除
        [self removeFromSuperview];
        UIWindow *currentWindow = self.window;
        if (currentWindow && [currentWindow.subviews containsObject:self]) {
            [self removeFromSuperview];
        }
        
    } @catch (NSException *exception) {
        // 捕获异常，记录日志但不影响程序运行
        NSLog(@"LaunchLoadingView dismiss exception: %@", exception);
    }
}

- (void)startTimer {
    // 先停止之前的计时器
    [self stopTimer];
    
    // 重置计时器
    self.seconds = 0;
    
    // 更新UI显示初始时间
    self.timerLabel.text = [NSString stringWithFormat:@"%@ 00:00 ,%@:%d",
                            kLocalizeStr(@"当前"),
                            kLocalizeStr(@"总超时时间"),
                            FirstAppOpen_Timeout];
    
    // 创建NSTimer并添加到主线程的RunLoop中
    // 使用scheduledTimerWithTimeInterval在主线程创建定时器
    // NSRunLoopCommonModes确保在滚动等操作时也能正常触发
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                 repeats:YES
                                                   block:^(NSTimer * _Nonnull timer) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf updateTimer];
        }
    }];
    
    // 将计时器添加到NSRunLoopCommonModes，确保UI操作时也能正常运行
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

#pragma mark - Private Methods

- (void)updateTimer {
    self.seconds++;
    
    // 检查是否达到超时时间
    if (self.seconds >= FirstAppOpen_Timeout) {
        // 超时了，自动移除视图
        NSLog(@"LaunchLoadingView timeout reached: %ld seconds", (long)self.seconds);
        [self dismiss];
        return;
    }
    
    NSInteger minutes = self.seconds / 60;
    NSInteger remainingSeconds = self.seconds % 60;
    
    // NSTimer已经在主线程运行，直接更新UI
    self.timerLabel.text = [NSString stringWithFormat:@"%@ %02ld:%02ld ,%@:%d",
                            kLocalizeStr(@"当前"),
                            (long)minutes,
                            (long)remainingSeconds,
                            kLocalizeStr(@"总超时时间"),
                            FirstAppOpen_Timeout];
}

- (void)stopTimer {
    if (self.timer) {
        // 确保在主线程停止计时器
        if ([NSThread isMainThread]) {
            [self.timer invalidate];
            self.timer = nil;
        } else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.timer invalidate];
                self.timer = nil;
            });
        }
    }
}

#pragma mark - Lifecycle

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    // 当视图即将从父视图移除时（newSuperview为nil），执行清理
    if (newSuperview == nil) {
        // 停止计时器
        [self stopTimer];
    }
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    // 当视图添加到新的父视图时，可以在这里做一些初始化
    if (self.superview) {
        // 确保frame正确
        if (self.window) {
            self.frame = self.window.bounds;
        }
    }
}

- (void)dealloc {
    // 确保在对象销毁时停止计时器和清理资源
    [self stopTimer];
    NSLog(@"LaunchLoadingView: dealloc called");
}

@end
