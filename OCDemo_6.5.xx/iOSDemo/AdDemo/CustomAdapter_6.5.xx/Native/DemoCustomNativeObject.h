//
//  DemoCustomNativeObject.h
//  AnyThinkSDKDemo
//
//  Created by ltz on 2025/7/22.
//

#import <Foundation/Foundation.h>
#import "DemoCustomAdapterCommonHeader.h"

@interface DemoCustomNativeObject : ATCustomNetworkNativeAd

@property (nonatomic, strong) MSNativeFeedAdModel *feedAdModel;

@property (nonatomic, strong) id<MSFeedAdMeta> feedAdMetaad;

@end
