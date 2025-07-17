//
//  FeedTemplateVC.m
//  iOSDemo
//
//  Created by ltz on 2025/2/8.
//

#import "FeedTemplateVC.h"
#import <AnyThinkNative/AnyThinkNative.h>

#import <MJRefresh/MJRefresh.h>
#import "SelfRenderView.h"
#import "DemoOfferAdModel.h"
//广告cell
#import "AdCell.h"
//非广告cell
#import "CustomCell.h"
 
@interface FeedTemplateVC () <ATNativeADDelegate,UITableViewDelegate,UITableViewDataSource>
  
@property (nonatomic, strong) ATNativeAdOffer * nativeAdOffer;
@property (nonatomic, strong) NSMutableArray <DemoOfferAdModel *> * dataSourceArray;
@property (nonatomic, strong) UITableView * feedTableView;
@property (strong, nonatomic) ATNativeADView * adv;

@end

@implementation FeedTemplateVC

//广告位ID
#define Feed_Native_Express_PlacementID @"b680af4b2bb0a9"

//场景ID，可选，可在后台生成。没有可传入空字符串
#define Feed_Native_Express_SceneID @""

#define Feed_Cell_ExpressAdWidth (kScreenW-30)
#define Feed_Cell_ExpressAdHeight (168.f)
#define Feed_Cell_ExpressMediaViewWidth (kScreenW-30)
#define Feed_Cell_ExpressMediaViewHeight (350 - kNavigationBarHeight - 150)
 
- (void)dealloc {
    NSLog(@"FeedTemplateVC dealloc");
    //销毁没有释放的广告
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataSourceArray[indexPath.row].isNativeAd) {
        DemoOfferAdModel *offerModel = self.dataSourceArray[indexPath.row];
        if (offerModel.offer.nativeAd.isExpressAd && offerModel.offer.nativeAd.nativeExpressAdViewHeight != 0) {
            //取模版高度
            return offerModel.offer.nativeAd.nativeExpressAdViewHeight;
        }
        return UITableViewAutomaticDimension;
    }
    //其他cell，自定义高度
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DemoOfferAdModel *offerModel = self.dataSourceArray[indexPath.row];
    
    if (offerModel.isNativeAd) {
        // 存在新的广告，可以刷新
        ATNativeAdOffer *offer = [self getOfferAndLoadNext];
        if (offer) {
            offerModel.nativeADView = [self getNativeADViewWithOffer:offer];
            offerModel.offer = offer;
        }
        AdCell *cell = [[AdCell alloc] initWithStyle:0 reuseIdentifier:@"AdCell"];;
        ATDemoLog(@"adView之前--%@",cell.adView);
        cell.adView = offerModel.nativeADView;
        ATDemoLog(@"adView之后--%@",cell.adView);
        return cell;
        
    }else{
        CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell"];
        return cell;
    }
}
 
/// 通过广告offer获取ATNativeADView对象
/// - Parameter offer: 已获取到的广告offer
- (ATNativeADView *)getNativeADViewWithOffer:(ATNativeAdOffer *)offer {
  
    // 初始化config配置
    ATNativeADConfiguration *config = [[ATNativeADConfiguration alloc] init];
    // 给模版广告nativeADView设置大小，通常为请求广告时设置的大小
    config.ADFrame = CGRectMake(0, 0, Feed_Cell_ExpressAdWidth, Feed_Cell_ExpressAdHeight);
    config.delegate = self;
    //设置展示根控制器
    config.rootViewController = self;
    // 开启模版广告自适应高度，当实际返回的广告大小与请求广告时设置的大小不一致时，SDK内部将自动调整nativeADView的大小为实际返回广告的大小。
    config.sizeToFit = YES;
    //设置仅wifi模式才自动播放，部分广告平台有效
    config.videoPlayType = ATNativeADConfigVideoPlayOnlyWiFiAutoPlayType;
    
    // 创建广告nativeADView
    ATNativeADView *nativeADView = [[ATNativeADView alloc] initWithConfiguration:config currentOffer:offer placementID:Feed_Native_Express_PlacementID];
    
    //渲染广告
    [offer rendererWithConfiguration:config selfRenderView:nil nativeADView:nativeADView];
  
    return nativeADView;
}

#pragma mark - 数据处理 data execute
/// 添加数据源
/// - Parameter isSuccess: 广告加载是否成功
- (void)setDataWithRequest:(BOOL)isSuccess {
    if (isSuccess) {
        //加载广告成功，获取offer并添加数据模型
        ATNativeAdOffer *offer = [self getOfferAndLoadNext];
        if (offer) {
            DemoOfferAdModel *offerModel = [[DemoOfferAdModel alloc] init];
            offerModel.nativeADView = [self getNativeADViewWithOffer:offer];;
            offerModel.offer = offer;
            //标记为广告
            offerModel.isNativeAd = YES;
            [self.dataSourceArray addObject:offerModel];
        }
    }
    
    //添加非广告model，模拟开发者自己的业务Cell
    for (int i = 0; i < 3; i ++) {
        DemoOfferAdModel *offerModel1 = [[DemoOfferAdModel alloc] init];
        offerModel1.isNativeAd = NO;
        [self.dataSourceArray addObject:offerModel1];
    }
    [self.feedTableView reloadData];
}

