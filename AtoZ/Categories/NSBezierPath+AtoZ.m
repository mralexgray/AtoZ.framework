#import "NSBezierPath+AtoZ.h"
#import "AtoZ.h"

@implementation NSAffineTransform (RectMapping)

- (NSAffineTransform *)mapFrom:(NSRect)src to:(NSRect)dst {
    NSAffineTransformStruct at;
    at.m11 = (dst.size.width / src.size.width);
    at.m12 = 0.0;
    at.tX = dst.origin.x - at.m11 * src.origin.x;
    at.m21 = 0.0;
    at.m22 = (dst.size.height / src.size.height);
    at.tY = dst.origin.y - at.m22 * src.origin.y;
    [self setTransformStruct:at];
    return self;
}

/* create a transform that prop. scales bounds to a rectangle of height centered distance units above a particular point.   */
- (NSAffineTransform *)scaleBounds:(NSR)bounds toHeight:(CGF)height centeredDistance:(CGF)distance abovePoint:(NSP)location {
    NSRect dst = bounds;
    float scale = (height / dst.size.height);
    dst.size.width *= scale;        dst.size.height *= scale;       dst.origin.x = location.x - dst.size.width / 2.0;
    dst.origin.y = location.y + distance;
    return [self mapFrom:bounds to:dst];
}

/* create a transform that proportionately scales bounds to a rectangle of height centered distance units above the origin.   */
- (NSAffineTransform *)scaleBounds:(NSRect)bounds toHeight:(CGF)height centeredAboveOrigin:(CGF)distance {
    return [self scaleBounds:bounds toHeight:height centeredDistance:
            distance abovePoint:NSMakePoint(0, 0)];
}

/* initialize the NSAffineTransform so it will flip the contents of bounds	vertically. */
- (NSAffineTransform *)flipVertical:(NSRect)bounds {
    NSAffineTransformStruct at;
    at.m11 = 1.0;
    at.m12 = 0.0;
    at.tX = 0;
    at.m21 = 0.0;
    at.m22 = -1.0;
    at.tY = bounds.size.height;
    [self setTransformStruct:at];
    return self;
}

@end
@implementation NSBezierPath (ShadowDrawing)
/* fill a bezier path, but draw a shadow under it offset by the	given angle (counter clockwise from the x-axis) and distance. */
- (void)fillWithShadowAtDegrees:(CGF)angle withDistance:(CGF)distance {
    float radians = angle * (3.141592 / 180.0); /* create a new shadow */
    NSShadow *theShadow = [[NSShadow alloc] init];    /* offset the shadow by the indicated direction and distance */
    [theShadow setShadowOffset:NSMakeSize(cosf(radians) * distance, sinf(radians) * distance)]; /* set other shadow parameters */
    [theShadow setShadowBlurRadius:3.0];
    [theShadow setShadowColor:[[NSColor blackColor] colorWithAlphaComponent:0.3]];    /* save the graphics context */
    [NSGraphicsContext state:^{         /* use the shadow */
        [theShadow set];
        [self fill];        /* fill the NSBezierPath *//* restore the graphics context */
    }];         /* done with the shadow */
}

@end
@implementation BezierNSLayoutManager

//- (void) dealloc {
//	self.theBezierPath = nil;
//}
//
//- (NSBezierPath *)theBezierPath {
//    return theBezierPath;
//}
//
//- (void)setTheBezierPath:(NSBezierPath *)value {    if (theBezierPath != value)   theBezierPath = value;
//    }
//}

/* convert the NSString into a NSBezierPath using a specific font. */
- (void)showPackedGlyphs:(char *)glyphs length:(unsigned)glyphLen glyphRange:(NSRNG)glyphRange atPoint:(NSP)point font:(NSFont *)font
                   color:(NSColor *)color printingAdjustment:(NSSize)printingAdjustment {
/* if there is a NSBezierPath associated with this	layout, then append the glyphs to it. */
    NSBezierPath *bezier = [self theBezierPath];
    if (nil != bezier) {
        [bezier moveToPoint:point];                                     /* add the glyphs to the bezier path */
        [bezier appendBezierPathWithPackedGlyphs:glyphs];
    }
}

@end
@implementation NSString (BezierConversions)
- (NSBezierPath *)bezierWithFont:(NSFont *)theFont {
    NSBezierPath *bezier = nil;     /* default result */
    /* put the string's text into a text storage so we can access the glyphs through a layout. */
    NSTextStorage *textStore = [[NSTextStorage alloc] initWithString:self];
    NSTextContainer *textContainer = [[NSTextContainer alloc] init];
    BezierNSLayoutManager *myLayout = [[BezierNSLayoutManager alloc] init];
    [myLayout addTextContainer:textContainer];
    [textStore addLayoutManager:myLayout];
    [textStore setFont:theFont];
/* create a new NSBezierPath and add it to the custom layout */
    [myLayout setTheBezierPath:[NSBezierPath bezierPath]];
/* to call drawGlyphsForGlyphRange, we need a destination so we'll
                set up a temporary one.  Size is unimportant and can be small.  */
    NSImage *theImage = [[NSImage alloc] initWithSize:NSMakeSize(10.0, 10.0)];
/* lines are drawn in reverse order, so we will draw the text upside down and then flip the resulting NSBezierPath right side up again to achieve our final result with the lines in the right order and the text with proper orientation.  */
    [theImage setFlipped:YES];
    [theImage lockFocus];
/* draw all of the glyphs to collecting them into a bezier pathusing our custom layout class. */
    NSRange glyphRange = [myLayout glyphRangeForTextContainer:textContainer];
    [myLayout drawGlyphsForGlyphRange:glyphRange atPoint:NSMakePoint(0.0, 0.0)];
/* clean up our temporary drawing environment */
    [theImage unlockFocus];
/* retrieve the glyphs from our BezierNSLayoutManager instance */
    bezier = [myLayout theBezierPath];
/* clean up our text storage objects *//* Flip the final NSBezierPath. */
    [bezier transformUsingAffineTransform:[[NSAffineTransform transform] flipVertical:[bezier bounds]]];
    return bezier;
}

@end

#define ONE_THIRD                  (1.0f / 3.0f)
#define TWO_THIRDS                 (2.0f / 3.0f)
#define ONE_HALF                   0.5f

#define DEFAULT_SHAFT_WIDTH        ONE_THIRD
#define DEFAULT_SHAFT_LENGTH_MULTI 1.0f

@implementation NSAffineTransform (UKShearing)

+ (NSAffineTransform *)transformRotatingAroundPoint:(NSPoint)p byDegrees:(CGFloat)deg {
    NSAffineTransform *transform = [NSAffineTransform transform];
    [transform translateXBy:p.x yBy:p.y];
    [transform rotateByDegrees:deg];
    [transform translateXBy:-p.x yBy:-p.y];
    return transform;
}

- (void)shearXBy:(CGFloat)xFraction yBy:(CGFloat)yFraction {
    NSAffineTransform *theTransform = [NSAffineTransform transform];
    NSAffineTransformStruct transformStruct = { 0 };

    transformStruct.m11 = 1.0;
    transformStruct.m12 = yFraction;
    transformStruct.m21 = xFraction;
    transformStruct.m22 = 1.0;

    [theTransform setTransformStruct:transformStruct];
    [self prependTransform:theTransform];
}

