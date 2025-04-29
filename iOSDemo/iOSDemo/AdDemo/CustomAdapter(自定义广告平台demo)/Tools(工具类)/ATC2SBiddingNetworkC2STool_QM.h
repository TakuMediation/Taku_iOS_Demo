

#import <Foundation/Foundation.h>




@interface ATC2SBiddingNetworkC2STool_QM : NSObject

+ (instancetype)sharedInstance;

- (void)saveRequestItem:(id)request withUnitId:(NSString *)unitID;

- (id)getRequestItemWithUnitID:(NSString*)unitID;

- (void)removeRequestItemWithUnitID:(NSString*)unitID;


@end


