//
//  BaseVC.h
//  iOSDemo
//
//  Created by ltz on 2025/1/6.
//

#import <UIKit/UIKit.h>
#import "NaviBarView.h"
#import "CustomTableViewCell.h"
#import "NormalNavBar.h"
#import "DemoADFootView.h"

@interface BaseVC : UIViewController

@property (nonatomic, strong) DemoADFootView *footView;
@property (strong, nonatomic) NaviBarView * bar;
@property (strong, nonatomic) NormalNavBar * nbar;
@property (nonatomic, strong) NSArray *dataSource;
@property (strong, nonatomic) UITableView * tableView;
@property (nonatomic, strong) UITextView *textView;

- (void)addHomeBar;
- (void)addNormalBarWithTitle:(NSString *)title;
- (void)addFootView;
- (void)addLogTextView;
- (void)showLog:(NSString *)logStr;

- (void)notReadyAlert;
- (void)clearLog; 

#pragma mark - actions
- (void)loadAd;

- (void)showAd;
 
- (void)hiddenAdButtonClickAction;

- (void)removeAdButtonClickAction;

- (void)reshowAd;

@end
 
