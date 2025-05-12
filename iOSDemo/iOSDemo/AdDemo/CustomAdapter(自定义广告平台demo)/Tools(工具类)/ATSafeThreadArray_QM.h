//  ATSafeThreadArray_QM.h
//  ATSDK
//
//  Created by mac on 2020/9/21.
//  Copyright © 2020 AnyThink. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 A simple implementation of thread safe mutable array.
 
 @discussion Generally, access performance is lower than NSMutableArray, 
 but higher than using @synchronized, NSLock, or pthread_mutex_t.

 @warning Fast enumerate(for..in) and enumerator is not thread safe,
 use enumerate using block instead. When enumerate or sort with block/callback,
 do *NOT* send message to the array inside the block/callback.
 */
@interface ATSafeThreadArray_QM<ObjectType> : NSMutableArray

@end
