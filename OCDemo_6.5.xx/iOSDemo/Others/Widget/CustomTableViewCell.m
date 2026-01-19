//
//  CustomTableViewCell.m
//  iOSDemo
//
//  Created by ltz on 2024/12/25.
//

#import "CustomTableViewCell.h"
 
@interface CustomTableViewCell ()

@property (nonatomic, strong) UIImageView *arrowImgView;
@property (nonatomic, strong) CAShapeLayer *maskLayer;
@property (assign, nonatomic) int isTop;


@end

@implementation CustomTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
 
        // 初始化标题标签
        self.titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLbl.font = [UIFont boldSystemFontOfSize:18];
        self.titleLbl.textColor = [UIColor blackColor];
        self.titleLbl.translatesAutoresizingMaskIntoConstraints = NO;
        self.titleLbl.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:self.titleLbl];
        
        // 初始化副标题标签
        self.subTitleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        self.subTitleLbl.font = [UIFont systemFontOfSize:14];
        self.subTitleLbl.textColor = [UIColor lightGrayColor];
        self.subTitleLbl.numberOfLines = 0; // 支持多行
        self.subTitleLbl.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.subTitleLbl];
        
        self.arrowImgView = [UIImageView new];
        self.arrowImgView.image = kImg(@"arrow_right");
        [self.contentView addSubview:self.arrowImgView];
        
        UIView * line = [UIView new];
        line.backgroundColor = kHexColor(0xF4F4F4);
        [self.contentView addSubview:line];
        
        // 设置标题和副标题的约束
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).mas_offset(20);
            make.left.mas_equalTo(self.contentView).mas_offset(30);
            make.height.mas_equalTo(self.titleLbl.font.lineHeight);
        }];
        
        // 设置标题和副标题的约束
        [self.subTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLbl.mas_bottom).mas_offset(15);
            make.left.mas_equalTo(self.titleLbl);
            make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-50);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-15);
        }];
        
        [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView);
            make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-20);
            make.width.height.mas_equalTo(30);
        }];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-1);
            make.left.mas_equalTo(self.contentView.mas_left).mas_offset(25);
            make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-25);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

@end

