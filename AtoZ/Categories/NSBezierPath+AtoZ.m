
//  GTMNSBezierPath+CGPath.m

//  Category for extracting a CGPathRef from a NSBezierPath


#import "NSBezierPath+AtoZ.h"
//#import "GTMDefines.h"
#import "AtoZ.h"


@implementation NSAffineTransform (UKShearing)

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
	CIImage*	coreimage;
	
	inStartColor = [inStartColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	inEndColor = [inEndColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	
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

- (void)fillWithInnerShadow:(NSShadow *)shadow
{
	[NSGraphicsContext saveGraphicsState];
	
	NSSize offset = shadow.shadowOffset;
	NSSize originalOffset = offset;
	CGFloat radius = shadow.shadowBlurRadius;
	NSRect bounds = NSInsetRect(self.bounds, -(ABS(offset.width) + radius), -(ABS(offset.height) + radius));
	offset.height += bounds.size.height;
	shadow.shadowOffset = offset;
	NSAffineTransform *transform = [NSAffineTransform transform];
	if ([[NSGraphicsContext currentContext] isFlipped])
		[transform translateXBy:0 yBy:bounds.size.height];
	else
		[transform translateXBy:0 yBy:-bounds.size.height];
	
	NSBezierPath *drawingPath = [NSBezierPath bezierPathWithRect:bounds];
	[drawingPath setWindingRule:NSEvenOddWindingRule];
	[drawingPath appendBezierPath:self];
	[drawingPath transformUsingAffineTransform:transform];
	
	[self addClip];
	[shadow set];
	[[NSColor blackColor] set];
	[drawingPath fill];
	
	shadow.shadowOffset = originalOffset;
	
	[NSGraphicsContext restoreGraphicsState];
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


@end
