//
//  THRect.h
//  Lumumba Framework
//
//  Created by Benjamin Schüttler on 28.09.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import <Cocoa/Cocoa.h>
//#import "AZGeometry.h"
#import <Foundation/Foundation.h>
//#import "AZGeometricFunctions.h"
/** Returns a rect that uses aSize as its size and centered inside the given rect.

The returned rect is expressed relative the given rect parent coordinate space.<br />
To get a rect expressed relative the the given rect itself, pass a rect with a zero 
origin: 
<code>
NSRect inRect = NSMakeRect(40, 50, 100, 200);
NSRect centeredRectSize = NSMakeSize(50, 100);
NSRect rect = ETCenteredRect(centeredRectSize, ETMakeRect(NSZeroPoint, inRect.size));
</code>
The resulting rect is equal to { 25, 50, 50, 100 }.

The returned rect origin is valid whether or not your coordinate space is flipped. */
static inline NSR AZCenteredRect(NSSize aSize, NSR inRect)
{
	float xOffset = aSize.width * 0.5;
	float x = NSMidX(inRect) - xOffset;
	float yOffset = aSize.height  * 0.5;
	float y = NSMidY(inRect) - yOffset;

	return NSMakeRect(x, y, aSize.width, aSize.height);
}

@interface NSObject (AZRectResponder)

@end


/*	Returns a rect that uses aSize scaled based on the content aspect rule and then centered inside the given rect.
	The returned rect is expressed relative the given rect parent coordinate space.
	To get a rect expressed relative the the given rect itself, see ETCenteredRect().
	The returned rect origin is valid whether or not your coordinate space is flipped. 
	
	extern NSR AZScaledRect(NSSize aSize, NSR inRect);
	Returns a rect with a width and height multiplied by the given factor and by shifting the origin to retain the original rect center location. 
static inline NSR AZScaleRect(NSRect frame, CGF factor) {
	NSSize prevSize = frame.size;
	NSRect newFrame;
	newFrame.size  = (NSSZ) {frame.size.width *2, frame.size.height*2};
	//AZMultiplySize( frame.size,  factor);
	// NOTE: frame.origin.x -= (frame.size.width - prevSize.width) / 2;
	//	   	frame.origin.y -= (frame.size.height - prevSize.height) / 2;
	newFrame.origin.x += (prevSize.width 	- newFrame.size.width ) / 2;
	newFrame.origin.y += (prevSize.height 	- newFrame.size.height) / 2;
	return frame;
}
*/

@class AZPoint;
@interface AZEdge : AZPoint
+ (INST) rect:(AZRect*)r along:(AZRect*)outer inside:(BOOL)isinide;
@property (NATOM, ASS) AZA alignment;
@property (NATOM, ASS) AZOrient orient;
@property (NATOM, ASS) CGF cornerTreshHold, snapThreshold;
//- (void) moveInDirection:(NSSZ)sz;
@end



@class AZPoint;
@interface AZRect : AZPoint 	{  CGF width, height;	}
#define AZRECTUNDERMENU [AZRect screnFrameUnderMenu]
#define $AZRECT(r) [AZRect rectWithRect:r]
#define $AZR(r) [AZRect rectWithRect:r]

//- (AZA) alignInside:(NSR)ext;
+ (AZRect*) screnFrameUnderMenu;
+ (AZRect*) rect;
+ (AZRect*) rectOf:			(id)object;
+ (AZRect*) rectWithRect:	(NSR)rect;
+ (AZRect*) rectWithOrigin:(NSP)origin andSize:(NSSZ)size;
+ (AZRect*) rectWithX:		(CGF)x andY:(CGF)y  width:(CGF)width  height:(CGF)height;
+ (AZRect*) rect:(NSR)frame oriented:(AZPOS)pos;

+ (BOOL)maybeRect:(id) object;

- (id) initWithRect: (NSR)rect;
- (id) initWithSize: (NSSZ)size;
- (id) initFromPoint:(NSP)ptOne toPoint:(NSP)ptTwo;
- (id) initWithFrame:(NSR)frame inFrame:(NSR)superframe;

@property (NATOM,ASS) CGP 		anchor, position;
@property (NATOM,ASS) CGF 		width, height, maxX, maxY, minY, minX;
@property (NATOM,ASS) NSP 		origin, center;
@property (NATOM,ASS) NSSZ 	size;
@property (NATOM,ASS) NSR 		rect;
@property (NATOM,ASS) AZPOS	orient;
@property (RONLY) CGF 	area;
@property (RONLY) NSP 	apex;
- (void) setApex:(NSP)p move1Scale2:(NSN*)n;
@property (NATOM,ASS) NSR r;


- (id) shrinkBy:(id) object;
- (id) shrinkByPadding:(NSI)padding;
- (id) shrinkBySizePadding:(NSSZ)padding;

- (id) growBy:				 	(id) object;
- (id) growByPadding:		(NSI)padding;
- (id) growBySizePadding:	(NSSZ)padding;

- (BOOL)contains:				(id) object;
- (BOOL)contaiNSP:			(NSP)pt;
- (BOOL)containsRect:		(NSR)rect;

- (id) centerOn:(id)bounds;
- (id) moveTo:  (id)relationPoint ofRect:(id) bounds;
- (id) sizeTo:  (id)relationPoint ofRect:(id) bounds;

// graphing
- (void) drawFrame;
- (void) fill;

@end
