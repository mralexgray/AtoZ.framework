//
//  THSegmentedRect.h
//  Lumumba
//
//  Created by Benjamin Schüttler on 26.10.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AtoZGeometry.h"
// #import "AtoZ.h"  // Do not change..  Weirdly essential.


@class AZPoint, AZSize,  AZRect;
@interface AZSegmentedRect : AZRect {	NSP segments;			BOOL emptyBorder;
											NSSize minimumSegmentSize;	NSSize maximumSegmentSize;
}
//+ (AZSegmentedRect*) rectsInside:  (NSR) rect NSIInside: (NSR)	rect;

+ (AZSegmentedRect*) rectWithRect: (NSR)	rect;
+ (AZSegmentedRect*) rectWithRect: (NSR) rect	cubicSize: (NSUInteger) size;
+ (AZSegmentedRect*) rectWithRect: (NSR) rect	width: 	   (NSUInteger) width 	height: (NSUInteger) height;

@property (NATOM,ASS)  AZOrient *orientation;
@property (NATOM,ASS)  BOOL emptyBorder;
@property (NATOM,ASS)  NSUI horizontalSegments;
@property (NATOM,ASS)  NSUI verticalSegments;

@property (NATOM,ASS)  NSSZ minimumSegmentSize;
@property (NATOM,ASS)  NSSZ maximumSegmentSize;

@property (RONLY)  NSUI segmentCount;
@property (RONLY)  NSSZ 	 segmentSize;

- (id) setCubicSize:	  (NSUInteger) size;
- (id) setDimensionWidth: (NSUInteger) width 	height: (NSUInteger) height;

- (NSP) 	indicesOfSegmentAtIndex: (NSUInteger) index;
- (NSUInteger) 	indexAtPoint: 			  (NSP)   pt;

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
