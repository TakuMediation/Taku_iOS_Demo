//
//  WildClickButton.m
//  iOSDemo
//
//  Created by ltz on 2025/1/7.
//

#import "WildClickButton.h"

@implementation WildClickButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event {
    CGRect bounds = self.bounds;
    //扩大原热区直径至26，可以暴露个接口，用来设置需要扩大的半径。
    CGFloat widthDelta = MAX(26, 0);
    CGFloat heightDelta = MAX(26, 0);
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
}

@end
