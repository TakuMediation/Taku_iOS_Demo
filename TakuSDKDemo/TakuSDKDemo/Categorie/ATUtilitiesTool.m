//
//  ATUtilitiesTool.m
//  TakuSDKDemo
//
//  Created by Taku on 8/2/22.
//  Copyright © 2022 AnyThink. All rights reserved.
//

#import "ATUtilitiesTool.h"

@implementation ATUtilitiesTool

+ (NSDictionary *)getNativeAdOfferExtraDic:(ATNativeAdOffer *)nativeAdOffer {
    NSMutableDictionary *extraDic = [NSMutableDictionary dictionary];
    [extraDic ATDemo_setDictValue:@(nativeAdOffer.networkFirmID) key:@"networkFirmID"];
    [extraDic ATDemo_setDictValue:nativeAdOffer.nativeAd.title key:@"title"];
    [extraDic ATDemo_setDictValue:nativeAdOffer.nativeAd.mainText key:@"mainText"];
    [extraDic ATDemo_setDictValue:nativeAdOffer.nativeAd.ctaText key:@"ctaText"];
    [extraDic ATDemo_setDictValue:nativeAdOffer.nativeAd.advertiser key:@"advertiser"];
    [extraDic ATDemo_setDictValue:nativeAdOffer.nativeAd.videoUrl key:@"videoUrl"];
    [extraDic ATDemo_setDictValue:nativeAdOffer.nativeAd.logoUrl key:@"logoUrl"];
    [extraDic ATDemo_setDictValue:nativeAdOffer.nativeAd.iconUrl key:@"iconUrl"];
    [extraDic ATDemo_setDictValue:nativeAdOffer.nativeAd.imageUrl key:@"imageUrl"];
    [extraDic ATDemo_setDictValue:@(nativeAdOffer.nativeAd.mainImageWidth) key:@"mainImageWidth"];
    [extraDic ATDemo_setDictValue:@(nativeAdOffer.nativeAd.mainImageHeight) key:@"mainImageHeight"];
    [extraDic ATDemo_setDictValue:nativeAdOffer.nativeAd.imageList key:@"imageList"];
    [extraDic ATDemo_setDictValue:@(nativeAdOffer.nativeAd.videoDuration) key:@"videoDuration"];
    [extraDic ATDemo_setDictValue:@(nativeAdOffer.nativeAd.videoAspectRatio) key:@"videoAspectRatio"];
    [extraDic ATDemo_setDictValue:@(nativeAdOffer.nativeAd.nativeExpressAdViewWidth) key:@"nativeExpressAdViewWidth"];
    [extraDic ATDemo_setDictValue:@(nativeAdOffer.nativeAd.nativeExpressAdViewHeight) key:@"nativeExpressAdViewHeight"];
    [extraDic ATDemo_setDictValue:@(nativeAdOffer.nativeAd.interactionType) key:@"interactionType"];
    [extraDic ATDemo_setDictValue:nativeAdOffer.nativeAd.mediaExt key:@"mediaExt"];
    [extraDic ATDemo_setDictValue:nativeAdOffer.nativeAd.source key:@"source"];
    [extraDic ATDemo_setDictValue:nativeAdOffer.nativeAd.rating key:@"rating"];
    [extraDic ATDemo_setDictValue:@(nativeAdOffer.nativeAd.commentNum) key:@"commentNum"];
    [extraDic ATDemo_setDictValue:@(nativeAdOffer.nativeAd.appSize) key:@"appSize"];
    [extraDic ATDemo_setDictValue:nativeAdOffer.nativeAd.appPrice key:@"appPrice"];
    [extraDic ATDemo_setDictValue:@(nativeAdOffer.nativeAd.isExpressAd) key:@"isExpressAd"];
    [extraDic ATDemo_setDictValue:@(nativeAdOffer.nativeAd.isVideoContents) key:@"isVideoContents"];
    [extraDic ATDemo_setDictValue:nativeAdOffer.nativeAd.icon key:@"iconImage"];
    [extraDic ATDemo_setDictValue:nativeAdOffer.nativeAd.logo key:@"logoImage"];
    [extraDic ATDemo_setDictValue:nativeAdOffer.nativeAd.mainImage key:@"mainImage"];
    return extraDic;
}

+ (NSString*) jsonString_anythink:(NSDictionary *)dic {
    NSError *error;
    NSData *jsonData;
    
    if (![NSJSONSerialization isValidJSONObject:dic]) {
      
        return @"{}";
    }
    
    @try {
        jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
    } @catch (NSException *exception) {
        
     
        return @"{}";
    } @finally {}
    
    if (!jsonData) {
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

+(BOOL)isEmpty:(id)object {
    
    if (object == nil || [object isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([object isKindOfClass:[NSString class]] && [(NSString *)object isEqualToString:@"(null)"]) {
        return YES;
    }
    
    if ([object respondsToSelector:@selector(length)]) {
        return [object length] == 0;
    }
    
    if ([object respondsToSelector:@selector(count)]) {
        return [object count] == 0;
    }
    return NO;
}

@end


@implementation NSMutableDictionary (ATDemoWeakly)

-(void)ATDemo_setDictValue:(id)value key:(NSString *)key {
    
    if ([key isKindOfClass:[NSString class]] == NO) {
        NSAssert(NO, @"key must str");
    }

    if(key != nil && [key respondsToSelector:@selector(length)] && key.length > 0){
        if ([ATUtilitiesTool isEmpty:value] == NO) {
            self[key] = value;
        }
//        if (value == nil) {
//            NSAssert(NO, @"value must not equal to nil");
//        }
    }else{
        NSAssert(NO, @"key must not equal to nil");
    }
}

@end
