//
//  DataUploadTool.h
//  iOSDemo
//
//  Created by ltz on 2025/3/26.
//

#import <Foundation/Foundation.h>
 
@interface DataUploadTool : NSObject


/// 上报信息给应用App的服务器，例如某一个广告位中的某一个广告源加载失败的信息
/// - Parameters:
///   - placementID: 广告位ID
///   - info: 广告源的信息,搜索参考文档"回调信息说明"，获取详细字段含义
+ (void)uploadAdSourceLoadFailed:(NSString *)placementID info:(NSMutableDictionary *)info;

/// 上报展示收益数据到AF
/// - Parameter extra: 代理回调中的extra参数
+ (void)handleAppsFlyerRevenueReport:(NSDictionary *)extra;

/// 上报展示收益数据到Adj
/// - Parameter extra: 代理回调中的extra参数
+ (void)handleAdjustRevenueReport:(NSDictionary *)extra;

/// 上报展示收益数据到Fir
/// - Parameter extra: 代理回调中的extra参数
+ (void)handleFirebaseRevenueReport:(NSDictionary *)extra;


@end
