//
//  ATHomeTableViewCell.m
//  AnyThingSDKDemo
//
//  Created by mac on 2021/12/6.
//

#import "ATHomeTableViewCell.h"

@interface ATHomeTableViewCell()
@property (nonatomic, strong) UIView * logoBorderView;
@property (nonatomic, strong) UIView *backView;

@end

@implementation ATHomeTableViewCell

+ (NSString *)idString
{
    return @"at_home_cell";
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
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.logoBorderView];
    [self.logoBorderView addSubview:self.logoImage];
    
    //[self.backView addSubview:self.logoImage];
    [self.backView addSubview:self.titleLabel];
    [self.backView addSubview:self.subTitleLabel];
    
//    self.backView.frame = CGRectMake(kScaleW(24), kScaleW(10), kScreenW - kScaleW(48), kScaleW(198));
//    self.logoImage.frame = CGRectMake(kScaleW(52), kScaleW(16), kScaleW(102), kScaleW(166));
//    self.titleLabel.frame = CGRectMake(kScaleW(212), kScaleW(46), kScreenW - kScaleW(236 - 66), kScaleW(32));
//    self.subTitleLabel.frame = CGRectMake(kScaleW(212), kScaleW(88), kScreenW - kScaleW(236 - 26), kScaleW(88));
}

- (void)layoutSubviews
{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(kScaleW(10));
        make.left.equalTo(self.mas_left).offset(kScaleW(24));
        make.right.equalTo(self.mas_right).offset(kScaleW(-24));
        make.height.mas_equalTo(kScaleW(238));
        
    }];
    
    
    [self.logoBorderView mas_makeConstraints:^(MASConstraintMaker *make) {
            
        make.top.equalTo(self.backView.mas_top).offset(kScaleW(16));
        make.left.equalTo(self.backView.mas_left).offset(kScaleW(24));
        make.height.mas_equalTo(kScaleW(200));
        make.width.mas_equalTo(kScaleW(200));
        
    }];
    
    [self.logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(kScaleW(166));
        make.width.mas_equalTo(kScaleW(102));
        make.center.mas_equalTo(self.logoBorderView);
        
    }];
    
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView.mas_top).offset(kScaleW(46));
        make.left.equalTo(self.logoBorderView.mas_right).offset(kScaleW(24));
        make.right.equalTo(self.mas_right).offset(kScaleW(-24));
        make.height.mas_equalTo(kScaleW(32));
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kScaleW(10));
        make.left.equalTo(self.logoBorderView.mas_right).offset(kScaleW(24));
        make.right.equalTo(self.mas_right).offset(kScaleW(-24));
        make.height.mas_equalTo(kScaleW(88));
    }];
}

#pragma mark - lazy
- (UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 5;
        _backView.layer.borderWidth = kScaleW(5);
    }
    return _backView;
}

- (UIImageView *)logoImage
{
    if (!_logoImage) {
        _logoImage = [[UIImageView alloc] init];
    }
    return _logoImage;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

-(UIView *)logoBorderView{
    if (!_logoBorderView) {
        _logoBorderView = [[UIView alloc] init];
        _logoBorderView.backgroundColor = [UIColor whiteColor];
        _logoBorderView.layer.borderColor = kRGB(249, 249, 249).CGColor;
        _logoBorderView.layer.borderWidth = kScaleW(5);
        _logoBorderView.layer.cornerRadius = 5;
        _logoBorderView.layer.masksToBounds = true;
        
    }
    return _logoBorderView;
}
- (UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.backgroundColor = [UIColor whiteColor];
        _subTitleLabel.numberOfLines = 3;
        _subTitleLabel.textColor = [UIColor grayColor];
        _subTitleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _subTitleLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        self.backView.layer.borderColor = kRGB(141, 165, 228).CGColor;//[[UIColor blueColor]CGColor];
       
        self.logoBorderView.layer.borderColor =  kRGB(141, 165, 228).CGColor;
        
    }else{
        self.backView.layer.borderColor = kRGB(249, 249, 249).CGColor;//[[UIColor blueColor]CGColor];
       
        self.logoBorderView.layer.borderColor =  kRGB(249, 249, 249).CGColor;
    }
    // Configure the view for the selected state
}

@end
