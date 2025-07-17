//
//  CustomAdapterNativeCustomEvent.h
//  CustomAdapter
//
//  Created by mac on 2024/8/27.
//

#import <AnyThinkNative/AnyThinkNative.h>
#import <QuMengAdSDK/QuMengAdSDK.h>
#import "ATSafeThreadDictionary_QM.h"
 
@interface CustomAdapterNativeCustomEvent : ATNativeADCustomEvent<QuMengFeedAdDelegate, QuMengNativeAdDelegate>

@property (nonatomic, strong) ATSafeThreadDictionary_QM *adAsset;

@end


