//  ATSafeThreadDictionary_QM.h
//  ATSDK
//
//  Created by mac on 2020/9/21.
//  Copyright © 2020 AnyThink. All rights reserved.
//

#import "ATSafeThreadDictionary_QM.h"
#import <pthread.h>


#define INIT(...) self = super.init; \
if (!self) return nil; \
__VA_ARGS__; \
if (!_dic) return nil; \
[self __initMutex:&_mutex_lock];\
return self;


#define LOCK(...) pthread_mutex_lock(&_mutex_lock); \
__VA_ARGS__; \
pthread_mutex_unlock(&_mutex_lock);

@implementation ATSafeThreadDictionary_QM {
    NSMutableDictionary *_dic;  //Subclass a class cluster...
    pthread_mutex_t _mutex_lock;
    pthread_mutexattr_t _attr;

}

#pragma mark - init

- (void)__initMutex:(pthread_mutex_t *)mutex {
    // 递归锁：允许同一个线程对一把锁进行重复加锁
    // 初始化属性
    pthread_mutexattr_init(&_attr);
    pthread_mutexattr_settype(&_attr, PTHREAD_MUTEX_RECURSIVE);
    // 初始化锁
    pthread_mutex_init(mutex, &_attr);
}

- (instancetype)init {
    
    INIT(_dic = [[NSMutableDictionary alloc] init]);
}

- (instancetype)initWithObjects:(NSArray *)objects forKeys:(NSArray *)keys {
    INIT(_dic =  [[NSMutableDictionary alloc] initWithObjects:objects forKeys:keys]);
}

- (instancetype)initWithCapacity:(NSUInteger)capacity {
    INIT(_dic = [[NSMutableDictionary alloc] initWithCapacity:capacity]);
}

- (instancetype)initWithObjects:(const id[])objects forKeys:(const id <NSCopying>[])keys count:(NSUInteger)cnt {
    INIT(_dic = [[NSMutableDictionary alloc] initWithObjects:objects forKeys:keys count:cnt]);
}

- (instancetype)initWithDictionary:(NSDictionary *)otherDictionary {
    INIT(_dic = [[NSMutableDictionary alloc] initWithDictionary:otherDictionary]);
}

- (instancetype)initWithDictionary:(NSDictionary *)otherDictionary copyItems:(BOOL)flag {
    INIT(_dic = [[NSMutableDictionary alloc] initWithDictionary:otherDictionary copyItems:flag]);
}


#pragma mark - method

- (NSUInteger)count {
    LOCK(NSUInteger c = _dic.count); return c;
}

- (id)objectForKey:(id)aKey {
    LOCK(id o = [_dic objectForKey:aKey]); return o;
}

- (NSEnumerator *)keyEnumerator {
    LOCK(NSEnumerator * e = [_dic keyEnumerator]); return e;
}

- (NSArray *)allKeys {
    LOCK(NSArray * a = [_dic allKeys]); return a;
}

- (NSArray *)allKeysForObject:(id)anObject {
    LOCK(NSArray * a = [_dic allKeysForObject:anObject]); return a;
}

- (NSArray *)allValues {
    LOCK(NSArray * a = [_dic allValues]); return a;
}

- (NSString *)description {
    LOCK(NSString * d = [_dic description]); return d;
}

- (NSString *)descriptionInStringsFileFormat {
    LOCK(NSString * d = [_dic descriptionInStringsFileFormat]); return d;
}

- (NSString *)descriptionWithLocale:(id)locale {
    LOCK(NSString * d = [_dic descriptionWithLocale:locale]); return d;
}

- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level {
    LOCK(NSString * d = [_dic descriptionWithLocale:locale indent:level]); return d;
}

- (BOOL)isEqualToDictionary:(NSDictionary *)otherDictionary {
    if (otherDictionary == self) return YES;
    
    if ([otherDictionary isKindOfClass:ATSafeThreadDictionary_QM.class]) {
        ATSafeThreadDictionary_QM *other = (id)otherDictionary;
        BOOL isEqual;
        pthread_mutex_lock(&_mutex_lock);
        pthread_mutex_lock(&(other->_mutex_lock));
        isEqual = [_dic isEqual:other->_dic];
        pthread_mutex_unlock(&_mutex_lock);
        pthread_mutex_unlock(&(other->_mutex_lock));
        return isEqual;
    }
    return NO;
}

- (NSEnumerator *)objectEnumerator {
    LOCK(NSEnumerator * e = [_dic objectEnumerator]); return e;
}

- (NSArray *)objectsForKeys:(NSArray *)keys notFoundMarker:(id)marker {
    LOCK(NSArray * a = [_dic objectsForKeys:keys notFoundMarker:marker]); return a;
}

- (NSArray *)keysSortedByValueUsingSelector:(SEL)comparator {
    LOCK(NSArray * a = [_dic keysSortedByValueUsingSelector:comparator]); return a;
}

- (void)getObjects:(id __unsafe_unretained[])objects andKeys:(id __unsafe_unretained[])keys {
    LOCK([_dic getObjects:objects andKeys:keys]);
}

- (id)objectForKeyedSubscript:(id)key {
    LOCK(id o = [_dic objectForKeyedSubscript:key]); return o;
}


