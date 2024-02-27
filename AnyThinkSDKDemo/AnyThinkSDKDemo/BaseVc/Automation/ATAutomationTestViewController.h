//
//  ATAutomationTestViewController.h
//  AnyThinkSDKDemo
//
//  Created by mac on 2022/1/21.
//  Copyright © 2022 AnyThink. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ATAutomationTestViewController : UIViewController

- (void)getProtocolMethodListFromProtocolList:(NSArray *)protocolList;

- (void)recordWithPlacementId:(NSString *)placementId protocol:(NSString *)protocolMethod;

@end

NS_ASSUME_NONNULL_END
