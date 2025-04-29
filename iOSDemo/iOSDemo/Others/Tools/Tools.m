//
//  Tools.m
//  iOSDemo
//
//  Created by ltz on 2025/1/11.
//

#import "Tools.h"
#import <AnyThinkNative/AnyThinkNative.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>

@implementation Tools

+ (NSDictionary *)getOfferInfo:(ATNativeAdOffer *)nativeAdOffer {
    NSMutableDictionary *extraDic = [NSMutableDictionary dictionary];
    [self ATDemo_setDict:extraDic value:@(nativeAdOffer.networkFirmID) key:@"networkFirmID"];
    [self ATDemo_setDict:extraDic value:nativeAdOffer.nativeAd.title key:@"title"];
    [self ATDemo_setDict:extraDic value:nativeAdOffer.nativeAd.mainText key:@"mainText"];
    [self ATDemo_setDict:extraDic value:nativeAdOffer.nativeAd.ctaText key:@"ctaText"];
    [self ATDemo_setDict:extraDic value:nativeAdOffer.nativeAd.advertiser key:@"advertiser"];
    [self ATDemo_setDict:extraDic value:nativeAdOffer.nativeAd.videoUrl key:@"videoUrl"];
    [self ATDemo_setDict:extraDic value:nativeAdOffer.nativeAd.logoUrl key:@"logoUrl"];
    [self ATDemo_setDict:extraDic value:nativeAdOffer.nativeAd.iconUrl key:@"iconUrl"];
    [self ATDemo_setDict:extraDic value:nativeAdOffer.nativeAd.imageUrl key:@"imageUrl"];
    [self ATDemo_setDict:extraDic value:@(nativeAdOffer.nativeAd.mainImageWidth) key:@"mainImageWidth"];
    [self ATDemo_setDict:extraDic value:@(nativeAdOffer.nativeAd.mainImageHeight) key:@"mainImageHeight"];
    [self ATDemo_setDict:extraDic value:nativeAdOffer.nativeAd.imageList key:@"imageList"];
    [self ATDemo_setDict:extraDic value:@(nativeAdOffer.nativeAd.videoDuration) key:@"videoDuration"];
    [self ATDemo_setDict:extraDic value:@(nativeAdOffer.nativeAd.videoAspectRatio) key:@"videoAspectRatio"];
    [self ATDemo_setDict:extraDic value:@(nativeAdOffer.nativeAd.nativeExpressAdViewWidth) key:@"nativeExpressAdViewWidth"];
    [self ATDemo_setDict:extraDic value:@(nativeAdOffer.nativeAd.nativeExpressAdViewHeight) key:@"nativeExpressAdViewHeight"];
    [self ATDemo_setDict:extraDic value:@(nativeAdOffer.nativeAd.interactionType) key:@"interactionType"];
    [self ATDemo_setDict:extraDic value:nativeAdOffer.nativeAd.mediaExt key:@"mediaExt"];
    [self ATDemo_setDict:extraDic value:nativeAdOffer.nativeAd.source key:@"source"];
    [self ATDemo_setDict:extraDic value:nativeAdOffer.nativeAd.rating key:@"rating"];
    [self ATDemo_setDict:extraDic value:@(nativeAdOffer.nativeAd.commentNum) key:@"commentNum"];
    [self ATDemo_setDict:extraDic value:@(nativeAdOffer.nativeAd.appSize) key:@"appSize"];
    [self ATDemo_setDict:extraDic value:nativeAdOffer.nativeAd.appPrice key:@"appPrice"];
    [self ATDemo_setDict:extraDic value:@(nativeAdOffer.nativeAd.isExpressAd) key:@"isExpressAd"];
    [self ATDemo_setDict:extraDic value:@(nativeAdOffer.nativeAd.isVideoContents) key:@"isVideoContents"];
    [self ATDemo_setDict:extraDic value:nativeAdOffer.nativeAd.icon key:@"iconImage"];
    [self ATDemo_setDict:extraDic value:nativeAdOffer.nativeAd.logo key:@"logoImage"];
    [self ATDemo_setDict:extraDic value:nativeAdOffer.nativeAd.mainImage key:@"mainImage"];
    return extraDic;
}

+ (void)ATDemo_setDict:(NSMutableDictionary *)dict value:(id)value key:(NSString *)key {
    
    if ([key isKindOfClass:[NSString class]] == NO) {
        NSAssert(NO, @"key must str");
    }
    if(key != nil && [key respondsToSelector:@selector(length)] && key.length > 0){
        if ([self isEmpty:value] == NO) {
            dict[key] = value;
        }
//        if (value == nil) {
//            NSAssert(NO, @"value must not equal to nil");
//        }
    }else{
        NSAssert(NO, @"key must not equal to nil");
    }
}

