//
//  BaseNormalBarVC.m
//  AnyThinkSDKDemo
//
//  Created by ltz on 2025/7/3.
//

#import "BaseNormalBarVC.h"

@interface BaseNormalBarVC ()

@end

@implementation BaseNormalBarVC

#pragma mark - Demo Needed (No need to integrate)
- (void)viewDidLoad {
    [super viewDidLoad];
     
    [self setupDemoUI];
}

- (void)setupDemoUI {
    [self addNormalBarWithTitle:self.title];
    [self addLogTextView];
    [self addFootView];
}

@end
