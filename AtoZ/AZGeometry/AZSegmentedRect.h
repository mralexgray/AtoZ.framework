//
//  THSegmentedRect.h
//  Lumumba
//
//  Created by Benjamin Schüttler on 26.10.09.
//  Copyright 2011 Rogue Coding. All rights reserved.

// #import "AtoZ.h"  // Do not change..  Weirdly essential.
#import "AZRect.h"

@class AZPoint, AZSize;
@interface AZSegmentedRect : AZRect {	NSP segments;			BOOL emptyBorder;
											NSSize minimumSegmentSize;	NSSize maximumSegmentSize;
}
//+ (AZSegmentedRect*) rectsInside:  (NSR) rect NSIInside: (NSR)	rect;

+ (AZSegmentedRect*) rectWithRect: (NSR)	rect;
+ (AZSegmentedRect*) rectWithRect: (NSR) rect	cubicSize: (NSUInteger) size;
+ (AZSegmentedRect*) rectWithRect: (NSR) rect	width: 	   (NSUInteger) width 	height: (NSUInteger) height;

@property (NA,ASS)  AZOrient *orientation;
@property (NA,ASS)  BOOL emptyBorder;
@property (NA,ASS)  NSUI horizontalSegments;
@property (NA,ASS)  NSUI verticalSegments;

@property (NA,ASS)  NSSZ minimumSegmentSize;
@property (NA,ASS)  NSSZ maximumSegmentSize;

_RO NSUI segmentCount;
_RO NSSZ 	 segmentSize;

- (id) setCubicSize:	  (NSUInteger) size;
- (id) setDimensionWidth: (NSUInteger) width 	height: (NSUInteger) height;

- (NSP) 	indicesOfSegmentAtIndex: (NSUInteger) index;
//- (NSUInteger) 	indexAtPoint: 			  (NSP)   pt;

- (AZRect*) segmentAtIndex: (NSUInteger) index;
- (AZRect*) segmentAtX: 	 (NSUInteger) x 	y:(NSUInteger) y;

- (NSP) pointOfSegmentAtIndex: (NSUInteger) index;
- (NSP) pointOfSegmentAtX: 	   (NSUInteger) x 	y:(NSUInteger) y;

- (NSR) rectOfSegmentAtIndex: (NSUInteger) index;
- (NSR) rectOfSegmentAtX: 	 (NSUInteger) x 	y: (NSUInteger) y;

- (NSP) pointWithString: 	(NSString*) string;

@end
@interface AZRect (AZSegmentedRect)

- (AZSegmentedRect*) segmentedRect;
- (AZSegmentedRect*) segmentedRectWithCubicSize: (NSUInteger) size;
- (AZSegmentedRect*) segmentedRectWithWidth: 	 (NSUInteger) width 	height: (NSUInteger) height;

@end
@interface NSBezierPath (AZSegmentedRect) 

- (id) traverseSegments: (NSString*) segmentDefinition inRect: (AZSegmentedRect*) segmentedRect;
@end
