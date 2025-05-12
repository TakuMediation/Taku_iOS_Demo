//
//  CustomAdapterBiddingRequest.h
//  AnyThinkSDK
//
//  Created by Captain on 2024/9/12.
//  Copyright © 2024 AnyThink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AnyThinkSDK/AnyThinkSDK.h>
 
@interface CustomAdapterBiddingRequest : NSObject

@property(nonatomic, strong) id customObject;

@property(nonatomic, strong) ATUnitGroupModel *unitGroup;

@property(nonatomic, strong) ATAdCustomEvent *customEvent;

@property(nonatomic, copy) NSString *unitID;

@property(nonatomic, copy) NSString *placementID;

@property(nonatomic, copy) NSDictionary *extraInfo;

@property(nonatomic, assign) ATAdFormat adType;

@property(nonatomic, copy) void(^bidCompletion)(ATBidInfo * _Nullable bidInfo, NSError * _Nullable error);

@end