/// 获取offer并且发起下一次load
- (ATNativeAdOffer *)getOfferAndLoadNext {
    
    //场景统计功能，可选接入
    [[ATAdManager sharedManager] entryNativeScenarioWithPlacementID:Feed_Native_Express_PlacementID scene:Feed_Native_Express_SceneID];
    
    ATNativeAdOffer *offer = [[ATAdManager sharedManager] getNativeAdOfferWithPlacementID:Feed_Native_Express_PlacementID];
    // load next
    [self loadNativeAd];
    return offer;
}

/// 用户点击close，从列表中移除广告
/// - Parameter nativeADView: 广告adView
- (void)removeAd:(ATNativeADView *)nativeADView {
    for (int i=0; i<self.dataSourceArray.count; i++) {
        DemoOfferAdModel *offerModel = self.dataSourceArray[i];
        if (offerModel.isNativeAd && offerModel.nativeADView == nativeADView) {
            
            if (nativeADView && nativeADView.superview) {
                [nativeADView removeFromSuperview];
            }
            //销毁广告视图
            [nativeADView destroyNative];
            //销毁offer
            offerModel.offer = nil;
            offerModel.nativeADView = nil;
            
            [self.dataSourceArray removeObject:offerModel];
            [self.feedTableView reloadData];
             
            break;
        }
    }
}
 
#pragma mark - 广告位代理回调
/// 广告位加载完成
/// - Parameter placementID: 广告位ID
- (void)didFinishLoadingADWithPlacementID:(NSString *)placementID {
    BOOL isReady = [[ATAdManager sharedManager] nativeAdReadyForPlacementID:placementID];
    [self showLog:[NSString stringWithFormat:@"didFinishLoadingADWithPlacementID:%@ SelfRender 是否准备好:%@", placementID,isReady ? @"YES":@"NO"]];
    
    if (self.feedTableView.mj_footer.refreshing == YES) {
        [self.feedTableView.mj_footer endRefreshing];
        [self setDataWithRequest:YES];
    }
}
 
/// 广告位加载失败
/// - Parameters:
///   - placementID: 广告位ID
///   - error: 错误信息
- (void)didFailToLoadADWithPlacementID:(NSString *)placementID error:(NSError *)error {
    ATDemoLog(@"didFailToLoadADWithPlacementID:%@ error:%@", placementID, error);
    [self showLog:[NSString stringWithFormat:@"didFailToLoadADWithPlacementID:%@ errorCode:%ld", placementID, error.code]];
    
    if (self.feedTableView.mj_footer.refreshing == YES) {
        [self.feedTableView.mj_footer endRefreshing];
        [self setDataWithRequest:NO];
    }
}

/// 获得展示收益
/// - Parameters:
///   - placementID: 广告位ID
///   - extra: 额外信息字典
- (void)didRevenueForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"didRevenueForPlacementID:%@ with extra: %@", placementID,extra);
    [self showLog:[NSString stringWithFormat:@"didRevenueForPlacementID:%@", placementID]];
}

#pragma mark - 原生广告事件回调

/// 原生广告已展示
/// - Parameters:
///   - adView: 广告视图对象
///   - placementID: 广告位ID
///   - extra: 额外信息
- (void)didShowNativeAdInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"didShowNativeAdInAdView:%@ extra:%@",placementID,extra);
    [self showLog:[NSString stringWithFormat:@"didShowNativeAdInAdView:%@", placementID]];
    
    ATDemoLog(@"🔥--原生广告adInfo信息，展示后：%@",self.nativeAdOffer.adOfferInfo);
}

/// 原生广告点击了关闭按钮
/// - Parameters:
///   - adView: 广告视图对象
///   - placementID: 广告位ID
///   - extra: 额外信息
- (void)didTapCloseButtonInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"didTapCloseButtonInAdView:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"didTapCloseButtonInAdView:%@", placementID]];
    
    //从列表移除
    [self removeAd:adView];
}

/// 原生广告开始播放视频
/// - Parameters:
///   - adView: 广告视图对象
///   - placementID: 广告位ID
///   - extra: 额外信息字典
- (void)didStartPlayingVideoInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"didStartPlayingVideoInAdView:%@ extra: %@", placementID,extra);
    [self showLog:[NSString stringWithFormat:@"didStartPlayingVideoInAdView:%@", placementID]];
}

