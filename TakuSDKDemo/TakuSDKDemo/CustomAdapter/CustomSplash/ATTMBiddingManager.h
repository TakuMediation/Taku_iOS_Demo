//
//  ATTMBiddingManager.h
//  HeadBiddingDemo
//
//  Created by lix on 2022/10/20.
//

#import <Foundation/Foundation.h>

#import "ATTMBiddingRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface ATTMBiddingManager : NSObject

+ (instancetype)sharedInstance;

- (void)startWithRequestItem:(ATTMBiddingRequest *)request;

- (ATTMBiddingRequest *)getRequestItemWithUnitID:(NSString *)unitID;

- (void)removeRequestItmeWithUnitID:(NSString *)unitID;

- (void)removeBiddingDelegateWithUnitID:(NSString *)unitID;

@end

NS_ASSUME_NONNULL_END
