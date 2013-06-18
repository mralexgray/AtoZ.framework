//
//  NSIndexSet+AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 12/10/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (AtoZKVO)
+ (NSSet*)keyPathsForValuesAffecting: (NSS*)key fromDictionary:(NSD*)pairs;
//- (NSSet*)keyPathsForValuesAffecting:(NSS*)string includingSuper:(NSSet*(^)(NSS*key))block;
//+ (NSSet*) keyPathsForValuesAffectingValueForKey:(NSSet*(^)(NSS*key))block;
@end

@interface NSIndexSet (AtoZ)
+ (instancetype) indexWithIndexes:(NSA*)indexes;
+ (instancetype) indexesOfObjects:(NSA*)objs inArray:(NSA*)ref;
@end

@interface NSIndexPath (ESExtensions)




- (NSUInteger)firstIndex;
- (NSUInteger)lastIndex;
- (NSIndexPath *)indexPathByIncrementingLastIndex;
- (NSIndexPath *)indexPathByReplacingIndexAtPosition:(NSUInteger)position withIndex:(NSUInteger)index;
@end

