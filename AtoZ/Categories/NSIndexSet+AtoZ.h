//
//  NSIndexSet+AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 12/10/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NoodleIndexSetEnumerator : NSObject
{
	NSUInteger	*_indexes;
	NSUInteger	_count;
	NSUInteger	_currentIndex;
}

// Returns NSNotFound when there are no more indexes.
- (NSUInteger)nextIndex;

@end


@interface NSIndexSet (NoodleExtensions)

- (NoodleIndexSetEnumerator *)indexEnumerator;

@end