//  ATSafeThreadArray_QM.h
//  ATSDK
//
//  Created by mac on 2020/9/21.
//  Copyright © 2020 AnyThink. All rights reserved.
//

#import "ATSafeThreadArray_QM.h"
#import <pthread.h>


#define INIT(...) self = super.init; \
if (!self) return nil; \
__VA_ARGS__; \
if (!_arr) return nil; \
[self __initMutex:&_mutex_lock];\
return self;


#define LOCK(...) pthread_mutex_lock(&_mutex_lock); \
__VA_ARGS__; \
pthread_mutex_unlock(&_mutex_lock);

@implementation ATSafeThreadArray_QM {
    NSMutableArray *_arr;  //Subclass a class cluster...
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
    INIT(_arr = [[NSMutableArray alloc] init]);
}

- (instancetype)initWithCapacity:(NSUInteger)numItems {
    INIT(_arr = [[NSMutableArray alloc] initWithCapacity:numItems]);
}

- (instancetype)initWithArray:(NSArray *)array {
    INIT(_arr = [[NSMutableArray alloc] initWithArray:array]);
}

- (instancetype)initWithObjects:(const id[])objects count:(NSUInteger)cnt {
    INIT(_arr = [[NSMutableArray alloc] initWithObjects:objects count:cnt]);
}

- (instancetype)initWithContentsOfFile:(NSString *)path {
    INIT(_arr = [[NSMutableArray alloc] initWithContentsOfFile:path]);
}

- (instancetype)initWithContentsOfURL:(NSURL *)url {
    INIT(_arr = [[NSMutableArray alloc] initWithContentsOfURL:url]);
}

#pragma mark - method

- (NSUInteger)count {
    LOCK(NSUInteger count = _arr.count); return count;
}

- (id)objectAtIndex:(NSUInteger)index {
    LOCK(id obj = [_arr objectAtIndex:index]); return obj;
}

- (NSArray *)arrayByAddingObject:(id)anObject {
    LOCK(NSArray * arr = [_arr arrayByAddingObject:anObject]); return arr;
}

- (NSArray *)arrayByAddingObjectsFromArray:(NSArray *)otherArray {
    LOCK(NSArray * arr = [_arr arrayByAddingObjectsFromArray:otherArray]); return arr;
}

- (NSString *)componentsJoinedByString:(NSString *)separator {
    LOCK(NSString * str = [_arr componentsJoinedByString:separator]); return str;
}

- (BOOL)containsObject:(id)anObject {
    LOCK(BOOL c = [_arr containsObject:anObject]); return c;
}

- (NSString *)description {
    LOCK(NSString * d = _arr.description); return d;
}

- (NSString *)descriptionWithLocale:(id)locale {
    LOCK(NSString * d = [_arr descriptionWithLocale:locale]); return d;
}

- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level {
    LOCK(NSString * d = [_arr descriptionWithLocale:locale indent:level]); return d;
}

- (id)firstObjectCommonWithArray:(NSArray *)otherArray {
    LOCK(id o = [_arr firstObjectCommonWithArray:otherArray]); return o;
}

- (void)getObjects:(id __unsafe_unretained[])objects range:(NSRange)range {
    LOCK([_arr getObjects:objects range:range]);
}

- (NSUInteger)indexOfObject:(id)anObject {
    LOCK(NSUInteger i = [_arr indexOfObject:anObject]); return i;
}

- (NSUInteger)indexOfObject:(id)anObject inRange:(NSRange)range {
    LOCK(NSUInteger i = [_arr indexOfObject:anObject inRange:range]); return i;
}

- (NSUInteger)indexOfObjectIdenticalTo:(id)anObject {
    LOCK(NSUInteger i = [_arr indexOfObjectIdenticalTo:anObject]); return i;
}

- (NSUInteger)indexOfObjectIdenticalTo:(id)anObject inRange:(NSRange)range {
    LOCK(NSUInteger i = [_arr indexOfObjectIdenticalTo:anObject inRange:range]); return i;
}

- (id)firstObject {
    LOCK(id o = _arr.firstObject); return o;
}

- (id)lastObject {
    LOCK(id o = _arr.lastObject); return o;
}

- (NSEnumerator *)objectEnumerator {
    LOCK(NSEnumerator * e = [_arr objectEnumerator]); return e;
}

- (NSEnumerator *)reverseObjectEnumerator {
    LOCK(NSEnumerator * e = [_arr reverseObjectEnumerator]); return e;
}

- (NSData *)sortedArrayHint {
    LOCK(NSData * d = [_arr sortedArrayHint]); return d;
}

- (NSArray *)sortedArrayUsingFunction:(__attribute__((noescape)) NSInteger (*)(id, id, void *))comparator context:(void *)context {
    LOCK(NSArray * arr = [_arr sortedArrayUsingFunction:comparator context:context]) return arr;
}

