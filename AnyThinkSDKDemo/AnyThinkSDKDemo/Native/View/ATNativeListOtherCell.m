//
//  ATNativeListOtherCell.m
//  AnyThinkSDKDemo
//
//  Created by GUO PENG on 2022/6/30.
//  Copyright © 2022 抽筋的灯. All rights reserved.
//

#import "ATNativeListOtherCell.h"

@interface ATNativeListOtherCell ()
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end

@implementation ATNativeListOtherCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = randomColor;
    
    self.descLabel.textColor = [UIColor whiteColor];
}

@end
