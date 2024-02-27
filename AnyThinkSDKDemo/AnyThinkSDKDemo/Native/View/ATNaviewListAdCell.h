//
//  ATNaviewListAdCell.h
//  AnyThinkSDKDemo
//
//  Created by GUO PENG on 2022/6/30.
//  Copyright © 2022 抽筋的灯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATNativeSelfRenderView.h"
@import AnyThinkNative;

NS_ASSUME_NONNULL_BEGIN

@interface ATNaviewListAdCell : UITableViewCell

@property(nonatomic, strong) ATNativeADView *adView;

@end

NS_ASSUME_NONNULL_END
