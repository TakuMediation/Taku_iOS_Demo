//
//  TwoButtonAlertView.h
//  iOSDemo
//
//  Created by ltz on 2025/1/7.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TwoButtonAlertView;
typedef void (^TwoButtonAlertBlock)(NSInteger index);
typedef void (^TwoButtonAlertTextStyle1Block)(NSInteger index,NSString * txt);
typedef void (^TwoButtonAlertSelfIndexBlock)(TwoButtonAlertView * selfView,NSInteger index);

@interface TwoButtonAlertView : UIView

@property (strong, nonatomic) TwoButtonAlertBlock TruelyGGBlock;
- (void)addTwoButtonAlertBlock:(TwoButtonAlertBlock)block;

//单行tf输入
@property (strong, nonatomic) TwoButtonAlertTextStyle1Block TwoButtonAlertTextStyle1Block;
- (void)addTwoButtonAlertTextStyle1Block:(TwoButtonAlertTextStyle1Block)block;
 
@property (strong, nonatomic) TwoButtonAlertSelfIndexBlock TwoButtonAlertSelfIndexBlock;
- (void)addTwoButtonAlertSelfIndexBlock:(TwoButtonAlertSelfIndexBlock)block;

- (instancetype)initWithTitle:(NSString *)title buttonText1:(NSString *)buttonText1 buttonText2:(NSString *)buttonText2;

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content buttonText1:(NSString *)buttonText1 buttonText2:(NSString *)buttonText2;
 
- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content att:(NSMutableAttributedString *)att buttonText1:(NSString *)buttonText1 buttonText2:(NSString *)buttonText2;

- (instancetype)initWithAlert:(NSString *)title content:(NSString *)content buttonText:(NSString *)buttonText;

- (instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder buttonText1:(NSString *)buttonText1 buttonText2:(NSString *)buttonText2 maxLength:(NSInteger)maxLength;
 
- (void)show;
- (void)dismiss;

- (void)disableBlackViewClick;
  
@end
