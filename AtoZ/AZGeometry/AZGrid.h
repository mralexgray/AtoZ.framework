//
//  AZGrid.h
//  Lumumba Framework
//
//  Created by Benjamin Schüttler on 28.09.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AZPoint.h"
#import "AZSize.h"
#import "AZRect.h"
#import "AZGrid.h"
#import "AZMatrix.h"

enum {
	AZGridStyleCompact = 0,
	AZGridStyleHorizontal = 1,
	AZGridStyleVertical = 2
};

enum AZGridOrder {
	AZGridRowMajorOrder = 0,
	AZGridColumnMajorOrder = 1
};

@class AZPoint, AZSize, AZRect, AZMatrix;

@interface AZGrid : NSObject {
	NSMA *array;
	NSUI parallels;
	NSUI style;
	NSUI order;
	BOOL rowMajorOrder;
}

- (id) initWithCapacity:(NSUInteger)numItems;

@property (UNSFE,RONLY) AZSize* size;
@property (RONLY) NSUI count;
@property (RONLY) CGF width;
@property (RONLY) CGF height;

@property (RONLY) CGF min;
@property (RONLY) CGF max;

@property (ASS) NSUI parallels;
@property (ASS) NSUI order;
@property (ASS) NSUI style;

- (NSMA*) elements;
- (NSNumber*) indexAtPoint:(NSP)point;
- (id) objectAtIndex:(NSUInteger)index;
- (id) objectAtPoint:(NSP)point;
- (AZPoint*) pointAtIndex:(NSUInteger)index;

- (void) addObject:(id) anObject;
- (void) insertObject:(id) anObject atIndex:(NSUInteger)index;
- (void) removeObjectAtIndex:(NSUInteger)index;
- (void) removeAllObjects;

@end
