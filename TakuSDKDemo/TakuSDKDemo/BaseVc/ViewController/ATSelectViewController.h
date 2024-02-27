//
//  ATSelectViewController.h
//  AnyThingSDKDemo
//
//  Created by mac on 2021/12/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ATSelectViewController : UIViewController

- (instancetype)initWithSelectList:(NSArray *)list;
- (instancetype)initWithSelectList:(NSArray *)list multipleSelection:(BOOL)multiple;

@property (nonatomic, copy) void(^ __nullable selectBlock)(NSArray<NSString *> *selections);

@end

NS_ASSUME_NONNULL_END
