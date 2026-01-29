//
//  CustomAdapterInterstitialAdapter.m
//  CustomAdapter
//
//  Created by mac on 2024/8/27.
//

#import "CustomAdapterInterstitialAdapter.h"
#import "CustomAdapterInterstitialCustomEvent.h"
#import "CustomAdapterBaseManager.h"
#import "CustomAdapterC2SBiddingRequestManager.h"
#import "CustomAdapterBiddingRequest.h"
#import "ATC2SBiddingNetworkC2STool_QM.h"
#import "ATGCDQueue_QM.h"
#import <SafariServices/SafariServices.h>

@interface CustomAdapterInterstitialAdapter()

@property (nonatomic, strong) CustomAdapterInterstitialCustomEvent *customEvent;
@property (nonatomic, strong) QuMengInterstitialAd *interstitialAd;

@end

@implementation CustomAdapterInterstitialAdapter

#pragma mark - Header bidding
#pragma mark - c2s
+ (void)bidRequestWithPlacementModel:(ATPlacementModel *)placementModel unitGroupModel:(ATUnitGroupModel *)unitGroupModel info:(NSDictionary *)info completion:(void(^)(ATBidInfo *bidInfo, NSError *error))completion {
    
    [CustomAdapterBaseManager initWithCustomInfo:info localInfo:info];

    CustomAdapterInterstitialCustomEvent *customEvent = [[CustomAdapterInterstitialCustomEvent alloc] initWithInfo:info localInfo:info];
    customEvent.isC2SBiding = YES;
    CustomAdapterBiddingRequest *request = [[CustomAdapterBiddingRequest alloc] init];
    request.customEvent = customEvent;
    request.unitGroup = unitGroupModel;
    request.placementID = placementModel.placementID;
    request.bidCompletion = completion;
    request.unitID = [NSString stringWithFormat:@"%@", info[@"adslot_id"]];
    request.extraInfo = info;
    request.adType = ATAdFormatInterstitial;
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
                self.customEvent = (CustomAdapterInterstitialCustomEvent*)request.customEvent;
                self.customEvent.requestCompletionBlock = completion;
                self.interstitialAd = request.customObject;
                //判断广告源是否已经loaded过
                [self.customEvent trackInterstitialAdLoaded:self.interstitialAd adExtra:nil];

            }
            [[ATC2SBiddingNetworkC2STool_QM sharedInstance] removeRequestItemWithUnitID:serverInfo[@"adslot_id"]];
        } else {
            
            self.customEvent = [[CustomAdapterInterstitialCustomEvent alloc] initWithInfo:serverInfo localInfo:localInfo];
            self.customEvent.requestCompletionBlock = completion;
            self.interstitialAd = [[QuMengInterstitialAd alloc] initWithSlot:serverInfo[@"adslot_id"]];
            self.interstitialAd.delegate = self.customEvent;
            [self.interstitialAd loadAdData];
        }
    }];
}

+ (BOOL)adReadyWithCustomObject:(id)customObject info:(NSDictionary *)info {
    return customObject;
}

+ (void)showInterstitial:(ATInterstitial *)interstitial inViewController:(UIViewController *)viewController delegate:(id)delegate {    
    interstitial.customEvent.delegate = delegate;
    QuMengInterstitialAd *interstitialAd = interstitial.customObject;
//    interstitialAd.viewController = viewController;
    [interstitialAd showInterstitialViewInRootViewController:viewController];
}

@end
