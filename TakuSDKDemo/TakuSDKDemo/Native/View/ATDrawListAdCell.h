//
//  ATDrawListAdCell.h
//  TakuSDKDemo
//
//  Created by Taku on 7/26/22.
//  Copyright © 2022 抽筋的灯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AnyThinkNative/AnyThinkNative.h>

NS_ASSUME_NONNULL_BEGIN

@interface ATDrawListAdCell : UITableViewCell

@property(nonatomic, strong) ATNativeADView *drawAdView;

@end

NS_ASSUME_NONNULL_END
