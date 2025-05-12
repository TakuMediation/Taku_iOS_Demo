//
//  SplashTypeSelectVC.m
//  iOSDemo
//
//  Created by ltz on 2025/1/18.
//

#import "SplashTypeSelectVC.h"
#import "SplashWithCustomBGVC.h"
#import "BaseNavigationController.h"
#import "BaseTabBarController.h"

@interface SplashTypeSelectVC () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation SplashTypeSelectVC

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *selectedItem = self.dataSource[indexPath.row][@"title"];
    ATDemoLog(@"Selected: %@", selectedItem);
    if ([selectedItem isEqualToString:kLocalizeStr(@"推荐场景演示")]) {
        
        BaseTabBarController * tabbarController = [[BaseTabBarController alloc] init];
        tabbarController.tabBar.barTintColor = [UIColor whiteColor];
        tabbarController.tabBar.translucent = NO;
        
        SplashWithCustomBGVC * firstViewController = [SplashWithCustomBGVC new];
         
        BaseNavigationController * navi = [[BaseNavigationController alloc] initWithRootViewController:firstViewController];
        
        UIViewController *secondViewController = [[UIViewController alloc] init];
        UIViewController *thirdViewController = [[UIViewController alloc] init];
        
        // 为每个ViewController创建相应的UITabBarItem
        navi.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"有广告" image:[UIImage imageNamed:@"home"] // 这里替换成相应的图片
                                                                         tag:1];
        
        secondViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"空的"
                                                                        image:[UIImage imageNamed:@""] // 这里替换成相应的图片
                                                                          tag:2];
        
        thirdViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"空的"
                                                                       image:[UIImage imageNamed:@""] // 这里替换成相应的图片
                                                                         tag:3];
        
        // 将ViewController数组设置给UITabBarController
        NSArray *viewControllersArray = @[navi, secondViewController, thirdViewController];
        tabbarController.viewControllers = viewControllersArray;
        tabbarController.fromController = self.navigationController;
        [self.navigationController pushViewController:tabbarController animated:YES];
    }
}

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
  
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNormalBarWithTitle:self.title];
     
    // 初始化数据源
    self.dataSource = @[
        @{@"title": kLocalizeStr(@"推荐场景演示"), @"subtitle": kLocalizeStr(@"在开发者最常见的开屏场景中展示广告，这是我们推荐的集成方式")},
    ];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.nbar.mas_bottom);
    }];
}

@end