@end
//#define VALUE(_INDEX_) AZVpoint(points[_INDEX_])
@implementation NSBezierPath (AtoZ)

void getPointsFromBezier(void *info, const CGPathElement *element) 	{

    NSMutableArray *bezierPoints = (__bridge NSMutableArray *)info;    
    CGPathElementType type 		= element->type;			// Retrieve the path element type and its points
    CGPoint *points 					= element->points;
    if (type != kCGPathElementCloseSubpath)	    	// Add the points if they're available (per type)
    {
        [bezierPoints addObject:AZVpoint(points[0])];
        if (type != kCGPathElementAddLineToPoint && type != kCGPathElementMoveToPoint) [bezierPoints addObject:AZVpoint(points[1])];
    }    
    if (type == kCGPathElementAddCurveToPoint)											         [bezierPoints addObject:AZVpoint(points[2])];
}
- (NSArray *)points
{
    NSMutableArray *points = NSMA.new;
    CGPathApply(self.quartzPath, (__bridge void*)points, getPointsFromBezier);
    return points;
}
+ (NSBP*) bezierPathWithPoints:(NSA*)points {

	NSBezierPath *path = [NSBezierPath bezierPath];
	[path moveToPoint:[points[0] pointValue]];
	int i;
	int count = [points count];
	for (NSValue* point in points)
		[path lineToPoint:[point pointValue]];
	return path;
}

static void linearShadedColor		(void *info, const CGFloat *in, CGFloat *out)	{	CGFloat *colors = info;
	*out++ = colors[0] + *in * colors[8];
	*out++ = colors[1] + *in * colors[9];
	*out++ = colors[2] + *in * colors[10];
	*out++ = colors[3] + *in * colors[11];
}
static void bilinearShadedColor	(void *info, const CGFloat *in, CGFloat *out)	{
	CGFloat *colors = info;
	CGFloat factor = (*in)*2.0;
	if (*in > 0.5) {
		factor = 2-factor;
	}
	*out++ = colors[0] + factor * colors[8];
	*out++ = colors[1] + factor * colors[9];
	*out++ = colors[2] + factor * colors[10];
	*out++ = colors[3] + factor * colors[11];
}

- (void)linearGradientFillWithStartColor:(NSColor *)startColor endColor:(NSColor *)endColor
{
	/*
	CGColorSpaceRef colorspace;
	CGShadingRef shading;
	CGPoint startPoint = {0, 0};
	CGPoint endPoint = {0, 0};
	CGFunctionRef function;
	float colors[12]; // pointer to color values
	
	// get my context
	CGContextRef currentContext = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
	
	NSColor *deviceDependentStartColor = [startColor colorUsingColorSpaceName:NSDeviceRGBColorSpace];
	NSColor *deviceDependentEndColor = [endColor colorUsingColorSpaceName:NSDeviceRGBColorSpace];
	
	// set up colors for gradient
	colors[0] = [deviceDependentStartColor redComponent];
	colors[1] = [deviceDependentStartColor greenComponent];
	colors[2] = [deviceDependentStartColor blueComponent];
	colors[3] = [deviceDependentStartColor alphaComponent];
	
	colors[4] = [deviceDependentEndColor redComponent];
	colors[5] = [deviceDependentEndColor greenComponent];
	colors[6] = [deviceDependentEndColor blueComponent];
	colors[7] = [deviceDependentEndColor alphaComponent];
	
	// difference between start and end color for each color components
	colors[8] = (colors[4]-colors[0]);
	colors[9] = (colors[5]-colors[1]);
	colors[10] = (colors[6]-colors[2]);
	colors[11] = (colors[7]-colors[3]);
	
	// draw gradient
	colorspace = CGColorSpaceCreateDeviceRGB();
	
	size_t components = 1 + CGColorSpaceGetNumberOfComponents(colorspace);
	static const float  domain[2] = {0.0, 1.0};
	static const float  range[10] = {0, 1, 0, 1, 0, 1, 0, 1, 0, 1};
	static const CGFunctionCallbacks callbacks = {0, &shadedColor, NULL};

	// Create a CGFunctionRef that describes a function taking 1 input and kChannelsPerColor outputs.
	function = CGFunctionCreate(colors, 1, domain, components, range, &callbacks);
	
	startPoint.x=0;
	startPoint.y=[self bounds].origin.y;
	endPoint.x=0;
	endPoint.y=NSMaxY([self bounds]);
	
	shading = CGShadingCreateAxial(colorspace, startPoint, endPoint, function, NO, NO);
	
	CGContextSaveGState(currentContext);
	[self addClip];
	CGContextDrawShading(currentContext, shading);
	CGContextRestoreGState(currentContext);
	
	CGShadingRelease(shading);
	CGFunctionRelease(function);
	CGColorSpaceRelease(colorspace);
	 */
	static const CGFunctionCallbacks callbacks = {0, &linearShadedColor, NULL};
	[self customVerticalFillWithCallbacks:callbacks firstColor:startColor secondColor:endColor];
};

- (void)bilinearGradientFillWithOuterColor:(NSColor *)outerColor innerColor:(NSColor *)innerColor
{
	static const CGFunctionCallbacks callbacks = {0, &bilinearShadedColor, NULL};
	[self customVerticalFillWithCallbacks:callbacks firstColor:innerColor secondColor:outerColor];
}

- (void)customVerticalFillWithCallbacks:(CGFunctionCallbacks)functionCallbacks firstColor:(NSColor *)firstColor secondColor:(NSColor *)secondColor	{
	CGColorSpaceRef colorspace;
	CGShadingRef shading;
	CGPoint startPoint = {0, 0};
	CGPoint endPoint = {0, 0};
	CGFunctionRef function;
	CGFloat colors[12]; // pointer to color values
	
	// get my context
	CGContextRef currentContext = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
	
	NSColor *deviceDependentFirstColor = [firstColor colorUsingColorSpaceName:NSDeviceRGBColorSpace];
	NSColor *deviceDependentSecondColor = [secondColor colorUsingColorSpaceName:NSDeviceRGBColorSpace];
	
	// set up colors for gradient
	colors[0] = [deviceDependentFirstColor redComponent];
	colors[1] = [deviceDependentFirstColor greenComponent];
	colors[2] = [deviceDependentFirstColor blueComponent];
	colors[3] = [deviceDependentFirstColor alphaComponent];
	
	colors[4] = [deviceDependentSecondColor redComponent];
	colors[5] = [deviceDependentSecondColor greenComponent];
	colors[6] = [deviceDependentSecondColor blueComponent];
	colors[7] = [deviceDependentSecondColor alphaComponent];
	
	// difference between start and end color for each color components
	colors[8] = (colors[4]-colors[0]);
	colors[9] = (colors[5]-colors[1]);
	colors[10] = (colors[6]-colors[2]);
	colors[11] = (colors[7]-colors[3]);
	
	// draw gradient
#if MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_4
	colorspace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
#else
	colorspace = CGColorSpaceCreateDeviceRGB();
#endif
	size_t components = 1 + CGColorSpaceGetNumberOfComponents(colorspace);
	static const CGFloat domain[2] = {0.0, 1.0};
	static const CGFloat range[10] = {0, 1, 0, 1, 0, 1, 0, 1, 0, 1};
	//static const CGFunctionCallbacks callbacks = {0, &bilinearShadedColor, NULL};
	
	// Create a CGFunctionRef that describes a function taking 1 input and kChannelsPerColor outputs.
	function = CGFunctionCreate(colors, 1, domain, components, range, &functionCallbacks);
	
	startPoint.x=0;
	startPoint.y=[self bounds].origin.y;
	endPoint.x=0;
	endPoint.y=NSMaxY([self bounds]);
	
	shading = CGShadingCreateAxial(colorspace, startPoint, endPoint, function, NO, NO);
	
	CGContextSaveGState(currentContext);
	[self addClip];
	CGContextDrawShading(currentContext, shading);
	CGContextRestoreGState(currentContext);
	
	CGShadingRelease(shading);
	CGFunctionRelease(function);
	CGColorSpaceRelease(colorspace);
}

