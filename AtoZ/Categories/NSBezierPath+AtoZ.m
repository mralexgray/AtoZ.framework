
//  GTMNSBezierPath+CGPath.m

//  Category for extracting a CGPathRef from a NSBezierPath
#import "NSBezierPath+AtoZ.h"
//#import "GTMDefines.h"
#import "AtoZ.h"

#define ONE_THIRD  (1.0f/3.0f)
#define TWO_THIRDS (2.0f/3.0f)
#define ONE_HALF    0.5f

#define DEFAULT_SHAFT_WIDTH ONE_THIRD
#define DEFAULT_SHAFT_LENGTH_MULTI 1.0f

@implementation NSAffineTransform (UKShearing)

+ (NSAffineTransform *)transformRotatingAroundPoint:(NSPoint) p byDegrees:(CGFloat) deg
{
    NSAffineTransform * transform = [NSAffineTransform transform];
    [transform translateXBy: p.x yBy: p.y];
    [transform rotateByDegrees:deg];
    [transform translateXBy: -p.x yBy: -p.y];
    return transform;
}

-(void)	shearXBy: (CGFloat)xFraction yBy: (CGFloat)yFraction
{
	NSAffineTransform*		theTransform = [NSAffineTransform transform];
	NSAffineTransformStruct	transformStruct = { 0 };
	
	transformStruct.m11 = 1.0;
	transformStruct.m12 = yFraction;
	transformStruct.m21 = xFraction;
	transformStruct.m22 = 1.0;
	
	[theTransform setTransformStruct: transformStruct];
	[self prependTransform: theTransform];
}

@end
@implementation NSBezierPath (AtoZ)

+ (NSBezierPath *)bezierPathWithPlateInRect:(NSRect)rect
{
	NSBezierPath *result = [[NSBezierPath alloc] init];
	[result appendBezierPathWithPlateInRect:rect];
	return [result autorelease];
}

- (void)appendBezierPathWithPlateInRect:(NSRect)rect
{
	if (rect.size.height > 0) {
		float xoff = rect.origin.x;
		float yoff = rect.origin.y;
		float radius = rect.size.height/2.0;
		NSPoint point4 = NSMakePoint(xoff+radius, yoff+rect.size.height);
		NSPoint center1 = NSMakePoint(xoff+radius, yoff+radius);
		NSPoint center2 = NSMakePoint(xoff+rect.size.width-radius, yoff+radius);
		[self moveToPoint:point4];
		[self appendBezierPathWithArcWithCenter:center1 radius:radius startAngle:90.0 endAngle:270.0];
		[self appendBezierPathWithArcWithCenter:center2 radius:radius startAngle:270.0 endAngle:90.0];
		[self closePath];
	}
}
//+ (NSBezierPath *)bezierPathWithRoundedRect:(NSRect)rect cornerRadius:(float)radius
//{
//	NSBezierPath *result = [[[NSBezierPath alloc] init] autorelease];
//	[result appendBezierPathWithRoundedRect:rect cornerRadius:radius];
//	return result;
//}

- (void)appendBezierPathWithRoundedRect:(NSRect)rect cornerRadius:(float)radius
{
	if (rect.size.height > 0) {
		float xoff = rect.origin.x;
		float yoff = rect.origin.y;
		NSPoint startpoint = NSMakePoint(xoff, yoff+radius);
		NSPoint center1 = NSMakePoint(xoff+radius, yoff+radius);
		NSPoint center2 = NSMakePoint(xoff+rect.size.width-radius, yoff+radius);
		NSPoint center3 = NSMakePoint(xoff+rect.size.width-radius, yoff+rect.size.height-radius);
		NSPoint center4 = NSMakePoint(xoff+radius, yoff+rect.size.height-radius);
		[self moveToPoint:startpoint];
		[self appendBezierPathWithArcWithCenter:center1 radius:radius startAngle:180.0 endAngle:270.0];
		[self appendBezierPathWithArcWithCenter:center2 radius:radius startAngle:270.0 endAngle:360.0];
		[self appendBezierPathWithArcWithCenter:center3 radius:radius startAngle:360.0 endAngle:90.0];
		[self appendBezierPathWithArcWithCenter:center4 radius:radius startAngle:90.0 endAngle:180.0];
		[self closePath];
	}
}

+ (NSBezierPath *)bezierPathWithTriangleInRect:(NSRect)aRect orientation:(AMTriangleOrientation)orientation
{
	NSBezierPath *result = [[[NSBezierPath alloc] init] autorelease];
	[result appendBezierPathWithTriangleInRect:aRect orientation:orientation];
	return result;
}

- (void)appendBezierPathWithTriangleInRect:(NSRect)aRect orientation:(AMTriangleOrientation)orientation
{
	NSPoint a, b, c;
	switch (orientation)	{
		case AMTriangleUp:
		{
		a = NSMakePoint(NSMinX(aRect), NSMinY(aRect));
		b = NSMakePoint((NSMinX(aRect) + NSMaxX(aRect)) / 2, NSMaxY(aRect));
		c = NSMakePoint(NSMaxX(aRect), NSMinY(aRect));
		break;
		}

		case AMTriangleDown:
		{
		a = NSMakePoint(NSMinX(aRect), NSMaxY(aRect));
		c = NSMakePoint(NSMaxX(aRect), NSMaxY(aRect));
		b = NSMakePoint((NSMinX(aRect) + NSMaxX(aRect)) / 2, NSMinY(aRect));
		break;
		}

		case AMTriangleLeft:
		{
		a = NSMakePoint(NSMaxX(aRect), NSMaxY(aRect));
		b = NSMakePoint(NSMaxX(aRect), NSMinY(aRect));
		c = NSMakePoint(NSMinX(aRect), (NSMinY(aRect) + NSMaxY(aRect)) / 2);
		break;
		}

		default : // case AMTriangleRight:
		{
		a = NSMakePoint(NSMinX(aRect), NSMinY(aRect));
		b = NSMakePoint(NSMinX(aRect), NSMaxY(aRect));
		c = NSMakePoint(NSMaxX(aRect), (NSMinY(aRect) + NSMaxY(aRect)) / 2);
		break;
		}
	}

	[self moveToPoint:a];
	[self lineToPoint:b];
	[self lineToPoint:c];
	[self closePath];
}

- (void) drawWithFill:(NSColor*)fill andStroke:(NSColor*)stroke
{
	[fill setFill];
	[self fill];
	[stroke setStroke];
	[self stroke];
}

- (void)fillGradientFrom:(NSColor*)inStartColor to:(NSColor*)inEndColor angle:(float)inAngle
{


	NSGradient *fillGradient = [[NSGradient alloc] initWithStartingColor:inStartColor endingColor:inEndColor];
	
	[fillGradient drawInBezierPath:self angle:inAngle];
	/*
	
	CIImage*	coreimage;
	inStartColor = [inStartColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	inEndColor 	 = [inEndColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	
	CIColor* startColor = [CIColor colorWithRed:[inStartColor redComponent] green:[inStartColor greenComponent] blue:[inStartColor blueComponent] alpha:[inStartColor alphaComponent]];
	CIColor* endColor = [CIColor colorWithRed:[inEndColor redComponent] green:[inEndColor greenComponent] blue:[inEndColor blueComponent] alpha:[inEndColor alphaComponent]];
	
	CIFilter* filter;
	
	filter = [CIFilter filterWithName:@"CILinearGradient"];
	[filter setValue:startColor forKey:@"inputColor0"];
	[filter setValue:endColor forKey:@"inputColor1"];
	
	CIVector* startVector;
	CIVector* endVector;
	
	startVector = [CIVector vectorWithX:0.0 Y:0.0];
	endVector = [CIVector vectorWithX:0.0 Y:[self bounds].size.height];
	
	[filter setValue:startVector forKey:@"inputPoint0"];
	[filter setValue:endVector forKey:@"inputPoint1"];
	
	coreimage = [filter valueForKey:@"outputImage"];
	
	[[NSGraphicsContext currentContext] saveGraphicsState];
	
	CIContext* context;
	
	context = [[NSGraphicsContext currentContext] CIContext];
	
	[self setClip];
	
	[context drawImage:coreimage atPoint:CGPointZero fromRect:CGRectMake( 0.0, 0.0, [self bounds].size.width + 100.0, [self bounds].size.height + 100.0 )];
	
	[[NSGraphicsContext currentContext] restoreGraphicsState];
	*/
}

+ (NSBezierPath *)bezierPathWithLeftRoundedRect:(NSRect)rect radius:(CGFloat)radius
{
    // Make sure radius doesn't exceed a maximum size to avoid artifacts:
    radius = fmin(radius, fmin(0.5f * NSHeight(rect), NSWidth(rect)));
    
    // Make sure silly values simply lead to un-rounded corners:
    if( radius <= 0 )
        return [self bezierPathWithRect:rect];
    
    NSRect ignored, innerRect;
    NSDivideRect(NSInsetRect(rect, 0.0, radius), &ignored, &innerRect, radius, NSMinXEdge); // Make rect with corners being centers of the corner circles.
    NSBezierPath *path = [self bezierPath];
    
    // Now draw our rectangle:
    [path moveToPoint: NSMakePoint(NSMaxX(rect), NSMinY(rect))];
    
    // Right edge:
    [path lineToPoint:NSMakePoint(NSMaxX(rect), NSMaxY(rect))];
    // Top edge and top left:
    [path appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(innerRect), NSMaxY(innerRect)) radius:radius startAngle:90.0  endAngle:180.0];
    // Left edge and bottom left:
    [path appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(innerRect), NSMinY(innerRect)) radius:radius startAngle:180.0  endAngle:270.0 ];
    // Bottom edge:
    [path closePath];
    
    return path;
}

+ (NSBezierPath *)bezierPathWithRightRoundedRect:(NSRect)rect radius:(CGFloat)radius
{
    // Make sure radius doesn't exceed a maximum size to avoid artifacts:
    radius = fmin(radius, fmin(0.5f * NSHeight(rect), NSWidth(rect)));
    
    // Make sure silly values simply lead to un-rounded corners:
    if( radius <= 0 )
        return [self bezierPathWithRect:rect];
    
    NSRect ignored, innerRect;
    NSDivideRect(NSInsetRect(rect, 0.0, radius), &ignored, &innerRect, radius, NSMaxXEdge); // Make rect with corners being centers of the corner circles.
    NSBezierPath *path = [self bezierPath];
    
    // Now draw our rectangle:
    [path moveToPoint: NSMakePoint(NSMinX(rect), NSMaxY(rect))];
    
    // Left edge:
    [path lineToPoint:NSMakePoint(NSMinX(rect), NSMinY(rect))];
    // Bottom edge and bottom right:
    [path appendBezierPathWithArcWithCenter:NSMakePoint(NSMaxX(innerRect), NSMinY(innerRect)) radius:radius startAngle:270.0 endAngle:360.0];
    // Right edge and top right:
    [path appendBezierPathWithArcWithCenter:NSMakePoint(NSMaxX(innerRect), NSMaxY(innerRect)) radius:radius startAngle:0.0  endAngle:90.0 ];
    // Top edge:
    [path closePath];
    
    return path;
}

- (NSArray *)dashPattern {
    NSInteger i, count = 0;
    NSMutableArray *array = [NSMutableArray array];
    [self getLineDash:NULL count:&count phase:NULL];
    if (count > 0) {
        CGFloat pattern[count];
        [self getLineDash:pattern count:&count phase:NULL];
        for (i = 0; i < count; i++)
            [array addObject:@(pattern[i])];
    }
    return array;
}

- (void)setDashPattern:(NSArray *)newPattern {
    NSInteger i, count = [newPattern count];
    CGFloat pattern[count];
    for (i = 0; i< count; i++)
        pattern[i] = [newPattern[i] doubleValue];
    [self setLineDash:pattern count:count phase:0];
}

- (NSPoint)associatedPointForElementAtIndex:(NSUInteger)anIndex {
    NSPoint points[3];
    if (NSCurveToBezierPathElement == [self elementAtIndex:anIndex associatedPoints:points])
        return points[2];
    else
        return points[0];
}

- (NSRect)nonEmptyBounds {
    NSRect bounds = [self bounds];
    if (NSIsEmptyRect(bounds) && [self elementCount]) {
        NSPoint point, minPoint = NSZeroPoint, maxPoint = NSZeroPoint;
        NSUInteger i, count = [self elementCount];
        for (i = 0; i < count; i++) {
            point = [self associatedPointForElementAtIndex:i];
            if (i == 0) {
                minPoint = maxPoint = point;
            } else {
                minPoint.x = fmin(minPoint.x, point.x);
                minPoint.y = fmin(minPoint.y, point.y);
                maxPoint.x = fmax(maxPoint.x, point.x);
                maxPoint.y = fmax(maxPoint.y, point.y);
            }
        }
        bounds = NSMakeRect(minPoint.x - 0.1, minPoint.y - 0.1, maxPoint.x - minPoint.x + 0.2, maxPoint.y - minPoint.y + 0.2);
    }
    return bounds;
}

+ (NSBezierPath *)bezierPathWithRoundedRect:(NSRect)aRect cornerRadius:(CGFloat)radius inCorners:(OSCornerType)corners
{
	NSBezierPath* path = [self bezierPath];
	radius = MIN(radius, 0.5f * MIN(NSWidth(aRect), NSHeight(aRect)));
	NSRect rect = NSInsetRect(aRect, radius, radius);
	
	if (corners & OSBottomLeftCorner)
	{
		[path appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(rect), NSMinY(rect)) radius:radius startAngle:180.0 endAngle:270.0];
	}
	else
	{
		NSPoint cornerPoint = NSMakePoint(NSMinX(aRect), NSMinY(aRect));
		[path appendBezierPathWithPoints:&cornerPoint count:1];
	}
	
	if (corners & OSBottomRightCorner)
	{
		[path appendBezierPathWithArcWithCenter:NSMakePoint(NSMaxX(rect), NSMinY(rect)) radius:radius startAngle:270.0 endAngle:360.0];
	}
	else
	{
		NSPoint cornerPoint = NSMakePoint(NSMaxX(aRect), NSMinY(aRect));
		[path appendBezierPathWithPoints:&cornerPoint count:1];
	}
	
	if (corners & OSTopRightCorner)
	{
		[path appendBezierPathWithArcWithCenter:NSMakePoint(NSMaxX(rect), NSMaxY(rect)) radius:radius startAngle:  0.0 endAngle: 90.0];
	}
	else
	{
		NSPoint cornerPoint = NSMakePoint(NSMaxX(aRect), NSMaxY(aRect));
		[path appendBezierPathWithPoints:&cornerPoint count:1];
	}
	
	if (corners & OSTopLeftCorner)
	{
		[path appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(rect), NSMaxY(rect)) radius:radius startAngle: 90.0 endAngle:180.0];
	}
	else
	{
		NSPoint cornerPoint = NSMakePoint(NSMinX(aRect), NSMaxY(aRect));
		[path appendBezierPathWithPoints:&cornerPoint count:1];
	}
	
	[path closePath];
	return path;	
}

