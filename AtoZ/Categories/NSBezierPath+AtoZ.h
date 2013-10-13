

@interface NSAffineTransform (RectMapping)
/* initialize the NSAffineTransform so it maps points in srcBounds proportionally to points in dstBounds */
- (NSAffineTransform*)mapFrom:(NSRect) srcBounds to: (NSRect) dstBounds;
/* scale the rectangle 'bounds' proportionally to the given height centered above the origin with the bottom of the rectangle a distance of height above the a particular point.  Handy for revolving items around a particular point. */
- (NSAffineTransform*)scaleBounds:(NSR) bounds 	toHeight: (CGF) height centeredDistance:(CGF) distance abovePoint:(NSP) loc;
/* same as the above, except it centers the item above the origin.  */
- (NSAffineTransform*)scaleBounds:(NSR) bounds	toHeight: (CGF) height centeredAboveOrigin:(CGF) distance;
/* initialize the NSAffineTransform so it will flip the contents of bounds	vertically. */
- (NSAffineTransform*)flipVertical:(NSRect) bounds;
@end
@interface NSBezierPath (ShadowDrawing)
/* fill a bezier path, but draw a shadow under it offset by the given angle (counter clockwise from the x-axis) and distance. */
- (void)fillWithShadowAtDegrees:(CGF) angle withDistance: (CGF) distance;
@end
@interface BezierNSLayoutManager: NSLayoutManager 
@property (nonatomic, copy) NSBezierPath* theBezierPath;
- (void)showPackedGlyphs:(char*)glyphs length:(unsigned)glyphLen	/* convert NSString into a NSBezierPath using a specific font. */
		glyphRange:(NSRange)glyphRange atPoint:(NSPoint)point font:(NSFont *)font
		color:(NSC*)color printingAdjustment:(NSSZ)printingAdjustment;
@end
@interface NSString (BezierConversions)
- (NSBezierPath*) bezierWithFont: (NSFont*) theFont;	/* convert the NSString into a NSBezierPath using a specific font. */
@end

@interface NSAffineTransform (UKShearing)
+ (NSAffineTransform *)transformRotatingAroundPoint:(NSP) p byDegrees:(CGF) deg;
-(void)	shearXBy: (CGF)xFraction yBy: (CGF)yFraction;
@end

@interface NSBezierPath (AtoZ)
- (NSA*) points;
+ (NSBP*) bezierPathWithPoints:(NSA*)points;
- (void) customVerticalFillWithCallbacks:  (CGFunctionCallbacks)functionCallbacks firstColor:(NSC*)firstColor secondColor:(NSC*)secondColor;
- (void) customHorizontalFillWithCallbacks:(CGFunctionCallbacks)functionCallbacks firstColor:(NSC*)firstColor secondColor:(NSC*)secondColor;
- (void) linearGradientFillWithStartColor:(NSColor *)startColor endColor:(NSColor *)endColor;
- (void) bilinearGradientFillWithOuterColor:(NSColor *)outerColor innerColor:(NSColor *)innerColor;

@property (nonatomic, assign) CGF width;
@property (nonatomic, assign) CGF height;

+ (NSBP*) diagonalLinesInRect:(NSR)rect phase:(CGF)phase; // background progress bar
- (NSR)	 nonEmptyBounds;
- (NSBP*) scaledToSize:  (NSSZ)size;
- (NSBP*) scaledToFrame: (NSR)rect;
- (NSP)   associatedPointForElementAtIndex:(NSUI)anIndex;
- (CGPR)  quartzPath CF_RETURNS_RETAINED;
//+ (NSBP*) bezierPathWithCGPath:(CGPR)pathRef;
- (CGPR)  cgPath CF_RETURNS_RETAINED;

- (NSBP*) pathWithStrokeWidth:(CGF)strokeWidth;
- (NSBP*) stroked:					(CGF)strokeWidth; // alias of pathWithStrokeWidth: 

- (void) drawWithFill: 	   (NSC*)fill  andStroke: (NSC*)stroke;
- (void) fillGradientFrom: (NSC*)start to:(NSC*)end angle:(float)inAngle;

@property (STRNG,NATOM) NSA* dashPattern;
//- (NSA*) dashPattern;
//- (void) setDashPattern:(NSA*)newPattern;

- (void) strokeInside;
- (void) strokeInsideWithinRect: (NSR)clipRect;
- (void) applyInnerShadow:	  (NSSHDW*)shadow;
- (void) fillWithInnerShadow:(NSSHDW*)shadow;
- (void) strokeWithColor:	 (NSC*)color;
- (void) strokeWithColor:	 (NSC*)color andWidth:(CGF)width;
- (void) fillWithColor:	 	 (NSC*)color;
- (void) drawBlurWithColor: (NSC*)color   radius:(CGF)radius;
- (void) strokeWithColor:	 (NSC*)color andWidth:(CGF)width inside:(NSR)frame;

