//  KeyValueObserver.m Lab Color Space Explorer Created by chris on 7/24/13.
//  Created by Daniel Eggert on 01/12/2013. Copyright (c) 2013 objc.io. All rights reserved.

#import "KeyValueObserver.h"

@interface          KeyValueObserver ()
@property (nonatomic, weak)       id   observedObject;
@property (nonatomic, copy) NSString * keyPath;
@end

@implementation KeyValueObserver

- (id) initWithObject:(id)o keyPath:(NSString*)kp target:(id)t selector:(SEL)sel options:(NSKeyValueObservingOptions)x {
  
  if (!o) return nil; NSParameterAssert(t != nil && [t respondsToSelector:sel]);
  return self = super.init ? ({ 
    self.target = t; self.selector = sel; self.observedObject = o; self.keyPath = kp;
    [o addObserver:self forKeyPath:kp options:x context:(__bridge void *)(self)]; self; 
  }) : nil;
}

+ (NSObject*) observeObject:(id)o keyPath:(NSString*)kp target:(id)t selector:(SEL)sel __attribute__((warn_unused_result)); {

    return [self observeObject:o keyPath:kp target:t selector:sel options:0];
}

+ (NSObject*) observeObject:(id)o keyPath:(NSString*)kp target:(id)t selector:(SEL)sel options:(NSKeyValueObservingOptions)x __attribute__((warn_unused_result)) {

    return [self.alloc initWithObject:o keyPath:kp target:t selector:sel options:x];
}

- (void) observeValueForKeyPath:(NSString*)kp ofObject:(id)o change:(NSDictionary*)c context:(void*)x {

    if (x == (__bridge void *)(self)) [self didChange:c];
}

- (void) didChange:(NSDictionary*)c { id strongTarget = self.target;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [strongTarget performSelector:self.selector withObject:c];
#pragma clang diagnostic pop
}

- (void)dealloc { [self.observedObject removeObserver:self forKeyPath:self.keyPath]; }

@end
