//
//  CustomAdapterSplashCustomEvent.h
//  CustomAdapter
//
//  Created by mac on 2024/8/27.
//

#import <AnyThinkSplash/AnyThinkSplash.h>
#import <QuMengAdSDK/QuMengAdSDK.h>



@interface CustomAdapterSplashCustomEvent : ATSplashCustomEvent<QuMengSplashAdDelegate>

@property (nonatomic,weak) UIView *containerView;
@end