+ (NSBP*) bezierPathWithSpringWithCoils: 		(NSUI)numCoils inFrame:(NSR)bounds;
+ (NSBP*) bezierPathWithPlateInRect: 	 		(NSR)rect;
+ (NSBP*) bezierPathWithTriangleInRect:   	(NSR)aRect orientation: (AZCompass)orientation;
+ (NSBP*) bezierPathWithCappedBoxInRect:  	(NSR)rect;
- (void) appendBezierPathWithTriangleInRect: (NSR)aRect orientation: (AZCompass)orientation;
- (void) appendBezierPathWithPlateInRect: 	(NSR)rect;
- (void) appendBezierPathWithRoundedRect: 	(NSR)rect cornerRadius:(float)radius;
#pragma mark Rounded rectangles
+ (NSBP*) bezierPathWithRoundedRect: 			(NSR)rect;
+ (NSBP*) bezierPathWithRoundedRect: 			(NSR)rect radius:(CGF)radius;
+ (NSBP*) bezierPathWithLeftRoundedRect:  	(NSR)rect radius:(CGF)radius;
+ (NSBP*) bezierPathWithRightRoundedRect: 	(NSR)rect radius:(CGF)radius;
+ (NSBP*) bezierPathWithRoundedTopCorners:	(NSR)rect radius:(CGF)radius;
+ (NSBP*) bezierPathWithRoundedBottomCorners:(NSR)rect radius:(CGF)radius;
+ (NSBP*) bezierPathWithRoundedRect: 			(NSR)aRect cornerRadius:(CGF)radius;
+ (NSBP*) bezierPathWithRoundedRect: 			(NSR)aRect cornerRadius:(CGF)radius inCorners:(OSCornerType)corners;
+ (NSBP*) bezierPathRoundedRectOfSize:			(NSSZ)backgroundSize;
#pragma mark Arrows
/* default metrics of the arrow (as returned by +bezierPathWithArrow):
 *	^
 *   / \
 *  /   \
 * /_   _\ ___
 *   | |	| shaft length multiplier:
 *   | |	| 1.0
 *   | |	| equals shaft length:
 *   |_|   _|_0.5
 *
 *   default shaft width: 1/3
 * the bounds of this arrow are { { 0, 0 }, { 1, 1 } }.
 * the other three methods allow you to override either or both of these metrics.		*/
+ (NSBP*)bezierPathWithArrowWithShaftLengthMultiplier:(CGF)shaftLengthMulti shaftWidth:(CGF)shaftWidth;
+ (NSBP*)bezierPathWithArrowWithShaftLengthMultiplier:(CGF)shaftLengthMulti;
+ (NSBP*)bezierPathWithArrowWithShaftWidth:(CGF)shaftWidth;
+ (NSBP*)bezierPathWithArrow;
#pragma mark Nifty things
//these three are in-place. they return self, so that you can do e.g. [[NSBezierPath bezierPathWithArrow] flipVertically].
- (NSBP*)flipHorizontally;
- (NSBP*)flipVertically;
- (NSBP*)scaleToSize:(NSSZ)newSize;
//these three return an autoreleased copy.
- (NSBP*)bezierPathByFlippingHorizontally;
- (NSBP*)bezierPathByFlippingVertically;
- (NSBP*)bezierPathByScalingToSize:(NSSZ)newSize;
@end
/*	Available at http://earthlingsoft.net/code/NSBezierPath+ESPoints/		More code at http://earthlingsoft.net/code/
	You may use this code in your own projects at your own risk. Please notify us of problems you discover and be sure to give reasonable credit.
	-drawPointsAndHandles 		Category on NSBezierPath for drawing anchor and handle control points with a single method call.  Draws the control points of the path and associated handles in green and the anchor points in red, which is particularly useful when debugging Bézier paths. 	Call it after stroking the path to get the full picture. The remaining methods allow finer control of the colour usage and are helper methods for doing the drawing.	
*/
@interface NSBezierPath (ESPoints)
- (void) drawPointsAndHandles;
- (void) drawPoint:(NSP)pt;
- (void) drawPoint:(NSP)pt inColor:(NSC*)pointColor;
- (void) drawPointsInColor:			  (NSC*)pointColor withHandlesInColor:(NSC*)handleColor;
- (void) drawHandlePoint:(NSP)pt;
- (void) drawHandlePoint:(NSP)pt inColor:(NSC*)pointColor;
- (NSP) drawPathElement:(int)n withPreviousPoint: (NSP)previous;
- (NSP) drawPathElement:(int)n withPreviousPoint: (NSP)previous inColor:(NSC*)pointColor withHandlesInColor:(NSC*) handleColor;
@end

@interface NSBezierPath (RoundRects)
+ (void)	fillRoundRectInRect:	 			 (NSR)rect radius:(CGF)radius;
+ (void)	strokeRoundRectInRect:  		 (NSR)rect radius:(CGF)radius;
+ (NSBP*) bezierPathWithRoundRectInRect:(NSR)rect radius:(CGF)radius;
NSP  UKCenterOfRect		 ( NSR rect );
NSP  UKTopCenterOfRect	 ( NSR rect );
NSP  UKTopLeftOfRect	 	 ( NSR rect );
NSP  UKTopRightOfRect		 ( NSR rect );
NSP  UKLeftCenterOfRect	 ( NSR rect );
NSP  UKBottomCenterOfRect( NSR rect );
NSP  UKBottomLeftOfRect	 ( NSR rect );
NSP  UKBottomRightOfRect ( NSR rect );
NSP  UKRightCenterOfRect ( NSR rect );

@end


@interface NSBezierPath(RoundedRectangle)
/*
 * Returns a closed bezier path describing a rectangle with curved corners
 * The corner radius will be trimmed to not exceed half of the lesser rectangle dimension.
 * <http://www.cocoadev.com/index.pl?RoundedRectangles>
 */
+ (NSBezierPath *)bezierPathWithRoundedRect:(NSRect) aRect radius:(float) radius;
+ (NSBezierPath*)bezierPathWithTopRoundedRect:(NSRect)aRect radius:(float)radius;
+ (NSBezierPath*)bezierPathWithBottomRoundedRect:(NSRect)aRect radius:(float)radius;

/* Fill a path with a gradient color - lighter at top, darker at bottom
 * <http://www.wilshipley.com/blog/2005/07/pimp-my-code-part-3-gradient.html>
 */
- (void)gradientFillWithColor:(NSColor*)color;
@end