+ (BOOL)isEmpty:(id)object {
    
    if (object == nil || [object isKindOfClass:[NSNull class]]) {
        return YES;
    }
     
    if ([object isKindOfClass:[NSString class]] && [(NSString *)object isEqualToString:@"(null)"]) {
        return YES;
    }
    
    if ([object respondsToSelector:@selector(length)]) {
        return [object length] == 0;
    }
    
    if ([object respondsToSelector:@selector(count)]) {
        return [object count] == 0;
    }
    return NO;
}

+ (NSString *)getIdfaString {
    NSString *idfaStr = @"";
    if (@available(iOS 14, *)) {
        ATTrackingManagerAuthorizationStatus status = ATTrackingManager.trackingAuthorizationStatus;
        if (status == ATTrackingManagerAuthorizationStatusNotDetermined) {
            return nil;
        } else if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
            idfaStr = [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString != nil ? [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString : nil;
        }
    } else {
        // Fallback on earlier versions
        idfaStr = [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString != nil ? [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString : nil;
    }
    return idfaStr;
}

/**
 * 检查输入的控制器是否有push或present出来的控制器，并返回当前显示的控制器
 * @param viewController 需要检查的视图控制器
 * @return UIViewController* 如果有push或present出的控制器，则返回该控制器；否则返回nil
 */
+ (UIViewController *)getVisibleChildViewController:(UIViewController *)viewController {
    // 1. 首先检查是否有presentedViewController
    if (viewController.presentedViewController) {
        // 递归查找最终显示的控制器
        return [self findFinalVisibleViewController:viewController.presentedViewController];
    }
    
    // 2. 检查是否有push出来的控制器
    if (viewController.navigationController) {
        NSArray *viewControllers = viewController.navigationController.viewControllers;
        NSInteger index = [viewControllers indexOfObject:viewController];
        
        // 确保该控制器在导航栈中且不是栈顶控制器
        if (index != NSNotFound && index < viewControllers.count - 1) {
            // 获取栈顶控制器
            UIViewController *topVC = [viewControllers lastObject];
            // 递归检查栈顶控制器是否有present出来的控制器
            return [self findFinalVisibleViewController:topVC];
        }
    }
    
    // 3. 如果控制器是容器控制器，检查其子控制器
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabController = (UITabBarController *)viewController;
        UIViewController *selectedVC = tabController.selectedViewController;
        if (selectedVC) {
            // 递归检查选中的标签页控制器
            return [self getVisibleChildViewController:selectedVC];
        }
    } else if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = (UINavigationController *)viewController;
        UIViewController *visibleVC = navController.visibleViewController;
        if (visibleVC && visibleVC != viewController) {
            // 递归检查可见的导航控制器子控制器
            return [self getVisibleChildViewController:visibleVC];
        }
    } else if ([viewController isKindOfClass:[UISplitViewController class]]) {
        UISplitViewController *splitVC = (UISplitViewController *)viewController;
        if (splitVC.viewControllers.count > 0) {
            // 在分屏模式下，检查最后一个控制器（通常是详情视图）
            UIViewController *detailVC = [splitVC.viewControllers lastObject];
            return [self getVisibleChildViewController:detailVC];
        }
    }
    
    // 没有找到子控制器，返回nil
    return nil;
}

/**
 * 递归查找最终显示的控制器
 */
+ (UIViewController *)findFinalVisibleViewController:(UIViewController *)viewController {
    if (viewController.presentedViewController) {
        return [self findFinalVisibleViewController:viewController.presentedViewController];
    }
    
    // 如果是容器控制器，查找其显示的子控制器
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = (UINavigationController *)viewController;
        return [self findFinalVisibleViewController:navController.visibleViewController];
    }
    
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabController = (UITabBarController *)viewController;
        return [self findFinalVisibleViewController:tabController.selectedViewController];
    }
    
    if ([viewController isKindOfClass:[UISplitViewController class]]) {
        UISplitViewController *splitVC = (UISplitViewController *)viewController;
        if (splitVC.viewControllers.count > 0) {
            return [self findFinalVisibleViewController:[splitVC.viewControllers lastObject]];
        }
    }
    
    return viewController;
}

/**
 * 递归查找最终显示的模态控制器
 */
+ (UIViewController *)findFinalPresentedViewController:(UIViewController *)viewController {
    if ([viewController presentedViewController]) {
        return [self findFinalPresentedViewController:[viewController presentedViewController]];
    }
    
    // 如果是UINavigationController，返回其可见的控制器
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        return [(UINavigationController *)viewController visibleViewController];
    }
    
    // 如果是UITabBarController，返回其选中的控制器
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        return [(UITabBarController *)viewController selectedViewController];
    }
    
    return viewController;
}

