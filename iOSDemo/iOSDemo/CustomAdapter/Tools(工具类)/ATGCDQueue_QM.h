//
//  GCDQueue.h
//  GCDObjC
//
//  Created by mac on 2020/9/21.
//  Copyright © 2020 AnyThink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ATGCDGroup;

static uint8_t mainQueueMarker[] = {0};
static uint8_t loadQueueMarker[] = {0};
static uint8_t waterfallQueueMarker[] = {0};

@interface ATGCDQueue_QM : NSObject

/**
 *  Returns the underlying dispatch queue object.
 *
 *  @return The dispatch queue object.
 */
@property (strong, readonly, nonatomic) dispatch_queue_t dispatchQueue;

+ (ATGCDQueue_QM *)logQueue;

/**
 *  Returns the serial dispatch queue associated with the application’s main thread.
 *
 *  @return The main queue. This queue is created automatically on behalf of the main thread before main is called.
 *  @see dispatch_get_main_queue()
 */
+ (ATGCDQueue_QM *)mainQueue;

/**
 *  Returns the default priority global concurrent queue.
 *
 *  @return The queue.
 *  @see dispatch_get_global_queue()
 */
+ (ATGCDQueue_QM *)globalQueue;

+ (ATGCDQueue_QM *)networkRequestQueue;

/**
 *  Returns the high priority global concurrent queue.
 *
 *  @return The queue.
 *  @see dispatch_get_global_queue()
 */
+ (ATGCDQueue_QM *)highPriorityGlobalQueue;

/**
 *  Returns the low priority global concurrent queue.
 *
 *  @return The queue.
 *  @see dispatch_get_global_queue()
 */
+ (ATGCDQueue_QM *)lowPriorityGlobalQueue;

/**
 *  Returns the background priority global concurrent queue.
 *
 *  @return The queue.
 *  @see dispatch_get_global_queue()
 */
+ (ATGCDQueue_QM *)backgroundPriorityGlobalQueue;

+ (ATGCDQueue_QM *)ioQueue;
+ (ATGCDQueue_QM *)loadQueue;
+ (ATGCDQueue_QM *)waterfallQueue;
+ (ATGCDQueue_QM *)tkQueue;
+ (ATGCDQueue_QM *)eventQueue;
+ (ATGCDQueue_QM *)winlossQueue;

+ (void)loadQueueCheck;
+ (void)waterfallQueueCheck;

+ (BOOL)isLoadQueue;
+ (BOOL)isWaterfallQueue;

+ (void*)loadQueueAddress;

/**
 *  Returns whether the current block is executing on the main queue.
 *
 *  @return YES if so, NO othewise.
 */
+ (BOOL)isMainQueue;

/**
 *  Initializes a new serial queue.
 *
 *  @return The initialized instance.
 *  @see dispatch_queue_create()
 */
- (instancetype)init;

/**
 *  Initializes a new serial queue.
 *
 *  @return The initialized instance.
 *  @see dispatch_queue_create()
 */
- (instancetype)initSerial;

/**
 *  Initializes a new concurrent queue.
 *
 *  @return The initialized instance.
 *  @see dispatch_queue_create()
 */
- (instancetype)initConcurrent;

/**
 *  The GCDQueue designated initializer.
 *
 *  @param dispatchQueue A dispatch_queue_t object.
 *  @return The initialized instance.
 */
- (instancetype)initWithDispatchQueue:(dispatch_queue_t)dispatchQueue;

/**
 *  Submits a block for asynchronous execution on the queue.
 *
 *  @param block The block to submit.
 *  @see dispatch_async()
 */
- (void)queueAsyncBlock:(dispatch_block_t)block;

/**
 *  Submits a block for asynchronous execution on the queue after a delay.
 *
 *  @param block The block to submit.
 *  @param seconds The delay in seconds.
 *  @see dispatch_after()
 */
- (void)queueBlock:(dispatch_block_t)block afterDelay:(double)seconds;

/**
 *  Submits a block for execution on the queue and waits until it completes.
 *
 *  @param block The block to submit.
 *  @see dispatch_sync()
 */
- (void)queueSyncBlock:(dispatch_block_t)block;

/**
 *  Submits a block for execution on the queue multiple times and waits until all executions complete.
 *
 *  @param block The block to submit.
 *  @param count The number of times to execute the block.
 *  @see dispatch_apply()
 */
- (void)queueAndAwaitBlock:(void (^)(size_t))block iterationCount:(size_t)count;
 
/**
 *  Submits a barrier block for asynchronous execution on the queue.
 *
 *  @param block The barrier block to submit.
 *  @see dispatch_barrier_async()
 */
- (void)queueBarrierBlock:(dispatch_block_t)block;

/**
 *  Submits a barrier block for execution on the queue and waits until it completes.
 *
 *  @param block The barrier block to submit.
 *  @see dispatch_barrier_sync()
 */
- (void)queueAndAwaitBarrierBlock:(dispatch_block_t)block;

/**
 *  Suspends execution of blocks on the queue.
 *
 *  @see dispatch_suspend()
 */
- (void)suspend;

/**
 *  Resumes execution of blocks on the queue.
 *
 *  @see dispatch_resume()
 */
- (void)resume;

/**
 *  Returns the context associated with a key.
 *
 *  @see dispatch_get_specific()
 */
- (void *)contextForKey:(const void *)key;

/**
 *  Sets the context associated with a key.
 *
 *  @see dispatch_queue_set_specific()
 */
- (void)setContext:(void *)context forKey:(const void *)key;

@end