/// 原生广告视频播放结束
/// - Parameters:
///   - adView: 广告视图对象
///   - placementID: 广告位ID
///   - extra: 额外信息字典
- (void)didEndPlayingVideoInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"didEndPlayingVideoInAdView:%@ extra: %@", placementID,extra);
    [self showLog:[NSString stringWithFormat:@"didEndPlayingVideoInAdView:%@", placementID]];
}

/// 原生广告用户已点击
/// - Parameters:
///   - adView: 广告视图对象
///   - placementID: 广告位ID
///   - extra: 额外信息字典
- (void)didClickNativeAdInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"didClickNativeAdInAdView:%@ extra:%@",placementID,extra);
    [self showLog:[NSString stringWithFormat:@"didClickNativeAdInAdView:%@", placementID]];
}
 
/// 原生广告已打开或跳转深链接页面
/// - Parameters:
///   - adView: 广告视图对象
///   - placementID: 广告位ID
///   - extra: 额外信息
///   - success: 是否成功
- (void)didDeepLinkOrJumpInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra result:(BOOL)success {
    ATDemoLog(@"didDeepLinkOrJumpInAdView:placementID:%@ with extra: %@, success:%@", placementID,extra, success ? @"YES" : @"NO");
    [self showLog:[NSString stringWithFormat:@"didDeepLinkOrJumpInAdView:%@, success:%@", placementID, success ? @"YES" : @"NO"]];
}
 
/// 原生广告已进入全屏视频播放，通常是点击视频meidaView后自动跳转至一个播放落地页
/// - Parameters:
///   - adView: 广告视图对象
///   - placementID: 广告位ID
///   - extra: 额外信息
- (void)didEnterFullScreenVideoInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra{
    ATDemoLog(@"didEnterFullScreenVideoInAdView:%@", placementID);
    [self showLog:[NSString stringWithFormat:@"didEnterFullScreenVideoInAdView:%@", placementID]];
}

/// 原生广告已退出全屏视频播放
/// - Parameters:
///   - adView: 广告视图对象
///   - placementID: 广告位ID
///   - extra: 额外信息
- (void)didExitFullScreenVideoInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"didExitFullScreenVideoInAdView:%@", placementID);
    [self showLog:[NSString stringWithFormat:@"didExitFullScreenVideoInAdView:%@", placementID]];
}
 
/// 原生广告已退出详情页面
/// - Parameters:
///   - adView: 广告视图对象
///   - placementID: 广告位ID
///   - extra: 额外信息
- (void)didCloseDetailInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"didCloseDetailInAdView:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"didCloseDetailInAdView:%@", placementID]];
}

#pragma mark - TableView Data Refresh
- (void)footerRefresh {
    self.feedTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upFreshLoadMoreData)];
    [self.feedTableView.mj_footer beginRefreshing];
}

/// 加载更多
- (void)upFreshLoadMoreData {
    [self loadNativeAd];
}
 
/// 加载广告
- (void)loadNativeAd {
    NSMutableDictionary * loadConfigDict = [NSMutableDictionary dictionary];
    
    //请求模版广告，指定一个大小，广告平台会匹配这个大小返回广告，不一定完全匹配，和广告平台后台勾选的模版类型有关
    [loadConfigDict setValue:[NSValue valueWithCGSize:CGSizeMake(Feed_Cell_ExpressAdWidth, Feed_Cell_ExpressAdHeight)] forKey:kATExtraInfoNativeAdSizeKey];
    
    [[ATAdManager sharedManager] loadADWithPlacementID:Feed_Native_Express_PlacementID extra:loadConfigDict delegate:self];
}
 
#pragma mark - getter
- (UITableView *)feedTableView {
    if (!_feedTableView) {
        _feedTableView = [[UITableView alloc] init];
        _feedTableView.delegate = self;
        _feedTableView.dataSource = self;
        _feedTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        //绑定cell
        [_feedTableView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellReuseIdentifier:@"CustomCell"];
        [_feedTableView registerClass:[AdCell class] forCellReuseIdentifier:@"AdCell"];
        
        //给一个合理的高度预估值
        _feedTableView.estimatedRowHeight = Feed_Cell_ExpressAdHeight; // 设置一个合理的预估值
        _feedTableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _feedTableView;
}

- (NSMutableArray *)dataSourceArray {
    if (_dataSourceArray) return _dataSourceArray;
    NSMutableArray *dataSourceArray = [NSMutableArray new];
    return _dataSourceArray = dataSourceArray;
}
 
#pragma mark - Demo UI
- (void)viewDidLoad {
    [super viewDidLoad];
     
    [self.view addSubview:self.feedTableView];
    [self.feedTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nbar.mas_bottom);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    [self footerRefresh];
}
 
@end