- (void)enumerateKeysAndObjectsUsingBlock:(__attribute__((noescape)) void (^)(id key, id obj, BOOL *stop))block  {
    LOCK([_dic enumerateKeysAndObjectsUsingBlock:block]);
}

- (void)enumerateKeysAndObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(__attribute__((noescape)) void (^)(id key, id obj, BOOL *stop))block {
    LOCK([_dic enumerateKeysAndObjectsWithOptions:opts usingBlock:block]);
}

- (NSArray *)keysSortedByValueUsingComparator:(__attribute__((noescape)) NSComparator)cmptr {
    LOCK(NSArray * a = [_dic keysSortedByValueUsingComparator:cmptr]); return a;
}

- (NSArray *)keysSortedByValueWithOptions:(NSSortOptions)opts usingComparator:(__attribute__((noescape)) NSComparator)cmptr {
    LOCK(NSArray * a = [_dic keysSortedByValueWithOptions:opts usingComparator:cmptr]); return a;
}

- (NSSet *)keysOfEntriesPassingTest:(__attribute__((noescape)) BOOL (^)(id key, id obj, BOOL *stop))predicate {
    LOCK(NSSet * a = [_dic keysOfEntriesPassingTest:predicate]); return a;
}

- (NSSet *)keysOfEntriesWithOptions:(NSEnumerationOptions)opts passingTest:(__attribute__((noescape)) BOOL (^)(id key, id obj, BOOL *stop))predicate {
    LOCK(NSSet * a = [_dic keysOfEntriesWithOptions:opts passingTest:predicate]); return a;
}

#pragma mark - mutable

- (void)removeObjectForKey:(id)aKey {
    LOCK(
         if (aKey) {
             [_dic removeObjectForKey:aKey];
         });
}

- (void)setObject:(id)anObject forKey:(id <NSCopying> )aKey {
    LOCK(
         if (anObject && aKey) {
             [_dic setObject:anObject forKey:aKey];
    });
}

- (void)addEntriesFromDictionary:(NSDictionary *)otherDictionary {
    LOCK(
         if (otherDictionary) {
             [_dic addEntriesFromDictionary:otherDictionary];
         });
}

- (void)removeAllObjects {
    LOCK([_dic removeAllObjects]);
}

- (void)removeObjectsForKeys:(NSArray *)keyArray {
    LOCK([_dic removeObjectsForKeys:keyArray]);
}

- (void)setDictionary:(NSDictionary *)otherDictionary {
    LOCK(
         if (otherDictionary) {
             [_dic setDictionary:otherDictionary];
         });
}

- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying> )key {
    LOCK(
         if (obj && key) {
             [_dic setObject:obj forKeyedSubscript:key];
         });
}

#pragma mark - protocol

- (id)copyWithZone:(NSZone *)zone {
    return [self mutableCopyWithZone:zone];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    LOCK(id copiedDictionary = [[self.class allocWithZone:zone] initWithDictionary:_dic]);
    return copiedDictionary;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(id __unsafe_unretained[])stackbuf
                                    count:(NSUInteger)len {
    LOCK(NSUInteger count = [_dic countByEnumeratingWithState:state objects:stackbuf count:len]);
    return count;
}

- (BOOL)isEqual:(id)object {
    if (object == self) return YES;
    
    if ([object isKindOfClass:ATSafeThreadDictionary_QM.class]) {
        ATSafeThreadDictionary_QM *other = object;
        BOOL isEqual;
        pthread_mutex_lock(&_mutex_lock);
        pthread_mutex_lock(&(other->_mutex_lock));
        isEqual = [_dic isEqual:other->_dic];
        pthread_mutex_unlock(&_mutex_lock);
        pthread_mutex_unlock(&(other->_mutex_lock));
        
        return isEqual;
    }
    return NO;
}

- (NSUInteger)hash {
    LOCK(NSUInteger hash = [_dic hash]);
    return hash;
}

- (void)dealloc {
    pthread_mutex_destroy(&_mutex_lock);
    pthread_mutexattr_destroy(&_attr);
}

- (void)AT_setDictValue:(id)value key:(NSString *)key {
    if ([key isKindOfClass:[NSString class]] == NO) {
        NSAssert(NO, @"key must str");
    }

    if (key != nil && [key respondsToSelector:@selector(length)] && key.length > 0) {
        if ([ATSafeThreadDictionary_QM isEmpty:value] == NO) {
            [self setObject:value forKey:key];
        }
//        if (value == nil) {
//            NSAssert(NO, @"value must not equal to nil");
//        }
    } else {
        NSAssert(NO, @"key must not equal to nil");
    }
}

+ (BOOL)isEmpty:(id)object {
    if (object == nil || [object isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([object isKindOfClass:[NSString class]] && [(NSString *)object isEqualToString:@"(null)"]) {
        return YES;
    }
    
    if (([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSData class]]) && [object respondsToSelector:@selector(length)]) {
        return [object length] == 0;
    }
    
    if (([object isKindOfClass:[NSDictionary class]] || [object isKindOfClass:[NSArray class]]) && [object respondsToSelector:@selector(count)]) {
        return [object count] == 0;
    }
    
    return NO;
}

@end