+ (NSBezierPath *)bezierPathWithRoundedRect:(NSRect)aRect cornerRadius:(CGFloat)radius
{
	return [NSBezierPath bezierPathWithRoundedRect:aRect cornerRadius:radius inCorners:OSTopLeftCorner | OSTopRightCorner | OSBottomLeftCorner | OSBottomRightCorner];
}

// This method works only in Mac OS X v10.2 and later.
- (CGPathRef)quartzPath
{
    int i, numElements;
	
    // Need to begin a path here.
    CGPathRef           immutablePath = NULL;
	
    // Then draw the path elements.
    numElements = [self elementCount];
    if (numElements > 0)
    {
        CGMutablePathRef    path = CGPathCreateMutable();
        NSPoint             points[3];
        BOOL                didClosePath = YES;
		
        for (i = 0; i < numElements; i++)
        {
            switch ([self elementAtIndex:i associatedPoints:points])
            {
                case NSMoveToBezierPathElement:
                    CGPathMoveToPoint(path, NULL, points[0].x, points[0].y);
                    break;
					
                case NSLineToBezierPathElement:
                    CGPathAddLineToPoint(path, NULL, points[0].x, points[0].y);
                    didClosePath = NO;
                    break;
					
                case NSCurveToBezierPathElement:
                    CGPathAddCurveToPoint(path, NULL, points[0].x, points[0].y,
										  points[1].x, points[1].y,
										  points[2].x, points[2].y);
                    didClosePath = NO;
                    break;
					
                case NSClosePathBezierPathElement:
                    CGPathCloseSubpath(path);
                    didClosePath = YES;
                    break;
            }
        }
		
        // Be sure the path is closed or Quartz may not do valid hit detection.
        if (!didClosePath)
            CGPathCloseSubpath(path);
		
        immutablePath = CGPathCreateCopy(path);
        CGPathRelease(path);
    }
	
    return immutablePath;
}

//#define MCBEZIER_USE_PRIVATE_FUNCTION

#ifdef MCBEZIER_USE_PRIVATE_FUNCTION
extern CGPathRef CGContextCopyPath(CGContextRef context);
#endif

static void CGPathCallback(void *info, const CGPathElement *element)
{
	NSBezierPath *path = (__bridge NSBezierPath*) info;
	CGPoint *points = element->points;
	
	switch (element->type) {
		case kCGPathElementMoveToPoint:
		{
			[path moveToPoint:NSMakePoint(points[0].x, points[0].y)];
			break;
		}
		case kCGPathElementAddLineToPoint:
		{
			[path lineToPoint:NSMakePoint(points[0].x, points[0].y)];
			break;
		}
		case kCGPathElementAddQuadCurveToPoint:
		{
			// NOTE: This is untested.
			NSPoint currentPoint = [path currentPoint];
			NSPoint interpolatedPoint = NSMakePoint((currentPoint.x + 2*points[0].x) / 3, (currentPoint.y + 2*points[0].y) / 3);
			[path curveToPoint:NSMakePoint(points[1].x, points[1].y) controlPoint1:interpolatedPoint controlPoint2:interpolatedPoint];
			break;
		}
		case kCGPathElementAddCurveToPoint:
		{
			[path curveToPoint:NSMakePoint(points[2].x, points[2].y) controlPoint1:NSMakePoint(points[0].x, points[0].y) controlPoint2:NSMakePoint(points[1].x, points[1].y)];
			break;
		}
		case kCGPathElementCloseSubpath:
		{
			[path closePath];
			break;
		}
	}
}
+ (NSBezierPath *)bezierPathWithCGPath:(CGPathRef)pathRef
{
	NSBezierPath *path = [NSBezierPath bezierPath];
	CGPathApply(pathRef,(__bridge void*)path, CGPathCallback);
	
	return path;
}

// Method borrowed from Google's Cocoa additions
- (CGPathRef)cgPath
{
	CGMutablePathRef thePath = CGPathCreateMutable();
	if (!thePath) return nil;
	
	unsigned int elementCount = [self elementCount];
	
	// The maximum number of points is 3 for a NSCurveToBezierPathElement.
	// (controlPoint1, controlPoint2, and endPoint)
	NSPoint controlPoints[3];
	
	for (unsigned int i = 0; i < elementCount; i++) {
		switch ([self elementAtIndex:i associatedPoints:controlPoints]) {
			case NSMoveToBezierPathElement:
				CGPathMoveToPoint(thePath, &CGAffineTransformIdentity, 
								  controlPoints[0].x, controlPoints[0].y);
				break;
			case NSLineToBezierPathElement:
				CGPathAddLineToPoint(thePath, &CGAffineTransformIdentity, 
									 controlPoints[0].x, controlPoints[0].y);
				break;
			case NSCurveToBezierPathElement:
				CGPathAddCurveToPoint(thePath, &CGAffineTransformIdentity, 
									  controlPoints[0].x, controlPoints[0].y,
									  controlPoints[1].x, controlPoints[1].y,
									  controlPoints[2].x, controlPoints[2].y);
				break;
			case NSClosePathBezierPathElement:
				CGPathCloseSubpath(thePath);
				break;
			default:
				NSLog(@"Unknown element at [NSBezierPath (GTMBezierPathCGPathAdditions) cgPath]");
				break;
		};
	}
	return thePath;
}

- (NSBezierPath *)pathWithStrokeWidth:(CGFloat)strokeWidth
{
#ifdef MCBEZIER_USE_PRIVATE_FUNCTION
	NSBezierPath *path = [self copy];
	CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
	CGPathRef pathRef = [path cgPath];
	[path release];
	
	CGContextSaveGState(context);
		
	CGContextBeginPath(context);
	CGContextAddPath(context, pathRef);
	CGContextSetLineWidth(context, strokeWidth);
	CGContextReplacePathWithStrokedPath(context);
	CGPathRef strokedPathRef = CGContextCopyPath(context);
	CGContextBeginPath(context);
	NSBezierPath *strokedPath = [NSBezierPath bezierPathWithCGPath:strokedPathRef];
	
	CGContextRestoreGState(context);
	
	CFRelease(pathRef);
	CFRelease(strokedPathRef);
	
	return strokedPath;
#else
	return nil;
#endif//MCBEZIER_USE_PRIVATE_FUNCTION
}

- (void)applyInnerShadow:(NSShadow *)shadow {
	[NSGraphicsContext saveGraphicsState];

	NSShadow *shadowCopy = [shadow copy];

	NSSize offset = shadowCopy.shadowOffset;
	CGFloat radius = shadowCopy.shadowBlurRadius;

	NSRect bounds = NSInsetRect(self.bounds, -(ABS(offset.width) + radius), -(ABS(offset.height) + radius));

	offset.height += bounds.size.height;
	shadowCopy.shadowOffset = offset;

	NSAffineTransform *transform = [NSAffineTransform transform];
	[transform translateXBy:0 yBy:([[NSGraphicsContext currentContext] isFlipped] ? 1 : -1) * bounds.size.height];

	NSBezierPath *drawingPath = [NSBezierPath bezierPathWithRect:bounds];
	[drawingPath setWindingRule:NSEvenOddWindingRule];

	[drawingPath appendBezierPath:self];
	[drawingPath transformUsingAffineTransform:transform];

	[self addClip];
	[shadowCopy set];

	[[NSColor blackColor] set];
	[drawingPath fill];

	[shadowCopy release];

	[NSGraphicsContext restoreGraphicsState];
}
- (void)fillWithInnerShadow:(NSShadow *)shadow
{
	[NSGraphicsContext state:^{	NSSize offset, originalOffset;
		originalOffset = offset = shadow.shadowOffset;
		CGF rad = shadow.shadowBlurRadius;
		NSR bounds = NSInsetRect(self.bounds, -(ABS(offset.width) + rad), -(ABS(offset.height) + rad));
		offset.height += bounds.size.height;
		shadow.shadowOffset = offset;
		NSAffineTransform *transform = [NSAT transform];
		[AZCURRENTCTX isFlipped] 	? [transform translateXBy:0 yBy:bounds.size.height]
									: [transform translateXBy:0 yBy:-bounds.size.height];
		NSBP *drawingPath = AZBezPath(bounds);
		[drawingPath setWindingRule:NSEvenOddWindingRule];
		[drawingPath appendBezierPath:self];
		[drawingPath transformUsingAffineTransform:transform];
		[self addClip];					[shadow set];
		[[NSColor blackColor] set];		[drawingPath fill];
		shadow.shadowOffset = originalOffset;
	}];
}

- (void)drawBlurWithColor:(NSColor *)color radius:(CGFloat)radius
{
	NSRect bounds = NSInsetRect(self.bounds, -radius, -radius);
	NSShadow *shadow = [[NSShadow alloc] init];
	shadow.shadowOffset = NSMakeSize(0, bounds.size.height);
	shadow.shadowBlurRadius = radius;
	shadow.shadowColor = color;
	NSBezierPath *path = [self copy];
	NSAffineTransform *transform = [NSAffineTransform transform];
	if ([[NSGraphicsContext currentContext] isFlipped])
		[transform translateXBy:0 yBy:bounds.size.height];
	else
		[transform translateXBy:0 yBy:-bounds.size.height];
	[path transformUsingAffineTransform:transform];
	
	[NSGraphicsContext saveGraphicsState];
	
	[shadow set];
	[[NSColor blackColor] set];
	NSRectClip(bounds);
	[path fill];
	
	[NSGraphicsContext restoreGraphicsState];
	
}
// Credit for the next two methods goes to Matt Gemmell
- (void)strokeInside
{
    /* Stroke within path using no additional clipping rectangle. */
    [self strokeInsideWithinRect:NSZeroRect];
}

- (void)strokeInsideWithinRect:(NSRect)clipRect
{
//    NSGraphicsContext *thisContext = [NSGraphicsContext currentContext];
    float lineWidth = [self lineWidth];
    
    /* Save the current graphics context. */
    [NSGraphicsContext saveGraphicsState];
    
    /* Double the stroke width, since -stroke centers strokes on paths. */
    [self setLineWidth:(lineWidth * 2.0)];
    
    /* Clip drawing to this path; draw nothing outwith the path. */
    [self addClip];
    
    /* Further clip drawing to clipRect, usually the view's frame. */
    if (clipRect.size.width > 0.0 && clipRect.size.height > 0.0) {
        [NSBezierPath clipRect:clipRect];
    }
    
    /* Stroke the path. */
    [self stroke];
    
    /* Restore the previous graphics context. */
    [NSGraphicsContext restoreGraphicsState];
    [self setLineWidth:lineWidth];
}

+(NSBezierPath*) bezierPathWithCappedBoxInRect: (NSRect)rect
{
    NSBezierPath* bezierPath = [NSBezierPath bezierPath];
    float cornerSize = rect.size.height / 2;
		// Corners:
    NSPoint leftTop 	= NSMakePoint(NSMinX(rect) + cornerSize, NSMaxY(rect));
    NSPoint rightTop 	= NSMakePoint(NSMaxX(rect) - cornerSize, NSMaxY(rect));
    NSPoint rightBottom = NSMakePoint(NSMaxX(rect) - cornerSize, NSMinY(rect));
    NSPoint leftBottom 	= NSMakePoint(NSMinX(rect) + cornerSize, NSMinY(rect));
		// Create our capped box:
		// Top edge:
    [bezierPath moveToPoint:leftTop];
    [bezierPath lineToPoint:rightTop];
		// Right cap:
    [bezierPath appendBezierPathWithArcWithCenter:NSMakePoint(rightTop.x,(NSMaxY(rect)+NSMinY(rect))/2)
										   radius:cornerSize startAngle:90 endAngle:-90 clockwise:YES];
		// Bottom edge:
    [bezierPath lineToPoint: rightBottom];
    [bezierPath lineToPoint: leftBottom];
		// Left cap:
    [bezierPath appendBezierPathWithArcWithCenter:NSMakePoint(leftTop.x,(NSMaxY(rect)+NSMinY(rect))/2)
										   radius:cornerSize startAngle:-90 endAngle:90 clockwise:YES];
    [bezierPath closePath]; // Just to be safe.
    return bezierPath;
}
#pragma mark Rounded rectangles

+ (NSBezierPath *)bezierPathRoundedRectOfSize:(NSSize)backgroundSize
{
	NSRect pathRect = NSMakeRect(0, 0, backgroundSize.width, backgroundSize.height);

	return [self bezierPathWithRoundedRect:pathRect];
}

+ (NSBezierPath *)bezierPathWithRoundedRect:(NSRect)bounds
{
	return [self bezierPathWithRoundedRect:bounds radius:MIN(bounds.size.width, bounds.size.height) / 2.0f];
}

+ (NSBezierPath *)bezierPathWithRoundedRect:(NSRect)rect radius:(CGFloat)radius
{
	return [NSBezierPath bezierPathWithRoundedRect:rect xRadius:radius yRadius:radius];
}

