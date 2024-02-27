//
//  ATADFootView.h
//  AnyThingSDKDemo
//
//  Created by mac on 2021/12/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ATADFootView : UIView

@property (nonatomic, copy) void(^clickLoadBlock)(void);

@property (nonatomic, copy) void(^clickReadyBlock)(void);

@property (nonatomic, copy) void(^clickShowBlock)(void);

@property (nonatomic, copy) void(^clickRemoveBlock)(void);


@property (nonatomic, strong) UIButton *loadBtn;

@property (nonatomic, strong) UIButton *readyBtn;

@property (nonatomic, strong) UIButton *showBtn;

@property (nonatomic, strong) UIButton *removeBtn;

- (instancetype)initWithRemoveBtn;

@end

NS_ASSUME_NONNULL_END