- (void)customHorizontalFillWithCallbacks:(CGFunctionCallbacks)functionCallbacks 
										  firstColor:(NSColor*)firstColor secondColor:(NSColor*)secondColor	{
	CGColorSpaceRef colorspace;
	CGShadingRef shading;
	CGPoint startPoint = {0, 0};
	CGPoint endPoint = {0, 0};
	CGFunctionRef function;
	float colors[12]; // pointer to color values
	
	// get my context
	CGContextRef currentContext = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
	
	NSColor *deviceDependentFirstColor = [firstColor colorUsingColorSpaceName:NSDeviceRGBColorSpace];
	NSColor *deviceDependentSecondColor = [secondColor colorUsingColorSpaceName:NSDeviceRGBColorSpace];
	
	// set up colors for gradient
	colors[0] = [deviceDependentFirstColor redComponent];
	colors[1] = [deviceDependentFirstColor greenComponent];
	colors[2] = [deviceDependentFirstColor blueComponent];
	colors[3] = [deviceDependentFirstColor alphaComponent];
	
	colors[4] = [deviceDependentSecondColor redComponent];
	colors[5] = [deviceDependentSecondColor greenComponent];
	colors[6] = [deviceDependentSecondColor blueComponent];
	colors[7] = [deviceDependentSecondColor alphaComponent];
	
	// difference between start and end color for each color components
	colors[8] = (colors[4]-colors[0]);
	colors[9] = (colors[5]-colors[1]);
	colors[10] = (colors[6]-colors[2]);
	colors[11] = (colors[7]-colors[3]);
	
	// draw gradient
	colorspace = CGColorSpaceCreateDeviceRGB();
	size_t components = 1 + CGColorSpaceGetNumberOfComponents(colorspace);
	static const CGFloat  domain[2] = {0.0, 1.0};
	static const CGFloat  range[10] = {0, 1, 0, 1, 0, 1, 0, 1, 0, 1};
	//static const CGFunctionCallbacks callbacks = {0, &bilinearShadedColor, NULL};
	
	// Create a CGFunctionRef that describes a function taking 1 input and kChannelsPerColor outputs.
	function = CGFunctionCreate(colors, 1, domain, components, range, &functionCallbacks);
	
	startPoint.x=0;
	startPoint.y=[self bounds].origin.y;
	endPoint.x=0;
	endPoint.y=NSMaxY([self bounds]);
	
	shading = CGShadingCreateAxial(colorspace, startPoint, endPoint, function, NO, NO);
	
	CGContextSaveGState(currentContext);
	[self addClip];
	CGContextDrawShading(currentContext, shading);
	CGContextRestoreGState(currentContext);
	
	CGShadingRelease(shading);
	CGFunctionRelease(function);
	CGColorSpaceRelease(colorspace);
}

- (CGF)width	{    return self.bounds.size.width;	}
- (CGF)height 	{    return self.bounds.size.height;	}
- (void)setWidth:(CGF)t 	{    [self scaledToSize:AZSizeExceptWide(self.bounds.size, t)];	}
- (void)setHeight:(CGF)t  	{
    [self scaledToSize:AZSizeExceptHigh(self.bounds.size, t)];
}

+ (NSBP *)diagonalLinesInRect:(NSR)rect phase:(CGF)phase {
    NSBP *_bp = [self new]; CGF bandWidth, h, modPhase, lastX;
    NSI numX        = ceil(rect.size.width / 25);
    bandWidth       = 20;
    h                               = 0;
    modPhase                = round(fmod(phase, rect.size.width));
    lastX           = -27 + modPhase - rect.size.width;
    for (NSI i = NEG(numX); i < numX; i++) {
        [_bp moveToPoint:NSMakePoint(lastX + .5, rect.size.height + .5 - h)];
        [_bp lineToPoint:NSMakePoint(lastX + bandWidth + .5,                0 + .5 + h)];
        [_bp lineToPoint:NSMakePoint(lastX + bandWidth + bandWidth + .5,                0 + .5 + h)];
        [_bp lineToPoint:NSMakePoint(lastX + bandWidth + .5, rect.size.height + .5 - h)];
        [_bp lineToPoint:NSMakePoint(lastX + .5, rect.size.height + .5 - h)];
        lastX += bandWidth * 2 - 1;
    }
    return _bp;
}

//	NSI numX        = ceil( rect.size.width / 25 );
//	CGF bandWidth   = 20;
//	CGF h           = 0;
//	CGF modPhase    = round(fmod(self.phase, rect.size.width));
//	CGF lastX	    = -27 + modPhase - rect.size.width;
//
//	for ( NSI i = NEG(numX); i < numX; i++ ) {
//		[_bp moveToPoint:NSMakePoint(                         lastX + .5, rect.size.height + .5 - h )];
//		[_bp lineToPoint:NSMakePoint(             lastX + bandWidth + .5,                0 + .5 + h )];
//		[_bp lineToPoint:NSMakePoint( lastX + bandWidth + bandWidth + .5,                0 + .5 + h )];
//		[_bp lineToPoint:NSMakePoint(             lastX + bandWidth + .5, rect.size.height + .5 - h )];
//		[_bp lineToPoint:NSMakePoint(                         lastX + .5, rect.size.height + .5 - h )];
//		lastX += bandWidth * 2 - 1;
//	}


- (NSBP *)scaledToSize:(NSSZ)size;
{
    return [self scaledToFrame:AZRectFromSize(size)];
}

- (NSBP *)scaledToFrame:(NSR)rect;
{
    NSAT *transform = [[NSAffineTransform alloc] init];
    CGF ratio     = 1.0;

    // get the ratio
    ratio = MIN(rect.size.width  / self.bounds.size.width,
                rect.size.height / self.bounds.size.height);

    // scale by ratio
    [transform scaleBy:ratio];

    // move the pat to (0,0)
    [transform translateXBy:-self.bounds.origin.x yBy:-self.bounds.origin.y];

    // set the transform
    [self transformUsingAffineTransform:transform];
    return self;
}


+ (NSBP *)bezierPathWithSpringWithCoils:(NSUI)numCoils inFrame:(NSR)bounds;
{
    CGPoint o = (CGP) {bounds.origin.x + bounds.size.width * .75, bounds.origin.y + bounds.size.height };

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, o.x, o.y);

    int springWidth = bounds.size.width  / 2;
    float coilHeight = bounds.size.height / numCoils;
    float coilUnit = coilHeight / 4;
    CGPoint p6;
    int i = 0;
    for (; i < numCoils; i++) {
        CGPoint p1  = CGPointMake(o.x,                                  o.y - coilUnit * 3);
        CGPoint p2  = CGPointMake(o.x - springWidth,    o.y - coilUnit * 3);
        CGPoint p3  = CGPointMake(o.x - springWidth,    o.y - coilUnit * 2);
        CGPoint p4  = CGPointMake(o.x - springWidth,    o.y - coilUnit * 1);
        CGPoint p5  = CGPointMake(o.x,                                  o.y);
        p6  = CGPointMake(o.x,                                  o.y - coilHeight);
        CGPathAddCurveToPoint(path, NULL, p1.x, p1.y, p2.x, p2.y, p3.x, p3.y);
        CGPathAddCurveToPoint(path, NULL, p4.x, p4.y, p5.x, p5.y, p6.x, p6.y);
        o.y -= coilHeight;
    }
    return [NSBezierPath bezierPathWithCGPath:path];
}

