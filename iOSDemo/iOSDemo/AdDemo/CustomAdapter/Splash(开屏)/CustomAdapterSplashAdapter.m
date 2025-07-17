//
//  CustomAdapterSplashAdapter.m
//  CustomAdapter
//
//  Created by mac on 2024/8/27.
//

#import <AnyThinkSplash/AnyThinkSplash.h>
#import "CustomAdapterSplashAdapter.h"
#import "CustomAdapterSplashCustomEvent.h"
#import "CustomAdapterBaseManager.h"
#import "CustomAdapterC2SBiddingRequestManager.h"
#import "CustomAdapterBiddingRequest.h"
#import "ATC2SBiddingNetworkC2STool_QM.h"
#import "ATGCDQueue_QM.h"

@interface CustomAdapterSplashAdapter()

@property (nonatomic, strong) CustomAdapterSplashCustomEvent *customEvent;
@property (nonatomic, strong) QuMengSplashAd *splashAd;

@end

@implementation CustomAdapterSplashAdapter

#pragma mark - Header bidding
#pragma mark - c2s
+ (void)bidRequestWithPlacementModel:(ATPlacementModel *)placementModel unitGroupModel:(ATUnitGroupModel *)unitGroupModel info:(NSDictionary *)info completion:(void(^)(ATBidInfo *bidInfo, NSError *error))completion {
    
    [CustomAdapterBaseManager initWithCustomInfo:info localInfo:info];

    CustomAdapterSplashCustomEvent *splashCustomEvent = [[CustomAdapterSplashCustomEvent alloc] initWithInfo:info localInfo:info];
    splashCustomEvent.isC2SBiding = YES;
    CustomAdapterBiddingRequest *request = [[CustomAdapterBiddingRequest alloc] init];
    request.customEvent = splashCustomEvent;
    request.unitGroup = unitGroupModel;
    request.placementID = placementModel.placementID;
    request.bidCompletion = completion;
    request.unitID = [NSString stringWithFormat:@"%@", info[@"adslot_id"]];
    request.extraInfo = info;
    request.adType = ATAdFormatSplash;
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
        
        if (bidId) {//如果是c2s
            CustomAdapterBiddingRequest *request = [[ATC2SBiddingNetworkC2STool_QM sharedInstance] getRequestItemWithUnitID:serverInfo[@"adslot_id"]];

            if (request != nil) {
                self.customEvent = (CustomAdapterSplashCustomEvent*)request.customEvent;
                self.customEvent.containerView = localInfo[kATSplashExtraContainerViewKey];
                self.customEvent.requestCompletionBlock = completion;
                self.splashAd = request.customObject;
                //判断广告源是否已经loaded过
                [self.customEvent trackSplashAdLoaded:self->_splashAd adExtra:nil];

            }
            [[ATC2SBiddingNetworkC2STool_QM sharedInstance] removeRequestItemWithUnitID:serverInfo[@"adslot_id"]];
        } else {
            
            self.customEvent = [[CustomAdapterSplashCustomEvent alloc] initWithInfo:serverInfo localInfo:localInfo];
            self.customEvent.containerView = localInfo[kATSplashExtraContainerViewKey];
            self.customEvent.requestCompletionBlock = completion;
            self.splashAd = [[QuMengSplashAd alloc] initWithSlot:serverInfo[@"adslot_id"]];
            self.splashAd.delegate = self.customEvent;
            [self.splashAd loadAdData];
        }
    }];
}

+ (BOOL)adReadyWithCustomObject:(id)customObject info:(NSDictionary *)info {
    return customObject;
}

+ (void)showSplash:(ATSplash *)splash localInfo:(NSDictionary *)localInfo delegate:(id)delegate {
    UIWindow *window = localInfo[kATSplashExtraWindowKey];
    
    NSDictionary *extra = splash.customEvent.localInfo;
    
//    UIView *bottomView = extra[kATSplashExtraContainerViewKey];
    
    QuMengSplashAd *qmSplash = splash.customObject;
    
    CustomAdapterSplashCustomEvent *customEvent = (CustomAdapterSplashCustomEvent *)splash.customEvent;
    customEvent.delegate = delegate;
    
    [qmSplash showSplashViewController:window.rootViewController withBottomView:customEvent.containerView];
}


@end
