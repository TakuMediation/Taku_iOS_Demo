//
//  ATTMCustomSplashViewController.m
//  HeadBiddingDemo
//
//  Created by Yc on 2022/10/19.
//

#import "ATTMCustomSplashViewController.h"
#import <AnyThinkSplash/AnyThinkSplash.h>

#define kSCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define kSCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define PlacementID @"b635261028cd5d"

@interface ATTMCustomSplashViewController ()<ATSplashDelegate, ATAdLoadingDelegate>

@end

@implementation ATTMCustomSplashViewController

/*
 ❤️❤️相要使用自定义的adapter加载广告，需要将bundle ID改为：com.TianmuSDK.demo和添加pod 'TianmuSDK'依赖。
 并且CustomSplash文件夹中的各文件的.m文件加入到编译文件中。
 该模块作为示例，可能会受三方平台的API影响，请开发者根据自己想要适配的广告平台进行修改。

 ❤️❤️To use a custom adapter to load ads, change the bundle ID to com.TianmuSDK.demo and add the pod 'TianmuSDK' dependency.
 The.m files of each file in the CustomSplash folder are added to the compile file.
 As an example, this module may be affected by the API of the tripartite platform, and developers are invited to modify it according to the advertising platform they want to adapt to.
*/


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    
}

-(void)setupUI{
    
    self.title = @"Custom Splash";
    self.view.backgroundColor = kRGB(245, 245, 245);
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((kSCREEN_WIDTH - 100)/2, 100, 100, 45)];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    button.backgroundColor = [UIColor blueColor];
    [button setTitle:@"loadAd" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(loadAd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.font = [UIFont systemFontOfSize:18];
    tipLabel.textColor = [UIColor redColor];
    tipLabel.numberOfLines = 0;
    tipLabel.text = @"Please check the ATTMCustomSplashViewController.m for hints";
    [self.view addSubview:tipLabel];
    tipLabel.frame = CGRectMake(50, 200, (kSCREEN_WIDTH-100), 200);
    
}

-(void)loadAd{
    NSLog(@"%s", __FUNCTION__);
    [[ATAdManager sharedManager] loadADWithPlacementID:PlacementID extra:nil delegate:self containerView:nil];
}

-(void)showAd{
    if (![[ATAdManager sharedManager] splashReadyForPlacementID:PlacementID]) {
        return;
    }
    NSLog(@"%s", __FUNCTION__);
    UIWindow *mainWindow = nil;
    if ( @available(iOS 13.0, *) ) {
        mainWindow = [UIApplication sharedApplication].windows.firstObject;
        [mainWindow makeKeyWindow];
    }else {
        mainWindow = [UIApplication sharedApplication].keyWindow;
    }
    [[ATAdManager sharedManager] showSplashWithPlacementID:PlacementID scene:@"" window:mainWindow extra:nil delegate:self];
}

#pragma mark - ATAdLoadingDelegate
/// Callback when the successful loading of the ad
- (void)didFinishLoadingADWithPlacementID:(NSString *)placementID{
    NSLog(@"%s", __FUNCTION__);
    [self showAd];
}

/// Callback of ad loading failure
- (void)didFailToLoadADWithPlacementID:(NSString*)placementID
                                 error:(NSError*)error{
    NSLog(@"%s", __FUNCTION__);
}

/// Ad start bidding
- (void)didStartBiddingADSourceWithPlacementID:(NSString *)placementID
                                         extra:(NSDictionary*)extra{
    NSLog(@"%s", __FUNCTION__);
}

/// Ad bidding success
- (void)didFinishBiddingADSourceWithPlacementID:(NSString *)placementID
                                          extra:(NSDictionary*)extra{
    NSLog(@"%s", __FUNCTION__);
}

/// Ad bidding fail
- (void)didFailBiddingADSourceWithPlacementID:(NSString*)placementID
                                        extra:(NSDictionary*)extra
                                        error:(NSError*)error{
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark - ATSplashDelegate

/// Splash ad displayed successfully
- (void)splashDidShowForPlacementID:(NSString *)placementID
                              extra:(NSDictionary *)extra{
    NSLog(@"%s", __FUNCTION__);
}

/// Splash ad click
- (void)splashDidClickForPlacementID:(NSString *)placementID
                               extra:(NSDictionary *)extra{
    NSLog(@"%s", __FUNCTION__);
}

/// Splash ad closed
- (void)splashDidCloseForPlacementID:(NSString *)placementID
                               extra:(NSDictionary *)extra{
    NSLog(@"%s", __FUNCTION__);
}

@end