+ (NSBezierPath *)bezierPathWithRoundedTopCorners:(NSRect)rect radius:(CGFloat)radius
{
    NSBezierPath	*path = [NSBezierPath bezierPath];
    NSPoint 		topLeft, topRight, bottomLeft, bottomRight;

    topLeft = NSMakePoint(rect.origin.x, rect.origin.y);
    topRight = NSMakePoint(rect.origin.x + rect.size.width, rect.origin.y);
    bottomLeft = NSMakePoint(rect.origin.x, rect.origin.y + rect.size.height);
    bottomRight = NSMakePoint(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);

	[path moveToPoint:NSMakePoint(bottomLeft.x, bottomLeft.y)];
	[path lineToPoint:NSMakePoint(topLeft.x, topLeft.y + radius)];

    [path appendBezierPathWithArcWithCenter:NSMakePoint(topLeft.x + radius, topLeft.y + radius)
                                     radius:radius
                                 startAngle:180
                                   endAngle:270
                                  clockwise:NO];
    [path lineToPoint:NSMakePoint(topRight.x - radius, topRight.y)];

    [path appendBezierPathWithArcWithCenter:NSMakePoint(topRight.x - radius, topRight.y + radius)
                                     radius:radius
                                 startAngle:270
                                   endAngle:0
                                  clockwise:NO];
    [path lineToPoint:NSMakePoint(bottomRight.x, bottomRight.y)];
	[path closePath];

    return path;
}

+ (NSBezierPath *)bezierPathWithRoundedBottomCorners:(NSRect)rect radius:(CGFloat)radius
{
    NSBezierPath	*path = [NSBezierPath bezierPath];
    NSPoint 		topLeft, topRight, bottomLeft, bottomRight;

    topLeft = NSMakePoint(rect.origin.x, rect.origin.y);
    topRight = NSMakePoint(rect.origin.x + rect.size.width, rect.origin.y);
    bottomLeft = NSMakePoint(rect.origin.x, rect.origin.y + rect.size.height);
    bottomRight = NSMakePoint(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);

	[path moveToPoint:NSMakePoint(topRight.x, topRight.y)];
	[path lineToPoint:NSMakePoint(bottomRight.x, bottomRight.y - radius)];

    [path appendBezierPathWithArcWithCenter:NSMakePoint(bottomRight.x - radius, bottomRight.y - radius)
                                     radius:radius
                                 startAngle:0
                                   endAngle:90
                                  clockwise:NO];
    [path lineToPoint:NSMakePoint(bottomLeft.x + radius, bottomLeft.y)];

    [path appendBezierPathWithArcWithCenter:NSMakePoint(bottomLeft.x + radius, bottomLeft.y - radius)
                                     radius:radius
                                 startAngle:90
                                   endAngle:180
                                  clockwise:NO];
    [path lineToPoint:NSMakePoint(topLeft.x, topLeft.y)];
	[path closePath];

    return path;
}

#pragma mark Arrows

+ (NSBezierPath *)bezierPathWithArrowWithShaftLengthMultiplier:(CGFloat)shaftLengthMulti shaftWidth:(CGFloat)shaftWidth {
	NSBezierPath *arrowPath = [NSBezierPath bezierPath];

	/*   5
	 *  / \
	 * /   \    1-7 = points
	 *6-7 3-4   the point of the triangle is 100% from the bottom.
	 *    |     the back edge of the triangle is 50% * shaftLengthMulti from the bottom.
	 *  1-2
	 */

	const CGFloat shaftLength = ONE_HALF * shaftLengthMulti;
	const CGFloat shaftEndY = -(shaftLength - ONE_HALF); //the end of the arrow shaft (points 1-2).
														 //wing width = the distance between 6 and 7 and 3 and 4.
	const CGFloat wingWidth = (1.0f - shaftWidth) * 0.5f;

	//start with the bottom vertex.
	[arrowPath moveToPoint:NSMakePoint(wingWidth,  shaftEndY)]; //1
	[arrowPath relativeLineToPoint:NSMakePoint(shaftWidth, 0.0f)]; //2
																   //up to the inner right corner.
	[arrowPath relativeLineToPoint:NSMakePoint(0.0f, shaftLength)]; //3
																	//far right.
	[arrowPath relativeLineToPoint:NSMakePoint(wingWidth,  0.0f)]; //4
																   //top center - the point of the arrow.
	[arrowPath lineToPoint:NSMakePoint(ONE_HALF,  1.0f)]; //5
														  //far left.
	[arrowPath lineToPoint:NSMakePoint(0.0f,  ONE_HALF)]; //6
														  //inner left corner.
	[arrowPath relativeLineToPoint:NSMakePoint(wingWidth,  0.0f)]; //7
																   //to the finish line! yay!
	[arrowPath closePath];

	return arrowPath;
}

+ (NSBezierPath *)bezierPathWithArrowWithShaftLengthMultiplier:(CGFloat)shaftLengthMulti {
	return [self bezierPathWithArrowWithShaftLengthMultiplier:shaftLengthMulti
	                                               shaftWidth:DEFAULT_SHAFT_WIDTH];
}
+ (NSBezierPath *)bezierPathWithArrowWithShaftWidth:(CGFloat)shaftWidth {
	return [self bezierPathWithArrowWithShaftLengthMultiplier:DEFAULT_SHAFT_LENGTH_MULTI
	                                               shaftWidth:shaftWidth];
}
+ (NSBezierPath *)bezierPathWithArrow {
	return [self bezierPathWithArrowWithShaftLengthMultiplier:DEFAULT_SHAFT_LENGTH_MULTI
	                                               shaftWidth:DEFAULT_SHAFT_WIDTH];
}

#pragma mark Nifty things

//these three are in-place.
- (NSBezierPath *)flipHorizontally {
	NSAffineTransform *transform = [NSAffineTransform transform];

	//adapted from http://developer.apple.com/documentation/Carbon/Conceptual/QuickDrawToQuartz2D/tq_other/chapter_3_section_2.html
	[transform translateXBy: 1.0f yBy: 0.0f];
	[transform     scaleXBy:-1.0f yBy: 1.0f];

	[self transformUsingAffineTransform:transform];
	return self;
}
- (NSBezierPath *)flipVertically {
	NSAffineTransform *transform = [NSAffineTransform transform];

	//http://developer.apple.com/documentation/Carbon/Conceptual/QuickDrawToQuartz2D/tq_other/chapter_3_section_2.html
	[transform translateXBy: 0.0f yBy: 1.0f];
	[transform     scaleXBy: 1.0f yBy:-1.0f];

	[self transformUsingAffineTransform:transform];
	return self;
}
- (NSBezierPath *)scaleToSize:(NSSize)newSize {
	NSAffineTransform *transform = [NSAffineTransform transform];
	[transform scaleXBy:newSize.width yBy:newSize.height];

	[self transformUsingAffineTransform:transform];
	return self;
}

//these three return an autoreleased copy.
- (NSBezierPath *)bezierPathByFlippingHorizontally {
	return [(NSBezierPath*)[[self copy] autorelease] flipHorizontally];
}
- (NSBezierPath *)bezierPathByFlippingVertically {
	return [(NSBezierPath*)[[self copy] autorelease] flipVertically];
}
- (NSBezierPath *)bezierPathByScalingToSize:(NSSize)newSize {
	return [[[self copy] autorelease] scaleToSize:newSize];
}
@end
#define POINTSIZE 5.0
#define HANDLESIZE 3.0
#define HANDLELINEWIDTH 1.5
#define DEFAULTPOINTCOLOR [NSColor redColor]
#define DEFAULTHANDLECOLOR [NSColor greenColor]
@implementation NSBezierPath (ESPoints)

#pragma mark MAIN CONVENIENCE METHODS
- (void) drawPointsAndHandles {
	[self drawPointsInColor:DEFAULTPOINTCOLOR withHandlesInColor:DEFAULTHANDLECOLOR];
}

- (void) drawPointsInColor: (NSColor*) pointColor withHandlesInColor: (NSColor *) handleColor {
	NSPoint previousPoint = NSMakePoint(0.0, 0.0);
	for (NSInteger i=0; i < [self elementCount]; i++) {
		previousPoint = [self drawPathElement:i withPreviousPoint: previousPoint inColor:pointColor withHandlesInColor: handleColor];
	}
}

#pragma mark DRAWING POINTS

- (void) drawPoint: (NSPoint) pt {
	[self drawPoint:pt inColor: DEFAULTPOINTCOLOR];
}
- (void) drawPoint: (NSPoint) pt inColor: (NSColor*) pointColor {
	NSBezierPath * bp = [NSBezierPath bezierPathWithRect:NSMakeRect(pt.x - POINTSIZE * 0.5, pt.y - POINTSIZE * 0.5, POINTSIZE, POINTSIZE)];
	[pointColor set];
	[bp fill];
}

- (void) drawHandlePoint: (NSPoint) pt {
	[self drawHandlePoint: pt inColor:DEFAULTHANDLECOLOR];
}
- (void) drawHandlePoint: (NSPoint) pt inColor: (NSColor*) pointColor {
	NSBezierPath * bp = [NSBezierPath bezierPathWithRect:NSMakeRect(pt.x-HANDLESIZE * 0.5, pt.y - HANDLESIZE * 0.5, HANDLESIZE, HANDLESIZE)];
	[pointColor set];
	[bp fill];
}
#pragma mark DRAWING PATH ELEMENTS

- (NSPoint) drawPathElement:(int) n withPreviousPoint: (NSPoint) previous {
	return [self drawPathElement:n withPreviousPoint:previous inColor:DEFAULTPOINTCOLOR withHandlesInColor:DEFAULTHANDLECOLOR];
}
- (NSPoint) drawPathElement:(int) n  withPreviousPoint: (NSPoint) previous inColor: (NSColor*) pointColor withHandlesInColor: (NSColor*) handleColor {
	NSPoint previousPoint;
	NSPoint points[3];
	NSBezierPathElement element = [self elementAtIndex: n associatedPoints:points];
	NSBezierPath * bp;
	switch (element) {
		case NSCurveToBezierPathElement:
			bp = [NSBezierPath bezierPath];
			[bp moveToPoint:previous];
			[bp lineToPoint:points[0]];
			[bp moveToPoint:points[2]];
			[bp lineToPoint:points[1]];
			[bp setLineWidth:HANDLELINEWIDTH];
			[handleColor set];
			[bp stroke];

			[self drawHandlePoint: points[0] inColor:handleColor];
			[self drawHandlePoint: points[1] inColor:handleColor];
			[self drawPoint:points[2] inColor:pointColor];

			previousPoint = points[2];
			break;

		case NSMoveToBezierPathElement:
			[self drawPoint:points[0] inColor:pointColor];
			previousPoint = points[0];
			break;

		case NSLineToBezierPathElement:
			[self drawPoint:points[0] inColor:pointColor];

			/*
			 bp = [NSBezierPath bezierPath];
			 [bp moveToPoint:previousPoint];
			 [bp lineToPoint:points[0]];
			 [handleColor:set];
			 [bp setLineWidth:HANDLELINEWIDTH];
			 [bp stroke]
			 */
			previousPoint = points[0];
			break;
	}
	return previousPoint;
}

@end

///**********************************************************************************************************************************
///  NSBezierPath-Geometry.m
///  DrawKit ¬¨¬®¬¨¬Æ¬¨¬®¬¨¬©2005-2008 Apptree.net
///
///  Created by graham on 22/10/2006.
///
///	 This software is released subject to licensing conditions as detailed in DRAWKIT-LICENSING.TXT, which must accompany this source file. 
///
///**********************************************************************************************************************************


//#import "DKDrawKitMacros.h"
//#import "DKGeometryUtilities.h"
//#import "DKRandom.h"
#import "NSBezierPath+Editing.h"

#include <math.h>

#if 0
static void				ConvertPathApplierFunction ( void *info, const CGPathElement *element );
#endif
static float			lengthOfBezier(const  NSPoint bez[4], float acceptableError);
static inline float		distanceBetween(NSPoint a, NSPoint b);

static void				InterpolatePoints( const NSPoint* pointsIn, NSPoint* cp1, NSPoint* cp2, const float smooth_value );
static NSPoint			CornerPoint( const NSPoint* pointsIn, float offset, float miterLimit );
static BOOL				CornerArc( const NSPoint* pointsIn, float offset, NSBezierPath* newPath );
static BOOL				CornerBevel( const NSPoint* pointsIn, float offset, NSBezierPath* newPath );


@interface NSBezierPath (Geometry_Private)
- (NSBezierPath*)		paralleloidPathWithOffset3:(float) delta lineJoinStyle:(NSLineJoinStyle) js;

@end

@implementation NSBezierPath (Geometry)

- (NSBezierPath*)		scaledPath:(float) scale
{
	// returns a copy of the receiver scaled by <scale>, with the path's origin assumed to be at the centre of its bounds rect.

	NSPoint	cp = [self centreOfBounds];
	return [self scaledPath:scale aboutPoint:cp];
}


- (NSBezierPath*)		scaledPath:(float) scale aboutPoint:(NSPoint) cp
{
	// This is like an inset or an outset operation. If scale is 1.0, self is returned.
	
	if( scale == 1.0 )
		return self;
	else
	{
		NSBezierPath* copy = [self copy];
		
		NSAffineTransform*	xfm = [NSAffineTransform transform];
		[xfm translateXBy:cp.x yBy:cp.y];
		[xfm scaleXBy:scale yBy:scale];
		[xfm translateXBy:-cp.x yBy:-cp.y];
		
		[copy transformUsingAffineTransform:xfm];
	
		return [copy autorelease];
	}
}


- (NSBezierPath*)		rotatedPath:(float) angle
{
	// return a rotated copy of the receiver. The origin is taken as the centre of the path bounds.
	// angle is a value in radians
	
	return [self rotatedPath:angle aboutPoint:[self centreOfBounds]];
}


- (NSBezierPath*)		rotatedPath:(float) angle aboutPoint:(NSPoint) cp
{
	// return a rotated copy of the receiver. The origin is taken as point <cp> relative to the original path.
	// angle is a value in radians
	
	if( angle == 0.0 )
		return self;
	else
	{
		NSBezierPath* copy = [self copy];
	
		NSAffineTransform*	xfm = RotationTransform( angle, cp );
		[copy transformUsingAffineTransform:xfm];
		
		return [copy autorelease];
	}
}


