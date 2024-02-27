//
//  ATTMBiddingManager.m
//  HeadBiddingDemo
//
//  Created by lix on 2022/10/20.
//

#import "ATTMBiddingManager.h"

#import "ATTMBiddingDelegate.h"

@interface ATTMBiddingManager ()

@property (nonatomic, strong) NSMutableDictionary *bidingAdStorageAccessor;
@property (nonatomic, strong) NSMutableDictionary *bidingAdDelegate;

@end

@implementation ATTMBiddingManager

+ (instancetype)sharedInstance {
    static ATTMBiddingManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ATTMBiddingManager alloc] init];
        sharedInstance.bidingAdStorageAccessor = [NSMutableDictionary dictionary];
        sharedInstance.bidingAdDelegate = [NSMutableDictionary dictionary];
    });
    return sharedInstance;
}

- (ATTMBiddingRequest *)getRequestItemWithUnitID:(NSString *)unitID {
    @synchronized (self) {
        return [self.bidingAdStorageAccessor objectForKey:unitID];
    }
    
}

- (void)removeRequestItmeWithUnitID:(NSString *)unitID {
    @synchronized (self) {
        [self.bidingAdStorageAccessor removeObjectForKey:unitID];
    }
}

- (void)savaBiddingDelegate:(ATTMBiddingDelegate *)delegate withUnitID:(NSString *)unitID {
    @synchronized (self) {
        [self.bidingAdDelegate setObject:delegate forKey:unitID];
    }
}

- (void)removeBiddingDelegateWithUnitID:(NSString *)unitID {
    @synchronized (self) {
        if (unitID.length) {
            [self.bidingAdDelegate removeObjectForKey:unitID];
        }
    }
}

- (void)startWithRequestItem:(ATTMBiddingRequest *)request {
    
    [self.bidingAdStorageAccessor setObject:request forKey:request.unitID];
    switch (request.adType) {
        case ESCAdFormatSplash: {
            // 获取代理
            ATTMBiddingDelegate *delegate = [[ATTMBiddingDelegate alloc] init];
            delegate.unitID = request.unitID;
            [request.customObject setValue:delegate forKey:@"delegate"];
            [self savaBiddingDelegate:delegate withUnitID:request.unitID];
            break;
        }
        default:
            break;
    }
}


@end
