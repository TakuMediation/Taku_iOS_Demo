//
//  PPVC.h
//  iOSDemo
//
//  Created by Developer on 2024.
//  Copyright © 2024 AnyThink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 隐私政策和SDK管理视图控制器
 * 用于首次启动时展示SDK初始化选项和隐私政策页面
 */
@interface PPVC : UIViewController <UITableViewDataSource, UITableViewDelegate>

/**
 * 展示SDK管理页面的类方法
 * @param agreementCallback 用户完成SDK初始化后的回调
 */
+ (void)showSDKManagementWithAgreementCallback:(void(^)(void))agreementCallback;

@end

NS_ASSUME_NONNULL_END