- (NSBezierPath*)		insetPathBy:(float) amount
{
	// returns a scaled copy of the receiver, calculating the scale by adding <amount> to all edges of the bounds.
	// since this can scale differently in x and y directions, this doesn't call the scale function but works
	// very similarly.
	
	// note that due to the mathematics of bezier curves, this may not produce exactly perfect results for some
	// curves.
	
	// +ve values of <amount> inset (shrink) the path, -ve values outset (grow) the shape.
	
	if( amount == 0.0 )
		return self;
	else
	{
		NSRect	r = NSInsetRect([self bounds], amount, amount );
		float	xs, ys;
		
		xs = r.size.width / [self bounds].size.width;
		ys = r.size.height / [self bounds].size.height;
		
		NSBezierPath* copy = [self copy];
		NSPoint		cp = [copy centreOfBounds];
		
		NSAffineTransform*	xfm = [NSAffineTransform transform];
		[xfm translateXBy:cp.x yBy:cp.y];
		[xfm scaleXBy:xs yBy:ys];
		[xfm translateXBy:-cp.x yBy:-cp.y];
		
		[copy transformUsingAffineTransform:xfm];
		
		return [copy autorelease];
	}
}


- (NSBezierPath*)		horizontallyFlippedPathAboutPoint:(NSPoint) cp
{
	NSBezierPath* copy = [self copy];
	
	NSAffineTransform*	xfm = [NSAffineTransform transform];
	[xfm translateXBy:cp.x yBy:cp.y];
	[xfm scaleXBy:-1.0 yBy:1.0];
	[xfm translateXBy:-cp.x yBy:-cp.y];
	
	[copy transformUsingAffineTransform:xfm];
	
	return [copy autorelease];
}


- (NSBezierPath*)		verticallyFlippedPathAboutPoint:(NSPoint) cp
{
	NSBezierPath* copy = [self copy];
	
	NSAffineTransform*	xfm = [NSAffineTransform transform];
	[xfm translateXBy:cp.x yBy:cp.y];
	[xfm scaleXBy:1.0 yBy:-1.0];
	[xfm translateXBy:-cp.x yBy:-cp.y];
	
	[copy transformUsingAffineTransform:xfm];
	
	return [copy autorelease];
}


- (NSBezierPath*)		horizontallyFlippedPath
{
	return [self horizontallyFlippedPathAboutPoint:[self centreOfBounds]];
}


- (NSBezierPath*)		verticallyFlippedPath
{
	return [self verticallyFlippedPathAboutPoint:[self centreOfBounds]];
}


- (NSPoint)				centreOfBounds
{
	return NSMakePoint( NSMidX([self bounds]), NSMidY([self bounds]));
}


- (float)				minimumCornerAngle
{
	// returns the smallest angle subtended by any segment join in the path. The largest value this can be is pi (180 degrees), the smallest is 0. The
	// resultis in radians. Can be used to determine the necessary bounding rect of the path for a given stroke width and miter limit. For curve
	// elements, the curvature is ignored and the element treated as a line segment.
	
	float				v, a = pi;
	int					i, m = [self elementCount] - 1;
	NSBezierPathElement	element, nextElement;
	NSPoint				fp, cp, pp, xp, ap[3], np[3];
	
	fp = cp = pp = xp = NSZeroPoint;
	
	for( i = 0; i < m; ++i )
	{
		element = [self elementAtIndex:i associatedPoints:ap];
		nextElement = [self elementAtIndex:i + 1 associatedPoints:np];
		
		switch( element )
		{
			case NSMoveToBezierPathElement:
				fp = pp = ap[0];
				continue;
				
			case NSLineToBezierPathElement:
				cp = ap[0];
				break;
				
			case NSCurveToBezierPathElement:
				cp = ap[2];
				break;
				
			case NSClosePathBezierPathElement:
				cp = fp;
				break;
				
			default:
				break;
		}
		
		switch( nextElement )
		{
			case NSMoveToBezierPathElement:
				continue;
				
			case NSLineToBezierPathElement:
				xp = np[0];
				break;
				
			case NSCurveToBezierPathElement:
				xp = np[2];
				break;
				
			case NSClosePathBezierPathElement:
				xp = fp;
				break;
				
			default:
				break;
		}
		
		v = fabs( AngleBetween( pp, cp, xp ));
		
		if ( v < a )
			a = v;
			
		pp = cp;
	}
	
	return a;
}


- (NSBezierPath*)		bezierPathByIteratingWithDelegate:(id) delegate contextInfo:(void*) contextInfo
{
	// this method allows a delegate to use the info from the receiver to build a new path element by element. This is a generic method that is intended to
	// avoid the need to write these loops over and over. The delegate is passed the points of each element in an order that is easier to work with than
	// the native list and also always includes the last point in a subpath.
	
	NSAssert( delegate != nil, @"cannot operate with a nil delegate");
	
	if(![delegate respondsToSelector:@selector(path:elementIndex:type:points:subPathIndex:subPathClosed:contextInfo:)])
		return nil;
		
	if([self isEmpty])
		return nil;
		
	NSBezierPath* newPath = [NSBezierPath bezierPath];	
	
	int					i, m, spi = -1;
	NSPoint				ap[3];
	NSPoint				rp[4];
	BOOL				spc = NO;
	NSBezierPathElement	element;
	
	m = [self elementCount];
	
	for( i = 0; i < m; ++i )
	{
		element = [self elementAtIndex:i associatedPoints:ap];
		
		if( element == NSMoveToBezierPathElement )
		{
			// get info about the end of this subpath
			
			++spi;
			
			// is it closed?
			
			spc = [self subpathContainingElementIsClosed:i];
			
			// what is its end point?
			
			int			spe = [self subpathEndingElementForElement:i];
			NSPoint		ep[3];
			
			if ( spc )
				--spe;	// ignore closePath element
				
			NSBezierPathElement	ee = [self elementAtIndex:spe associatedPoints:ep];
			
			if ( ee == NSCurveToBezierPathElement )
				rp[3] = ep[2];
			else
				rp[3] = ep[0];
		}
		
		// set up the list of points (reordered from ap). The list passed to the delegate is always ordered thus:
		//[0] = the next on-path point
		//[1] = cp1 for a curve element
		//[2] = cp2 for a curve element
		//[3] = the end point of the current subpath
		
		if( element == NSCurveToBezierPathElement )
		{
			rp[0] = ap[2];
			rp[1] = ap[0];
			rp[2] = ap[1];
		}
		else
			rp[0] = rp[1] = rp[2] = ap[0];
	
		// let the delegate do its thing with the info:
		
		[delegate path:newPath elementIndex:i type:element points:rp subPathIndex:spi subPathClosed:spc contextInfo:contextInfo];
	}
	
	return newPath;
}


- (NSBezierPath*)		paralleloidPathWithOffset:(float) delta
{
	// returns a copy of the receiver modified by offsetting all of its control points by <delta> in the direction of the
	// normal of the path at the location of the on-path control point. This will create a parallel-ish offset path that works
	// for most non-pathological paths. Given that there is no known mathematically correct way to do this (for bezier curves), this works well enough in
	// many practical situations. Positive delta moves the path below or to the right, -ve is up and left.
	
	NSBezierPath* newPath = [NSBezierPath bezierPath];
	
	if( ![self isEmpty])
	{
		int						i, count = [self elementCount];
		NSPoint					ap[3], np[3], p0, p1;
		NSBezierPathElement		kind, nextKind;
		float					slope, dx, dy, pdx, pdy;
		
		pdx = pdy = 0;
		
		for( i = 0; i < count; ++i )
		{
			kind = [self elementAtIndex:i associatedPoints:ap];
			
			if ( i < count - 1 )
			{
				nextKind = [self elementAtIndex:i + 1 associatedPoints:np];
				
				// calculate the slope of the on-path point
				
				if ( kind != NSCurveToBezierPathElement )
				{
					p0 = ap[0];
					p1 = np[0];
				}
				else
				{
					p0 = ap[2];
					p1 = np[0];
				}
			}
			else
			{
				if ( kind == NSCurveToBezierPathElement )
				{
					p1 = ap[2];
					p0 = ap[1];
				}
				else
				{
					p1 = ap[0];
					
					nextKind = [self elementAtIndex:i - 1 associatedPoints:np];
				
					if ( nextKind != NSCurveToBezierPathElement )
						p0 = np[0];
					else
						p0 = np[2];
				}
			}
			
			slope = atan2f( p1.y - p0.y, p1.x - p0.x ) + ( pi * 0.5 );
			
			// calculate the position of the modified point
			
			dx = delta * cosf( slope );
			dy = delta * sinf( slope );
			
			switch( kind )
			{
				case NSMoveToBezierPathElement:
					ap[0].x += dx;
					ap[0].y += dy;
					[newPath moveToPoint:ap[0]];
					break;
					
				case NSLineToBezierPathElement:
					ap[0].x += dx;
					ap[0].y += dy;
					[newPath lineToPoint:ap[0]];
					break;
					
				case NSCurveToBezierPathElement:
					ap[0].x += pdx;
					ap[0].y += pdy;
					ap[1].x += dx;
					ap[1].y += dy;
					ap[2].x += dx;
					ap[2].y += dy;
					[newPath curveToPoint:ap[2] controlPoint1:ap[0] controlPoint2:ap[1]];
					break;
					
				case NSClosePathBezierPathElement:
					[newPath closePath];
					break;
					
				default:
					break;
			}
			
			pdx = dx;
			pdy = dy;
		}
	}

	return newPath;
}


static NSPoint	CornerPoint( const NSPoint* pointsIn, float offset, float miterLimit )
{
	// given 3 points in pointsIn, this returns the point that bisects the angle between the vertices, and is extended to intercept the <offset>
	// parallel up to <miterLimit>. This is used to compute the correct location of a vertex for a parallel offset path.	
	// for zero offset, result is simply second point.
	// The three points are three consecutive vertices from the original path.
	
	if( offset == 0.0 )
		return pointsIn[1];
	
	NSPoint rp;
	float	relAngle, r, s1, s2, angle;
	
	s1 = Slope( pointsIn[0], pointsIn[1]);
	s2 = Slope( pointsIn[1], pointsIn[2]);
	
	relAngle = ( s2 - s1 ) * 0.5f;
	r = offset / cosf( relAngle );
	angle = s1 + relAngle + NINETY_DEGREES;
	
	float maxR = fabs( miterLimit * offset );
	
	if( r > maxR )
		r = maxR;
	
	if( r < -maxR )
		r = -maxR;
	
	rp.x = pointsIn[1].x + r * cosf( angle );
	rp.y = pointsIn[1].y + r * sinf( angle );
	
	return rp;
}


static BOOL		CornerArc( const NSPoint* pointsIn, float offset, NSBezierPath* newPath )
{
	// returns an arc segment that is centred at the middle vertex having a radius of <offset> and a start point and end point such that the offset normals to the original
	// edges are joined by the arc. If the vertex is an inside bend, returns nil in which case the CornerPoint should be used.
	
	if( offset == 0.0 )
		return NO;
	
	float	s1, s2, ra;
	
	s1 = Slope( pointsIn[0], pointsIn[1]);
	s2 = Slope( pointsIn[2], pointsIn[1]);
	
	// only the arc that goes around the "outside" of the bend is required, so we need a way to detect which side of the line we are offsetting to
	// and only append an arc for the outside case.
	
	ra = s2 - s1;
	
	if( ra > pi )
		ra = pi - ra;
	
	if( ra < -pi )
		ra = -pi - ra;
	
	//NSLog(@"ra = %f, offset = %f", ra, offset );
	
	if(( ra < 0 && offset > 0 ) || ( ra > 0 && offset < 0 ))
		return NO;
	
	s2 = Slope( pointsIn[1], pointsIn[2]);
	
	[newPath appendBezierPathWithArcWithCenter:pointsIn[1] radius:offset startAngle:RADIANS_TO_DEGREES(s1 + NINETY_DEGREES) endAngle:RADIANS_TO_DEGREES(s2 + NINETY_DEGREES) clockwise:offset > 0 ];
	
	return YES;
}


static BOOL		CornerBevel( const NSPoint* pointsIn, float offset, NSBezierPath* newPath )
{
	// appends a bevel segment that is centred at the middle vertex having a radius of <offset> and a start point and end point such that the offset normals to the original
	// edges are joined by the arc. If the vertex is an inside bend, returns nil in which case the CornerPoint should be used.
	
	if( offset == 0.0 )
		return NO;
	
	float	s1, s2, ra;
	
	s1 = Slope( pointsIn[0], pointsIn[1]);
	s2 = Slope( pointsIn[2], pointsIn[1]);
	
	// only the arc that goes around the "outside" of the bend is required, so we need a way to detect which side of the line we are offsetting to
	// and only append an arc for the outside case.
	
	ra = s2 - s1;
	
	if( ra > pi )
		ra = pi - ra;
	
	if( ra < -pi )
		ra = -pi - ra;
	
	//NSLog(@"ra = %f, offset = %f", ra, offset );
	
	if(( ra < 0 && offset > 0 ) || ( ra > 0 && offset < 0 ))
		return NO;
	
	NSPoint pa, pb;
	
	pa.x = pointsIn[1].x + offset * cosf( s1 + NINETY_DEGREES );
	pa.y = pointsIn[1].y + offset * sinf( s1 + NINETY_DEGREES );
	pb.x = pointsIn[1].x + offset * cosf( s2 - NINETY_DEGREES );
	pb.y = pointsIn[1].y + offset * sinf( s2 - NINETY_DEGREES );
	
	[newPath lineToPoint:pa];
	[newPath lineToPoint:pb];
	
	return YES;
}



- (NSBezierPath*)		paralleloidPathWithOffset2:(float) delta
{
	// returns a path offset by <delta>, using the paralleloidPathWithOffset method above on a flattened version of the path. If the caller sets the
	// default flatness prior to calling this they can control the fineness of the offset path. The offset joins are set to match the current line join style.
	
	if( delta == 0.0 )
		return self;
	
	NSBezierPath* temp;
	temp = [self bezierPathByFlatteningPath];
	temp = [temp paralleloidPathWithOffset:delta];

	return temp;
}


- (NSBezierPath*)		paralleloidPathWithOffset22:(float) delta
{
	// returns a path offset by <delta>, using the paralleloidPathWithOffset3 method below on a flattened version of the path. If the caller sets the
	// default flatness prior to calling this they can control the fineness of the offset path. The offset joins are set to match the current line join style.
	
	if( delta == 0.0 )
		return self;
	
	NSBezierPath* temp;
	temp = [self bezierPathByFlatteningPath];
	temp = [temp paralleloidPathWithOffset3:delta lineJoinStyle:[self lineJoinStyle]];
	
	return temp;
}