- (NSArray *)sortedArrayUsingFunction:(__attribute__((noescape)) NSInteger (*)(id, id, void *))comparator context:(void *)context hint:(NSData *)hint {
    LOCK(NSArray * arr = [_arr sortedArrayUsingFunction:comparator context:context hint:hint]); return arr;
}

- (NSArray *)sortedArrayUsingSelector:(SEL)comparator {
    LOCK(NSArray * arr = [_arr sortedArrayUsingSelector:comparator]); return arr;
}

- (NSArray *)subarrayWithRange:(NSRange)range {
    LOCK(NSArray * arr = [_arr subarrayWithRange:range]) return arr;
}

- (void)makeObjectsPerformSelector:(SEL)aSelector {
    LOCK([_arr makeObjectsPerformSelector:aSelector]);
}

- (void)makeObjectsPerformSelector:(SEL)aSelector withObject:(id)argument {
    LOCK([_arr makeObjectsPerformSelector:aSelector withObject:argument]);
}

- (NSArray *)objectsAtIndexes:(NSIndexSet *)indexes {
    LOCK(NSArray * arr = [_arr objectsAtIndexes:indexes]); return arr;
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    LOCK(id o = [_arr objectAtIndexedSubscript:idx]); return o;
}

- (void)enumerateObjectsUsingBlock:(__attribute__((noescape)) void (^)(id obj, NSUInteger idx, BOOL *stop))block {
    LOCK([_arr enumerateObjectsUsingBlock:block]);
}

- (void)enumerateObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(__attribute__((noescape)) void (^)(id obj, NSUInteger idx, BOOL *stop))block {
    LOCK([_arr enumerateObjectsWithOptions:opts usingBlock:block]);
}

- (void)enumerateObjectsAtIndexes:(NSIndexSet *)s options:(NSEnumerationOptions)opts usingBlock:(__attribute__((noescape)) void (^)(id obj, NSUInteger idx, BOOL *stop))block {
    LOCK([_arr enumerateObjectsAtIndexes:s options:opts usingBlock:block]);
}

