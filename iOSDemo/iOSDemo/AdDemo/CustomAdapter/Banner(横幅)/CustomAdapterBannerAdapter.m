//
//  CustomAdapterBannerAdapter.m
//  CustomAdapter
//
//  Created by Captain on 2024/12/23.
//  Copyright © 2024 AnyThink. All rights reserved.
//

#import "CustomAdapterBannerAdapter.h"
#import "CustomAdapterBaseManager.h"
#import "ATGCDQueue_QM.h"
#import "CustomAdapterBannerCustomEvent.h"
#import <AnyThinkBanner/AnyThinkBanner.h>
#import <AnyThinkBanner/ATBanner.h>
#import "CustomAdapterBiddingRequest.h"
#import "ATC2SBiddingNetworkC2STool_QM.h"
#import "CustomAdapterC2SBiddingRequestManager.h"
  
@interface CustomAdapterBannerAdapter ()

@property (nonatomic, strong) CustomAdapterBannerCustomEvent *customEvent;
@property (nonatomic, strong) SMABannerView *bannerView;

@end

@implementation CustomAdapterBannerAdapter

- (instancetype)initWithNetworkCustomInfo:(NSDictionary *)serverInfo localInfo:(NSDictionary *)localInfo {
    self = [super init];
    if (self != nil) {
        // TODO: add some code for initialize Network SDK
        [CustomAdapterBaseManager initWithCustomInfo:serverInfo localInfo:localInfo];
    }
    return self;
}

- (void)loadADWithInfo:(NSDictionary *)serverInfo localInfo:(NSDictionary *)localInfo completion:(void (^)(NSArray *, NSError *))completion {
    

    ATUnitGroupModel *unitGroupModel = serverInfo[kATAdapterCustomInfoUnitGroupModelKey];

    NSString *bidId = serverInfo[kATAdapterCustomInfoBuyeruIdKey];

    [[ATGCDQueue_QM mainQueue] queueAsyncBlock:^{

        if (bidId) {
            //C2S
            CustomAdapterBiddingRequest *request = [[ATC2SBiddingNetworkC2STool_QM sharedInstance] getRequestItemWithUnitID:serverInfo[@"adslot_id"]];

            if (request != nil) {
                self.customEvent = (CustomAdapterBannerCustomEvent*)request.customEvent;
                self.customEvent.requestCompletionBlock = completion;
                self.bannerView = request.customObject;
       
                [self.customEvent trackBannerAdLoaded:self.bannerView adExtra:@{}];
            }
            [[ATC2SBiddingNetworkC2STool_QM sharedInstance] removeRequestItemWithUnitID:serverInfo[@"adslot_id"]];
            
        } else {
            self.customEvent = [[CustomAdapterBannerCustomEvent alloc] initWithInfo:serverInfo localInfo:localInfo];
            self.customEvent.requestCompletionBlock = completion;

            self.bannerView  = [SMABannerView new];
            self.bannerView.autoreloadInterval = kSMABannerAutoreloadIntervalDisabled;
            self.bannerView.delegate = self.customEvent;
            SMABannerAdSize adSize = [CustomAdapterBannerAdapter _banner_sizeWithSize:unitGroupModel.adSize];
             
            [self.bannerView loadWithAdSpaceId:[serverInfo[@"unit_id"] stringValue]
                                        adSize:adSize];
        }

    }];
}

#pragma mark - C2S
+ (void)bidRequestWithPlacementModel:(ATPlacementModel*)placementModel unitGroupModel:(ATUnitGroupModel*)unitGroupModel info:(NSDictionary*)info completion:(void(^)(ATBidInfo *bidInfo, NSError *error))completion {
      
    CustomAdapterBannerCustomEvent *customEvent = [[CustomAdapterBannerCustomEvent alloc]initWithInfo:info localInfo:info];
    customEvent.networkAdvertisingID = unitGroupModel.content[@"unit_id"];
    customEvent.isC2SBiding = YES;
    
    CustomAdapterBiddingRequest *req = [CustomAdapterBiddingRequest new];
    req.customEvent = customEvent;
    req.unitGroup = unitGroupModel;
    req.placementID = placementModel.placementID;
    req.bidCompletion = completion;
    req.unitID = unitGroupModel.content[@"unit_id"];
    req.extraInfo = info;
    req.adType = ATAdFormatBanner;
    [[CustomAdapterC2SBiddingRequestManager sharedInstance] startWithRequestItem:req];
}

+ (SMABannerAdSize)_banner_sizeWithSize:(CGSize)size {
    
    if (CGSizeEqualToSize(CGSizeMake(320, 50), size)) {
        return kSMABannerAdSizeXXLarge_320x50;
    } else if (CGSizeEqualToSize(CGSizeMake(320, 250), size)) {
        return kSMABannerAdSizeMediumRectangle_300x250;
    } else if (CGSizeEqualToSize(CGSizeMake(728, 90), size)) {
        return kSMABannerAdSizeLeaderboard_728x90;
    }
    return kSMABannerAdSizeXXLarge_320x50;
}

+ (BOOL)adReadyWithCustomObject:(id)customObject info:(NSDictionary *)info {
    return customObject;
}
 

@end
