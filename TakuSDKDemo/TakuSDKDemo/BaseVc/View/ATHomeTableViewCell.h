//
//  ATHomeTableViewCell.h
//  AnyThingSDKDemo
//
//  Created by mac on 2021/12/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ATHomeTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *logoImage;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;

+ (NSString *)idString;


@end

NS_ASSUME_NONNULL_END
