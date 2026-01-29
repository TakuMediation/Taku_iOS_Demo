//
//  HomeViewController.m
//  iOSDemo
//
//  Created by ltz on 2025/1/5.
//

#import "HomeViewController.h"
#import "InterstitialVC.h"
#import "RewardedVC.h"
#import "SplashVC.h"
#import "BannerVC.h"
#import "NativeTypeSelectVC.h"
#import "IMAVC.h"
#import "BaseTabBarController.h"
#import "BaseNavigationController.h"
#import "TestModeTool.h"

@interface HomeViewController () <UITableViewDelegate,UITableViewDataSource>
 
@end

@implementation HomeViewController
 
#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120.0; // 每个cell的高度
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomTableViewCellIdentifier" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CustomTableViewCellIdentifier"];
    }
    
    NSDictionary *data = self.dataSource[indexPath.row];
    // 配置cell的titleLbl和subTitleLbl的文本
    cell.titleLbl.text = data[@"title"];
    cell.subTitleLbl.text = data[@"subtitle"];

    return cell;
}
 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *selectedItem = self.dataSource[indexPath.row][@"title"];
    ATDemoLog(@"Selected: %@", selectedItem);
    
    //Interstitial Ad Controller
    if ([selectedItem isEqualToString:kLocalizeStr(@"插屏广告")]) {
        InterstitialVC * vc = [InterstitialVC new];
        vc.title = selectedItem;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    //RewardVideo Ad Controller
    if ([selectedItem isEqualToString:kLocalizeStr(@"激励广告")]) {
        RewardedVC * vc = [RewardedVC new];
        vc.title = selectedItem;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    //Splash Ad Controller
    if ([selectedItem isEqualToString:kLocalizeStr(@"开屏广告")]) {
        BaseTabBarController * tabbarController = [[BaseTabBarController alloc] init];
        tabbarController.tabBar.barTintColor = [UIColor whiteColor];
        tabbarController.tabBar.translucent = NO;
        
        SplashVC * firstViewController = [SplashVC new];
        firstViewController.title = @"App Home";
        BaseNavigationController * navi = [[BaseNavigationController alloc] initWithRootViewController:firstViewController];
        
        UIViewController *secondViewController = [[UIViewController alloc] init];
        UIViewController *thirdViewController = [[UIViewController alloc] init];
         
        navi.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Ad" image:[UIImage imageNamed:@"home"]
                                                                         tag:1];
        
        secondViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Empty"
                                                                        image:[UIImage imageNamed:@""]
                                                                          tag:2];
        
        thirdViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Empty"
                                                                       image:[UIImage imageNamed:@""]
                                                                         tag:3];
         
        NSArray *viewControllersArray = @[navi, secondViewController, thirdViewController];
        tabbarController.viewControllers = viewControllersArray;
        tabbarController.fromController = self.navigationController;
        [self.navigationController pushViewController:tabbarController animated:NO];
    }
    
    //Banner Ad Controller
    if ([selectedItem isEqualToString:kLocalizeStr(@"横幅广告")]) {
        BannerVC * vc = [BannerVC new];
        vc.title = selectedItem;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    //Native Ad Controller
    if ([selectedItem isEqualToString:kLocalizeStr(@"原生广告")]) {
        NativeTypeSelectVC * vc = [NativeTypeSelectVC new];
        vc.title = selectedItem;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    //IMA Ad Controller
    if ([selectedItem isEqualToString:kLocalizeStr(@"插播广告")]) {
        IMAVC * vc = [IMAVC new];
        vc.title = selectedItem;
        [self.navigationController pushViewController:vc animated:YES];
    }
     
    if ([selectedItem isEqualToString:@"DebugUI"]) {
        [TestModeTool showDebugUI:self];
    }
}
 
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addHomeBar];
     
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.bar.mas_bottom);
    }];
}

@end
