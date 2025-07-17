//
//  GCDQueue.m
//  GCDObjC
//
//  Created by mac on 2020/9/21.
//  Copyright © 2020 AnyThink. All rights reserved.
//
 
#import "ATGCDQueue_QM.h"

static ATGCDQueue_QM *logQueue;
static ATGCDQueue_QM *mainQueue;
static ATGCDQueue_QM *globalQueue;
static ATGCDQueue_QM *highPriorityGlobalQueue;
static ATGCDQueue_QM *lowPriorityGlobalQueue;
static ATGCDQueue_QM *backgroundPriorityGlobalQueue;
static ATGCDQueue_QM *ioQueue;
static ATGCDQueue_QM *loadQueue;
static ATGCDQueue_QM *waterfallQueue;
static ATGCDQueue_QM *tkQueue;
static ATGCDQueue_QM *eventQueue;
static ATGCDQueue_QM *winlossQueue;
static ATGCDQueue_QM *networkRequestQueue;

@interface ATGCDQueue_QM ()
@property (strong, readwrite, nonatomic) dispatch_queue_t dispatchQueue;
@end

@implementation ATGCDQueue_QM
 
+ (ATGCDQueue_QM *)mainQueue {
  return mainQueue;
}

+ (ATGCDQueue_QM *)logQueue {
  return logQueue;
}

+ (ATGCDQueue_QM *)networkRequestQueue {
    return networkRequestQueue;
}

+ (ATGCDQueue_QM *)globalQueue {
  return globalQueue;
}

+ (ATGCDQueue_QM *)highPriorityGlobalQueue {
  return highPriorityGlobalQueue;
}

+ (ATGCDQueue_QM *)lowPriorityGlobalQueue {
  return lowPriorityGlobalQueue;
}

+ (ATGCDQueue_QM *)backgroundPriorityGlobalQueue {
  return backgroundPriorityGlobalQueue;
}

+ (ATGCDQueue_QM *)ioQueue {
  return ioQueue;
}

+ (ATGCDQueue_QM *)loadQueue {
  return loadQueue;
}

+ (ATGCDQueue_QM *)waterfallQueue {
  return waterfallQueue;
}

+ (ATGCDQueue_QM *)tkQueue {
    return tkQueue;
}

+ (ATGCDQueue_QM *)eventQueue {
    return eventQueue;
}

+ (ATGCDQueue_QM *)winlossQueue {
    return winlossQueue;
}

+ (void*)loadQueueAddress {
    void* address = dispatch_get_specific(loadQueueMarker);
    return address;
}

+ (BOOL)isLoadQueue {
    //如果有把load queue里面的线程放到其他queue执行，就需要这样判断
//    dispatch_queue_t queue = loadQueue_t;
//    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(queue)) == 0) {
//
//    }
    
    return dispatch_get_specific(loadQueueMarker) == loadQueueMarker;
}

+ (BOOL)isWaterfallQueue {
    //如果有把load queue里面的线程放到其他queue执行，就需要这样判断
//    dispatch_queue_t queue = loadQueue_t;
//    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(queue)) == 0) {
//
//    }
    
  return dispatch_get_specific(waterfallQueueMarker) == waterfallQueueMarker;
}

+ (void)waterfallQueueCheck {
    if (![ATGCDQueue_QM isLoadQueue]) {
        ATLogFault("必须在Load Queue运行");
    }
}

+ (void)loadQueueCheck {
    if (![ATGCDQueue_QM isLoadQueue]) {
//        ATLogFault("必须在Load Queue运行");
    }
}

+ (BOOL)isMainQueue {
  return dispatch_get_specific(mainQueueMarker) == mainQueueMarker;
}
 
