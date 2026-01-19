//
//  NormalNavBar.h
//  iOSDemo
//
//  Created by ltz on 2025/1/7.
//

#import <UIKit/UIKit.h>
#import "WildClickButton.h"



@interface NormalNavBar : UIView

@property (strong, nonatomic) WildClickButton * arrowImgView;
@property (strong, nonatomic) UIImageView * bgImgView;
@property (strong, nonatomic) UILabel * titleLbl;

@end


