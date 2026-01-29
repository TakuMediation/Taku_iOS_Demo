
#import "ATC2SBiddingNetworkC2STool_QM.h"


@interface ATC2SBiddingNetworkC2STool_QM()

@property(nonatomic, strong) NSMutableDictionary<NSString *, id> *requestDic;

@end


@implementation ATC2SBiddingNetworkC2STool_QM


+ (instancetype)sharedInstance {
    static ATC2SBiddingNetworkC2STool_QM *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ATC2SBiddingNetworkC2STool_QM alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    _requestDic = [NSMutableDictionary dictionary];
    return self;
}

#pragma mark - request CRUD
- (void)saveRequestItem:(id)request withUnitId:(NSString *)unitID{
    @synchronized (self) {
        [self.requestDic setValue:request forKey:unitID];
    }
}

- (id)getRequestItemWithUnitID:(NSString*)unitID {
    @synchronized (self) {
        return [self.requestDic objectForKey:unitID];
    }
}

- (void)removeRequestItemWithUnitID:(NSString*)unitID {
    @synchronized (self) {
        [self.requestDic removeObjectForKey:unitID];
    }
}


@end
