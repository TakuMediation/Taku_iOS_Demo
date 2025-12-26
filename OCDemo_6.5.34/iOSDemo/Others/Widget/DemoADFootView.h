//
//  DemoADFootView.h
//  AnyThingSDKDemo
//
//  Created by ltz on 2021/12/6.
//

#import <UIKit/UIKit.h>
 
@interface DemoADFootView : UIView

@property (nonatomic, copy) void(^clickLoadBlock)(void);

@property (nonatomic, copy) void(^clickLogBlock)(void);

@property (nonatomic, copy) void(^clickShowBlock)(void);

@property (nonatomic, copy) void(^clickRemoveBlock)(void);

@property (nonatomic, copy) void(^clickReShowBlock)(void);

@property (nonatomic, copy) void(^clickHidenBlock)(void);

@property (nonatomic, copy) void(^clickLeftMoveBlock)(void);

@property (nonatomic, copy) void(^clickRightMoveBlock)(void);


@property (nonatomic, strong) UIButton *loadBtn;

@property (nonatomic, strong) UIButton *showBtn;

@property (nonatomic, strong) UIButton *logBtn;

@property (nonatomic, strong) UIButton *removeBtn;

@property (nonatomic, strong) UIButton *reShowBtn;

@property (nonatomic, strong) UIButton *hidenBtn;

- (instancetype)initWithRemoveBtn;
- (instancetype)initWithRemoveAndHidenBtn;

@end


