//
//  DrawCustomCell.m
//  iOSDemo
//
//  Created by ltz on 2025/2/14.
//

#import "DrawCustomCell.h"

@implementation DrawCustomCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

@end