+ (NSBezierPath *)bezierPathWithPlateInRect:(NSRect)rect {
    NSBezierPath *result = [[NSBezierPath alloc] init];
    [result appendBezierPathWithPlateInRect:rect];
    return [result autorelease];
}

- (void)appendBezierPathWithPlateInRect:(NSRect)rect {
    if (rect.size.height > 0) {
        float xoff = rect.origin.x;
        float yoff = rect.origin.y;
        float radius = rect.size.height / 2.0;
        NSPoint point4 = NSMakePoint(xoff + radius, yoff + rect.size.height);
        NSPoint center1 = NSMakePoint(xoff + radius, yoff + radius);
        NSPoint center2 = NSMakePoint(xoff + rect.size.width - radius, yoff + radius);
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

- (void)appendBezierPathWithRoundedRect:(NSRect)rect cornerRadius:(float)radius {
    if (rect.size.height > 0) {
        float xoff = rect.origin.x;
        float yoff = rect.origin.y;
        NSPoint startpoint = NSMakePoint(xoff, yoff + radius);
        NSPoint center1 = NSMakePoint(xoff + radius, yoff + radius);
        NSPoint center2 = NSMakePoint(xoff + rect.size.width - radius, yoff + radius);
        NSPoint center3 = NSMakePoint(xoff + rect.size.width - radius, yoff + rect.size.height - radius);
        NSPoint center4 = NSMakePoint(xoff + radius, yoff + rect.size.height - radius);
        [self moveToPoint:startpoint];
        [self appendBezierPathWithArcWithCenter:center1 radius:radius startAngle:180.0 endAngle:270.0];
        [self appendBezierPathWithArcWithCenter:center2 radius:radius startAngle:270.0 endAngle:360.0];
        [self appendBezierPathWithArcWithCenter:center3 radius:radius startAngle:360.0 endAngle:90.0];
        [self appendBezierPathWithArcWithCenter:center4 radius:radius startAngle:90.0 endAngle:180.0];
        [self closePath];
    }
}

+ (NSBezierPath *)bezierPathWithTriangleInRect:(NSRect)aRect orientation:(AZCompass)orientation {
    NSBezierPath *result = [[[NSBezierPath alloc] init] autorelease];
    [result appendBezierPathWithTriangleInRect:aRect orientation:orientation];
    return result;
}

- (void)appendBezierPathWithTriangleInRect:(NSRect)aRect orientation:(AZCompass)orientation {
    NSPoint a, b, c;
    switch (orientation) {
        case AZCompassN: {
            a = NSMakePoint(NSMinX(aRect), NSMinY(aRect));
            b = NSMakePoint((NSMinX(aRect) + NSMaxX(aRect)) / 2, NSMaxY(aRect));
            c = NSMakePoint(NSMaxX(aRect), NSMinY(aRect));
            break;
        }

        case AZCompassS: {
            a = NSMakePoint(NSMinX(aRect), NSMaxY(aRect));
            c = NSMakePoint(NSMaxX(aRect), NSMaxY(aRect));
            b = NSMakePoint((NSMinX(aRect) + NSMaxX(aRect)) / 2, NSMinY(aRect));
            break;
        }

        case AZCompassW: {
            a = NSMakePoint(NSMaxX(aRect), NSMaxY(aRect));
            b = NSMakePoint(NSMaxX(aRect), NSMinY(aRect));
            c = NSMakePoint(NSMinX(aRect), (NSMinY(aRect) + NSMaxY(aRect)) / 2);
            break;
        }

        default:          // case AZCompassE:
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

- (void)drawWithFill:(NSColor *)fill andStroke:(NSColor *)stroke {
    [fill setFill];
    [self fill];
    [stroke setStroke];
    [self stroke];
}

- (void)fillGradientFrom:(NSColor *)start to:(NSColor *)end angle:(float)angle {
    [[NSG.alloc initWithStartingColor:start endingColor:end] drawInBezierPath:self angle:angle];
    /*

       CIImage*	coreimage;
       inStartColor = [inStartColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
       inEndColor    = [inEndColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];

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

       [AZGRAPHICSCTX saveGraphicsState];

       CIContext* context;

       context = [AZGRAPHICSCTX CIContext];

       [self setClip];

       [context drawImage:coreimage atPoint:CGPointZero fromRect:CGRectMake( 0.0, 0.0, [self bounds].size.width + 100.0, [self bounds].size.height + 100.0 )];

       [AZGRAPHICSCTX restoreGraphicsState];
     */
}

+ (NSBezierPath *)bezierPathWithLeftRoundedRect:(NSRect)rect radius:(CGFloat)radius {
    // Make sure radius doesn't exceed a maximum size to avoid artifacts:
    radius = fmin(radius, fmin(0.5f * NSHeight(rect), NSWidth(rect)));

    // Make sure silly values simply lead to un-rounded corners:
    if (radius <= 0) return [self bezierPathWithRect:rect];

    NSRect ignored, innerRect;
    NSDivideRect(NSInsetRect(rect, 0.0, radius), &ignored, &innerRect, radius, NSMinXEdge);     // Make rect with corners being centers of the corner circles.
    NSBezierPath *path = [self bezierPath];

    // Now draw our rectangle:
    [path moveToPoint:NSMakePoint(NSMaxX(rect), NSMinY(rect))];

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

+ (NSBezierPath *)bezierPathWithRightRoundedRect:(NSRect)rect radius:(CGFloat)radius {
    // Make sure radius doesn't exceed a maximum size to avoid artifacts:
    radius = fmin(radius, fmin(0.5f * NSHeight(rect), NSWidth(rect)));

    // Make sure silly values simply lead to un-rounded corners:
    if (radius <= 0) return [self bezierPathWithRect:rect];

    NSRect ignored, innerRect;
    NSDivideRect(NSInsetRect(rect, 0.0, radius), &ignored, &innerRect, radius, NSMaxXEdge);     // Make rect with corners being centers of the corner circles.
    NSBezierPath *path = [self bezierPath];

    // Now draw our rectangle:
    [path moveToPoint:NSMakePoint(NSMinX(rect), NSMaxY(rect))];

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

- (NSA*) dashPattern {
    NSInteger i, count = 0;
    NSMutableArray *array = [NSMutableArray array];
    [self getLineDash:NULL count:&count phase:NULL];
    if (count > 0) {
        CGFloat pattern[count];
        [self getLineDash:pattern count:&count phase:NULL];
        for (i = 0; i < count; i++) {
            [array addObject:@(pattern[i])];
        }
    }
    return array;
}

- (void)setDashPattern:(NSA*) newPattern {
    NSI i, count = [newPattern count];
    CGF pattern[count];
    for (i = 0; i < count; i++) {
        pattern[i] = [newPattern[i] doubleValue];
    }
    [self setLineDash:pattern count:count phase:0];
}

- (NSPoint)associatedPointForElementAtIndex:(NSUInteger)anIndex {
    NSPoint points[3];
    if (NSCurveToBezierPathElement == [self elementAtIndex:anIndex associatedPoints:points]) return points[2];
    else return points[0];
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

+ (NSBezierPath *)bezierPathWithRoundedRect:(NSRect)aRect cornerRadius:(CGFloat)radius inCorners:(OSCornerType)corners {
    NSBezierPath *path = [self bezierPath];
    radius = MIN(radius, 0.5f * MIN(NSWidth(aRect), NSHeight(aRect)));
    NSRect rect = NSInsetRect(aRect, radius, radius);

    if (corners & OSBottomLeftCorner) {
        [path appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(rect), NSMinY(rect)) radius:radius startAngle:180.0 endAngle:270.0];
    } else {
        NSPoint cornerPoint = NSMakePoint(NSMinX(aRect), NSMinY(aRect));
        [path appendBezierPathWithPoints:&cornerPoint count:1];
    }

    if (corners & OSBottomRightCorner) {
        [path appendBezierPathWithArcWithCenter:NSMakePoint(NSMaxX(rect), NSMinY(rect)) radius:radius startAngle:270.0 endAngle:360.0];
    } else {
        NSPoint cornerPoint = NSMakePoint(NSMaxX(aRect), NSMinY(aRect));
        [path appendBezierPathWithPoints:&cornerPoint count:1];
    }

    if (corners & OSTopRightCorner) {
        [path appendBezierPathWithArcWithCenter:NSMakePoint(NSMaxX(rect), NSMaxY(rect)) radius:radius startAngle:0.0 endAngle:90.0];
    } else {
        NSPoint cornerPoint = NSMakePoint(NSMaxX(aRect), NSMaxY(aRect));
        [path appendBezierPathWithPoints:&cornerPoint count:1];
    }

    if (corners & OSTopLeftCorner) {
        [path appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(rect), NSMaxY(rect)) radius:radius startAngle:90.0 endAngle:180.0];
    } else {
        NSPoint cornerPoint = NSMakePoint(NSMinX(aRect), NSMaxY(aRect));
        [path appendBezierPathWithPoints:&cornerPoint count:1];
    }

    [path closePath];
    return path;
}

+ (NSBezierPath *)bezierPathWithRoundedRect:(NSRect)aRect cornerRadius:(CGFloat)radius {
    return [NSBezierPath bezierPathWithRoundedRect:aRect cornerRadius:radius inCorners:OSTopLeftCorner | OSTopRightCorner | OSBottomLeftCorner | OSBottomRightCorner];
}

// This method works only in OS X v10.2 and later.
- (CGPathRef)quartzPath {
    int i, numElements;

    // Need to begin a path here.
    CGPathRef immutablePath = NULL;

    // Then draw the path elements.
    numElements = [self elementCount];
    if (numElements > 0) {
        CGMutablePathRef path = CGPathCreateMutable();
        NSPoint points[3];
        BOOL didClosePath = YES;

        for (i = 0; i < numElements; i++) {
            switch ([self elementAtIndex:i associatedPoints:points]) {
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
        if (!didClosePath) CGPathCloseSubpath(path);

        immutablePath = CGPathCreateCopy(path);
//		CGPathRelease(path);
    }

    return CGPathCreateCopy(immutablePath);    // immutablePath;
}

//	return [self newQuartzPath];
/*	// Need to begin a path here.
   __block CGPathRef		   immutablePath = NULL;

   __block CGMutablePathRef	path = CGPathCreateMutable();
   __block BOOL				didClosePath = YES;

   // Then draw the path elements.
   NSI numElements = [self elementCount];
   if (numElements > 0)
   {
   [[NSA from:0 to:numElements-1] eachWithIndex:^(id obj, NSInteger idx) {

   CGP pnts[3], *pPtr;
   pPtr = pnts;

   NSBezierPathElement e = [self elementAtIndex:idx associatedPoints:pnts];
   e == NSMoveToBezierPathElement	?       CGPathMoveToPoint(		path, NULL, pnts[0].x, pnts[0].y)       :
   e == NSLineToBezierPathElement	? ^{	CGPathAddLineToPoint(	path, NULL, pPtr[0].x, pPtr[0].y);
   didClosePath = NO;                                           }() :
   e == NSCurveToBezierPathElement	? ^{	CGPathAddCurveToPoint(path, NULL, pPtr[0].x, pPtr[0].y,
   pPtr[1].x, pPtr[1].y,
   pPtr[2].x, pPtr[2].y);
   didClosePath = NO;											}()	:

   e == NSClosePathBezierPathElement ? ^{	CGPathCloseSubpath(path); didClosePath = YES;				}() : nil;
   // Be sure the path is closed or Quartz may not do valid hit detection.
   didClosePath ?: CGPathCloseSubpath(path);
   }];
   }
   return CGPathCreateCopy(path);
 */


#define MCBEZIER_USE_PRIVATE_FUNCTION

#ifdef MCBEZIER_USE_PRIVATE_FUNCTION
extern CGPathRef CGContextCopyPath(CGContextRef context);
#endif

static void CGPathCallback(void *info, const CGPathElement *element) {
    NSBezierPath *path = (__bridge NSBezierPath *)info;
    CGPoint *points = element->points;

    switch (element->type) {
        case kCGPathElementMoveToPoint: {
            [path moveToPoint:NSMakePoint(points[0].x, points[0].y)];
            break;
        }
        case kCGPathElementAddLineToPoint: {
            [path lineToPoint:NSMakePoint(points[0].x, points[0].y)];
            break;
        }
        case kCGPathElementAddQuadCurveToPoint: {
            // NOTE: This is untested.
            NSPoint currentPoint = [path currentPoint];
            NSPoint interpolatedPoint = NSMakePoint((currentPoint.x + 2 * points[0].x) / 3, (currentPoint.y + 2 * points[0].y) / 3);
            [path curveToPoint:NSMakePoint(points[1].x, points[1].y) controlPoint1:interpolatedPoint controlPoint2:interpolatedPoint];
            break;
        }
        case kCGPathElementAddCurveToPoint: {
            [path curveToPoint:NSMakePoint(points[2].x, points[2].y) controlPoint1:NSMakePoint(points[0].x, points[0].y) controlPoint2:NSMakePoint(points[1].x, points[1].y)];
            break;
        }
        case kCGPathElementCloseSubpath: {
            [path closePath];
            break;
        }
    }
}

//+ (NSBezierPath *)bezierPathWithCGPath:(CGPathRef)pathRef {
//    NSBezierPath *path = [NSBezierPath bezierPath];
//    CGPathApply(pathRef, (__bridge void *)path, CGPathCallback);
//
//    return path;
//}

// Method borrowed from Google's Cocoa additions
- (CGPathRef)cgPath {
		// Borrowed from http://bit.ly/150i1lL

//	- (CGPathRef) CGPath {
		NSInteger i, numElements;

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

			// Auto-destroy path after a cycle of the run loop

		double delayInSeconds = 0.0;
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
			CGPathRelease(immutablePath);
		});

		return immutablePath;
	}
	
    /*	CGMutablePathRef thePath = CGPathCreateMutable();
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
     */


- (NSBP *)stroked:(CGF)strokeWidth {
    return [self pathWithStrokeWidth:strokeWidth];
}

- (NSBezierPath *)pathWithStrokeWidth:(CGFloat)strokeWidth {
    [self setLineWidth:strokeWidth];
    return self;
/*
   #ifdef MCBEZIER_USE_PRIVATE_FUNCTION
        NSBezierPath *path = [self copy];
        CGContextRef context = [AZGRAPHICSCTX graphicsPort];
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
 */
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
    [transform translateXBy:0 yBy:([AZGRAPHICSCTX isFlipped] ? 1 : -1) * bounds.size.height];

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

- (void)fillWithColor:(NSC *)color {
    [color set];
    [self fill];
}

- (void)strokeWithColor:(NSC *)color andWidth:(CGF)width inside:(NSR)frame {
    [self setLineWidth:width];
    [color setStroke];
    [self strokeInsideWithinRect:frame];
}

- (void)strokeWithColor:(NSC *)color andWidth:(CGF)width {
    [self setLineWidth:width];
    [self strokeWithColor:color];
}

- (void)strokeWithColor:(NSC *)color {
    [color set];
    [self stroke];
}

- (void)fillWithInnerShadow:(NSShadow *)shadow {
    [NSGraphicsContext state:^{     NSSize offset, originalOffset;
                                    originalOffset = offset = shadow.shadowOffset;
                                    CGF rad = shadow.shadowBlurRadius;
                                    NSR bounds = NSInsetRect(self.bounds, -(ABS(offset.width) + rad), -(ABS(offset.height) + rad));
                                    offset.height += bounds.size.height;
                                    shadow.shadowOffset = offset;
                                    NSAffineTransform *transform = [NSAT transform];
                                    [AZCURRENTCTX isFlipped] ? [transform translateXBy:0 yBy:bounds.size.height]
                                    : [transform translateXBy:0 yBy:-bounds.size.height];
                                    NSBP *drawingPath = [NSBP bezierPathWithRect:bounds];
                                    [drawingPath setWindingRule:NSEvenOddWindingRule];
                                    [drawingPath appendBezierPath:self];
                                    [drawingPath transformUsingAffineTransform:transform];
                                    [self addClip];                                 [shadow set];
                                    [[NSColor blackColor] set];             [drawingPath fill];
                                    shadow.shadowOffset = originalOffset; }];
}

- (void)drawBlurWithColor:(NSColor *)color radius:(CGFloat)radius {
    NSRect bounds = NSInsetRect(self.bounds, -radius, -radius);
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = NSMakeSize(0, bounds.size.height);
    shadow.shadowBlurRadius = radius;
    shadow.shadowColor = color;
    NSBezierPath *path = [self copy];
    NSAffineTransform *transform = [NSAffineTransform transform];
    if ([AZGRAPHICSCTX isFlipped]) [transform translateXBy:0 yBy:bounds.size.height];
    else [transform translateXBy:0 yBy:-bounds.size.height];
    [path transformUsingAffineTransform:transform];

    [NSGraphicsContext saveGraphicsState];

    [shadow set];
    [[NSColor blackColor] set];
    NSRectClip(bounds);
    [path fill];

    [NSGraphicsContext restoreGraphicsState];
}

// Credit for the next two methods goes to Matt Gemmell
- (void)strokeInside {
    /* Stroke within path using no additional clipping rectangle. */
    [self strokeInsideWithinRect:NSZeroRect];
}

- (void)strokeInsideWithinRect:(NSRect)clipRect {
    //	NSGraphicsContext *thisContext = AZGRAPHICSCTX;
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

+ (NSBezierPath *)bezierPathWithCappedBoxInRect:(NSRect)rect {
    NSBezierPath *bezierPath = [NSBezierPath bezierPath];
    float cornerSize = rect.size.height / 2;
    // Corners:
    NSPoint leftTop         = NSMakePoint(NSMinX(rect) + cornerSize, NSMaxY(rect));
    NSPoint rightTop        = NSMakePoint(NSMaxX(rect) - cornerSize, NSMaxY(rect));
    NSPoint rightBottom = NSMakePoint(NSMaxX(rect) - cornerSize, NSMinY(rect));
    NSPoint leftBottom      = NSMakePoint(NSMinX(rect) + cornerSize, NSMinY(rect));
    // Create our capped box:
    // Top edge:
    [bezierPath moveToPoint:leftTop];
    [bezierPath lineToPoint:rightTop];
    // Right cap:
    [bezierPath appendBezierPathWithArcWithCenter:NSMakePoint(rightTop.x, (NSMaxY(rect) + NSMinY(rect)) / 2)
                                           radius:cornerSize startAngle:90 endAngle:-90 clockwise:YES];
    // Bottom edge:
    [bezierPath lineToPoint:rightBottom];
    [bezierPath lineToPoint:leftBottom];
    // Left cap:
    [bezierPath appendBezierPathWithArcWithCenter:NSMakePoint(leftTop.x, (NSMaxY(rect) + NSMinY(rect)) / 2)
                                           radius:cornerSize startAngle:-90 endAngle:90 clockwise:YES];
    [bezierPath closePath];     // Just to be safe.
    return bezierPath;
}

#pragma mark Rounded rectangles

+ (NSBezierPath *)bezierPathRoundedRectOfSize:(NSSize)backgroundSize {
    NSRect pathRect = NSMakeRect(0, 0, backgroundSize.width, backgroundSize.height);

    return [self bezierPathWithRoundedRect:pathRect];
}

+ (NSBezierPath *)bezierPathWithRoundedRect:(NSRect)bounds {
    return [self bezierPathWithRoundedRect:bounds radius:MIN(bounds.size.width, bounds.size.height) / 2.0f];
}

+ (NSBezierPath *)bezierPathWithRoundedRect:(NSRect)rect radius:(CGFloat)radius {
    return [NSBezierPath bezierPathWithRoundedRect:rect xRadius:radius yRadius:radius];
}

+ (NSBezierPath *)bezierPathWithRoundedTopCorners:(NSRect)rect radius:(CGFloat)radius {
    NSBezierPath *path = [NSBezierPath bezierPath];
    NSPoint topLeft, topRight, bottomLeft, bottomRight;

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

+ (NSBezierPath *)bezierPathWithRoundedBottomCorners:(NSRect)rect radius:(CGFloat)radius {
    NSBezierPath *path = [NSBezierPath bezierPath];
    NSPoint topLeft, topRight, bottomLeft, bottomRight;

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
     * /   \	1-7 = points
     * 6-7 3-4   the point of the triangle is 100% from the bottom.
     *	|	 the back edge of the triangle is 50% * shaftLengthMulti from the bottom.
     *  1-2
     */

    const CGFloat shaftLength = ONE_HALF * shaftLengthMulti;
    const CGFloat shaftEndY = -(shaftLength - ONE_HALF);     //the end of the arrow shaft (points 1-2).
    //wing width = the distance between 6 and 7 and 3 and 4.
    const CGFloat wingWidth = (1.0f - shaftWidth) * 0.5f;

    //start with the bottom vertex.
    [arrowPath moveToPoint:NSMakePoint(wingWidth,  shaftEndY)];     //1
    [arrowPath relativeLineToPoint:NSMakePoint(shaftWidth, 0.0f)];     //2
    //up to the inner right corner.
    [arrowPath relativeLineToPoint:NSMakePoint(0.0f, shaftLength)];     //3
    //far right.
    [arrowPath relativeLineToPoint:NSMakePoint(wingWidth,  0.0f)];     //4
    //top center - the point of the arrow.
    [arrowPath lineToPoint:NSMakePoint(ONE_HALF,  1.0f)];     //5
    //far left.
    [arrowPath lineToPoint:NSMakePoint(0.0f,  ONE_HALF)];     //6
    //inner left corner.
    [arrowPath relativeLineToPoint:NSMakePoint(wingWidth,  0.0f)];     //7
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
    [transform translateXBy:1.0f yBy:0.0f];
    [transform scaleXBy:-1.0f yBy:1.0f];

    [self transformUsingAffineTransform:transform];
    return self;
}

- (NSBezierPath *)flipVertically {
    NSAffineTransform *transform = [NSAffineTransform transform];

    //http://developer.apple.com/documentation/Carbon/Conceptual/QuickDrawToQuartz2D/tq_other/chapter_3_section_2.html
    [transform translateXBy:0.0f yBy:1.0f];
    [transform scaleXBy:1.0f yBy:-1.0f];

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
    return [(NSBezierPath *)[[self copy] autorelease] flipHorizontally];
}

- (NSBezierPath *)bezierPathByFlippingVertically {
    return [(NSBezierPath *)[[self copy] autorelease] flipVertically];
}

- (NSBezierPath *)bezierPathByScalingToSize:(NSSize)newSize {
    return [[[self copy] autorelease] scaleToSize:newSize];
}

@end
#define POINTSIZE          5.0
#define HANDLESIZE         3.0
#define HANDLELINEWIDTH    1.5
#define DEFAULTPOINTCOLOR  [NSColor redColor]
#define DEFAULTHANDLECOLOR [NSColor greenColor]
@implementation NSBezierPath (ESPoints)

#pragma mark MAIN CONVENIENCE METHODS
- (void)drawPointsAndHandles {
    [self drawPointsInColor:DEFAULTPOINTCOLOR withHandlesInColor:DEFAULTHANDLECOLOR];
}

- (void)drawPointsInColor:(NSColor *)pointColor withHandlesInColor:(NSColor *)handleColor {
    NSPoint previousPoint = NSMakePoint(0.0, 0.0);
    for (NSInteger i = 0; i < [self elementCount]; i++) {
        previousPoint = [self drawPathElement:i withPreviousPoint:previousPoint inColor:pointColor withHandlesInColor:handleColor];
    }
}

#pragma mark DRAWING POINTS

- (void)drawPoint:(NSPoint)pt {
    [self drawPoint:pt inColor:DEFAULTPOINTCOLOR];
}

- (void)drawPoint:(NSPoint)pt inColor:(NSColor *)pointColor {
    NSBezierPath *bp = [NSBezierPath bezierPathWithRect:NSMakeRect(pt.x - POINTSIZE * 0.5, pt.y - POINTSIZE * 0.5, POINTSIZE, POINTSIZE)];
    [pointColor set];
    [bp fill];
}

- (void)drawHandlePoint:(NSPoint)pt {
    [self drawHandlePoint:pt inColor:DEFAULTHANDLECOLOR];
}

- (void)drawHandlePoint:(NSPoint)pt inColor:(NSColor *)pointColor {
    NSBezierPath *bp = [NSBezierPath bezierPathWithRect:NSMakeRect(pt.x - HANDLESIZE * 0.5, pt.y - HANDLESIZE * 0.5, HANDLESIZE, HANDLESIZE)];
    [pointColor set];
    [bp fill];
}

#pragma mark DRAWING PATH ELEMENTS

- (NSPoint)drawPathElement:(int)n withPreviousPoint:(NSPoint)previous {
    return [self drawPathElement:n withPreviousPoint:previous inColor:DEFAULTPOINTCOLOR withHandlesInColor:DEFAULTHANDLECOLOR];
}

- (NSPoint)drawPathElement:(int)n withPreviousPoint:(NSPoint)previous inColor:(NSColor *)pointColor withHandlesInColor:(NSColor *)handleColor {
    NSPoint previousPoint;
    NSPoint points[3];
    NSBezierPathElement element = [self elementAtIndex:n associatedPoints:points];
    NSBezierPath *bp;
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

            [self drawHandlePoint:points[0] inColor:handleColor];
            [self drawHandlePoint:points[1] inColor:handleColor];
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

@implementation NSBezierPath (RoundRects)

+ (void)fillRoundRectInRect:(NSR)rect radius:(CGFloat)radius {
    NSBezierPath *p = [self bezierPathWithRoundRectInRect:rect radius:radius];
    [p fill];
}

+ (void)strokeRoundRectInRect:(NSR)rect radius:(CGFloat)radius {
    NSBezierPath *p = [self bezierPathWithRoundRectInRect:rect radius:radius];
    [p stroke];
}

// -----------------------------------------------------------------------------
//		bezierPathWithRoundRectInRect:radius:
//				  This method adds the traditional Macintosh rounded-rectangle to
//				  NSBezierPath's repertoire.
//
//		REVISIONS:
//				  2004-02-04		witness Created.
// -----------------------------------------------------------------------------

+ (NSBezierPath *)bezierPathWithRoundRectInRect:(NSR)rect radius:(CGFloat)radius {
    // Make sure radius doesn't exceed a maximum size to avoid artifacts:
    if (radius >= (rect.size.height / 2) ) radius = truncf(rect.size.height / 2) - 1;
    if (radius >= (rect.size.width / 2) ) radius = truncf(rect.size.width / 2) - 1;

    // Make sure silly values simply lead to un-rounded corners:
    if (radius <= 0) return [self bezierPathWithRect:rect];

    // Now draw our rectangle:
    NSR innerRect = NSInsetRect(rect, radius, radius);                                                                    // Make rect with corners being centers of the corner circles.
    NSBezierPath *path = [self bezierPath];

    [path moveToPoint:NSMakePoint(rect.origin.x, rect.origin.y + radius)];

    // Bottom left (origin):
    [path appendBezierPathWithArcWithCenter:UKBottomLeftOfRect(innerRect)
                                     radius:radius startAngle:180.0 endAngle:270.0 ];
    [path relativeLineToPoint:NSMakePoint(NSWidth(innerRect), 0.0) ];                                    // Bottom edge.

    // Bottom right:
    [path appendBezierPathWithArcWithCenter:UKBottomRightOfRect(innerRect)
                                     radius:radius startAngle:270.0 endAngle:360.0 ];
    [path relativeLineToPoint:NSMakePoint(0.0, NSHeight(innerRect)) ];                                   // Right edge.

    // Top right:
    [path appendBezierPathWithArcWithCenter:UKTopRightOfRect(innerRect)
                                     radius:radius startAngle:0.0  endAngle:90.0 ];
    [path relativeLineToPoint:NSMakePoint(-NSWidth(innerRect), 0.0) ];           // Top edge.

    // Top left:
    [path appendBezierPathWithArcWithCenter:UKTopLeftOfRect(innerRect)
                                     radius:radius startAngle:90.0  endAngle:180.0 ];

    [path closePath];           // Implicitly causes left edge.

    return path;
}

NSP  UKCenterOfRect(NSR rect) {
    return NSMakePoint(NSMidX(rect), NSMidY(rect) );
}

NSP  UKTopCenterOfRect(NSR rect) {
    return NSMakePoint(NSMidX(rect), NSMaxY(rect) );
}

NSP  UKTopLeftOfRect(NSR rect) {
    return NSMakePoint(NSMinX(rect), NSMaxY(rect) );
}

NSP  UKTopRightOfRect(NSR rect) {
    return NSMakePoint(NSMaxX(rect), NSMaxY(rect) );
}

NSP  UKLeftCenterOfRect(NSR rect) {
    return NSMakePoint(NSMinX(rect), NSMidY(rect) );
}

NSP  UKBottomCenterOfRect(NSR rect) {
    return NSMakePoint(NSMidX(rect), NSMinY(rect) );
}

NSP  UKBottomLeftOfRect(NSR rect) {
    return rect.origin;
}

NSP  UKBottomRightOfRect(NSR rect) {
    return NSMakePoint(NSMaxX(rect), NSMinY(rect) );
}

NSP  UKRightCenterOfRect(NSR rect) {
    return NSMakePoint(NSMaxX(rect), NSMidY(rect) );
}

@end


// CoreGraphics gradient helpers
typedef struct {
  CGFloat red1, green1, blue1, alpha1;
  CGFloat red2, green2, blue2, alpha2;
} _twoColorsType;

void _linearColorBlendFunction(void *info, const CGFloat *in, CGFloat *out);
void _linearColorBlendFunction(void *info, const CGFloat *in, CGFloat *out) {
  _twoColorsType *twoColors = info;
  out[0] = (1.0 - *in) * twoColors->red1 + *in * twoColors->red2;
  out[1] = (1.0 - *in) * twoColors->green1 + *in * twoColors->green2;
  out[2] = (1.0 - *in) * twoColors->blue1 + *in * twoColors->blue2;
  out[3] = (1.0 - *in) * twoColors->alpha1 + *in * twoColors->alpha2;
}

void _linearColorReleaseInfoFunction(void *info);
void _linearColorReleaseInfoFunction(void *info) {
  free(info);
}

static const CGFunctionCallbacks linearFunctionCallbacks = {0, &_linearColorBlendFunction, &_linearColorReleaseInfoFunction};
static const CGFloat domainAndRange[8] = {0.0, 1.0, 0.0, 1.0, 0.0, 1.0, 0.0, 1.0};

@implementation NSBezierPath(RoundedRectangle)
+ (NSBezierPath*)bezierPathWithRoundedRect:(NSRect)aRect radius:(float)radius {
   NSBezierPath* path = [self bezierPath];
   //radius = MIN(radius, 0.5f * MIN(NSWidth(aRect), NSHeight(aRect)));
   NSRect rect = NSInsetRect(aRect, radius, radius);
   [path appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(rect), NSMinY(rect)) radius:radius startAngle:180.0 endAngle:270.0];
   [path appendBezierPathWithArcWithCenter:NSMakePoint(NSMaxX(rect), NSMinY(rect)) radius:radius startAngle:270.0 endAngle:360.0];
   [path appendBezierPathWithArcWithCenter:NSMakePoint(NSMaxX(rect), NSMaxY(rect)) radius:radius startAngle:  0.0 endAngle: 90.0];
   [path appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(rect), NSMaxY(rect)) radius:radius startAngle: 90.0 endAngle:180.0];
   [path closePath];
   return path;
}

+ (NSBezierPath*)bezierPathWithTopRoundedRect:(NSRect)aRect radius:(float)radius {
   NSBezierPath* path = [self bezierPath];
   //radius = MIN(radius, 0.5f * MIN(NSWidth(aRect), NSHeight(aRect)));
   NSRect rect = NSInsetRect(aRect, radius, radius);
   [path moveToPoint:NSMakePoint(NSMinX(aRect) , NSMinY(aRect))];
   [path lineToPoint:NSMakePoint(NSMaxX(aRect) , NSMinY(aRect) )];
   [path appendBezierPathWithArcWithCenter:NSMakePoint(NSMaxX(rect), NSMaxY(rect)) radius:radius startAngle:  0.0 endAngle: 90.0];
   [path appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(rect), NSMaxY(rect)) radius:radius startAngle: 90.0 endAngle:180.0];
   [path closePath];
   return path;
}

+ (NSBezierPath*)bezierPathWithBottomRoundedRect:(NSRect)aRect radius:(float)radius {
   NSBezierPath* path = [self bezierPath];
   //radius = MIN(radius, 0.5f * MIN(NSWidth(aRect), NSHeight(aRect)));
   NSRect rect = NSInsetRect(aRect, radius, radius);
   [path appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(rect), NSMinY(rect)) radius:radius startAngle:180.0 endAngle:270.0];
   [path appendBezierPathWithArcWithCenter:NSMakePoint(NSMaxX(rect), NSMinY(rect)) radius:radius startAngle:270.0 endAngle:360.0];
   [path lineToPoint:NSMakePoint(NSMaxX(aRect), NSMaxY(aRect))];
   [path lineToPoint:NSMakePoint(NSMinX(aRect), NSMaxY(aRect))];
   [path closePath];
   return path;
}

- (void)gradientFillWithColor:(NSColor*)color {
	// Take the color apart
	CGFloat hue, saturation, brightness, alpha;
	[[color colorUsingColorSpaceName:NSDeviceRGBColorSpace] getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
	// Create synthetic darker and lighter versions
	NSColor *lighterColor = [NSColor colorWithDeviceHue:hue saturation:MAX(0.0, saturation-.12) brightness:MIN(1.0,brightness+0.30) alpha:alpha];
	NSColor *darkerColor = [NSColor colorWithDeviceHue:hue saturation:MIN(1.0, (saturation > .04) ? saturation+0.12 : 0.0) brightness:MAX(0.0, brightness-0.045) alpha:alpha];
	
	//lighterColor = [[color blendedColorWithFraction:0.7 ofColor:[NSColor whiteColor]] colorUsingColorSpaceName:NSDeviceRGBColorSpace];		
	//darkerColor = [[color blendedColorWithFraction:0.15 ofColor:[NSColor blackColor]] colorUsingColorSpaceName:NSDeviceRGBColorSpace];		
		
	// Set up the helper function for drawing washes
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	_twoColorsType *twoColors = malloc(sizeof(_twoColorsType)); 
	[lighterColor getRed:&twoColors->red1 green:&twoColors->green1 blue:&twoColors->blue1 alpha:&twoColors->alpha1];
	[darkerColor getRed:&twoColors->red2 green:&twoColors->green2 blue:&twoColors->blue2 alpha:&twoColors->alpha2];
	CGFunctionRef linearBlendFunctionRef = CGFunctionCreate(twoColors, 1, domainAndRange, 4, domainAndRange, &linearFunctionCallbacks);  
	NSRect bounds = [self bounds];
	CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
	CGContextSaveGState(context); 
	[self addClip];
	{	CGShadingRef cgShading = CGShadingCreateAxial(colorSpace,CGPointMake(0, NSMaxY(bounds)), CGPointMake(0, NSMinY(bounds)), linearBlendFunctionRef, NO, NO);
		CGContextDrawShading(context, cgShading);
		CGShadingRelease(cgShading);
	} 
	CGContextRestoreGState(context);
	CGFunctionRelease(linearBlendFunctionRef);
	CGColorSpaceRelease(colorSpace);	
}
@end


