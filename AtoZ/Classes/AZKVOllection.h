//
//  AZKVOllection.h
//  AtoZ
//
//  Created by Alex Gray on 10/14/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AZKVOllection : NSObject

- (NSUInteger) countOfArr;
- (id) objectInArrAtIndex:(NSUInteger)index;
- (void) insertObject:(id)obj inArrAtIndex:(NSUInteger)index;
- (void) removeObjectFromArrAtIndex:(NSUInteger)index;
- (void) replaceObjectInArrAtIndex:(NSUInteger)index withObject:(id)obj;

- (void) addObjectToArr:(id)obj;
@end
