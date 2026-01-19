//
//  DemoCustomInitAdapter.m
//  AnyThinkSDKDemo
//
//  Created by ltz on 2025/7/21.
//

#import "DemoCustomInitAdapter.h"
#import <AdSupport/AdSupport.h>

@implementation DemoCustomInitAdapter
 
/// Init Ad SDK
/// - Parameter adInitArgument: server info
- (void)initWithInitArgument:(ATAdInitArgument *)adInitArgument {
    dispatch_async(dispatch_get_main_queue(), ^{
        //Get dashboard setting params in serverContentDic
        BOOL result = [MSAdSDK startSDKWithAppid:adInitArgument.serverContentDic[@"appId"] configBlock:^{
            BOOL state = [[ATAPI sharedInstance] getPersonalizedAdState] == ATNonpersonalizedAdStateType ? YES : NO;
            if (state) {
                [MSConfig setEnablePersonalRecommend:NO];
            } else {
                [MSConfig setEnablePersonalRecommend:YES];
            }
        }];
        if (result) {
            // notifi sdk success
            [self notificationNetworkInitSuccess];
            return;
        }
        NSError *error = [NSError errorWithDomain:@"DemoCustomInitAdapter init fail" code:-1 userInfo:@{}];
        [self notificationNetworkInitFail:error];
    });
}

#pragma mark - version
- (nullable NSString *)sdkVersion {
    return [MSAdSDK getVersionName];
}

- (nullable NSString *)adapterVersion {
    return @"2.6.4.0";
}
  
@end
