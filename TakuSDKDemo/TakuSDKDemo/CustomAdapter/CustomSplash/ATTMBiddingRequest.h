//
//  ATTiMBiddingRequest.h
//  HeadBiddingDemo
//
//  Created by lix on 2022/10/20.
//

#import <Foundation/Foundation.h>

#import <AnyThinkSDK/AnyThinkSDK.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ESCAdFormat) {
    ESCAdFormatSplash = 0,
};



@interface ATTMBiddingRequest : NSObject

@property(nonatomic, strong) id customObject;

@property(nonatomic, strong) ATUnitGroupModel *unitGroup;

@property(nonatomic, strong) ATAdCustomEvent *customEvent;

@property(nonatomic, copy) NSString *unitID;
@property(nonatomic, copy) NSString *placementID;

@property(nonatomic, copy) NSDictionary *extraInfo;

@property(nonatomic, copy) void(^bidCompletion)(ATBidInfo * _Nullable bidInfo, NSError * _Nullable error);

@property(nonatomic, assign) ESCAdFormat adType;

@end

NS_ASSUME_NONNULL_END