/**
 * 将一个控制器从当前Window切换到目标Window
 * @param viewController 需要切换的视图控制器
 * @param sourceWindow 源Window(当前显示控制器的Window)
 * @param targetWindow 目标Window
 * @param completion 完成回调
 */
+ (void)switchViewController:(UIViewController *)viewController
                 fromWindow:(UIWindow *)sourceWindow
                   toWindow:(UIWindow *)targetWindow
                 completion:(void(^)(BOOL success))completion {
    
    if (!viewController || !sourceWindow || !targetWindow) {
        if (completion) {
            completion(NO);
        }
        return;
    }
    
    // 1. 保存控制器的当前状态
    // 从父控制器中移除前，先保存相关信息
    UIViewController *parentVC = viewController.parentViewController;
    BOOL isPresentedVC = [self isViewControllerPresented:viewController];
    BOOL isInNavigationStack = viewController.navigationController != nil;
    NSInteger navigationIndex = -1;
    
    // 2. 如果控制器在导航栈中，保存其索引
    if (isInNavigationStack) {
        navigationIndex = [viewController.navigationController.viewControllers
                          indexOfObject:viewController];
    }
    
    // 3. 将控制器从当前层次结构中分离
    if (isPresentedVC) {
        // 如果是被present出来的，先dismiss它
        [viewController.presentingViewController dismissViewControllerAnimated:NO completion:^{
            [self moveControllerToTargetWindow:viewController
                                  targetWindow:targetWindow
                                    completion:completion];
        }];
    } else if (isInNavigationStack) {
        // 如果在导航栈中，从栈中移除但不触发viewDidDisappear
        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:
                                          viewController.navigationController.viewControllers];
        [viewControllers removeObject:viewController];
        [viewController.navigationController setViewControllers:viewControllers animated:NO];
        [self moveControllerToTargetWindow:viewController
                              targetWindow:targetWindow
                                completion:completion];
    } else if (parentVC) {
        // 从父控制器中移除
        [viewController willMoveToParentViewController:nil];
        [viewController.view removeFromSuperview];
        [viewController removeFromParentViewController];
        [self moveControllerToTargetWindow:viewController
                              targetWindow:targetWindow
                                completion:completion];
    } else {
        // 控制器可能是根控制器
        [self moveControllerToTargetWindow:viewController
                              targetWindow:targetWindow
                                completion:completion];
    }
}

/**
 * 将控制器移动到目标Window
 */
+ (void)moveControllerToTargetWindow:(UIViewController *)viewController
                        targetWindow:(UIWindow *)targetWindow
                          completion:(void(^)(BOOL success))completion {
    
    // 1. 确保视图控制器的视图已从旧window中分离
    [viewController.view removeFromSuperview];
    
    // 2. 设置目标Window的根控制器
    // 有两种方式：直接设置为根控制器或使用容器控制器
    
    // 方式1：如果目标Window没有根控制器或可以直接替换
    if (!targetWindow.rootViewController ||
        [targetWindow.rootViewController isKindOfClass:[UINavigationController class]]) {
        
        // 如果目标Window有一个导航控制器作为根控制器
        if ([targetWindow.rootViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navController = (UINavigationController *)targetWindow.rootViewController;
            [navController pushViewController:viewController animated:YES];
        } else {
            // 直接设置为根控制器
            targetWindow.rootViewController = viewController;
        }
        
        // 使目标Window成为keyWindow并可见
        [targetWindow makeKeyAndVisible];
        
        if (completion) {
            completion(YES);
        }
    }
    // 方式2：使用容器控制器
    else {
        // 创建一个新的容器控制器（例如导航控制器）
        UINavigationController *navController = [[UINavigationController alloc]
                                                initWithRootViewController:viewController];
        
        // 设置为根控制器
        targetWindow.rootViewController = navController;
        
        // 使目标Window成为keyWindow并可见
        [targetWindow makeKeyAndVisible];
        
        if (completion) {
            completion(YES);
        }
    }
}

/**
 * 检查一个视图控制器是否是通过present方式显示的
 */
+ (BOOL)isViewControllerPresented:(UIViewController *)viewController {
    if (viewController.presentingViewController != nil) {
        return YES;
    }
    
    if (viewController.navigationController &&
        viewController.navigationController.presentingViewController != nil) {
        return YES;
    }
    
    if (viewController.tabBarController &&
        viewController.tabBarController.presentingViewController != nil) {
        return YES;
    }
    
    return NO;
}


/// 打印原生广告素材信息
/// - Parameter nativeAdOffer: 原生广告素材offer对象
+ (void)printNativeAdOffer:(ATNativeAdOffer *)nativeAdOffer {
    ATDemoLog(@"原生广告offer(%@)素材信息:%@",nativeAdOffer,[self getOfferInfo:nativeAdOffer]);
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

@end
