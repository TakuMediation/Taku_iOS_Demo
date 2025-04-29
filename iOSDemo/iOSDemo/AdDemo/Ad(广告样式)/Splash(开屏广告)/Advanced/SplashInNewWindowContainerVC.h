//
//  SplashInNewWindowContainerVC.h
//  iOSDemo
//
//  Created by ltz on 2025/2/28.
//

#import <UIKit/UIKit.h>
 
//开屏专用Window的根视图控制器
@interface SplashInNewWindowContainerVC : UIViewController
 
/// 用户点击了广告标记，通过splashDidClickForPlacementID回调标记
@property (assign, nonatomic) BOOL isUserClickAd;
 
- (void)enterHome;

@end
 
