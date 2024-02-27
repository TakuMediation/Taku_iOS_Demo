//
//  ATAutomationTableViewCell.h
//  AnyThinkSDKDemo
//
//  Created by mac on 2022/1/21.
//  Copyright © 2022 AnyThink. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ATAutomationTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *numberLabel;

@property (nonatomic, strong) UILabel *methodLabel;

+ (NSString *)idString;

@end

NS_ASSUME_NONNULL_END