+ (void)initialize {
  if (self == [ATGCDQueue_QM class]) {
      
      mainQueue = [[ATGCDQueue_QM alloc] initWithDispatchQueue:dispatch_get_main_queue()];
      globalQueue = [[ATGCDQueue_QM alloc] initWithDispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
      highPriorityGlobalQueue = [[ATGCDQueue_QM alloc] initWithDispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)];
      lowPriorityGlobalQueue = [[ATGCDQueue_QM alloc] initWithDispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)];
      backgroundPriorityGlobalQueue = [[ATGCDQueue_QM alloc] initWithDispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)];
      dispatch_queue_t logQueue_t = dispatch_queue_create("com.anythink.logQueue", DISPATCH_QUEUE_SERIAL);
      logQueue = [[ATGCDQueue_QM alloc] initWithDispatchQueue:logQueue_t];
      
      dispatch_queue_t ioQueue_t = dispatch_queue_create("com.anythink.ioQueue", DISPATCH_QUEUE_SERIAL);
      ioQueue = [[ATGCDQueue_QM alloc] initWithDispatchQueue:ioQueue_t];
      
      dispatch_queue_t loadQueue_t = dispatch_queue_create("com.anythink.loadQueue", DISPATCH_QUEUE_SERIAL);
      loadQueue = [[ATGCDQueue_QM alloc] initWithDispatchQueue:loadQueue_t];
      
      dispatch_queue_t waterfallQueue_t = dispatch_queue_create("com.anythink.waterfallQueue", DISPATCH_QUEUE_SERIAL);
      waterfallQueue = [[ATGCDQueue_QM alloc] initWithDispatchQueue:waterfallQueue_t];
      
      dispatch_queue_t tkQueue_t = dispatch_queue_create("com.anythink.tkQueue", DISPATCH_QUEUE_SERIAL);
      tkQueue = [[ATGCDQueue_QM alloc] initWithDispatchQueue:tkQueue_t];
      
      dispatch_queue_t eventQueue_t = dispatch_queue_create("com.anythink.eventQueue", DISPATCH_QUEUE_SERIAL);
      eventQueue = [[ATGCDQueue_QM alloc] initWithDispatchQueue:eventQueue_t];
      
      dispatch_queue_t winlossQueue_t = dispatch_queue_create("com.anythink.winlossQueue", DISPATCH_QUEUE_SERIAL);
      winlossQueue = [[ATGCDQueue_QM alloc] initWithDispatchQueue:winlossQueue_t];
      
      dispatch_queue_t networkRequestQueue_t = dispatch_queue_create("com.anythink.networkRequestQueue", DISPATCH_QUEUE_CONCURRENT);
      networkRequestQueue = [[ATGCDQueue_QM alloc] initWithDispatchQueue:networkRequestQueue_t];
      
      [mainQueue setContext:mainQueueMarker forKey:mainQueueMarker];
      [loadQueue setContext:loadQueueMarker forKey:loadQueueMarker];
      [waterfallQueue setContext:waterfallQueueMarker forKey:waterfallQueueMarker];
  }
}

- (instancetype)init {
  return [self initSerial];
}

- (instancetype)initSerial {
  return [self initWithDispatchQueue:dispatch_queue_create("com.anyThink.serial", DISPATCH_QUEUE_SERIAL)];
}

- (instancetype)initConcurrent {
  return [self initWithDispatchQueue:dispatch_queue_create("com.anyThink.concurrent", DISPATCH_QUEUE_CONCURRENT)];
}

- (instancetype)initWithDispatchQueue:(dispatch_queue_t)dispatchQueue {
  if ((self = [super init]) != nil) {
    self.dispatchQueue = dispatchQueue;
  }
  
  return self;
}

#pragma mark Public methods.

- (void)queueAsyncBlock:(dispatch_block_t)block {
  dispatch_async(self.dispatchQueue, block);
}

- (void)queueSyncBlock:(dispatch_block_t)block {
  dispatch_sync(self.dispatchQueue, block);
}


- (void)queueBlock:(dispatch_block_t)block afterDelay:(double)seconds {
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (seconds * NSEC_PER_SEC)), self.dispatchQueue, block);
}


- (void)queueAndAwaitBlock:(void (^)(size_t))block iterationCount:(size_t)count {
  dispatch_apply(count, self.dispatchQueue, block);
}
 
- (void)queueBarrierBlock:(dispatch_block_t)block {
  dispatch_barrier_async(self.dispatchQueue, block);
}

- (void)queueAndAwaitBarrierBlock:(dispatch_block_t)block {
  dispatch_barrier_sync(self.dispatchQueue, block);
}

- (void)suspend {
  dispatch_suspend(self.dispatchQueue);
}

- (void)resume {
  dispatch_resume(self.dispatchQueue);
}

- (void *)contextForKey:(const void *)key {
  return dispatch_get_specific(key);
}

- (void)setContext:(void *)context forKey:(const void *)key {
  dispatch_queue_set_specific(self.dispatchQueue, key, context, NULL);
}

@end
