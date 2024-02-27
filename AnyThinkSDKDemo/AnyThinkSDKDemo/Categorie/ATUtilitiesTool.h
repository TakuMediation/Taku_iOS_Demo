//
//  ATUtilitiesTool.h
//  AnyThinkSDKDemo
//
//  Created by Taku on 8/2/22.
//  Copyright © 2022 AnyThink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AnyThinkNative/AnyThinkNative.h>

NS_ASSUME_NONNULL_BEGIN

@interface ATUtilitiesTool : NSObject

+(BOOL)isEmpty:(id)object;
+ (NSString*) jsonString_anythink:(NSDictionary *)dic;
// for native
+ (NSDictionary *)getNativeAdOfferExtraDic:(ATNativeAdOffer *)nativeAdOffer;

@end

@interface NSMutableDictionary(ATDemoWeakly)
-(void)ATDemo_setDictValue:(id)value key:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
