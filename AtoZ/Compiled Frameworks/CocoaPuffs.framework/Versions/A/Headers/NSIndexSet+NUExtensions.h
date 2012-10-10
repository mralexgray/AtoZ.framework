/**
 
 \category  NSIndexSet(NUExtensions)
 
 \brief     Adds a number of facilities to NSIndexSet for a more functional 
            style of programming.
 
 \author    Eric Methot
 \date      2012-04-10
 
 \copyright Copyright 2011 NUascent Sàrl. All rights reserved.
 
 */

#import <Foundation/Foundation.h>

@interface NSIndexSet (NUExtensions)

/// Returns a copy of the index set with an additional `index`.
- (NSIndexSet*) indexSetByAddingIndex:(NSUInteger)index;

/// Returns a copy of the index with `index` removed.
/// If `index` is not in self then the result is an exact copy of self.
- (NSIndexSet*) indexSetByRemovingIndex:(NSUInteger)index;

/// Returns a copy of the index set with an additional `indexes`.
- (NSIndexSet*) indexSetByAddingIndexes:(NSIndexSet*)indexes;

/// Returns a copy of the index set with but with `indexes` removed.
/// Indexes in `indexes` but not in self are ignored.
- (NSIndexSet*) indexSetByRemovingIndexes:(NSIndexSet*)indexes;

@end
