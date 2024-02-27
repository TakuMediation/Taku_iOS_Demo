//
//  ATAutomationTestViewController.m
//  AnyThinkSDKDemo
//
//  Created by mac on 2022/1/21.
//  Copyright © 2022 AnyThink. All rights reserved.
//

#import "ATAutomationTestViewController.h"
#import "ATAutomationTableViewCell.h"
#import <objc/runtime.h>

@interface ATAutomationTestViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableDictionary *delegateList;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UIButton *placementIdButton;

@property (nonatomic, strong) UIButton *switchButton;

@property (nonatomic, strong) UIButton *clearButton;

@end

@implementation ATAutomationTestViewController

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
}

- (void)setupUI
{
    [self.headerView addSubview:self.placementIdButton];
    [self.headerView addSubview:self.switchButton];
    [self.headerView addSubview:self.clearButton];
    
    [self.placementIdButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headerView.mas_centerX);
        make.centerY.equalTo(self.headerView.mas_centerY);
    }];
    
    [self.switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScaleW(100));
        make.height.mas_equalTo(kScaleW(50));
        make.right.equalTo(self.headerView.mas_right).offset(kScaleW(-24));
        make.centerY.equalTo(self.headerView.mas_centerY);
    }];
    
    [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScaleW(100));
        make.height.mas_equalTo(kScaleW(50));
        make.left.equalTo(self.headerView.mas_left).offset(kScaleW(24));
        make.centerY.equalTo(self.headerView.mas_centerY);
    }];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

- (void)recordWithPlacementId:(NSString *)placementId protocol:(NSString *)protocolMethod
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![self.placementIdButton.titleLabel.text isEqualToString:placementId]) {
            [self.placementIdButton setTitle:placementId forState:UIControlStateNormal];
            NSArray *nums = self.delegateList.allKeys;
            for (NSString *key in nums) {
                [self.delegateList setValue:@0 forKey:key];
            }
        }
        if (self.switchButton.isSelected) {
            NSNumber *num = self.delegateList[protocolMethod];
            NSInteger intNum = num.integerValue;
            intNum++;
            [self.delegateList setValue:@(intNum) forKey:protocolMethod];
            [self.tableView reloadData];
        }
    });
}

- (void)getProtocolMethodListFromProtocolList:(NSArray *)protocolList
{
    for (NSString *protocolName in protocolList) {
        [self getProtocolMethodListWithProtocolName:protocolName];
    }
}

- (void)getProtocolMethodListWithProtocolName:(NSString *)protocolName
{
    // required method
    unsigned int count = 0;
    struct objc_method_description *requiredDesc = protocol_copyMethodDescriptionList(NSProtocolFromString(protocolName),
                                       YES,
                                       YES,
                                       &count);
    for (int i = 0; i < count; i++) {
        struct objc_method_description temp = requiredDesc[i];
        [self.delegateList setValue:@0 forKey:NSStringFromSelector(temp.name)];
    }
    free(requiredDesc);
    // optional method
    struct objc_method_description *optionalDesc = protocol_copyMethodDescriptionList(NSProtocolFromString(protocolName),
                                       NO,
                                       YES,
                                       &count);
    for (int i = 0; i < count; i++) {
        struct objc_method_description temp = optionalDesc[i];
        [self.delegateList setValue:@0 forKey:NSStringFromSelector(temp.name)];
    }
    free(optionalDesc);
}

- (void)clickSwitch:(UIButton *)sender
{
    sender.selected = !sender.selected;
    sender.backgroundColor = sender.selected ? kRGB(73, 109, 255) : [UIColor grayColor];
}

- (void)clickClear:(UIButton *)sender
{
    NSArray *nums = self.delegateList.allKeys;
    for (NSString *key in nums) {
        [self.delegateList setValue:@0 forKey:key];
    }
    [self.tableView reloadData];
}

- (void)clickDissmiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.headerView.frame.size.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.delegateList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ATAutomationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ATAutomationTableViewCell idString]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *methodList = self.delegateList.allKeys;
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    [methodList enumerateObjectsUsingBlock:^(NSString  *keyStr, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *tempStr = [NSString stringWithFormat:@"%@---%@",self.delegateList[keyStr],keyStr];
        [tempArray addObject:tempStr];
    }];
    
    NSArray *sortArray = [[[tempArray sortedArrayUsingSelector:@selector(compare:)] reverseObjectEnumerator] allObjects];
    
    NSString *tempKeyStr = [sortArray[indexPath.row] componentsSeparatedByString:@"---"].lastObject;
    
    cell.methodLabel.text = tempKeyStr;
 
    cell.numberLabel.text = [NSString stringWithFormat:@"%@", self.delegateList[tempKeyStr]];
    
    if ([cell.numberLabel.text isEqualToString:@"0"]) {
        cell.numberLabel.textColor = [UIColor redColor];
        cell.numberLabel.font = [UIFont systemFontOfSize:14];
    }else{
        cell.numberLabel.textColor = [UIColor greenColor];
        cell.numberLabel.font = [UIFont boldSystemFontOfSize:25];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kScaleW(100);
}

#pragma mark - lazy
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[ATAutomationTableViewCell class] forCellReuseIdentifier:[ATAutomationTableViewCell idString]];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _tableView;
}

- (NSMutableDictionary *)delegateList
{
    if (!_delegateList) {
        _delegateList = [NSMutableDictionary dictionary];
    }
    return _delegateList;
}

- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kNavigationBarHeight)];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}

- (UIButton *)placementIdButton
{
    if (!_placementIdButton) {
        _placementIdButton = [[UIButton alloc] init];
        [_placementIdButton setTitle:@"placementID" forState:UIControlStateNormal];
        [_placementIdButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _placementIdButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_placementIdButton addTarget:self action:@selector(clickDissmiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _placementIdButton;
}

- (UIButton *)switchButton
{
    if (!_switchButton) {
        _switchButton = [[UIButton alloc] init];
        _switchButton.backgroundColor = [UIColor grayColor];
        _switchButton.layer.masksToBounds = YES;
        _switchButton.layer.cornerRadius = kScaleW(25);
        [_switchButton setTitle:@"off" forState:UIControlStateNormal];
        [_switchButton setTitle:@"on" forState:UIControlStateSelected];
        [_switchButton addTarget:self action:@selector(clickSwitch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchButton;
}

- (UIButton *)clearButton
{
    if (!_clearButton) {
        _clearButton = [[UIButton alloc] init];
        [_clearButton setTitle:@"clear" forState:UIControlStateNormal];
        [_clearButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_clearButton addTarget:self action:@selector(clickClear:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearButton;
}

@end