- (NSBezierPath*)		paralleloidPathWithOffset3:(float) delta lineJoinStyle:(NSLineJoinStyle) js
{
	// requires flattened path, calculates correct points at the corners
	
	NSBezierPath*		newPath = [NSBezierPath bezierPath];
	int					i, m = [self elementCount], spc = 0, spStartIndex;
	NSBezierPathElement element;
	NSPoint				ap[3];
	NSPoint				v[3];
	NSPoint				fp, op, fop, sop;
	float				slope;
	
	v[0] = v[1] = v[2] = NSZeroPoint;
	
	for( i = 0; i < m; ++i )
	{
		element = [self elementAtIndex:i associatedPoints:ap];
		
		switch( element )
		{
			case NSMoveToBezierPathElement:
				// starting a new subpath - don't start the new path yet as we need the next point to know the slope
				
				fp = v[0] = ap[0];
				spc = 0;
				break;
				
			case NSLineToBezierPathElement:
				if( spc == 0 )
				{
					// recently started a new subpath, so set 2nd vertex
					v[1] = ap[0];
					spc++;
					
					// ok, we have enough to work out the slope and start the new path
					
					slope = Slope( v[0], v[1] ) + pi * 0.5f;
					op.x = v[0].x + delta * cosf( slope );
					op.y = v[0].y + delta * sinf( slope );
					[newPath moveToPoint:op];
					spStartIndex = [newPath elementCount] - 1;
					fop = op;
				}
				else
				{
					v[2] = ap[0];
					
					// we have three vertices, so we can calculate the required corner point
					
					op = CornerPoint( v, delta, [self miterLimit] );
					if( js == NSMiterLineJoinStyle )
						[newPath lineToPoint:op];
					else if( js == NSBevelLineJoinStyle )
					{
						if( !CornerBevel( v, delta, newPath ))
							[newPath lineToPoint:op];
					}
					else
					{
						if( !CornerArc( v, delta, newPath ))
							[newPath lineToPoint:op];
					}
					
					if( spc == 1 )
						sop = op;
					
					// shift vertex array
					
					v[0] = v[1];
					v[1] = v[2];
					spc++;
				}
				break;
				
			case NSCurveToBezierPathElement:
				NSAssert( NO, @"paralleloidPathWithOffset3 requires a flattened path");
				break;
				
			case NSClosePathBezierPathElement:
				// close the path by curving back to the first point
				v[2] = fp;
				
				op = CornerPoint( v, delta, [self miterLimit] );
				if( js == NSMiterLineJoinStyle )
					[newPath lineToPoint:op];
				else if( js == NSBevelLineJoinStyle )
				{
					if( !CornerBevel( v, delta, newPath ))
						[newPath lineToPoint:op];
				}
				else
				{
					if( !CornerArc( v, delta, newPath ))
						[newPath lineToPoint:op];
				}
				v[0] = v[1];
				v[1] = v[2];
				v[2] = sop;
				
				op = CornerPoint( v, delta, [self miterLimit]);
				if( js == NSMiterLineJoinStyle )
				{
					[newPath lineToPoint:op];
					[newPath setAssociatedPoints:&op atIndex:spStartIndex];
				}
				else if( js == NSBevelLineJoinStyle )
				{
					if( !CornerBevel( v, delta, newPath ))
					{
						[newPath lineToPoint:op];
						[newPath setAssociatedPoints:&op atIndex:spStartIndex];
					}
				}
				else
				{
					if( !CornerArc( v, delta, newPath ))
					{
						[newPath lineToPoint:op];
						[newPath setAssociatedPoints:&op atIndex:spStartIndex];
					}
				}
				spc = 0;
				
				[newPath closePath];
				break;
				
			default:
				break;
		}
	}
	
	if( spc > 0 )
	{
		// open-ended path, place last offset point
		
		slope = Slope( v[0], v[1] ) + pi * 0.5f;
		op.x = v[1].x + delta * cosf( slope );
		op.y = v[1].y + delta * sinf( slope );
		[newPath lineToPoint:op];
	}
	
	return newPath;
}


- (NSBezierPath*)		offsetPathWithStartingOffset:(float) delta1 endingOffset:(float) delta2
{
	// similar to making a paralleloid path, but instead of a constant offset, each point has a different offset
	// applied as a linear function of the difference between delta1 and delta2. So the result has a similar curvature
	// to the original path, but also an additional ramp.
	
	NSBezierPath* newPath = [NSBezierPath bezierPath];
	
	if( ![self isEmpty])
	{
		int						i, count = [self elementCount];
		NSPoint					lp, ap[3], np[3], p0, p1, fp;
		NSBezierPathElement		kind, nextKind;
		float					del, length, slope, dx, dy, pdx, pdy;
		
		pdx = pdy = 0;
		length = [self length];
		
		for( i = 0; i < count; ++i )
		{
			del = ((( delta2 - delta1 ) * i ) / ( count - 1 )) + delta1;
			
		//	LogEvent_(kInfoEvent, @"segment %d, del = %f", i, del );
			
			kind = [self elementAtIndex:i associatedPoints:ap];
			
			if ( i < count - 1 )
			{
				nextKind = [self elementAtIndex:i + 1 associatedPoints:np];
				
				// calculate the slope of the on-path point
				
				if ( kind != NSCurveToBezierPathElement )
				{
					p0 = ap[0];
					p1 = np[0];
				}
				else
				{
					p0 = ap[2];
					p1 = np[0];
				}
			}
			else
			{
				if ( kind == NSCurveToBezierPathElement )
				{
					p1 = ap[2];
					p0 = ap[1];
				}
				else
				{
					p1 = ap[0];
					
					nextKind = [self elementAtIndex:i - 1 associatedPoints:np];
				
					if ( nextKind != NSCurveToBezierPathElement )
						p0 = np[0];
					else
						p0 = np[2];
				}
			}
			
			slope = atan2f( p1.y - p0.y, p1.x - p0.x ) + ( pi * 0.5 );
			
			// calculate the position of the modified point
			
			dx = del * cosf( slope );
			dy = del * sinf( slope );
			
			switch( kind )
			{
				case NSMoveToBezierPathElement:
					ap[0].x += dx;
					ap[0].y += dy;
					[newPath moveToPoint:ap[0]];
					fp = lp = ap[0];
					break;
					
				case NSLineToBezierPathElement:
					ap[0].x += dx;
					ap[0].y += dy;
					[newPath lineToPoint:ap[0]];
					lp = ap[0];
					break;
					
				case NSCurveToBezierPathElement:
				{
					ap[0].x += pdx;
					ap[0].y += pdy;
					ap[1].x += dx;
					ap[1].y += dy;
					ap[2].x += dx;
					ap[2].y += dy;
					[newPath curveToPoint:ap[2] controlPoint1:ap[0] controlPoint2:ap[1]];
					lp = ap[2];
				}
				break;
					
				case NSClosePathBezierPathElement:
					[newPath closePath];
					lp = fp;
					break;
					
				default:
					break;
			}
			
			pdx = dx;
			pdy = dy;
		}
	}

	return newPath;
}


- (NSBezierPath*)		offsetPathWithStartingOffset2:(float) delta1 endingOffset:(float) delta2
{
	// When GPC is disabled, works exactly as above.
	NSBezierPath* temp = self;
	temp = [temp offsetPathWithStartingOffset:delta1 endingOffset:delta2];
	return temp;
}


- (NSBezierPath*)		bezierPathByInterpolatingPath:(float) amount
{
	// smooths a vector (line segment) path by interpolation into curve segments. This algorithm from http://antigrain.com/research/bezier_interpolation/index.html#PAGE_BEZIER_INTERPOLATION
	// existing curve segments are reinterpolated as if a straight line joined the start and end points. Note this doesn't simplify a curve - it merely smooths it using the same number
	// of curve segments. <amount> is a value from 0..1 that yields the amount of smoothing, 0 = none.
	
	amount = LIMIT( amount, 0, 1 );
	
	if( amount == 0.0 || [self isEmpty])
		return self;	// nothing to do
	
	NSBezierPath*		newPath = [NSBezierPath bezierPath];
	int					i, m = [self elementCount], spc = 0;
	NSBezierPathElement element;
	NSPoint				ap[3];
	NSPoint				v[3];
	NSPoint				fp, cp1, cp2, pcp;
	
	fp = cp1 = cp2 = NSZeroPoint;
	v[0] = v[1] = v[2] = NSZeroPoint;
	
	for( i = 0; i < m; ++i )
	{
		element = [self elementAtIndex:i associatedPoints:ap];
		
		switch( element )
		{
			case NSMoveToBezierPathElement:
				// starting a new subpath
				
				[newPath moveToPoint:ap[0]];
				fp = v[0] = ap[0];
				spc = 0;
				break;
				
			case NSLineToBezierPathElement:
				if( spc == 0 )
				{
					// recently started a new subpath, so set 2nd vertex
					v[1] = ap[0];
					spc++;
				}
				else
				{
					v[2] = ap[0];
					
					// we have three vertices, so we can interpolate
					
					InterpolatePoints( v, &cp1, &cp2, amount );
					
					// cp2 completes the  curve segment v0..v1 so we can add that to the new path. If it was the first
					// segment, cp1 == cp2
					
					if( spc == 1 )
						pcp = cp2;
					
					[newPath curveToPoint:v[1] controlPoint1:pcp controlPoint2:cp2];
					
					// shift vertex array
					
					v[0] = v[1];
					v[1] = v[2];
					pcp = cp1;
					spc++;
				}
				break;
				
			case NSCurveToBezierPathElement:
				if( spc == 0 )
				{
					// recently started a new subpath, so set 2nd vertex
					v[1] = ap[2];
					spc++;
				}
				else
				{
					v[2] = ap[2];
					
					// we have three vertices, so we can interpolate
					
					InterpolatePoints( v, &cp1, &cp2, amount );
					
					// cp2 completes the  curve segment v0..v1 so we can add that to the new path. If it was the first
					// segment, cp1 == cp2
					
					if( spc == 1 )
						pcp = cp2;
					
					[newPath curveToPoint:v[1] controlPoint1:pcp controlPoint2:cp2];
					
					// shift vertex array
					
					v[0] = v[1];
					v[1] = v[2];
					pcp = cp1;
					spc++;
				}
				break;
				
			case NSClosePathBezierPathElement:
				// close the path by curving back to the first point
				v[2] = fp;
				
				InterpolatePoints( v, &cp1, &cp2, amount );
				
				// cp2 completes the  curve segment v0..v1 so we can add that to the new path. If it was the first
				// segment, cp1 == cp2
				
				if( spc == 1 )
					pcp = cp2;
				
				[newPath curveToPoint:v[1] controlPoint1:pcp controlPoint2:cp2];
				
				// final segment closes the path
				
				[newPath curveToPoint:fp controlPoint1:cp1 controlPoint2:cp1];
				[newPath closePath];
				spc = 0;
				break;
				
			default:
				break;
		}
	}
	
	if( spc > 1 )
	{
		// path ended without a closepath, so add in the final curve segment to the end
		
		[newPath curveToPoint:v[1] controlPoint1:pcp controlPoint2:pcp];
	}
	
	//NSLog(@"new path = %@", newPath);
	
	return newPath;
}


static void				InterpolatePoints( const NSPoint* v, NSPoint* cp1, NSPoint* cp2, const float smooth_value )
{
	// given the vertices of the path v0..v2, this calculates cp1 and cp2 being the control points for the curve segments v0..v1 and v1..v2. i.e. this
	// calculates only half of the control points, but does so for two segments. The caller needs to accumulate cp1 until it has cp2 for the same segment
	// before it can add the curve segment.
	
	// calculate the midpoints of the two edges
	
	float xc1 = ( v[0].x + v[1].x ) * 0.5f;	//(x0 + x1) / 2.0;
    float yc1 =	( v[0].y + v[1].y ) * 0.5f;	//(y0 + y1) / 2.0;
    float xc2 =	( v[1].x + v[2].x ) * 0.5f;	//(x1 + x2) / 2.0;
    float yc2 =	( v[1].y + v[2].y ) * 0.5f;	//(y1 + y2) / 2.0;
	
	// calculate the ratio of the two lengths

    float len1 = hypotf( v[1].x - v[0].x, v[1].y - v[0].y );	//sqrt((x1-x0) * (x1-x0) + (y1-y0) * (y1-y0));
    float len2 = hypotf( v[2].x - v[1].x, v[2].y - v[1].y );	//sqrt((x2-x1) * (x2-x1) + (y2-y1) * (y2-y1));
    float k1;
	
	if(( len1 + len2 ) > 0.0 )
		k1 = len1 / (len1 + len2);
    else
		k1 = 0.0;
	
	// calculate the pivot point of the control point "arms" xm1, ym1
	
    float xm1 =	xc1 + (xc2 - xc1) * k1;
    float ym1 = yc1 + (yc2 - yc1) * k1;

	NSPoint ctrl1, ctrl2;
	
	// ctrl1 is CP1 for the segment v1..v2
	// ctrl2 is CP2 for the segment v0..v1
	
    ctrl1.x = ( xm1 + (xc2 - xm1) * smooth_value ) + v[1].x - xm1;
    ctrl1.y = ( ym1 + (yc2 - ym1) * smooth_value ) + v[1].y - ym1;
	
	ctrl2.x = ( xm1 - (xm1 - xc1) * smooth_value ) + v[1].x - xm1;
	ctrl2.y = ( ym1 - (ym1 - yc1) * smooth_value ) + v[1].y - ym1;

	if( cp1 )
		*cp1 = ctrl1;
		
	if( cp2 )
		*cp2 = ctrl2;
}


- (NSBezierPath*)		filletPathForVertex:(NSPoint[]) vp filletSize:(float) fs
{
	// given three points vp[0]..vp[2], this calculates a curve that will form a fillet. <fs> is the size of the fillet, expressed as the distance from the
	// apex ap[1] along each side of the vertex. The returned path consists of a single element curve segment.
	
	NSPoint fa, fb;
	float	ra, rb;
	
	ra = fs / LineLength(vp[0], vp[1]);
	rb = fs / LineLength(vp[1], vp[2]);
	
	fa = Interpolate(vp[1], vp[0], ra);
	fb = Interpolate(vp[1], vp[2], rb);
	
	NSBezierPath* path = [NSBezierPath bezierPath];
	[path moveToPoint:fa];
	[path curveToPoint:fb controlPoint1:vp[1] controlPoint2:vp[1]];
	
	return path;
}


