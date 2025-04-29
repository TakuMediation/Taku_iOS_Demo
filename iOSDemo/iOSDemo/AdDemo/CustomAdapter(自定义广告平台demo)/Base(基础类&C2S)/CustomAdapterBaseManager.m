//
//  CustomAdapterBaseManager.m
//  AnyThinkSDK
//
//  Created by Captain on 2024/9/12.
//  Copyright © 2024 AnyThink. All rights reserved.
//

#import "CustomAdapterBaseManager.h"
 
#import <QuMengAdSDK/QuMengAdSDK.h>
//#import "ATAdManager.h"
#import <AnyThinkSDK/ATAPI.h>

@interface CustomAdapterBaseManager ()
@property (nonatomic, strong) ATSafeThreadArray_QM *blockArray;
@property (atomic, assign) BOOL isInitSucceed;
@end


@implementation CustomAdapterBaseManager

+ (instancetype)sharedManager {
    static CustomAdapterBaseManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[CustomAdapterBaseManager alloc] init];
        sharedManager.blockArray = [ATSafeThreadArray_QM array];
    });
    return sharedManager;
}


+ (void)initWithCustomInfo:(NSDictionary *)serverInfo localInfo:(NSDictionary *)localInfo {
    if ([CustomAdapterBaseManager sharedManager].isInitSucceed) {
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self initQMSDK];
    });
}

+ (void)initQMSDK {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        QuMengAdSDKConfiguration *config = [QuMengAdSDKConfiguration shareConfiguration];
        [QuMengAdSDKManager setupSDKWith:config];
    });
}

- (NSString *)versionsString {
    return [NSString stringWithFormat:@"%@-%@",[QuMengAdSDKManager sdkVersion],[QuMengAdSDKManager shortSdkVersion]];
}

- (NSArray *)recommendVersionsArray {
    return @[@"1.3.2"];
}

@end
