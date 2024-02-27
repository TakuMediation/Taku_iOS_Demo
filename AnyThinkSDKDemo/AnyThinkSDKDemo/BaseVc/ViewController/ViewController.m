//
//  ViewController.m
//  AnyThinkSDKDemo
//
//  Created by Martin Lau on 2019/10/31.
//  Copyright © 2019 AnyThink. All rights reserved.
//

#import "ViewController.h"
#import "ATHomeTableViewCell.h"
#import "ATHomeFootView.h"
#import <AppTrackingTransparency/ATTrackingManager.h>


@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic) BOOL autoLoadEnable;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *autoEnableBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
  
    [self setupData];
    [self setupUI];
    [self checkTrackingPermission];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
  
}

- (void)checkTrackingPermission
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (@available(iOS 14, *)) {
            //iOS 14
            [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                
            }];
        } else {
            // Fallback on earlier versions
        }
    });
}

- (void)setupData
{
    self.dataSource = @[
        @{
            @"image":@"rewarded video",
            @"title":@"Reward Video",
            @"class":@"ATRewardVideoViewController",
            @"des":@"Users can engage with a video ad in exchange for in-app rewards.",
          
        },
        @{
            @"image":@"interstitial",
            @"title":@"Interstitial",
            @"class":@"ATInterstitialViewController",
            @"des":@"Include Interstitial and FullScreen.Appears at natural breaks or transition points.",
        
        },
        @{
            @"image":@"splash",
            @"title":@"Splash",
            @"class":@"ATSplashViewController",
            @"des":@"Displayed immediately after the application is launched.",
        },
        @{
            @"image":@"banner",
            @"title":@"Banner",
            @"class":@"ATBannerViewController",
            @"des":@"Flexible formats which could appear at the top, middle or bottom of your app.",
        },
        @{
            @"image":@"native",
            @"title":@"Native",
            @"class":@"ATNativeMainViewController",
            @"des":@"Include Native,Vertical Draw Video and Pre-roll Ads.Most compatible with your native app code for video ads and graphic ads.",
        },
        @{
            @"image":@"splash",
            @"title":@"CustomAdapterSplash",
            @"class":@"ATTMCustomSplashViewController",
            @"des":@"Displayed immediately after the application is launched.",
        }
    ];
}

- (void)setupUI
{
    [self setupNav];
    
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[ATHomeFootView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScaleW(150))];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

-(void)setupNav{

    UIView * navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,200,40)];
   
    UIImageView * logoIV = [[ UIImageView alloc]initWithImage:[UIImage imageNamed:@"Taku_logo"]];
    logoIV.frame = CGRectMake(0, 0, 40, 40);
    [navView addSubview:logoIV];

    UILabel * title = [[UILabel alloc]initWithFrame:CGRectZero];
    title.frame = CGRectMake(44+5, 0, 150, 40);
    title.font = [UIFont boldSystemFontOfSize:17];
    title.text = @"Taku Sdk Demo";
    [navView addSubview:title];
  

    self.navigationItem.titleView = navView;
    
}

- (IBAction)autoLoadEnable:(id)sender {
    self.autoLoadEnable = !self.autoLoadEnable;
    NSLog(@"auto load %@",self.autoLoadEnable ? @"enable" : @"disable");

    UIBarButtonItem *btnItem = self.navigationItem.rightBarButtonItem;
    UIButton *clearBtn = btnItem.customView;
    [clearBtn setTitleColor:self.autoLoadEnable ? [UIColor blackColor] : [UIColor lightGrayColor] forState:UIControlStateNormal];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kScaleW(238 + 10);
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ATHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ATHomeTableViewCell idString]];
    cell.backgroundColor = kRGB(245, 245, 245);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = self.dataSource[indexPath.row];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@", dic[@"title"]];
    cell.subTitleLabel.text = [NSString stringWithFormat:@"%@", dic[@"des"]];
    cell.logoImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", dic[@"image"]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.dataSource[indexPath.row];
    
    NSString *classString = [NSString stringWithFormat:@"%@", dic[@"class"]];
    Class class = NSClassFromString(classString);

    UIViewController *con = [class new];
    [self.navigationController pushViewController:con animated:YES];
}

#pragma mark - lazy
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        [_tableView registerClass:[ATHomeTableViewCell class] forCellReuseIdentifier:[ATHomeTableViewCell idString]];
    }
    return _tableView;
}

@end
