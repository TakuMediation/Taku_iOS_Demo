//
//  PPVC.h
//  iOSDemo
//
//  Created by Developer on 2024.
//  Copyright © 2024 AnyThink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
 
/**
 * 隐私政策视图控制器
 * 用于首次启动时展示隐私政策页面
 */
@interface PPVC : UIViewController

/**
 * 展示隐私政策页面的类方法
 * @param agreementCallback 用户点击同意按钮的回调
 */
+ (void)showPrivacyPolicyWithAgreementCallback:(void(^)(void))agreementCallback;

@end