- (NSUInteger)indexOfObjectPassingTest:(__attribute__((noescape)) BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate {
    LOCK(NSUInteger i = [_arr indexOfObjectPassingTest:predicate]); return i;
}

- (NSUInteger)indexOfObjectWithOptions:(NSEnumerationOptions)opts passingTest:(__attribute__((noescape)) BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate {
    LOCK(NSUInteger i = [_arr indexOfObjectWithOptions:opts passingTest:predicate]); return i;
}

- (NSUInteger)indexOfObjectAtIndexes:(NSIndexSet *)s options:(NSEnumerationOptions)opts passingTest:(__attribute__((noescape)) BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate {
    LOCK(NSUInteger i = [_arr indexOfObjectAtIndexes:s options:opts passingTest:predicate]); return i;
}

- (NSIndexSet *)indexesOfObjectsPassingTest:(__attribute__((noescape)) BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate {
    LOCK(NSIndexSet * i = [_arr indexesOfObjectsPassingTest:predicate]); return i;
}

- (NSIndexSet *)indexesOfObjectsWithOptions:(NSEnumerationOptions)opts passingTest:(__attribute__((noescape)) BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate {
    LOCK(NSIndexSet * i = [_arr indexesOfObjectsWithOptions:opts passingTest:predicate]); return i;
}

- (NSIndexSet *)indexesOfObjectsAtIndexes:(NSIndexSet *)s options:(NSEnumerationOptions)opts passingTest:(__attribute__((noescape)) BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate {
    LOCK(NSIndexSet * i = [_arr indexesOfObjectsAtIndexes:s options:opts passingTest:predicate]); return i;
}

- (NSArray *)sortedArrayUsingComparator:(__attribute__((noescape)) NSComparator)cmptr  {
    LOCK(NSArray * a = [_arr sortedArrayUsingComparator:cmptr]); return a;
}

- (NSArray *)sortedArrayWithOptions:(NSSortOptions)opts usingComparator:(__attribute__((noescape)) NSComparator)cmptr {
    LOCK(NSArray * a = [_arr sortedArrayWithOptions:opts usingComparator:cmptr]); return a;
}

- (NSUInteger)indexOfObject:(id)obj inSortedRange:(NSRange)r options:(NSBinarySearchingOptions)opts usingComparator:(__attribute__((noescape)) NSComparator)cmp {
    LOCK(NSUInteger i = [_arr indexOfObject:obj inSortedRange:r options:opts usingComparator:cmp]); return i;
}

#pragma mark - mutable

- (void)addObject:(id)anObject {
    LOCK(
         if (anObject) {
             [_arr addObject:anObject];
         });
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index {
    LOCK(
         if (anObject) {
             [_arr insertObject:anObject atIndex:index];
         });
}

- (void)removeLastObject {
    LOCK([_arr removeLastObject]);
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    LOCK([_arr removeObjectAtIndex:index]);
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    LOCK([_arr replaceObjectAtIndex:index withObject:anObject]);
}

- (void)addObjectsFromArray:(NSArray *)otherArray {
    LOCK(
         if (otherArray) {
             [_arr addObjectsFromArray:otherArray];
         });
}

- (void)exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2 {
    LOCK([_arr exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2]);
}

- (void)removeAllObjects {
    LOCK([_arr removeAllObjects]);
}

- (void)removeObject:(id)anObject inRange:(NSRange)range {
    LOCK([_arr removeObject:anObject inRange:range]);
}

- (void)removeObject:(id)anObject {
    LOCK(
         if (anObject) {
             [_arr removeObject:anObject];
         });
}

- (void)removeObjectIdenticalTo:(id)anObject inRange:(NSRange)range {
    LOCK([_arr removeObjectIdenticalTo:anObject inRange:range]);
}

- (void)removeObjectIdenticalTo:(id)anObject {
    LOCK(
         if (anObject) {
             [_arr removeObjectIdenticalTo:anObject];
         });
}

- (void)removeObjectsInArray:(NSArray *)otherArray {
    LOCK([_arr removeObjectsInArray:otherArray]);
}

- (void)removeObjectsInRange:(NSRange)range {
    LOCK([_arr removeObjectsInRange:range]);
}

- (void)replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray *)otherArray range:(NSRange)otherRange {
    LOCK([_arr replaceObjectsInRange:range withObjectsFromArray:otherArray range:otherRange]);
}

- (void)replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray *)otherArray {
    LOCK([_arr replaceObjectsInRange:range withObjectsFromArray:otherArray]);
}

- (void)setArray:(NSArray *)otherArray {
    LOCK(
         if (otherArray) {
             [_arr setArray:otherArray];
         });
}

- (void)sortUsingFunction:(__attribute__((noescape)) NSInteger (*)(id, id, void *))compare context:(void *)context {
    LOCK([_arr sortUsingFunction:compare context:context]);
}

- (void)sortUsingSelector:(SEL)comparator {
    LOCK([_arr sortUsingSelector:comparator]);
}

- (void)insertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes {
    LOCK([_arr insertObjects:objects atIndexes:indexes]);
}

- (void)removeObjectsAtIndexes:(NSIndexSet *)indexes {
    LOCK([_arr removeObjectsAtIndexes:indexes]);
}

- (void)replaceObjectsAtIndexes:(NSIndexSet *)indexes withObjects:(NSArray *)objects {
    LOCK([_arr replaceObjectsAtIndexes:indexes withObjects:objects]);
}

- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx {
    LOCK([_arr setObject:obj atIndexedSubscript:idx]);
}

- (void)sortUsingComparator:(__attribute__((noescape)) NSComparator)cmptr {
    LOCK([_arr sortUsingComparator:cmptr]);
}

- (void)sortWithOptions:(NSSortOptions)opts usingComparator:(__attribute__((noescape)) NSComparator)cmptr {
    LOCK([_arr sortWithOptions:opts usingComparator:cmptr]);
}

- (BOOL)isEqualToArray:(NSArray *)otherArray {
    if (otherArray == self) return YES;
    if ([otherArray isKindOfClass:ATSafeThreadArray_QM.class]) {
        ATSafeThreadArray_QM *other = (id)otherArray;
        BOOL isEqual;
        pthread_mutex_lock(&_mutex_lock);
        pthread_mutex_lock(&(other->_mutex_lock));
        isEqual = [_arr isEqualToArray:other->_arr];
        pthread_mutex_unlock(&_mutex_lock);
        pthread_mutex_unlock(&(other->_mutex_lock));
        return isEqual;
    }
    return NO;
}

#pragma mark - protocol

- (id)copyWithZone:(NSZone *)zone {
    return [self mutableCopyWithZone:zone];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    LOCK(id copiedDictionary = [[self.class allocWithZone:zone] initWithArray:_arr]);
    return copiedDictionary;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(id __unsafe_unretained[])stackbuf
                                    count:(NSUInteger)len {
    LOCK(NSUInteger count = [_arr countByEnumeratingWithState:state objects:stackbuf count:len]);
    return count;
}

- (BOOL)isEqual:(id)object {
    if (object == self) return YES;
    
    if ([object isKindOfClass:ATSafeThreadArray_QM.class]) {
        ATSafeThreadArray_QM *other = object;
        BOOL isEqual;
        pthread_mutex_lock(&_mutex_lock);
        pthread_mutex_lock(&(other->_mutex_lock));
        isEqual = [_arr isEqual:other->_arr];
        pthread_mutex_unlock(&_mutex_lock);
        pthread_mutex_unlock(&(other->_mutex_lock));
        return isEqual;
    }
    return NO;
}

- (NSUInteger)hash {
    LOCK(NSUInteger hash = [_arr hash]);
    return hash;
}

- (void)dealloc {
    pthread_mutex_destroy(&_mutex_lock);
    pthread_mutexattr_destroy(&_attr);
}
@end