- (NSBezierPath*)		bezierPathByRandomisingPoints:(float) maxAmount
{
	NSBezierPath* newPath = [self copy];
	
	if( ![self isEmpty])
	{
		if ( maxAmount == 0.0f )
			maxAmount = MIN( [self controlPointBounds].size.width, [self controlPointBounds].size.height ) / 24.0f;
		
		int						i, count = [self elementCount];
		NSPoint					ap[3];
		NSBezierPathElement		kind;
		float					dx, dy;
		
		[newPath removeAllPoints];
		
		for( i = 0; i < count; ++i )
		{
			kind = [self elementAtIndex:i associatedPoints:ap];
			
			dx = [DKRandom randomPositiveOrNegativeNumber] * maxAmount;
			dy = [DKRandom randomPositiveOrNegativeNumber] * maxAmount;
			
			//LogEvent_(kInfoEvent, @"random amount = {%f, %f}", dx, dy );
			
			switch( kind )
			{
				case NSMoveToBezierPathElement:
					[newPath moveToPoint:ap[0]];
					break;
					
				case NSLineToBezierPathElement:
					ap[0].x += dx;
					ap[0].y += dy;
					[newPath lineToPoint:ap[0]];
					break;
					
				case NSCurveToBezierPathElement:
					ap[0].x += dx;
					ap[0].y += dy;
					dx = [DKRandom randomPositiveOrNegativeNumber] * maxAmount;
					dy = [DKRandom randomPositiveOrNegativeNumber] * maxAmount;
					ap[1].x += dx;
					ap[1].y += dy;
					dx = [DKRandom randomPositiveOrNegativeNumber] * maxAmount;
					dy = [DKRandom randomPositiveOrNegativeNumber] * maxAmount;
					ap[2].x += dx;
					ap[2].y += dy;
					[newPath curveToPoint:ap[2] controlPoint1:ap[0] controlPoint2:ap[1]];
					break;
					
				case NSClosePathBezierPathElement:
					[newPath closePath];
					break;
					
				default:
					break;
			}
		}
	}

	return [newPath autorelease];
}

#if 0
- (NSBezierPath*)		bezierPathWithRoughenedStrokeOutline:(float) amount
{
	// given the path, this returns the outline of the path stroke roughened by the given amount. Roughening works by first taking the stroke outline at the
	// current stroke width, inserting a large number of redundant points and then randomly offsetting each one by a small amount. The result is a path that, when
	// FILLED, will emulate a stroke drawn using a randomly varying width pen. This can be used to give a very naturalistic effect that precise strokes lack. 
	
	NSBezierPath* newPath = [self strokedPath];
	
	if ( newPath != nil && amount > 0.0 )
	{
		// work out the desired flatness by getting the average length of the elements and dividing that down:

		float flatness = 4.0 / ([newPath length] / [newPath elementCount]);
		
		//NSLog(@"flatness = %f", flatness);
		
		// break up existing line segments into short lengths:
		
		newPath = [newPath bezierPathWithFragmentedLineSegments:[self lineWidth] / 2.0 ];
		
		// flatten the path - this breaks up curve segments into short straight segments
		
		float savedFlatness = [[self class] defaultFlatness];
		[[self class] setDefaultFlatness:flatness];
		newPath = [newPath bezierPathByFlatteningPath];
		[[self class] setDefaultFlatness:savedFlatness];
		
		// randomise the positions of the points
		
		newPath = [newPath bezierPathByRandomisingPoints:amount];
	}
	
	return newPath; //[newPath bezierPathByUnflatteningPath];
}
#endif

- (NSBezierPath*)		bezierPathWithFragmentedLineSegments:(float) flatness
{
	// this is only really useful as a step in the roughened stroke processing. It takes a path and for any line elements in the path, it breaks them up into
	// much shorter lengths by interpolation.
	
	NSBezierPath*			newPath = [NSBezierPath bezierPath];
	int						i, m, k, j;
	NSBezierPathElement		element;
	NSPoint					ap[3];
	NSPoint					fp, pp;
	float					len, t;
	
	fp = pp = NSZeroPoint;	// shut up, stupid warning
	
	m = [self elementCount];
	
	for( i = 0; i < m; ++ i )
	{
		element = [self elementAtIndex:i associatedPoints:ap];
		
		switch( element )
		{
			case NSMoveToBezierPathElement:
				fp = pp = ap[0];
				[newPath moveToPoint:fp];
				break;
				
			case NSLineToBezierPathElement:
				len = LineLength( pp, ap[0] );
				k = floor( len / flatness );
				
				//NSLog(@"inserting %d fragments", k );
				
				for( j = 0; j < k; ++j )
				{
					t = (( j + 1 ) * flatness ) / len;
					NSPoint np = Interpolate( pp, ap[0], t );
					[newPath lineToPoint:np];
				}
				pp = ap[0];
				break;
				
			case NSCurveToBezierPathElement:
				[newPath curveToPoint:ap[2] controlPoint1:ap[0] controlPoint2:ap[1]];
				pp = ap[2];
				break;
				
			case NSClosePathBezierPathElement:
				[newPath closePath];
				pp = fp;
				break;
				
			default:
				break;
		}
	}

	return newPath;
}



- (NSBezierPath*)		bezierPathWithZig:(float) zig zag:(float) zag
{
	// returns a zigzag based on the original path. The "zig" is the length along the path between each point, and the "zag" is the distance offset
	// normal to the path. By joining up the series of points so generated, an accurate zig-zag path is formed. Note that the returned path follows the
	// curvature of the original but it contains no curved segments itself.
	
	NSAssert( zig > 0, @"zig must be > 0");
	
	// no amplitude, return the original path
	
	if( zag <= 0 )
		return self;
	
	float			len, t = 0.0, slope;
	NSPoint			zp, np, fp;
	NSBezierPath*	newPath;
	BOOL			side = 0;		// are we zigging or zagging?
	BOOL			doneFirst = NO;
	
	len = [self length];
	newPath = [NSBezierPath bezierPath];
	fp = [self firstPoint];
	[newPath moveToPoint:fp];
	[newPath setWindingRule:[self windingRule]];
	
	while( t < len )
	{
		if (( t + zig ) > len )
		{
			if ([self isPathClosed])
				zp = [self pointOnPathAtLength:0.0 slope:&slope];
			else
				zp = [self pointOnPathAtLength:len slope:&slope];
		}
		else
			zp = [self pointOnPathAtLength:t slope:&slope];
	
		// calculate position of corner offset from the path
		
		if ( side )
			slope += ( pi / 2.0 );
		else
			slope -= ( pi / 2.0 );
	
		side = !side;
		
		np.x = zp.x + ( cosf( slope ) * zag );
		np.y = zp.y + ( sinf( slope ) * zag );
		
		if ( doneFirst )
			[newPath lineToPoint:np];
		else
		{
			[newPath moveToPoint:np];
			doneFirst = YES;
			fp = np;
		}
		
		t += zig;
	}
	
	if ([self isPathClosed])
		[newPath closePath];
		
	return newPath;
}


- (NSBezierPath*)		bezierPathWithWavelength:(float) lambda amplitude:(float) amp spread:(float) spread
{
	// similar effect to a zig-zag, but creates curved segments which smoothly oscillate about the master path. Wavelength is the distance between each peak
	// (note - this is half the actual "wavelength" in the strict sense) and amplitude is the distance from the path. Spread is a value indicating the
	// "roundness" of the peak, and is a value between 0 and 1. 0 is equivalent to a sharp zig-zag as above.
	
	NSAssert( lambda > 0, @"wavelength cannot be 0 or negative");
	
	// if amplitude is zero, there is no zig-zag - just return the original path
	
	if( amp <= 0 )
		return self;
	
	// if no spread, return a triangle zig-zag with no curve elements
	
	if ( spread <= 0.0 )
		return [self bezierPathWithZig:lambda zag:amp];
	else
	{
		float			len, t = 0.0, slope, rad, lastSlope;
		NSPoint			zp, np, fp, cp1, cp2;
		NSBezierPath*	newPath;
		BOOL			side = 0;		// are we zigging or zagging?
		BOOL			doneFirst = NO;
		
		len = [self length];
		newPath = [NSBezierPath bezierPath];
		[newPath moveToPoint:fp = [self firstPoint]];
		[newPath setWindingRule:[self windingRule]];

		rad = amp * spread;
		
		//NSLog(@"rad = %f", rad);
		
		lastSlope = [self slopeStartingPath];
		
		while( t <= len )
		{
			if (( t + lambda ) > len )
			{
				if ([self isPathClosed])
				{
					// if we are not in the same phase as the start of the path, need to insert an extra curve segment
					
					if ( side == 1 )
					{
						t = (t + len) / 2.0;
						zp = [self pointOnPathAtLength:t slope:&slope];
						lambda = MAX( 1, len - t );
					}
					else
						zp = [self pointOnPathAtLength:0.0 slope:&slope];
				}
				else
					zp = [self pointOnPathAtLength:len slope:&slope];
			}
			else
				zp = [self pointOnPathAtLength:t slope:&slope];
		
			// calculate position of peak offset from the path
			
			float slp = slope;
			
			if ( side )
				slp += ( pi / 2.0 );
			else
				slp -= ( pi / 2.0 );
		
			side = !side;
			
			np.x = zp.x + ( cosf( slp ) * amp );
			np.y = zp.y + ( sinf( slp ) * amp );
			
			// calculate the control points
			
			cp1 = [newPath currentPoint];
			cp1.x += cosf( lastSlope ) * rad;
			cp1.y += sinf( lastSlope ) * rad;
			
			cp2 = np;
			cp2.x += cosf( slope - pi ) * rad;
			cp2.y += sinf( slope - pi ) * rad;
			
			if ( doneFirst )
				[newPath curveToPoint:np controlPoint1:cp1 controlPoint2:cp2];
			else
			{
				[newPath moveToPoint:np];
				doneFirst = YES;
			}
			
			lastSlope = slope;
			t += lambda;
		}
		
		if ([self isPathClosed])
		{
			[newPath closePath];
		}
		return newPath;
	}
}


#if 0
- (NSBezierPath*)		strokedPath
{
	// returns a path representing the stroked edge of the receiver, taking into account its current width and other
	// stroke settings. This works by converting to a quartz path and using the similar system function there.
	
	// this creates an offscreen graphics context to support the CG function used, but the context itself does not
	// need to actually draw anything, therefore a simple 1x1 bitmap is used and reused for this context.
	
	NSBezierPath*				path = nil;
	NSGraphicsContext*			ctx = nil;
	static NSBitmapImageRep*	rep = nil;
	
	if( rep == nil )
	{
		rep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL
										pixelsWide:1
										pixelsHigh:1
										bitsPerSample:8
										samplesPerPixel:3
										hasAlpha:NO
										isPlanar:NO
										colorSpaceName:NSCalibratedRGBColorSpace
										bytesPerRow:4
										bitsPerPixel:32];
	}
	
	ctx = [NSGraphicsContext graphicsContextWithBitmapImageRep:rep];

	NSAssert( ctx != nil, @"no context for -strokedPath");
	
	SAVE_GRAPHICS_CONTEXT	//[NSGraphicsContext saveGraphicsState];
	[NSGraphicsContext setCurrentContext:ctx];
	
	CGContextRef context = [self setQuartzPath];
	
	path = self;
	
	if ( context )
	{
		CGContextReplacePathWithStrokedPath( context );
		path = [NSBezierPath bezierPathWithPathFromContext:context];
	}
	
	RESTORE_GRAPHICS_CONTEXT	//[NSGraphicsContext restoreGraphicsState];

	return path;
}

- (NSBezierPath*)		strokedPathWithStrokeWidth:(float) width
{
	float savedLineWidth = [self lineWidth];
	
	[self setLineWidth:width];
	NSBezierPath* newPath = [self strokedPath];
	[self setLineWidth:savedLineWidth];
	
	return newPath;
}

#endif

- (NSArray*)			subPaths
{
	// returns an array of bezier paths, each derived from this path's subpaths.
	// first see if we can take a shortcut - if there's only one subpath, just return self in the array
	
	if([self countSubPaths] < 2)
		return [NSArray arrayWithObject:self];
	
	// more than 1 subpath, break it down:
	
	NSMutableArray*		sp = [[NSMutableArray alloc] init];
    int					i, numElements;
	NSBezierPath*		temp = nil;
	BOOL				added = NO;
 
    numElements = [self elementCount];
	NSPoint	points[3];

	for (i = 0; i < numElements; i++)
	{
		switch ([self elementAtIndex:i associatedPoints:points])
		{
			case NSMoveToBezierPathElement:
				temp = [NSBezierPath bezierPath];
				[temp moveToPoint:points[0]];
				added = NO;
				break;

			case NSLineToBezierPathElement:
				[temp lineToPoint:points[0]];
				break;

			case NSCurveToBezierPathElement:
				[temp curveToPoint:points[2] controlPoint1:points[0] controlPoint2:points[1]];
				break;

			case NSClosePathBezierPathElement:
				[temp closePath];
				break;
				
			default:
				break;
		}
		
		// object is added only if it has more than just the moveTo element
		
		if ( !added && [temp elementCount] > 1 )
		{
			[sp addObject:temp];
			added = YES;
		}
	}
	return [sp autorelease];
}


- (int)					countSubPaths
{
	// returns the number of moveTo ops in the path, though doesn't count a final moveTo as following a closepath
	
	int m, i, spc = 0;
	
    m = [self elementCount] - 1;

	for (i = 0; i < m; ++i)
	{
		if([self elementAtIndex:i] == NSMoveToBezierPathElement)
			++spc;
	}
	
	return spc;
}



#if 0

- (CGPathRef)			newQuartzPath
{
	CGMutablePathRef mpath = [self newMutableQuartzPath];
	CGPathRef		 path = CGPathCreateCopy(mpath);
    CGPathRelease(mpath);
	
	// the caller is responsible for releasing the returned value when done
	
	return path;
}


