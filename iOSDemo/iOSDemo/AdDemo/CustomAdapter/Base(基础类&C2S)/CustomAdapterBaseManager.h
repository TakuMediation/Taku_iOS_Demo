//
//  CustomAdapterBaseManager.h
//  AnyThinkSDK
//
//  Created by Captain on 2024/9/12.
//  Copyright © 2024 AnyThink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATSafeThreadDictionary_QM.h"
#import "ATSafeThreadArray_QM.h"
#import "ATGCDQueue_QM.h"
 
@interface CustomAdapterBaseManager : NSObject

+ (instancetype)sharedManager;

+ (void)initWithCustomInfo:(NSDictionary *)serverInfo localInfo:(NSDictionary *)localInfo;

@end 
