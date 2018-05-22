//
//  NSMutableArray+Safe.m
//  method swizzling
//
//  Created by 666 on 2018/3/14.
//  Copyright © 2018年 666. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <objc/runtime.h>


@implementation NSMutableArray (Safe)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        id obj = [[self alloc] init];
        [obj swizzleMethod:@selector(addObject:) withMethod:@selector(safeAddObject:)];
        [obj swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(safeObjectAtIndex:)];
        [obj swizzleMethod:@selector(objectAtIndexedSubscript:) withMethod:@selector(safeobjectAtIndexedSubscript:)];
        [obj swizzleMethod:@selector(insertObject:atIndex:) withMethod:@selector(safeInsertObject:atIndex:)];
        [obj swizzleMethod:@selector(removeObjectAtIndex:) withMethod:@selector(safeRemoveObjectAtIndex:)];
        [obj swizzleMethod:@selector(replaceObjectAtIndex:withObject:) withMethod:@selector(safeReplaceObjectAtIndex:withObject:)];
        [obj swizzleMethod:@selector(setObject:atIndexedSubscript:) withMethod:@selector(safesetObject:atIndexedSubscript:)];
    });
}

- (id)safeobjectAtIndexedSubscript:(NSUInteger)idx{
    if(idx<[self count]){
        return [self safeobjectAtIndexedSubscript:idx];
    }else{
        NSLog(@"index is beyond bounds ");
    }
    return nil;
}

- (void)safeAddObject:(id)anObject
{
    if (anObject) {
        [self safeAddObject:anObject];
    }else{
        NSLog(@"obj is nil");
    }
}

- (id)safeObjectAtIndex:(NSInteger)index
{
    if(index<[self count]){
        return [self safeObjectAtIndex:index];
    }else{
        NSLog(@"index is beyond bounds ");
    }
    return nil;
}

- (void)safeInsertObject:(id)anObject atIndex:(NSUInteger)index{
    if (index > [self count]) {
        NSLog(@"index is beyond bounds ");
    }else if (anObject){
        [self safeInsertObject:anObject atIndex:index];
    }else{
         NSLog(@"obj is nil");
    }
}

- (void)safeRemoveObjectAtIndex:(NSUInteger)index{
    if (index < [self count]) {
        [self safeRemoveObjectAtIndex:index];
    }else{
        NSLog(@"index is beyond bounds ");
    }
}

- (void)safesetObject:(id)obj atIndexedSubscript:(NSUInteger)idx{
    if (idx < [self count]) {
        if (obj) {
            [self safesetObject:obj atIndexedSubscript:idx];
        }else{
            NSLog(@"obj is nil");
        }
    }else{
        NSLog(@"index is beyond bounds ");
    }
}

- (void)safeReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject{
    if (index < [self count]) {
        if (anObject) {
            [self safeReplaceObjectAtIndex:index withObject:anObject];
        }else{
            NSLog(@"obj is nil");
        }
    }else{
        NSLog(@"index is beyond bounds ");
    }
}

- (void)swizzleMethod:(SEL)origSelector withMethod:(SEL)newSelector
{
    Class class = [self class];

    Method originalMethod = class_getInstanceMethod(class, origSelector);
    Method swizzledMethod = class_getInstanceMethod(class, newSelector);

    BOOL didAddMethod = class_addMethod(class,
                                        origSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class,
                            newSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end

@implementation NSArray (Safe)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        id obj = [[self alloc] init];
         //__NSArrayI(多项)  __NSArray0(0项)   __NSSingleObjectArrayI(一项) 目前就这三个类 有新的再加
        [obj swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(swizzleObjectAtIndexNSArrayI:) withClass:objc_getClass("__NSArrayI")];
        [obj swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(swizzleObjectAtIndexNSArray0:) withClass:objc_getClass("__NSArray0")];
        [obj swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(swizzleObjectAtIndexNSSingleObjectArrayI:) withClass:objc_getClass("__NSSingleObjectArrayI")];
    });
}

- (id)swizzleObjectAtIndexNSArrayI:(NSInteger)index{
    if(index<[self count]){
        return [self swizzleObjectAtIndexNSArrayI:index];
    }else{
        NSLog(@"index is beyond bounds ");
    }
    return nil;
}
- (id)swizzleObjectAtIndexNSArray0:(NSInteger)index{
    if(index<[self count]){
        return [self swizzleObjectAtIndexNSArray0:index];
    }else{
        NSLog(@"index is beyond bounds ");
    }
    return nil;
}
- (id)swizzleObjectAtIndexNSSingleObjectArrayI:(NSInteger)index{
    if(index<[self count]){
        return [self swizzleObjectAtIndexNSSingleObjectArrayI:index];
    }else{
        NSLog(@"index is beyond bounds ");
    }
    return nil;
}

- (void)swizzleMethod:(SEL)origSelector withMethod:(SEL)newSelector withClass:(Class)class
{
    Method originalMethod = class_getInstanceMethod(class, origSelector);
    Method swizzledMethod = class_getInstanceMethod(class, newSelector);

    BOOL didAddMethod = class_addMethod(class,
                                        origSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class,
                            newSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end



