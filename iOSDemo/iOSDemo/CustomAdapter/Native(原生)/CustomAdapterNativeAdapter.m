//
//  CustomAdapterNativeAdapter.m
//  CustomAdapter
//
//  Created by mac on 2024/8/27.
//

#import "CustomAdapterNativeAdapter.h"
#import "CustomAdapterNativeCustomEvent.h"
#import <QuMengAdSDK/QuMengAdSDK.h>
#import "CustomAdapterNativeRenderer.h"
#import "CustomAdapterBaseManager.h"
#import "CustomAdapterNativeCustomEvent.h"
#import "CustomAdapterBiddingRequest.h"
#import "CustomAdapterC2SBiddingRequestManager.h"
#import "ATC2SBiddingNetworkC2STool_QM.h"
 
@interface CustomAdapterNativeAdapter()<QuMengNativeAdDelegate>

@property (nonatomic, strong) CustomAdapterNativeCustomEvent *customEvent;

@property (nonatomic, strong) QuMengFeedAd *feedAd; // 模板渲染

@property (nonatomic, strong) QuMengNativeAd *nativeAd; // 模板渲染

@end

@implementation CustomAdapterNativeAdapter

#pragma mark - Header bidding
#pragma mark - c2s
+ (void)bidRequestWithPlacementModel:(ATPlacementModel *)placementModel unitGroupModel:(ATUnitGroupModel *)unitGroupModel info:(NSDictionary *)info completion:(void(^)(ATBidInfo *bidInfo, NSError *error))completion {
    [CustomAdapterBaseManager initWithCustomInfo:info localInfo:info];
    
    CustomAdapterNativeCustomEvent *customEvent = [[CustomAdapterNativeCustomEvent alloc] initWithInfo:info localInfo:info];
    customEvent.isC2SBiding = YES;
    CustomAdapterBiddingRequest *request = [[CustomAdapterBiddingRequest alloc] init];
    request.customEvent = customEvent;
    request.unitGroup = unitGroupModel;
    request.placementID = placementModel.placementID;
    request.bidCompletion = completion;
    request.unitID = [NSString stringWithFormat:@"%@", info[@"adslot_id"]];
    request.extraInfo = info;
    request.adType = ATAdFormatNative;
    [[CustomAdapterC2SBiddingRequestManager sharedInstance] startWithRequestItem:request];
}

- (instancetype)initWithNetworkCustomInfo:(NSDictionary *)serverInfo localInfo:(NSDictionary *)localInfo {
    self = [super init];
    if (self != nil) {
    // TODO: add some code for initialize Network SDK
        [CustomAdapterBaseManager initWithCustomInfo:serverInfo localInfo:localInfo];
    }
    return self;
}

- (void)loadADWithInfo:(NSDictionary *)serverInfo localInfo:(NSDictionary *)localInfo completion:(void (^)(NSArray *, NSError *))completion {
    
    [[ATGCDQueue_QM mainQueue] queueAsyncBlock:^{
        NSString *bidId = serverInfo[kATAdapterCustomInfoBuyeruIdKey];
        NSInteger layoutType = [serverInfo[@"unit_type"] integerValue];// 渲染方式 1:模板渲染 0 自渲染

        if (bidId) {// c2s
            if (layoutType == 1) {// 模板渲染
                [self loadAdC2SNativeExpressAdWithInfo:serverInfo localInfo:localInfo completion:completion];
            } else if (layoutType == 0) {// 自渲染
                [self loadAdC2SNativeManualRenderAdWithInfo:serverInfo localInfo:localInfo completion:completion];
            }
        } else {// 常规
            if (layoutType == 1) {// 模板渲染
                [self loadAdNativeExpressAdWithInfo:serverInfo localInfo:localInfo completion:completion];
            } else if (layoutType == 0) {// 自渲染
                [self loadAdNativeManualRenderAdWithInfo:serverInfo localInfo:localInfo completion:completion];
            }
        }
    }];    
}