- (CGMutablePathRef)	newMutableQuartzPath
{
    int i, numElements;
 
    // If there are elements to draw, create a CGMutablePathRef and draw.

    numElements = [self elementCount];
    if (numElements > 0)
    {
        CGMutablePathRef    path = CGPathCreateMutable();
        NSPoint             points[3];
 
        for (i = 0; i < numElements; i++)
        {
            switch ([self elementAtIndex:i associatedPoints:points])
            {
                case NSMoveToBezierPathElement:
                    CGPathMoveToPoint(path, NULL, points[0].x, points[0].y);
                    break;
 
                case NSLineToBezierPathElement:
                    CGPathAddLineToPoint(path, NULL, points[0].x, points[0].y);
                    break;
 
                case NSCurveToBezierPathElement:
                    CGPathAddCurveToPoint(path, NULL, points[0].x, points[0].y,
                                                points[1].x, points[1].y,
                                                points[2].x, points[2].y);
                    break;
 
                case NSClosePathBezierPathElement:
                    CGPathCloseSubpath(path);
                    break;
					
				default:
					break;
            }
        }
		
		// the caller is responsible for releasing this ref when done
		
		return path;
    }
 
    return nil;
}


- (CGContextRef)		setQuartzPath
{
	// converts the path to a CGPath and adds it as the current context's path. It also copies the current line width
	// and join and cap styles, etc. to the context.
	
	CGContextRef	context = [[NSGraphicsContext currentContext] graphicsPort];
	
	NSAssert( context != nil, @"no context for setQuartzPath");
	
	if ( context )
		[self setQuartzPathInContext:context isNewPath:YES];
	
	return context;
}


- (void)				setQuartzPathInContext:(CGContextRef) context isNewPath:(BOOL) np
{
	NSAssert( context != nil, @"no context for [NSBezierPath setQuartzPathInContext:isNewPath:]");
	
	CGPathRef		cp = [self newQuartzPath];
	
	if ( np )
		CGContextBeginPath( context );
		
	CGContextAddPath( context, cp );
	CGPathRelease( cp );
	
	CGContextSetLineWidth( context, [self lineWidth]);
	CGContextSetLineCap( context, (CGLineCap)[self lineCapStyle]);
	CGContextSetLineJoin( context, (CGLineJoin)[self lineJoinStyle]);
	CGContextSetMiterLimit( context, [self miterLimit]);
	
	float	lengths[16];
	float	phase;
	int		count;
	
	[self getLineDash:lengths count:&count phase:&phase];
	CGContextSetLineDash( context, phase, lengths, count );
}


+ (NSBezierPath*)		bezierPathWithCGPath:(CGPathRef) path
{
	// given a CGPath, this converts it to the equivalent NSBezierPath by using a custom apply function
	
	NSAssert( path != nil, @"CG path was nil in bezierPathWithCGPath");
	
	NSBezierPath* newPath = [self bezierPath];
	CGPathApply( path, newPath, ConvertPathApplierFunction );
	return newPath;
}


+ (NSBezierPath*)		bezierPathWithPathFromContext:(CGContextRef) context
{
	// given a context, this converts its current path to an NSBezierPath. It is the inverse to the -setQuartzPath method.
	
	NSAssert( context != nil, @"no context for bezierPathWithPathFromContext");
	
	// WARNING: this uses an undocumented function in CG (CGContextCopyPath)
	
	CGPathRef cp = CGContextCopyPath( context );
	NSBezierPath* bp = [self bezierPathWithCGPath:cp];
	CGPathRelease( cp );
	
	return bp;
}

#endif

- (NSPoint)				pointOnPathAtLength:(float) length slope:(float*) slope
{
	// Given a length in terms of the distance from the path start, this returns the point and slope
	// of the path at that position. This works for any path made up of line or curve segments or combinations of them. This should be used with
	// paths that have no subpaths. If the path has less than two elements, the result is NSZeroPoint.
	
	NSPoint					p = NSZeroPoint;
	NSPoint					ap[3], lp[3];
	NSBezierPathElement		pre, elem;
	
	if ([self elementCount] < 2 )
		return p;
	
	if ( length <= 0.0 )
	{
		[self elementAtIndex:0 associatedPoints:ap];
		p = ap[0];
		
		[self elementAtIndex:1 associatedPoints:lp];
		
		if ( slope )
			*slope = Slope( ap[0], lp[0] );
	}
	else
	{
		NSBezierPath* temp = [self bezierPathByTrimmingToLength:length];
		
		// given the trimmed path, the desired point is at the end of the path.
		
		int			ec = [temp elementCount];
		float		slp = 1;
		
		if ( ec > 1 )
		{
			elem = [temp elementAtIndex:ec - 1 associatedPoints:ap];
			pre = [temp elementAtIndex:ec - 2 associatedPoints:lp];
			
			if ( pre == NSCurveToBezierPathElement )
				lp[0] = lp[2];
			
			if ( elem == NSCurveToBezierPathElement )
			{
				slp = Slope( ap[1], ap[2] );
				p = ap[2];
			}
			else
			{
				slp = Slope( lp[0], ap[0] );
				p = ap[0];
			}
		}

		if ( slope )
			*slope = slp;
	}
	return p;
}


- (float)				slopeStartingPath
{
	// returns the slope starting the path
	
	if ([self elementCount] > 1)
	{
		NSPoint	ap[3], lp[3];

		[self elementAtIndex:0 associatedPoints:ap];
		[self elementAtIndex:1 associatedPoints:lp];
		
		return Slope( ap[0], lp[0] );
	}
	else
		return 0;
}


- (float)				distanceFromStartOfPathAtPoint:(NSPoint) p tolerance:(float) tol
{
	// find the distance along the path where the point <p> is
	NSPoint	np;
	float	t;
	int		elem = [self elementHitByPoint:p tolerance:tol tValue:&t nearestPoint:&np];
	
	//NSLog(@"elem = %d, t = %f, nearest = %@", elem, t, NSStringFromPoint( np ));
	
	if( elem < 1 )
		return -1.0;	// not close enough
	else
	{
		// get length up to the split element
		
		float distance = [self lengthOfPathFromElement:0 toElement:elem - 1];
		
		// now split the final element and add its length
		
		NSPoint				ap[4];
		NSBezierPathElement et = [self elementAtIndex:elem associatedPoints:&ap[1]];
		
		NSPoint				pp[3];
		NSBezierPathElement pt = [self elementAtIndex:elem - 1 associatedPoints:pp];
		
		if ( pt == NSCurveToBezierPathElement )
			ap[0] = pp[2];
		else
			ap[0] = pp[0];
			
		if( et == NSCurveToBezierPathElement )
		{
			NSPoint left[4], right[4];
			subdivideBezierAtT( ap, left, right, t );
			
			float bd = lengthOfBezier( left, 0.1 );
			distance += bd;
		}
		else if ( et == NSLineToBezierPathElement )
		{
			NSPoint ip = Interpolate( ap[0], ap[1],  t );
			distance += distanceBetween( ip, ap[0] );
		}
		
		return distance;
	}
}


- (int)					pointWithinPathRegion:(NSPoint) p
{
	// given a point p, returns 0, -1 or + 1 to indicate whether the point lies within a region defined by the path. For closed paths, this returns 0 for a point inside, -1 for a point
	// outside the path. If open, the path is treated as a straight line between its end points, and the point tested to see if it lies in the line segment.
	
	if([self isPathClosed])
		return [self containsPoint:p]? 0 : -1;
	else
	{
		NSPoint a, b;
		
		a = [self firstPoint];
		b = [self lastPoint];
		
		return PointInLineSegment( p, a, b );
	}
}

#if 0
- (void)				addInverseClip
{
	// this is similar to -addClip, except that it excludes the area bounded by the path instead of includes it. It works by combining this path
	// with the existing clip area using the E/O winding rule, then setting the result as the clip area. This should be called between
	// calls to save and restore the gstate, as for addClip.
	
	CGContextRef	context = [[NSGraphicsContext currentContext] graphicsPort];
	CGRect cbbox = CGContextGetClipBoundingBox( context );
	
	NSBezierPath*	cp = [NSBezierPath bezierPathWithRect:*(NSRect*)&cbbox];
	[cp appendBezierPath:self];
	[cp setWindingRule:NSEvenOddWindingRule];
	[cp addClip];
}


static void ConvertPathApplierFunction ( void* info, const CGPathElement* element )
{
	NSBezierPath* np = (NSBezierPath*) info;
	
	switch( element->type )
	{
		case kCGPathElementMoveToPoint:
			[np moveToPoint:*(NSPoint*) element->points];
			break;
		
		case kCGPathElementAddLineToPoint:
			[np lineToPoint:*(NSPoint*) element->points];
			break;
		
		case kCGPathElementAddQuadCurveToPoint:
			[np curveToPoint:*(NSPoint*) &element->points[1] controlPoint1:*(NSPoint*) &element->points[0] controlPoint2:*(NSPoint*) &element->points[0]];
			break;
		
		case kCGPathElementAddCurveToPoint:
			[np curveToPoint:*(NSPoint*) &element->points[2] controlPoint1:*(NSPoint*) &element->points[0] controlPoint2:*(NSPoint*) &element->points[1]];
			break;
			
		case kCGPathElementCloseSubpath:
			[np closePath];
			break;
			
		default:
			break;
	}
}
#endif


inline static void subdivideBezier(const NSPoint bez[4], NSPoint bez1[4], NSPoint bez2[4])
{
  NSPoint q;
  
  bez1[0].x = bez[0].x;
  bez1[0].y = bez[0].y;
  bez2[3].x = bez[3].x;
  bez2[3].y = bez[3].y;
  
  q.x = (bez[1].x + bez[2].x) / 2.0;
  q.y = (bez[1].y + bez[2].y) / 2.0;
  bez1[1].x = (bez[0].x + bez[1].x) / 2.0;
  bez1[1].y = (bez[0].y + bez[1].y) / 2.0;
  bez2[2].x = (bez[2].x + bez[3].x) / 2.0;
  bez2[2].y = (bez[2].y + bez[3].y) / 2.0;
  
  bez1[2].x = (bez1[1].x + q.x) / 2.0;
  bez1[2].y = (bez1[1].y + q.y) / 2.0;
  bez2[1].x = (q.x + bez2[2].x) / 2.0;
  bez2[1].y = (q.y + bez2[2].y) / 2.0;
  
  bez1[3].x = bez2[0].x = (bez1[2].x + bez2[1].x) / 2.0;
  bez1[3].y = bez2[0].y = (bez1[2].y + bez2[1].y) / 2.0;
}

void subdivideBezierAtT(const NSPoint bez[4], NSPoint bez1[4], NSPoint bez2[4], float t)
{
  NSPoint q;
  float mt = 1 - t;
  
  bez1[0].x = bez[0].x;
  bez1[0].y = bez[0].y;
  bez2[3].x = bez[3].x;
  bez2[3].y = bez[3].y;
  
  q.x = mt * bez[1].x + t * bez[2].x;
  q.y = mt * bez[1].y + t * bez[2].y;
  bez1[1].x = mt * bez[0].x + t * bez[1].x;
  bez1[1].y = mt * bez[0].y + t * bez[1].y;
  bez2[2].x = mt * bez[2].x + t * bez[3].x;
  bez2[2].y = mt * bez[2].y + t * bez[3].y;
  
  bez1[2].x = mt * bez1[1].x + t * q.x;
  bez1[2].y = mt * bez1[1].y + t * q.y;
  bez2[1].x = mt * q.x + t * bez2[2].x;
  bez2[1].y = mt * q.y + t * bez2[2].y;
  
  bez1[3].x = bez2[0].x = mt * bez1[2].x + t * bez2[1].x;
  bez1[3].y = bez2[0].y = mt * bez1[2].y + t * bez2[1].y;
}

// Distance between two points
static inline float distanceBetween(NSPoint a, NSPoint b)
{
   return hypotf( a.x - b.x, a.y - b.y );
}

// Length of a curve
static float lengthOfBezier(const  NSPoint bez[4],
			     float acceptableError)
{
  float   polyLen = 0.0;
  float   chordLen = distanceBetween (bez[0], bez[3]);
  float   retLen, errLen;
  unsigned n;
  
  for (n = 0; n < 3; ++n)
    polyLen += distanceBetween (bez[n], bez[n + 1]);
  
  errLen = polyLen - chordLen;
  
  if (errLen > acceptableError) {
    NSPoint left[4], right[4];
    subdivideBezier (bez, left, right);
    retLen = (lengthOfBezier (left, acceptableError) 
	      + lengthOfBezier (right, acceptableError));
  } else {
    retLen = 0.5 * (polyLen + chordLen);
  }
  
  return retLen;
}

// Split a curve at a specific length
static float subdivideBezierAtLength (const NSPoint bez[4],
				       NSPoint bez1[4],
				       NSPoint bez2[4],
				       float length,
				       float acceptableError)
{
  float top = 1.0, bottom = 0.0;
  float t, prevT;
  
  prevT = t = 0.5;
  for (;;) {
    float len1;
    
    subdivideBezierAtT (bez, bez1, bez2, t);
    
    len1 = lengthOfBezier (bez1, 0.5 * acceptableError);
    
    if (fabs (length - len1) < acceptableError)
      return len1;
    
    if (length > len1) {
      bottom = t;
      t = 0.5 * (t + top);
    } else if (length < len1) {
      top = t;
      t = 0.5 * (bottom + t);
    }
    
    if (t == prevT)
      return len1;
    
    prevT = t;
  }
}


// Find the first point in the path

- (NSPoint)			firstPoint
{
	NSPoint points[3];
	
	if ([self elementCount] > 0 )
	{
		NSBezierPathElement element = [self elementAtIndex:0 associatedPoints:points];

		if (element == NSCurveToBezierPathElement)
			return points[2];
		else
			return points[0];
	}
	else
		return NSZeroPoint;
}

- (NSPoint)			lastPoint
{
	NSPoint points[3];
	if ([self elementCount] > 0 )
	{
		NSBezierPathElement element = [self elementAtIndex:[self elementCount] - 1 associatedPoints:points];

		if ( element == NSCurveToBezierPathElement )
			return points[2];
		else
			return points[0];
	}
	else
		return NSZeroPoint;
}


