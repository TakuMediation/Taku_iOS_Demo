//
//  ATAutomationTableViewCell.m
//  AnyThinkSDKDemo
//
//  Created by mac on 2022/1/21.
//  Copyright © 2022 AnyThink. All rights reserved.
//

#import "ATAutomationTableViewCell.h"

@implementation ATAutomationTableViewCell

+ (NSString *)idString
{
    return @"at_automation_cell";
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    [self.contentView addSubview:self.numberLabel];
    [self.contentView addSubview:self.methodLabel];
}

- (void)layoutSubviews
{
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kScaleW(24));
        make.width.mas_equalTo(kScaleW(50));
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.methodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(kScaleW(-24));
        make.left.equalTo(self.numberLabel.mas_right).offset(kScaleW(24));
        make.centerY.equalTo(self.mas_centerY);
    }];
}

#pragma mark - lazy
- (UILabel *)numberLabel
{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.textColor = [UIColor redColor];
        _numberLabel.font = [UIFont systemFontOfSize:14];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numberLabel;
}

- (UILabel *)methodLabel
{
    if (!_methodLabel) {
        _methodLabel = [[UILabel alloc] init];
        _methodLabel.backgroundColor = [UIColor whiteColor];
        _methodLabel.numberOfLines = 2;
        _methodLabel.textColor = [UIColor blackColor];
        _methodLabel.font = [UIFont systemFontOfSize:14];
    }
    return _methodLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