// 模板渲染
- (void)loadAdNativeExpressAdWithInfo:(NSDictionary *)serverInfo localInfo:(NSDictionary *)localInfo completion:(void (^)(NSArray *, NSError *))completion {
    
    self.customEvent = [[CustomAdapterNativeCustomEvent alloc] initWithInfo:serverInfo localInfo:localInfo];
    self.customEvent.requestCompletionBlock = completion;
    self.feedAd = [[QuMengFeedAd alloc] initWithSlot:serverInfo[@"adslot_id"]];
    self.feedAd.delegate = self.customEvent;
    [self.feedAd loadAdData];

}

// 自渲染
- (void)loadAdNativeManualRenderAdWithInfo:(NSDictionary *)serverInfo localInfo:(NSDictionary *)localInfo completion:(void (^)(NSArray *, NSError *))completion {
    
    self.customEvent = [[CustomAdapterNativeCustomEvent alloc] initWithInfo:serverInfo localInfo:localInfo];
    self.customEvent.requestCompletionBlock = completion;
    
    self.nativeAd = [[QuMengNativeAd alloc] initWithSlot:serverInfo[@"adslot_id"]];
    self.nativeAd.delegate = self.customEvent;
    [self.nativeAd loadAdData];

}

// 模板渲染c2s
- (void)loadAdC2SNativeExpressAdWithInfo:(NSDictionary *)serverInfo localInfo:(NSDictionary *)localInfo completion:(void (^)(NSArray *, NSError *))completion {
    
    CustomAdapterBiddingRequest *request = [[ATC2SBiddingNetworkC2STool_QM sharedInstance] getRequestItemWithUnitID:serverInfo[@"adslot_id"]];

    if (request != nil) {
        self.customEvent = (CustomAdapterNativeCustomEvent*)request.customEvent;
        self.customEvent.requestCompletionBlock = completion;
        self.feedAd = request.customObject;
        
//        ATSafeThreadDictionary_QM *asset = self.customEvent.adAsset;
        ATSafeThreadDictionary_QM *assetTemp = [[ATSafeThreadDictionary_QM alloc] initWithDictionary:self.customEvent.adAsset];
        ATSafeThreadArray_QM *adAssets = [[ATSafeThreadArray_QM alloc] init];
        if (assetTemp) {
            [adAssets addObject:assetTemp];
        }

        [self.customEvent trackNativeAdLoaded:adAssets];
        
        // 置空 避免 循环引用 后续改进
        [self.customEvent.adAsset removeAllObjects];
        self.customEvent.adAsset = nil;
        
    }
    [[ATC2SBiddingNetworkC2STool_QM sharedInstance] removeRequestItemWithUnitID:serverInfo[@"adslot_id"]];
}

// 自渲染c2s
- (void)loadAdC2SNativeManualRenderAdWithInfo:(NSDictionary *)serverInfo localInfo:(NSDictionary *)localInfo completion:(void (^)(NSArray *, NSError *))completion {
    
    CustomAdapterBiddingRequest *request = [[ATC2SBiddingNetworkC2STool_QM sharedInstance] getRequestItemWithUnitID:serverInfo[@"adslot_id"]];

    if (request != nil) {
        self.customEvent = (CustomAdapterNativeCustomEvent*)request.customEvent;
        self.customEvent.requestCompletionBlock = completion;
        self.nativeAd = request.customObject;

//        ATSafeThreadDictionary_QM *asset = self.customEvent.adAsset;
        ATSafeThreadDictionary_QM *assetTemp = [[ATSafeThreadDictionary_QM alloc] initWithDictionary:self.customEvent.adAsset];
        ATSafeThreadArray_QM *adAssets = [[ATSafeThreadArray_QM alloc] init];
        if (assetTemp) {
            [adAssets addObject:assetTemp];
        }
        [self.customEvent trackNativeAdLoaded:adAssets];
        // 置空 避免 循环引用 后续改进
        [self.customEvent.adAsset removeAllObjects];
        self.customEvent.adAsset = nil;
    }
    [[ATC2SBiddingNetworkC2STool_QM sharedInstance] removeRequestItemWithUnitID:serverInfo[@"adslot_id"]];

}
 
+ (Class)rendererClass {
    return [CustomAdapterNativeRenderer class];
}

@end
