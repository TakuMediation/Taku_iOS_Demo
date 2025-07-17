//
//  CustomAdapterC2SBiddingRequestManager.h
//  AnyThinkQMAdapter
//
//  Created by Captain on 2024/9/12.
//  Copyright © 2024 AnyThink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomAdapterBiddingRequest.h"


@interface CustomAdapterC2SBiddingRequestManager : NSObject

+ (instancetype)sharedInstance;

- (void)startWithRequestItem:(CustomAdapterBiddingRequest *)request;

+ (void)disposeLoadSuccessCall:(NSString *)priceStr customObject:(id)customObject unitID:(NSString *)unitID;

+ (void)disposeLoadFailCall:(NSError *)error key:(NSString *)keyStr unitID:(NSString *)unitID;


@end


