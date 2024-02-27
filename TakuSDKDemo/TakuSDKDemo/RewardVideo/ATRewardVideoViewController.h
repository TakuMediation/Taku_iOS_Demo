//
//  ATReWardVideoViewController.h
//  AnyThingSDKDemo
//
//  Created by mac on 2021/12/6.
//

#import <UIKit/UIKit.h>

#import "ATADFootView.h"
#import "ATMenuView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ATRewardVideoViewController : UIViewController

@property (copy, nonatomic) NSString *placementID;
@property (copy, nonatomic) NSDictionary<NSString *, NSString *> *placementIDs;

@property (nonatomic, strong) ATMenuView *menuView;
@property (nonatomic, strong) ATADFootView *footView;

- (void)showAd;

@end

NS_ASSUME_NONNULL_END
