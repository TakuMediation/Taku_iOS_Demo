//
//  ATDrawListOtherCell.m
//  TakuSDKDemo
//
//  Created by Taku on 7/26/22.
//  Copyright © 2022 抽筋的灯. All rights reserved.
//

#import "ATDrawListOtherCell.h"

@interface ATDrawListOtherCell ()
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@end

@implementation ATDrawListOtherCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.backgroundColor = randomColor;
    
    self.logoImageView.layer.cornerRadius = 10.0f;
    self.logoImageView.layer.masksToBounds = YES;
}

#pragma mark - dealloc
-(void)dealloc {
    NSLog(@"ATDrawListOtherCell dealloc");
}

@end
