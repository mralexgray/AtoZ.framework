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
static inline NSRect AZCenteredRect(NSSize aSize, NSRect inRect)
{
	float xOffset = aSize.width * 0.5;
	float x = NSMidX(inRect) - xOffset;
	float yOffset = aSize.height  * 0.5;
	float y = NSMidY(inRect) - yOffset;

	return NSMakeRect(x, y, aSize.width, aSize.height);
}

/** Returns a rect that uses aSize scaled based on the content aspect rule and 
then centered inside the given rect.

The returned rect is expressed relative the given rect parent coordinate space.<br />
To get a rect expressed relative the the given rect itself, see ETCenteredRect().

The returned rect origin is valid whether or not your coordinate space is flipped. */
//extern NSRect AZScaledRect(NSSize aSize, NSRect inRect);
/** Returns a rect with a width and height multiplied by the given factor and 
by shifting the origin to retain the original rect center location. */
static inline NSRect AZScaleRect(NSRect frame, CGFloat factor) {
	NSSize prevSize = frame.size;
	NSRect newFrame;
	newFrame.size  = (NSSize) {frame.size.width *2, frame.size.height*2};
	//AZMultiplySize( frame.size,  factor);

	// NOTE: frame.origin.x -= (frame.size.width - prevSize.width) / 2;
	//       frame.origin.y -= (frame.size.height - prevSize.height) / 2;
	newFrame.origin.x += (prevSize.width - newFrame.size.width) / 2;
	newFrame.origin.y += (prevSize.height - newFrame.size.height) / 2;

	return frame;
}
@class AZPoint;
@interface AZRect : AZPoint {
  CGFloat width;
  CGFloat height;
}

+(AZRect *)rect;
+(AZRect *)rectOf:(id)object;
+(AZRect *)rectWithRect:(NSRect)rect;
+(AZRect *)rectWithOrigin:(NSPoint)origin 
                  andSize:(NSSize)size;
+(AZRect *)rectWithX:(CGFloat)x 
                andY:(CGFloat)y 
               width:(CGFloat)width 
              height:(CGFloat)height;

+(BOOL)maybeRect:(id)object;

-(id)initWithRect:(NSRect)rect;
-(id)initWithSize:(NSSize)size;
-(id)initFromPoint:(NSPoint)ptOne 
           toPoint:(NSPoint)ptTwo;

@property (assign) CGFloat width;
@property (assign) CGFloat height;
@property (RONLY) CGFloat area;

@property (assign) NSPoint origin;
@property (assign) NSPoint center;
@property (assign) NSSize size;
@property (assign) NSRect rect;

-(id)shrinkBy:(id)object;
-(id)shrinkByPadding:(NSInteger)padding;
-(id)shrinkBySizePadding:(NSSize)padding;

-(id)growBy:(id)object;
-(id)growByPadding:(NSInteger)padding;
-(id)growBySizePadding:(NSSize)padding;

-(BOOL)contains:(id)object;
-(BOOL)containsPoint:(NSPoint)pt;
-(BOOL)containsRect:(NSRect)rect;

-(id)centerOn:(id)bounds;
-(id)moveTo:(id)relationPoint ofRect:(id)bounds;
-(id)sizeTo:(id)relationPoint ofRect:(id)bounds;

// graphing
-(void)drawFrame;
-(void)fill;

@end
