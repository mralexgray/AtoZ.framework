//
//  THSegmentedRect.h
//  Lumumba
//
//  Created by Benjamin Schüttler on 26.10.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AZGeometricFunctions.h"
#import "AtoZ.h"
#import "AZGeometry.h"

@class AZPoint, AZSize,  AZRect;

@interface AZSegmentedRect : AZRect {	NSPoint segments;			BOOL emptyBorder;
  										NSSize minimumSegmentSize;	NSSize maximumSegmentSize;
}
//+(AZSegmentedRect *) rectsInside:  (NSRect) rect NSIInside: (NSRect)	rect;

+(AZSegmentedRect *) rectWithRect: (NSRect)	rect;
+(AZSegmentedRect *) rectWithRect: (NSRect) rect	cubicSize: (NSUInteger) size;
+(AZSegmentedRect *) rectWithRect: (NSRect) rect	width: 	   (NSUInteger) width 	height: (NSUInteger) height;

@property (nonatomic, assign)  AZOrient *orientation;
@property (nonatomic, assign)  BOOL emptyBorder;
@property (nonatomic, assign)  NSUInteger horizontalSegments;
@property (nonatomic, assign)  NSUInteger verticalSegments;

@property (nonatomic, assign)  NSSize minimumSegmentSize;
@property (nonatomic, assign)  NSSize maximumSegmentSize;

@property (RONLY)  NSUInteger segmentCount;
@property (RONLY)  NSSize 	 segmentSize;

- (id) setCubicSize:	  (NSUInteger) size;
- (id) setDimensionWidth: (NSUInteger) width 	height: (NSUInteger) height;

- (NSPoint) 	indicesOfSegmentAtIndex: (NSUInteger) index;
- (NSUInteger) 	indexAtPoint: 			  (NSPoint)   pt;

- (AZRect *) segmentAtIndex: (NSUInteger) index;
- (AZRect *) segmentAtX: 	 (NSUInteger) x 	y:(NSUInteger) y;

- (NSPoint) pointOfSegmentAtIndex: (NSUInteger) index;
- (NSPoint) pointOfSegmentAtX: 	   (NSUInteger) x 	y:(NSUInteger) y;

- (NSRect) rectOfSegmentAtIndex: (NSUInteger) index;
- (NSRect) rectOfSegmentAtX: 	 (NSUInteger) x 	y: (NSUInteger) y;

- (NSPoint) pointWithString: 	(NSString *) string;

@end
@interface AZRect (AZSegmentedRect)

- (AZSegmentedRect*) segmentedRect;
- (AZSegmentedRect*) segmentedRectWithCubicSize: (NSUInteger) size;
- (AZSegmentedRect*) segmentedRectWithWidth: 	 (NSUInteger) width 	height: (NSUInteger) height;

@end
@interface NSBezierPath (AZSegmentedRect) 

- (id) traverseSegments: (NSString *) segmentDefinition inRect: (AZSegmentedRect *) segmentedRect;
@end