- (float)				lengthOfElement:(int) i
{
	if ( i < 0 || i >= [self elementCount])
		return -1.0;
		
	if( i == 0 )
		return 0.0;
	else
	{
		NSPoint				ap[4];
		NSBezierPathElement element = [self elementAtIndex:i associatedPoints:&ap[1]];
	
		NSPoint				pp[3];
		NSBezierPathElement prev = [self elementAtIndex:i - 1 associatedPoints:pp];
	
		if( prev == NSCurveToBezierPathElement )
			ap[0] = pp[2];
		else
			ap[0] = pp[0];
			
		if ( element == NSCurveToBezierPathElement )
			return lengthOfBezier( ap, 0.1 );
		else if ( element == NSLineToBezierPathElement )
			return distanceBetween( ap[1], ap[0] );
		else if ( element == NSClosePathBezierPathElement )
		{
			prev = [self elementAtIndex:0 associatedPoints:pp];
			return distanceBetween( pp[0], ap[0]);
		}
		else
			return 0.0;
	}
}


- (float)				lengthOfPathFromElement:(int) startElement toElement:(int) endElement
{
	int			i;
	float		d = 0.0;
	
	if( startElement < 0 )
		startElement = 0;
	
	if( endElement >= [self elementCount])
		endElement = [self elementCount] - 1;
	
	for( i = startElement; i <= endElement; ++i )
		d += [self lengthOfElement:i];
		
	return d;
}




#define DEFAULT_TRIM_EPSILON		0.1

// Convenience method

- (NSBezierPath *)	bezierPathByTrimmingToLength:(float)trimLength
{
	return [self bezierPathByTrimmingToLength:trimLength withMaximumError:DEFAULT_TRIM_EPSILON];
}


/* Return an NSBezierPath corresponding to the first trimLength units
   of this NSBezierPath. */
- (NSBezierPath *)	bezierPathByTrimmingToLength:(float)trimLength withMaximumError:(float) maxError
{
	if( trimLength >= [self length])
		return self;
	
	NSBezierPath *newPath = [NSBezierPath bezierPath];
	int	       elements = [self elementCount];
	int	       n;
	float     length = 0.0;
	NSPoint    pointForClose = NSMakePoint (0.0, 0.0);
	NSPoint    lastPoint = NSMakePoint (0.0, 0.0);

	for (n = 0; n < elements; ++n)
	{
		NSPoint		points[3];
		NSBezierPathElement element = [self elementAtIndex:n associatedPoints:points];
		float		elementLength;
		float		remainingLength = trimLength - length;
    
		switch (element)
		{
			case NSMoveToBezierPathElement:
				[newPath moveToPoint:points[0]];
				pointForClose = lastPoint = points[0];
				continue;
	
			case NSLineToBezierPathElement:
				elementLength = distanceBetween (lastPoint, points[0]);
	
				if (length + elementLength <= trimLength)
					[newPath lineToPoint:points[0]];
				else
				{
					float f = remainingLength / elementLength;
					[newPath lineToPoint:NSMakePoint (lastPoint.x + f * (points[0].x - lastPoint.x), lastPoint.y + f * (points[0].y - lastPoint.y))];
					return newPath;
				}
	
				length += elementLength;
				lastPoint = points[0];
				break;
	
			case NSCurveToBezierPathElement:
			{
				NSPoint bezier[4] = { lastPoint, points[0], points[1], points[2] };
				elementLength = lengthOfBezier (bezier, maxError);
	
				if (length + elementLength <= trimLength)
					[newPath curveToPoint:points[2] controlPoint1:points[0] controlPoint2:points[1]];
				else
				{
					NSPoint bez1[4], bez2[4];
					subdivideBezierAtLength (bezier, bez1, bez2, remainingLength, maxError);
					[newPath curveToPoint:bez1[3] controlPoint1:bez1[1] controlPoint2:bez1[2]];
					return newPath;
				}
	
				length += elementLength;
				lastPoint = points[2];
				break;
			}
	
			case NSClosePathBezierPathElement:
				elementLength = distanceBetween (lastPoint, pointForClose);
	
				if (length + elementLength <= trimLength)
				{
					[newPath closePath];
				}
				else
				{
					float f = remainingLength / elementLength;
					[newPath lineToPoint:NSMakePoint (lastPoint.x + f * (pointForClose.x - lastPoint.x), lastPoint.y + f * (pointForClose.y - lastPoint.y))];
					return newPath;
				}
	
				length += elementLength;
				lastPoint = pointForClose;
				break;
				
			default:
				break;
		}
	} 
	return newPath;
}



// Convenience method
- (NSBezierPath *)	bezierPathByTrimmingFromLength:(float) trimLength
{
	return [self bezierPathByTrimmingFromLength:trimLength withMaximumError:DEFAULT_TRIM_EPSILON];
}


/* Return an NSBezierPath corresponding to the part *after* the first
   trimLength units of this NSBezierPath. */
- (NSBezierPath *)	bezierPathByTrimmingFromLength:(float)trimLength withMaximumError:(float)maxError
{
	if( trimLength <= 0 )
		return self;
	
	NSBezierPath *newPath = [NSBezierPath bezierPath];
	int	       elements = [self elementCount];
	int	       n;
	float       length = 0.0;
	NSPoint      pointForClose = NSMakePoint (0.0, 0.0);
	NSPoint      lastPoint = NSMakePoint (0.0, 0.0);
  
	for (n = 0; n < elements; ++n)
	{
		NSPoint		points[3];
		NSBezierPathElement element = [self elementAtIndex:n associatedPoints:points];
		float		elementLength;
		float		remainingLength = trimLength - length;
    
		switch (element)
		{
			case NSMoveToBezierPathElement:
				if ( length > trimLength )
					[newPath moveToPoint:points[0]];
				pointForClose = lastPoint = points[0];
				continue;
	
			case NSLineToBezierPathElement:
				elementLength = distanceBetween (lastPoint, points[0]);
	
				if (length > trimLength)
					[newPath lineToPoint:points[0]];
				else if (length + elementLength > trimLength)
				{
					float f = remainingLength / elementLength;
					[newPath moveToPoint:NSMakePoint (lastPoint.x + f * (points[0].x - lastPoint.x), lastPoint.y + f * (points[0].y - lastPoint.y))];
					[newPath lineToPoint:points[0]];
				}
	  
				length += elementLength;
				lastPoint = points[0];
				break;
	
			case NSCurveToBezierPathElement:
			{
				NSPoint bezier[4] = { lastPoint, points[0], points[1], points[2] };
				elementLength = lengthOfBezier (bezier, maxError);
	
				if (length > trimLength)
					[newPath curveToPoint:points[2] controlPoint1:points[0] controlPoint2:points[1]];
				else if (length + elementLength > trimLength)
				{
					NSPoint bez1[4], bez2[4];
					subdivideBezierAtLength (bezier, bez1, bez2, remainingLength, maxError);
					[newPath moveToPoint:bez2[0]];
					[newPath curveToPoint:bez2[3] controlPoint1:bez2[1] controlPoint2:bez2[2]];
				}
	
				length += elementLength;
				lastPoint = points[2];
				break;
			}
	
			case NSClosePathBezierPathElement:
				elementLength = distanceBetween (lastPoint, pointForClose);
	
				if (length > trimLength)
				{
					[newPath lineToPoint:pointForClose];
					[newPath closePath];
				}
				else if (length + elementLength > trimLength)
				{
					float f = remainingLength / elementLength;
					[newPath moveToPoint:NSMakePoint (lastPoint.x + f * (points[0].x - lastPoint.x), lastPoint.y + f * (points[0].y - lastPoint.y))];
					[newPath lineToPoint:points[0]];
				}
	  
				length += elementLength;
				lastPoint = pointForClose;
				break;
				
			default:
				break;
		}
	} 
	return newPath;
}



- (NSBezierPath*)		bezierPathByTrimmingFromBothEnds:(float) trimLength
{
	return [self bezierPathByTrimmingFromBothEnds:trimLength withMaximumError:DEFAULT_TRIM_EPSILON];
}


- (NSBezierPath *)		bezierPathByTrimmingFromBothEnds:(float) trimLength withMaximumError:(float) maxError
{
	// trims <trimLength> from both ends of the path, returning the shortened centre section
	
	float rlen = [self length] - (trimLength * 2.0);
	return [self bezierPathByTrimmingFromLength:trimLength toLength:rlen withMaximumError:maxError];
}


- (NSBezierPath*)		bezierPathByTrimmingFromCentre:(float) trimLength
{
	return [self bezierPathByTrimmingFromCentre:trimLength withMaximumError:DEFAULT_TRIM_EPSILON];
}


- (NSBezierPath*)		bezierPathByTrimmingFromCentre:(float) trimLength withMaximumError:(float) maxError
{
	// removes a section <trimLength> long from the centre of the path. The returned path thus consists of two
	// subpaths with a gap between them.
	
	float centre = [self length] * 0.5f;
	
	NSBezierPath* temp1 = [self bezierPathByTrimmingToLength:centre - (trimLength * 0.5f) withMaximumError:maxError];
	NSBezierPath* temp2 = [self bezierPathByTrimmingFromLength:centre + (trimLength * 0.5f) withMaximumError:maxError];
	
	[temp1 appendBezierPath:temp2];
	
	return temp1;
}


- (NSBezierPath*)		bezierPathByTrimmingFromLength:(float) startLength toLength:(float) newLength
{
	return [self bezierPathByTrimmingFromLength:startLength toLength:newLength withMaximumError:DEFAULT_TRIM_EPSILON];
}


- (NSBezierPath*)		bezierPathByTrimmingFromLength:(float) startLength toLength:(float) newLength withMaximumError:(float) maxError
{
	// returns a new path which is <newLength> long, starting at <startLength> on the receiver's path. If <newLength> exceeds the available length, the
	// remainder of the path is returned. If <startLength> exceeds the length, returns nil.
	
	NSBezierPath* temp = [self bezierPathByTrimmingFromLength:startLength withMaximumError:maxError];
	return [temp bezierPathByTrimmingToLength:newLength withMaximumError:maxError];	
}



// Create an NSBezierPath containing an arrowhead for the start of this path


- (NSBezierPath *)	bezierPathWithArrowHeadForStartOfLength:(float) length angle:(float) angle closingPath:(BOOL) closeit
{
	NSBezierPath *rightSide = [self bezierPathByTrimmingToLength:length];
	NSBezierPath *leftSide = [rightSide bezierPathByReversingPath];
	NSAffineTransform *rightTransform = [NSAffineTransform transform];
	NSAffineTransform *leftTransform = [NSAffineTransform transform];
	NSPoint firstPoint = [self firstPoint];
	//NSPoint fp2 = [self firstPoint2:length / 2.0];
	// Rotate about the point of the arrowhead
	[rightTransform translateXBy:firstPoint.x yBy:firstPoint.y];
	[rightTransform rotateByDegrees:angle];
	[rightTransform translateXBy:-firstPoint.x yBy:-firstPoint.y];
  
	[rightSide transformUsingAffineTransform:rightTransform];
  
	// Same again, but for the left hand side of the arrowhead
	[leftTransform translateXBy:firstPoint.x yBy:firstPoint.y];
	[leftTransform rotateByDegrees:-angle];
	[leftTransform translateXBy:-firstPoint.x yBy:-firstPoint.y];
  
	[leftSide transformUsingAffineTransform:leftTransform];
  
	/* Careful!  We don't want to append the -moveToPoint from the right hand
     side, because then -closePath won't do what we would want it to. */
	[leftSide appendBezierPathRemovingInitialMoveToPoint:rightSide];
	
	if ( closeit )
		[leftSide closePath];
  
	return leftSide;
}

// Convenience function for obtaining arrow for the other end
- (NSBezierPath *)	bezierPathWithArrowHeadForEndOfLength:(float) length  angle:(float) angle closingPath:(BOOL) closeit
{
	return [[self bezierPathByReversingPath] bezierPathWithArrowHeadForStartOfLength:length angle:angle closingPath:closeit];
}


/* Append a Bezier path, but if it starts with a -moveToPoint, then remove
   it.  This is useful when manipulating trimmed path segments. */

- (void)			appendBezierPathRemovingInitialMoveToPoint:(NSBezierPath*) path
{
	int	       elements = [path elementCount];
	int	       n;
  
	for (n = 0; n < elements; ++n)
	{
		NSPoint		points[3];
		NSBezierPathElement element = [path elementAtIndex:n associatedPoints:points];

		switch (element)
		{
			case NSMoveToBezierPathElement:
			{
				if (n != 0)
					[self moveToPoint:points[0]];
				break;
			}
	
			case NSLineToBezierPathElement:
				[self lineToPoint:points[0]];
			break;
	
			case NSCurveToBezierPathElement:
				[self curveToPoint:points[2] controlPoint1:points[0] controlPoint2:points[1]];
			break;
	
			case NSClosePathBezierPathElement:
				[self closePath];
				
			default:
				break;
		}
	}
}


// Convenience method

- (float)			length
{
	return [self lengthWithMaximumError:DEFAULT_TRIM_EPSILON];
}

// Estimate the total length of a bezier path

- (float)			lengthWithMaximumError:(float) maxError
{
  int     elements = [self elementCount];
  int     n;
  float  length = 0.0;
  NSPoint pointForClose = NSMakePoint (0.0, 0.0);
  NSPoint lastPoint = NSMakePoint (0.0, 0.0);
  
  for (n = 0; n < elements; ++n)
  {
		NSPoint		points[3];
		NSBezierPathElement element = [self elementAtIndex:n associatedPoints:points];
    
		switch (element)
		{
			case NSMoveToBezierPathElement:
				pointForClose = lastPoint = points[0];
				break;
	
			case NSLineToBezierPathElement:
				length += distanceBetween (lastPoint, points[0]);
				lastPoint = points[0];
				break;
	
			case NSCurveToBezierPathElement:
			{
				NSPoint bezier[4] = { lastPoint, points[0], points[1], points[2] };
				length += lengthOfBezier (bezier, maxError);
				lastPoint = points[2];
				break;
			}
	
			case NSClosePathBezierPathElement:
				length += distanceBetween (lastPoint, pointForClose);
				lastPoint = pointForClose;
				break;
				
			default:
				break;
		}
  }
  
  return length;
}


@end


