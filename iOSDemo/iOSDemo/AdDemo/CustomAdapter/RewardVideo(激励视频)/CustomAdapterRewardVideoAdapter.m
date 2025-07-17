//
//  CustomAdapterRewardVideoAdapter.m
//  CustomAdapter
//
//  Created by mac on 2024/8/26.
//

#import <AnyThinkRewardedVideo/AnyThinkRewardedVideo.h>
#import "CustomAdapterC2SBiddingRequestManager.h"
#import "CustomAdapterBiddingRequest.h"
#import "CustomAdapterBaseManager.h"
#import "CustomAdapterRewardVideoAdapter.h"
#import "CustomAdapterRewardVideoCustomEvent.h"
#import "ATGCDQueue_QM.h"
#import "ATC2SBiddingNetworkC2STool_QM.h"

@interface CustomAdapterRewardVideoAdapter()

@property (nonatomic, strong) CustomAdapterRewardVideoCustomEvent *customEvent;

@property (nonatomic, strong) QuMengRewardedVideoAd *rewardedVideoAd;

@end

@implementation CustomAdapterRewardVideoAdapter

#pragma mark - Header bidding
#pragma mark - c2s
+ (void)bidRequestWithPlacementModel:(ATPlacementModel *)placementModel unitGroupModel:(ATUnitGroupModel *)unitGroupModel info:(NSDictionary *)info completion:(void(^)(ATBidInfo *bidInfo, NSError *error))completion {
    
    [CustomAdapterBaseManager initWithCustomInfo:info localInfo:info];

    CustomAdapterRewardVideoCustomEvent *customEvent = [[CustomAdapterRewardVideoCustomEvent alloc] initWithInfo:info localInfo:info];
    customEvent.isC2SBiding = YES;
    CustomAdapterBiddingRequest *request = [[CustomAdapterBiddingRequest alloc] init];
    request.customEvent = customEvent;
    request.unitGroup = unitGroupModel;
    request.placementID = placementModel.placementID;
    request.bidCompletion = completion;
    request.unitID = [NSString stringWithFormat:@"%@", info[@"adslot_id"]];
    request.extraInfo = info;
    request.adType = ATAdFormatRewardedVideo;
    [[CustomAdapterC2SBiddingRequestManager sharedInstance] startWithRequestItem:request];

}

- (instancetype)initWithNetworkCustomInfo:(NSDictionary *)serverInfo localInfo:(NSDictionary*)localInfo {
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

        if (bidId) {//如果是c2s
            CustomAdapterBiddingRequest *request = [[ATC2SBiddingNetworkC2STool_QM sharedInstance] getRequestItemWithUnitID:serverInfo[@"adslot_id"]];

            if (request != nil) {
                self.customEvent = (CustomAdapterRewardVideoCustomEvent*)request.customEvent;
                self.customEvent.requestCompletionBlock = completion;
                self.rewardedVideoAd = request.customObject;
                //判断广告源是否已经loaded过
                [self.customEvent trackRewardedVideoAdLoaded:self.rewardedVideoAd adExtra:nil];

            }
            [[ATC2SBiddingNetworkC2STool_QM sharedInstance] removeRequestItemWithUnitID:serverInfo[@"adslot_id"]];
        } else {
            
            self.customEvent = [[CustomAdapterRewardVideoCustomEvent alloc] initWithInfo:serverInfo localInfo:localInfo];
            self.customEvent.requestCompletionBlock = completion;
            
            self.rewardedVideoAd = [[QuMengRewardedVideoAd alloc] initWithSlot:serverInfo[@"adslot_id"] ];
            self.rewardedVideoAd.delegate = self.customEvent;
            [self.rewardedVideoAd loadAdData];
        }

    }];
}

+ (BOOL)adReadyWithCustomObject:(id)customObject info:(NSDictionary *)info {
    return customObject;
}

+ (void)showRewardedVideo:(ATRewardedVideo *)rewardedVideo inViewController:(UIViewController *)viewController delegate:(id)delegate {
    
    rewardedVideo.customEvent.delegate = delegate;
    QuMengRewardedVideoAd *rewardAd = rewardedVideo.customObject;
    [rewardAd showRewardedVideoViewInRootViewController:viewController];
}

@end
