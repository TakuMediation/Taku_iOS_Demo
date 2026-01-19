//
//  SDKMacros.h
//  iOSDemo
//
//  Created by ltz on 2025/1/5.
//

#ifndef SDKMacros_h
#define SDKMacros_h
 
#define DemoLogAccess(l) ({\
    BOOL isOpenLog = l==0?NO:YES; \
    [[NSUserDefaults standardUserDefaults] setBool:isOpenLog forKey:@"iOSDemoLogSw"]; \
})

#define ATDemoLog(FORMAT, ...) {\
NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];\
[dateFormatter setDateStyle:NSDateFormatterMediumStyle];\
[dateFormatter setTimeStyle:NSDateFormatterShortStyle];\
NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];\
[dateFormatter setTimeZone:timeZone];\
[dateFormatter setDateFormat:@"HH:mm:ss.SSSSSSZ"];\
NSString *str = [dateFormatter stringFromDate:[NSDate date]];\
if ([[NSUserDefaults standardUserDefaults] boolForKey:@"iOSDemoLogSw"])\
fprintf(stderr,"[iOSDemo]--TIME：%s[FILE：%s--LINE：%d]FUNCTION：%s\n%s\n",[str UTF8String],[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__,__PRETTY_FUNCTION__,[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);\
}

// ===============    ===============
// =============== UI ===============
// ===============    ===============
  
#define kImg(a) [UIImage imageNamed:a]

#define isiPAD ({\
    BOOL isiPAD = NO; \
    isiPAD = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad); \
    isiPAD; \
})

// size
#define kUIRefereWidth  (isiPAD?804.f:804.f)  // 手机参考宽度
#define kUIRefereHeight (isiPAD?1748.f:1748.f)  // 手机参考高度

#define kNavigationBarHeight ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown ? ([[UIApplication sharedApplication]statusBarFrame].size.height + 44) : ([[UIApplication sharedApplication]statusBarFrame].size.height - 4))

#define kOrientationScreenWidth ({\
    CGFloat w = 0.f; \
    if ([[UIScreen mainScreen] bounds].size.width>[[UIScreen mainScreen] bounds].size.height) { \
        w = [[UIScreen mainScreen] bounds].size.height;\
    } else { \
        w = [[UIScreen mainScreen] bounds].size.width;\
    }\
    w; \
})

#define kOrientationScreenHeight ({\
    CGFloat h = 0.f; \
    if ([[UIScreen mainScreen] bounds].size.width>[[UIScreen mainScreen] bounds].size.height) { \
        h = [[UIScreen mainScreen] bounds].size.width;\
    } else { \
        h = [[UIScreen mainScreen] bounds].size.height;\
    }\
    h; \
})

//  (设计图的值/设计图屏幕尺寸) * 当前屏幕尺寸 = 返回的值
#define kAdaptX(x,padx) (((isiPAD?padx:x)/kUIRefereWidth)*kOrientationScreenWidth)
#define kAdaptY(y,pady) (((isiPAD?pady:y)/kUIRefereHeight)*kOrientationScreenHeight)

#define kAdaptW(w,padw) (((isiPAD?padw:w)/kUIRefereWidth)*kOrientationScreenWidth)
#define kAdaptH(h,padh) (((isiPAD?padh:h)/kUIRefereHeight)*kOrientationScreenHeight)

#define kAdaptFont(s) (((s)/kUIRefereWidth)*kOrientationScreenWidth)

#define kScreenW ([UIScreen mainScreen].bounds.size.width)
#define kScreenH ([UIScreen mainScreen].bounds.size.height)

//colors
#define kHexColorAlpha(rgbValue,a)   [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]
#define kHexColor(rgbValue)          [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define kRGBColor(r, g, b)             [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
#define kRGBColorAlpha(r, g, b, a)     [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]
// rbg颜色
#define kRGB(r, g, b) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

//#define kScreenScaleString ({\
//    NSString * scale = @"";\
//    if ([UIScreen mainScreen].scale == 1) { \
//        scale = @"";\
//    } \
//    if ([UIScreen mainScreen].scale == 2) { \
//        scale = @"@2x";\
//    } \
//    if ([UIScreen mainScreen].scale == 3) { \
//        scale = @"@3x";\
//    } \
//    scale; \
//})

#define kScreenScaleString ({\
    NSString * scale = @"";\
    scale; \
})

#define isHaveSafeArea ({\
    BOOL isBangsScreen = NO; \
    if (@available(iOS 11.0, *)) { \
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject]; \
    isBangsScreen = window.safeAreaInsets.bottom > 0; \
    } \
    isBangsScreen; \
})

#define TopSafeAreaHeight ({\
    CGFloat height = 0.f; \
    if (@available(iOS 11.0, *)) { \
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject]; \
    height = window.safeAreaInsets.top; \
    } \
    height; \
})

#define BottomSafeAreaHeight ({\
    CGFloat height = 0.f; \
    if (@available(iOS 11.0, *)) { \
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject]; \
    height = window.safeAreaInsets.bottom; \
    } \
    height; \
})

#define LeftSafeAreaWidth ({\
    CGFloat width = 0.f; \
    if (@available(iOS 11.0, *)) { \
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject]; \
    width = window.safeAreaInsets.left; \
    } \
    width; \
})

#define RightSafeAreaWidth ({\
    CGFloat width = 0.f; \
    if (@available(iOS 11.0, *)) { \
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject]; \
    width = window.safeAreaInsets.right; \
    } \
    width; \
})

#define kStatusBarHeight ({\
    CGFloat height = 0.f; \
    if (@available(iOS 13.0, *)) { \
    height = [UIApplication sharedApplication].keyWindow.windowScene.statusBarManager.statusBarFrame.size.height; \
    } else { \
    height = [[UIApplication sharedApplication] statusBarFrame].size.height; \
    } \
    height; \
})

// ===============       ===============
// =============== Tools ===============
// ===============       ===============
#define WeakObj(o) try{}@finally{} __weak typeof(o) o##Weak = o;
#define StrongObj(o) autoreleasepool{} __strong typeof(o) o = o##Weak;
#define kUserDefaults [NSUserDefaults standardUserDefaults]
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
#define kTrimStrSpace(str) [str stringByReplacingOccurrencesOfString:@" " withString:@""]

#endif /* SDKMacros_h */
