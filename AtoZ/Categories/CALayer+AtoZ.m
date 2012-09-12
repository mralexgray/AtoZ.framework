
//  CALayer+AtoZ.m
//  AtoZ

//  Created by Alex Gray on 7/13/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.


#import "CALayer+AtoZ.h"
#import "AtoZ.h"

/*
struct CATransform3D
{
	CGFloat m11, m12, m13, m14;
	CGFloat m21, m22, m23, m24;
	CGFloat m31, m32, m33, m34;
	CGFloat m41, m42, m43, m44;
};
typedef struct CATransform3D CATransform3D;

@property CATransform3D transform;
@property CATransform3D sublayerTransform;
@property CGPoint anchorPoint;
@property CGFloat anchorPointZ;

//	CATransform3D Matrix Operations

CATransform3D CATransform3DMakeTranslation ( CGFloat tx, 		CGFloat ty, 	CGFloat tz		);
CATransform3D CATransform3DMakeScale (		CGFloat sx, 		 	CGFloat sy,		CGFloat sz		);
CATransform3D CATransform3DMakeRotation (	CGFloat angle, 	 	CGFloat x,  	CGFloat y, 		CGFloat z		);
CATransform3D CATransform3DTranslate (		CATransform3D t, 	CGFloat tx, 	CGFloat ty, 	CGFloat tz		);
CATransform3D CATransform3DScale (			CATransform3D t, 	CGFloat sx, 	CGFloat sy, 	CGFloat sz		);
CATransform3D CATransform3DRotate (			CATransform3D t, 	CGFloat angle,	CGFloat x,		CGFloat y,		CGFloat z	);
CATransform3D CATransform3DConcat (			CATransform3D a, 	CATransform3D b	);
CATransform3D CATransform3DInvert (			CATransform3D t		);

//Scale the layer along the x-axis
	 [layer setValue:[NSNumber numberWithFloat:1.5] forKeyPath:@"transform.scale.x"];
//Same result as above
	CGSize biggerX = CGSizeMake(1.5, 1.);
	[layer setValue:[NSValue valueWithCGSize:biggerX] forKeyPath:@"transform.scale"];
*/

/*
 File: QuartzUtils.m
 Abstract: Assorted CoreGraphics / Core Animation utility functions.
 */

void prepareContext(CGContextRef ctx) {
	NSGraphicsContext *nsGraphicsContext = [NSGraphicsContext graphicsContextWithGraphicsPort:ctx flipped:NO];
	[NSGraphicsContext saveGraphicsState]; [NSGraphicsContext setCurrentContext:nsGraphicsContext];
}


void applyPerspective (CALayer* layer) {
	CATransform3D perspectiveTransform = CATransform3DIdentity;
	perspectiveTransform.m34 = 1.0 / -850;
	layer.sublayerTransform = perspectiveTransform;
}


//CGColorRef kBlackColor, kWhiteColor,
//kTranslucentGrayColor, kTranslucentLightGrayColor,
//kAlmostInvisibleWhiteColor,
//kHighlightColor, kRedColor, kLightBlueColor;

static CGColorRef CreateDeviceGrayColor(CGFloat w, CGFloat a)
{
    CGColorSpaceRef gray = CGColorSpaceCreateDeviceGray();
    CGFloat comps[] = {w, a};
    CGColorRef color = CGColorCreate(gray, comps);
    CGColorSpaceRelease(gray);
    return color;
}

static CGColorRef CreateDeviceRGBColor(CGFloat r, CGFloat g, CGFloat b, CGFloat a)
{
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGFloat comps[] = {r, g, b, a};
    CGColorRef color = CGColorCreate(rgb, comps);
    CGColorSpaceRelease(rgb);
    return color;
}

//__attribute__((constructor))        // Makes this function run when the app loads
//static void InitQuartzUtils()
//{
// }


void ChangeSuperlayer( CALayer *layer, CALayer *newSuperlayer, int index )
{
    // Disable actions, else the layer will move to the wrong place and then back!
    [CATransaction flush];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue
                     forKey:kCATransactionDisableActions];

    CGPoint pos = [newSuperlayer convertPoint: layer.position
									fromLayer: layer.superlayer];
    [layer removeFromSuperlayer];
    if( index >= 0 )
        [newSuperlayer insertSublayer: layer atIndex: index];
    else
        [newSuperlayer addSublayer: layer];
    layer.position = pos;

    [CATransaction commit];
}


void RemoveImmediately( CALayer *layer )
{
    [CATransaction flush];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue
                     forKey:kCATransactionDisableActions];
    [layer removeFromSuperlayer];
    [CATransaction commit];
}


CALayer* AddBloom( CALayer *layer) {
	// create the filter and set its default values
	CIFilter *filter = [CIFilter filterWithName:@"CIBloom"];
	[filter setDefaults];
	[filter setValue:@(5.0) forKey:@"inputRadius"];
	// name the filter so we can use the keypath to animate the inputIntensity attribute of the filter
	[filter setName:@"pulseFilter"];
	// set the filter to the selection layer's filters
	layer.filters  = layer.filters  ? [NSArray arrayWithArrays:@[layer.filters,@[filter]]]
									: @[filter];
	return layer;
}
CALayer* AddShadow( CALayer *layer) {
	layer.shadowOffset 		= (CGSize){ 0, 3 };
	layer.shadowRadius 		= 5.0;
	layer.shadowColor	 	= cgBLACK;
	layer.shadowOpacity 	= 0.8;
	return layer;
}

CALayer* ReturnLayer( CALayer *superlayer){

    CALayer *layer 			= [[CALayer alloc] init];
    layer.backgroundColor 	= cgRANDOMCOLOR;
	layer.bounds			= AZMakeRectFromSize(superlayer.frame.size);
	layer.position		  	= AZCenterOfRect(superlayer.frame);
	layer.frame				= AZMakeRectFromSize(nanSizeCheck([superlayer frame].size));
	layer.contentsGravity  	= kCAGravityResizeAspect;
	layer.autoresizingMask 	= kCALayerWidthSizable| kCALayerHeightSizable;
	return layer;
}

CALayer* AddLayer( CALayer *superlayer)
{
	CALayer *layer = ReturnLayer(superlayer);
	layer.delegate 	= superlayer;
	[superlayer addSublayer:layer];
	return layer;
}

CATextLayer* AddTextLayer( CALayer *superlayer,	NSString *text, NSFont* font,	enum CAAutoresizingMask align )
{
    CATextLayer *label 	  = [[CATextLayer alloc] init];
    label.foregroundColor = kBlackColor;
    label.string 		= text;
    label.font 			= (__bridge CGFontRef)font;
    label.fontSize 		= font.pointSize;
    NSString *mode	 	= align & kCALayerWidthSizable 	? @"center"
				   		: align & kCALayerMinXMargin 	? @"right"		: @"left";
						  align |= kCALayerWidthSizable;
	label.alignmentMode = mode;
    CGFloat inset 		= superlayer.borderWidth + 3;
    CGRect bounds 		= CGRectInset(superlayer.bounds, inset, inset);
    CGFloat height 		= font.ascender;
    CGFloat y 			= bounds.origin.y;
	y 				   += align & kCALayerHeightSizable	? ((bounds.size.height-height) / 2.0)
 						: align & kCALayerMinYMargin 	? bounds.size.height - height : 0;
    align &= ~kCALayerHeightSizable;
    label.bounds 		= (CGRect) { 0, font.descender, bounds.size.width, height - font.descender };
    label.position 		= (CGPoint) { bounds.origin.x, y+font.descender };
    label.anchorPoint 	= (CGPoint) { 0, 0 };
    label.autoresizingMask = align;
    [superlayer addSublayer: label];
    return label;
}

CALayer * AddImageLayer( CALayer *superlayer, NSImage *image, CGFloat scale) {
	CALayer *u = ReturnImageLayer(superlayer, image, scale);
	[superlayer addSublayer:u];
	[superlayer setNeedsLayout];
	return u;
}

CALayer* ReturnImageLayer(CALayer *superlayer, NSImage *image, CGFloat scale)
{
    CALayer *label 			= ReturnLayer(superlayer);
    label.contents 			= image;
	label.layoutManager  	= [CAConstraintLayoutManager layoutManager];
	[label addConstraintsSuperSizeScaled:scale];
	return label;
}

//    NSString *mode;
//    if( align & kCALayerWidthSizable )
//        mode = @"center";
//    else if( align & kCALayerMinXMargin )
//        mode = @"right";
//    else
//        mode = @"left";
//    align |= kCALayerWidthSizable;
//    label.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;

//    CGFloat inset = superlayer.borderWidth + 3;
//    CGRect bounds = AZScaleRect(superlayer.bounds, scale);//(superlayer.bounds, inset, inset);
//    CGFloat height = font.ascender;
//    CGFloat y = bounds.origin.y;
//    if( align & kCALayerHeightSizable )
//        y += (bounds.size.height-height)/2.0;
//    else if( align & kCALayerMinYMargin )
//        y += bounds.size.height - height;
//    align &= ~kCALayerHeightSizable;
//    label.bounds = CGRectMake(0, font.descender,
//                              bounds.size.width, height - font.descender);
//	CGPointMake(bounds.origin.x,y+font.descender);
//    label.anchorPoint = CGPointMake(.5,.5);
//    label.autoresizingMask = align;


CGImageRef CreateCGImageFromFile( NSString *path )
{
    CGImageRef image = NULL;
    CFURLRef url = (__bridge CFURLRef) [NSURL fileURLWithPath: path];
    CGDataProviderRef provider = CGDataProviderCreateWithURL(url);
    if( provider ) {
        image = CGImageCreateWithPNGDataProvider(provider, NULL, NO, kCGRenderingIntentDefault);
        if(!image) {
//            NSLog(@"INFO: Cannot load image as PNG file %@ (ptr size=%u)",path,sizeof(void*));
            //fall back to JPEG
            image = CGImageCreateWithJPEGDataProvider(provider, NULL, NO, kCGRenderingIntentDefault);
        }
        CFRelease(provider);
    }
    return image;
}


CGImageRef GetCGImageNamed( NSString *name )
{
    // For efficiency, loaded images are cached in a dictionary by name.
    static NSMutableDictionary *sMap;
    if( ! sMap )
        sMap = [NSMutableDictionary dictionary];

    CGImageRef image = [(NSImage*)[NSImage imageNamed:sMap[name]] cgImage];
    if( ! image ) {
        // Hasn't been cached yet, so load it:
        NSString *path;
        if( [name hasPrefix: @"/"] )
            path = name;
        else {
            path = [[NSBundle mainBundle] pathForResource: name ofType: nil];
            NSCAssert1(path,@"Couldn't find bundle image resource '%@'",name);
        }
        image = CreateCGImageFromFile(path);
        NSCAssert1(image,@"Failed to load image from %@",path);
        sMap[name] = (__bridge id)image;
    }
    return image;
}


CGColorRef GetCGPatternNamed( NSString *name )         // can be resource name or abs. path
{
    // For efficiency, loaded patterns are cached in a dictionary by name.
    static NSMutableDictionary *sMap;
    if( ! sMap )
        sMap = [NSMutableDictionary dictionary];

    CGColorRef pattern = [NSColor colorWithPatternImage:sMap[name]].CGColor;
    if( ! pattern ) {
        pattern = CreatePatternColor( GetCGImageNamed(name) );
        sMap[name] = (__bridge id)pattern;
    }
    return pattern;
}


//CGImageRef GetCGImageFromPasteboard( NSPasteboard *pb )
//{
//    CGImageSourceRef src = NULL;
//    NSArray *paths = [pb propertyListForType: NSFilenamesPboardType];
//    if( paths.count==1 ) {
//        // If a file is being dragged, read it:
//        CFURLRef url = (CFURLRef) [NSURL fileURLWithPath: [paths objectAtIndex: 0]];
//        src = CGImageSourceCreateWithURL(url, NULL);
//    } else {
//        // Else look for an image type:
//        NSString *type = [pb availableTypeFromArray: [NSImage imageUnfilteredPasteboardTypes]];
//        if( type ) {
//            NSData *data = [pb dataForType: type];
//            src = CGImageSourceCreateWithData((CFDataRef)data, NULL);
//        }
//    }
//    if(src) {
//        CGImageRef image = CGImageSourceCreateImageAtIndex(src, 0, NULL);
//        CFRelease(src);
//        return image;
//    } else
//        return NULL;
//}


float GetPixelAlpha( CGImageRef image, CGSize imageSize, CGPoint pt )
{
    // Trivial reject:
    if( pt.x<0 || pt.x>=imageSize.width || pt.y<0 || pt.y>=imageSize.height )
        return 0.0;

    // sTinyContext is a 1x1 CGBitmapContext whose pixmap stores only alpha.
    static UInt8 sPixel[1];
    static CGContextRef sTinyContext;
    if( ! sTinyContext ) {
        sTinyContext = CGBitmapContextCreate(sPixel, 1, 1,
                                             8, 1,     // bpp, rowBytes
                                             NULL,
                                             kCGImageAlphaOnly);
        CGContextSetBlendMode(sTinyContext, kCGBlendModeCopy);
    }

    // Draw the image into sTinyContext, positioned so the desired point is at
    // (0,0), then examine the alpha value in the pixmap:
    CGContextDrawImage(sTinyContext,
                       CGRectMake(-pt.x,-pt.y, imageSize.width,imageSize.height),
                       image);
    return sPixel[0] / 255.0;
}


#pragma mark -
#pragma mark PATTERNS:


// callback for CreateImagePattern.
static void drawPatternImage (void *info, CGContextRef ctx)
{
    CGImageRef image = (CGImageRef) info;
    CGContextDrawImage(ctx,
                       CGRectMake(0,0, CGImageGetWidth(image),CGImageGetHeight(image)),
                       image);
}

// callback for CreateImagePattern.
static void releasePatternImage( void *info )
{
    CGImageRelease( (CGImageRef)info );
}


CGPatternRef CreateImagePattern( CGImageRef image )
{
    NSCParameterAssert(image);
    int width = CGImageGetWidth(image);
    int height = CGImageGetHeight(image);
    static const CGPatternCallbacks callbacks = {0, &drawPatternImage, &releasePatternImage};
    return CGPatternCreate (image,
                            CGRectMake (0, 0, width, height),
                            CGAffineTransformMake (1, 0, 0, 1, 0, 0),
                            width,
                            height,
                            kCGPatternTilingConstantSpacing,
                            true,
                            &callbacks);
}


CGColorRef CreatePatternColor( CGImageRef image )
{
    CGPatternRef pattern = CreateImagePattern(image);
    CGColorSpaceRef space = CGColorSpaceCreatePattern(NULL);
    CGFloat components[1] = {1.0};
    CGColorRef color = CGColorCreateWithPattern(space, pattern, components);
    CGColorSpaceRelease(space);
    CGPatternRelease(pattern);
    return color;
}


#define kCALayerLabel @"CALayerLabel"

@implementation CALayer (AtoZ)


- (void)orientWithPoint:(CGPoint)point
{
	[self orientWithX:point.x andY:point.y];
}

- (void)orientWithX: (CGFloat)x andY: (CGFloat)y
{
	CATransform3D transform	 = CATransform3DConcat(
									CATransform3DMakeRotation(x, 0, 1, 0),
									CATransform3DMakeRotation( y, 1, 0, 0) );
	transform.m34		= 1.0 / -450;
	self.sublayerTransform		= transform;
}


- (void) toggleFlip  {        //:(CATransform3D)transform {
	BOOL isFlipped = [[self valueForKey:@"flipped"]boolValue];
	isFlipped ? [self flipBack] : [self flipOver];
	[self setValue:@(isFlipped =! isFlipped) forKey:@"flipped"];
}

- (void) flipDown  {        //:(CATransform3D)transform {
	self.anchorPoint = CGPointMake(.5, 0);
	CATransform3D transform = CATransform3DIdentity;
	transform.m34 = 1.0/700.0;
    self.transform = CATransform3DRotate(transform, 180 * M_PI/180, 1, 0, 0);
}


- (void) flipOver  {        //:(CATransform3D)transform {
    CATransform3D transform = CATransform3DIdentity;
	transform.m34 = 1.0/700.0;
    self.transform = CATransform3DRotate(transform, 180 * M_PI/180, 1, 0, 0);
}
- (void) flipBack  {        //:(CATransform3D)transform {
    CATransform3D transform = CATransform3DIdentity;
	transform.m34 = 1.0/700.0;
    self.transform =  CATransform3DRotate(transform, 180 * M_PI/180, -1, 0, 0);
}


- (void) setScale: (CGFloat) scale {
	[self setValue:[NSValue valueWithSize:NSSizeToCGSize((NSSize){scale,scale})] forKeyPath:@"transform.scale"];
}


-(void)pulse
{
    CIFilter *filter = [CIFilter filterWithName:@"CIBloom"]; [filter setDefaults];
    [filter setValue:[NSNumber numberWithFloat:5.0] forKey:@"inputRadius"];
		// name the filter so we can use the keypath to animate the inputIntensity attribute of the filter
    [filter setName:@"pulseFilter"];
		// set the filter to the selection layer's filters
    [self setFilters:[NSArray arrayWithObject:filter]];
		// create the animation that will handle the pulsing.
    CABasicAnimation* pulseAnimation = [CABasicAnimation animation];
		// the attribute we want to animate is the inputIntensity of the pulseFilter
    pulseAnimation.keyPath = @"filters.pulseFilter.inputIntensity";
		// we want it to animate from the value 0 to 1
    pulseAnimation.fromValue = [NSNumber numberWithFloat: 0.0];
    pulseAnimation.toValue = [NSNumber numberWithFloat: 1.5];
		// over one a one second duration, and run an infinite number of times
    pulseAnimation.duration = 1.0;
    pulseAnimation.repeatCount = MAXFLOAT;
		// we want it to fade on, and fade off, so it needs to automatically autoreverse.. this causes the intensity input to go from 0 to 1 to 0
    pulseAnimation.autoreverses = YES;
		// use a timing curve of easy in, easy out..
    pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
		// add the animation to the selection layer. This causes it to begin animating. We'll use pulseAnimation as the animation key name
    [self addAnimation:pulseAnimation forKey:@"pulseAnimation"];
}

-(void)fadeIn
{
//    CABasicAnimation *theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
//    theAnimation.duration=3.5;			theAnimation.repeatCount=1;
//    theAnimation.autoreverses=YES;		theAnimation.fromValue=@(1.0);
//    theAnimation.toValue=@(0.0);
//    [self addAnimation:theAnimation forKey:@"animateOpacity"];
	CABasicAnimation *theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    theAnimation.duration =  [self animationKeys]
	?  [[[self  animationForKey:[self animationKeys].first] valueForKey:@"duration"]floatValue] : .5;
	theAnimation.repeatCount=1;
	theAnimation.fillMode =	kCAFillModeForwards;
	theAnimation.removedOnCompletion = NO;
//    theAnimation.autoreverses=NO;
	theAnimation.fromValue=@(0.0);
    theAnimation.toValue=@(1.0);
    [self addAnimation:theAnimation forKey:@"animateOpacity"];
//	disable
}
-(void)fadeOut
{
    CABasicAnimation *theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    theAnimation.duration =  [self animationKeys]
						  ? [[[self  animationForKey:[self animationKeys].first] valueForKey:@"duration"]integerValue]						  : .5;
	theAnimation.repeatCount=1;
	theAnimation.fillMode =	kCAFillModeForwards;//kCAFillModeBoth;
//  theAnimation.autoreverses=NO;
	theAnimation.removedOnCompletion = NO;
	theAnimation.fromValue=@(1.0);
    theAnimation.toValue=@(0.0);
    [self addAnimation:theAnimation forKey:@"animateOpacity"];

}



+ (CALayer *) withName:(NSString*)name   inFrame:(NSRect)rect
			   colored:(NSColor*)color withBorder:(CGFloat)width colored:(NSColor*) borderColor;
{

	CALayer *new					= [CALayer layer];
	if (name) new.name				= name;
	new.frame						= rect;
	new.position					= AZCenterOfRect(rect);
	new.borderWidth					= width;
	if(width) {
		new.borderWidth 			= width;
		new.borderColor 			= borderColor.CGColor;
	}
	if (color)	new.backgroundColor = color.CGColor;
	new.contentsGravity  	= kCAGravityResizeAspect;
	new.autoresizingMask 	= kCALayerWidthSizable| kCALayerHeightSizable;
	return  new;
}


-(CATransform3D)makeTransformForAngleX:(CGFloat)angle
{
	return [self makeTransformForAngle: angle from:CATransform3DIdentity];
}

-(CATransform3D)makeTransformForAngle:(CGFloat)angle from:(CATransform3D)start{
    CATransform3D transform = start;
	CATransform3D persp = CATransform3DIdentity;
    persp.m34 = 1.0 / -1000;
    transform = CATransform3DConcat(transform, persp);
	transform = CATransform3DRotate(transform, DEG2RAD(angle), 0.0, 1.0, 0.0);
    return transform;
}

- (BOOL)containsOpaquePoint:(CGPoint)p {
	if (![self containsPoint:p]) return NO;
	if (self.backgroundColor && CGColorGetAlpha(self.backgroundColor) > 0.15) return YES;
	float alpha = 0.0;
		// RESTORE if ([self isKindOfClass:[CATextLayer class]]) return YES;
	CGImageRef image = (CGImageRef)[self.contents CGImage];
	if( image ) {		alpha = 1.0; //RESTORE GetPixelAlpha(image, self.bounds.size, p);
	}
	return alpha > 0.15;
}

- (CALayer *) labelLayer {
	return [self sublayerWithName:kCALayerLabel];
}

- (CALayer *)sublayerWithName:(NSString *)name {
	for (CALayer *layer in [self sublayers]){	if([[layer name] isEqualToString:name]) return layer;}	return nil;
}

- (CALayer *) setLabelString:(NSString *)label {
	CATextLayer *layer = (CATextLayer *)[self sublayerWithName:kCALayerLabel];
	if (!label) {		[layer removeFromSuperlayer]; return nil;	}
	if (!layer) {
		layer = [CATextLayer layer]; 		layer.doubleSided = NO;
		layer.wrapped = TRUE;				layer.fontSize = 14.0;
		layer.alignmentMode = kCAAlignmentCenter;
		layer.anchorPoint = CGPointZero;	layer.name = kCALayerLabel;
		[self addSublayer:layer];
	}
	layer.string = label;
	NSLog(@"created text layer %@", layer);
	layer.position = CGPointZero; //CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
	layer.autoresizingMask = kCALayerHeightSizable | kCALayerWidthSizable;
	layer.bounds = self.bounds;
	return layer;
}

+ (CALayer*)veilForView:(CALayer*)view{


	int pixelsHigh = (int)[view bounds].size.height;
	int pixelsWide = (int)[view bounds].size.width;
	int bitmapBytesPerRow   = (pixelsWide * 4);
	int bitmapByteCount = (bitmapBytesPerRow * pixelsHigh);
	CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
		//	context = NULL;
	CGContextRef context = CGBitmapContextCreate (NULL, pixelsWide, pixelsHigh,
												  8,	bitmapBytesPerRow,
												  colorSpace, kCGImageAlphaNoneSkipLast);//kCGImageAlphaNoneSkipLastkCGImageAlphaPremultipliedLast);
	if (context== NULL)	{	NSLog(@"Failed to create context.");	return nil;	}
	CGColorSpaceRelease( colorSpace );
	[[view presentationLayer] renderInContext:context];
	CALayer *layer = [CALayer layer];
    [layer setFrame:view.bounds];
    [layer setBackgroundColor:cgBLACK];
	if (view) [layer setDelegate:view];

	layer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
	layer.contents =  [NSImage imageFromCGImageRef:CGBitmapContextCreateImage(context)];
//	.frame = [view bounds];
	layer.zPosition = 1000;
	return  layer;
//		CFBridgingRetain(//	NS)BitmapImageRep *bitmap = [[NSBitmapImageRep alloc] initWithCGImage:img];
		//	CFRelease(img);
		//	return bitmap;
}


	//[Transpose Matrix][1]

- (CATransform3D)rectToQuad:(NSRect)rect quadTLX:(double)x1a quadTLY:(double)y1a quadTRX:(double)x2a quadTRY:(double)y2a quadBLX:(double)x3a quadBLY:(double)y3a quadBRX:(double)x4a quadBRY:(double)y4a
{
	double X = rect.origin.x;
	double Y = rect.origin.y;
	double W = rect.size.width;
	double H = rect.size.height;

	double y21 = y2a - y1a;
	double y32 = y3a - y2a;
	double y43 = y4a - y3a;
	double y14 = y1a - y4a;
	double y31 = y3a - y1a;
	double y42 = y4a - y2a;

	double a = -H*(x2a*x3a*y14 + x2a*x4a*y31 - x1a*x4a*y32 + x1a*x3a*y42);
	double b = W*(x2a*x3a*y14 + x3a*x4a*y21 + x1a*x4a*y32 + x1a*x2a*y43);
	double c = H*X*(x2a*x3a*y14 + x2a*x4a*y31 - x1a*x4a*y32 + x1a*x3a*y42) - H*W*x1a*(x4a*y32 - x3a*y42 + x2a*y43) - W*Y*(x2a*x3a*y14 + x3a*x4a*y21 + x1a*x4a*y32 + x1a*x2a*y43);

	double d = H*(-x4a*y21*y3a + x2a*y1a*y43 - x1a*y2a*y43 - x3a*y1a*y4a + x3a*y2a*y4a);
	double e = W*(x4a*y2a*y31 - x3a*y1a*y42 - x2a*y31*y4a + x1a*y3a*y42);
	double f = -(W*(x4a*(Y*y2a*y31 + H*y1a*y32) - x3a*(H + Y)*y1a*y42 + H*x2a*y1a*y43 + x2a*Y*(y1a - y3a)*y4a + x1a*Y*y3a*(-y2a + y4a)) - H*X*(x4a*y21*y3a - x2a*y1a*y43 + x3a*(y1a - y2a)*y4a + x1a*y2a*(-y3a + y4a)));

	double g = H*(x3a*y21 - x4a*y21 + (-x1a + x2a)*y43);
	double h = W*(-x2a*y31 + x4a*y31 + (x1a - x3a)*y42);
	double i = W*Y*(x2a*y31 - x4a*y31 - x1a*y42 + x3a*y42) + H*(X*(-(x3a*y21) + x4a*y21 + x1a*y43 - x2a*y43) + W*(-(x3a*y2a) + x4a*y2a + x2a*y3a - x4a*y3a - x2a*y4a + x3a*y4a));

        //Transposed matrix
	CATransform3D transform;
	transform.m11 = a / i;
	transform.m12 = d / i;
	transform.m13 = 0;
	transform.m14 = g / i;
	transform.m21 = b / i;
	transform.m22 = e / i;
	transform.m23 = 0;
	transform.m24 = h / i;
	transform.m31 = 0;
	transform.m32 = 0;
	transform.m33 = 1;
	transform.m34 = 0;
	transform.m41 = c / i;
	transform.m42 = f / i;
	transform.m43 = 0;
	transform.m44 = i / i;
	return transform;
}
- (void) addConstraintsSuperSizeScaled:(CGFloat)scale;
{
	[self addConstraintsSuperSize];
	[self addConstraint: AZConstRelSuperScaleOff(kCAConstraintWidth, scale,0)];
	[self addConstraint: AZConstRelSuperScaleOff(kCAConstraintHeight, scale,0)];
}

- (void) _ensureSuperHasLayoutManager {

	if (!self.superlayer.layoutManager) {
		CAConstraintLayoutManager *l = [[CAConstraintLayoutManager alloc]init];
		self.superlayer.layoutManager = l;
	}
}

- (void) addConstraintsSuperSize
{
	[self _ensureSuperHasLayoutManager];
	self.constraints =	@[	AZConstRelSuper(kCAConstraintHeight),
							AZConstRelSuper(kCAConstraintWidth),
							AZConstRelSuper(kCAConstraintMidX),
							AZConstRelSuper(kCAConstraintMidY)		];

}


- (void)addConstraints:(NSArray*)constraints{
	[self _ensureSuperHasLayoutManager];
	[constraints do:^(id obj) {
		[self addConstraint:obj];
	}];
}

//NSImage *image = // load a image
//CALayer *layer = [CALayer layer];
//[layer setContents:image];
//[view setLayer:myLayer];
//[view setFrame:NSMakeRect(0, 0, image.size.width, image.size.height)];
//view.layer.transform = [self rectToQuad:view.frame quadTLX:0 quadTLY:0 quadTRX:image.size.width quadTRY:20 quadBLX:0 quadBLY:image.size.height quadBRX:image.size.width quadBRY:image.size.height + 90];

//[1]: http://codingincircles.com/2010/07/major-misunderstanding/


+ (CALayer*)closeBoxLayer
{
	CALayer *layer = [CALayer closeBoxLayerForLayer:nil];
	return layer;
}

+ (CALayer*)closeBoxLayerForLayer:(CALayer*)parentLayer;
{
    CALayer *layer = [CALayer layer];
    [layer setFrame:CGRectMake(0.0, 0,
                               30.0, 30.0)];

    [layer setBackgroundColor:cgBLACK];
    [layer setShadowColor:cgBLACK];
    [layer setShadowOpacity:1.0];
    [layer setShadowRadius:5.0];
    [layer setBorderColor:cgWHITE];
    [layer setBorderWidth:3];
    [layer setCornerRadius:15];
	if (parentLayer) [layer setDelegate:parentLayer];
	return layer;
}


- (void)flipLayer:(CALayer*)top withLayer:(CALayer*)bottom
{
	#define ANIMATION_DURATION_IN_SECONDS (1.0)
    // Hold the shift key to flip the window in slo-mo. It's really cool!
    CGFloat flipDuration = ANIMATION_DURATION_IN_SECONDS;// * (self.isDebugging || window.currentEvent.modifierFlags & NSShiftKeyMask ? 10.0 : 1.0);

    // The hidden layer is "in the back" and will be rotating forward. The visible layer is "in the front" and will be rotating backward
    CALayer *hiddenLayer = bottom; //[frontView.isHidden ? frontView : backView layer];
    CALayer *visibleLayer = top;// [frontView.isHidden ? backView : frontView layer];

    // Before we can "rotate" the window, we need to make the hidden view look like it's facing backward by rotating it pi radians (180 degrees). We make this its own transaction and supress animation, because this is already the assumed state
    [CATransaction begin]; {
        [CATransaction setValue:@YES forKey:kCATransactionDisableActions];
        [hiddenLayer setValue:@M_PI forKeyPath:@"transform.rotation.y"];
//        if (self.isDebugging) // Shadows screw up corner finding
//            [self _hideShadow:YES];
    } [CATransaction commit];

    // There's no way to know when we are halfway through the animation, so we have to use a timer. On a sufficiently fast machine (like a Mac) this is close enough. On something like an iPhone, this can cause minor drawing glitches
//    [self performSelector:@selector(_swapViews) withObject:nil afterDelay:flipDuration / 2.0];

    // For debugging, sample every half-second
//    if (self.isDebugging) {
//        [debugger reset];

//        NSUInteger frameIndex;
//        for (frameIndex = 0; frameIndex < flipDuration; frameIndex++)
//            [debugger performSelector:@selector(sample) withObject:nil afterDelay:(CGFloat)frameIndex / 2.0];

        // We want a sample right before the center frame, when the panel is still barely visible
//        [debugger performSelector:@selector(sample) withObject:nil afterDelay:(CGFloat)flipDuration / 2.0 - 0.05];
//    }

    // Both layers animate the same way, but in opposite directions (front to back versus back to front)
    [CATransaction begin]; {
        [hiddenLayer addAnimation:[self _flipAnimationWithDuration:flipDuration isFront:NO] forKey:@"flipGroup"];
        [visibleLayer addAnimation:[self _flipAnimationWithDuration:flipDuration isFront:YES] forKey:@"flipGroup"];
    } [CATransaction commit];
}


- (CAAnimationGroup *)_flipAnimationWithDuration:(CGFloat)duration isFront:(BOOL)isFront;
{
    // Rotating halfway (pi radians) around the Y axis gives the appearance of flipping
    CABasicAnimation *flipAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];

    // The hidden view rotates from negative to make it look like it's in the back
#define LEFT_TO_RIGHT (isFront ? -M_PI : M_PI)
//#define RIGHT_TO_LEFT (isFront ? M_PI : -M_PI)
//    flipAnimation.toValue = [NSNumber numberWithDouble:[backView isHidden] ? LEFT_TO_RIGHT : RIGHT_TO_LEFT];

    // Shrinking the view makes it seem to move away from us, for a more natural effect
    CABasicAnimation *shrinkAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];

//    shrinkAnimation.toValue = [NSNumber numberWithDouble:self.scale];

    // We only have to animate the shrink in one direction, then use autoreverse to "grow"
    shrinkAnimation.duration = duration / 2.0;
    shrinkAnimation.autoreverses = YES;

    // Combine the flipping and shrinking into one smooth animation
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[flipAnimation, shrinkAnimation];

    // As the edge gets closer to us, it appears to move faster. Simulate this in 2D with an easing function
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

    // Set ourselves as the delegate so we can clean up when the animation is finished
    animationGroup.delegate = self;
    animationGroup.duration = duration;

    // Hold the view in the state reached by the animation until we can fix it, or else we get an annoying flicker
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.removedOnCompletion = NO;

    return animationGroup;
}


//Metallic grey gradient background
+ (CAGradientLayer*) greyGradient {
	NSArray *colors =  $array(
							  (id)[[NSColor colorWithDeviceWhite:0.15f alpha:1.0f]CGColor],
							  [[NSColor colorWithDeviceWhite:0.19f alpha:1.0f]CGColor],
							  [[NSColor colorWithDeviceWhite:0.20f alpha:1.0f]CGColor],
							  [[NSColor colorWithDeviceWhite:0.25f alpha:1.0f] CGColor]);
	NSArray *locations = $array($float(0),$float(.5), $float(.5), $float(1));
	CAGradientLayer *headerLayer = [CAGradientLayer layer];
	headerLayer.colors = colors;
	headerLayer.locations = locations;
	return headerLayer;

}

-(NSString*)debugDescription
{
	return [NSString stringWithFormat:@"<%@ (%@) frame=%@ zAnchor=%1.1f>", NSStringFromClass([self class]),
			self.name, NSStringFromRect(self.frame), self.zPosition];
}

-(void)debugAppendToLayerTree:(NSMutableString*)treeStr indention:(NSString*)indentStr
{
	[treeStr appendFormat:@"%@%@\n", indentStr, self.debugDescription];
	for (CALayer *aSub in self.sublayers)
		[aSub debugAppendToLayerTree:treeStr indention:[indentStr stringByAppendingString:@"\t"]];
}

-(NSString*)debugLayerTree
{
	NSMutableString *str = [NSMutableString string];
	[self debugAppendToLayerTree:str indention:@""];
	return str;
}

@end

@implementation CATextLayer (AtoZ)

- (CTFontRef)newFontWithAttributes:(NSDictionary *)attributes {
	CTFontDescriptorRef descriptor = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)attributes);
	CTFontRef font = CTFontCreateWithFontDescriptor(descriptor, 0, NULL);
	CFRelease(descriptor);
	return font;
}

- (CTFontRef)newCustomFontWithName:(NSString *)fontName ofType:(NSString *)type attributes:(NSDictionary *)attributes {
	NSString *fontPath = [[NSBundle bundleForClass:[AtoZ class]] pathForResource:fontName ofType:type];
	NSData *data = [[NSData alloc] initWithContentsOfFile:fontPath];
	CGDataProviderRef fontProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
	[data release];

	CGFontRef cgFont = CGFontCreateWithDataProvider(fontProvider);
	CGDataProviderRelease(fontProvider);

	CTFontDescriptorRef fontDescriptor = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)attributes);
	CTFontRef font = CTFontCreateWithGraphicsFont(cgFont, 0, NULL, fontDescriptor);
	CFRelease(fontDescriptor);
	CGFontRelease(cgFont);
	return font;
}

- (CGSize)suggestSizeAndFitRange:(CFRange *)range
             forAttributedString:(NSMutableAttributedString *)attrString
                       usingSize:(CGSize)referenceSize
{
	CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attrString);
	CGSize suggestedSize =
	CTFramesetterSuggestFrameSizeWithConstraints(framesetter,
												 CFRangeMake(0, [attrString length]),
												 NULL,
												 referenceSize,
												 range);

		//HACK: There is a bug in Core Text where suggested size is not quite right
		//I'm padding it with half line height to make up for the bug.
		//see the coretext-dev list: http://web.archiveorange.com/archive/v/nagQXwVJ6Gzix0veMh09

	CTLineRef line = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)attrString);
	CGFloat ascent, descent, leading;
	CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
	CGFloat lineHeight = ascent + descent + leading;
	suggestedSize.height += lineHeight / 2.f;
		//END HACK

	return suggestedSize;
}

- (void)setupAttributedTextLayerWithFont:(CTFontRef)font {
	NSDictionary *baseAttributes = [NSDictionary dictionaryWithObject:(__bridge id)font
															   forKey:(NSString *)kCTFontAttributeName];

	NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self.string
																				   attributes:baseAttributes];
	CFRelease(font);


		//Make the class name in the string Courier Bold and red
	NSDictionary *fontAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
									@"Courier", (NSString *)kCTFontFamilyNameAttribute,
									@"Bold", (NSString *)kCTFontStyleNameAttribute,
									[NSNumber numberWithFloat:16.f], (NSString *)kCTFontSizeAttribute,
									nil];
	CTFontRef courierFont = [self newFontWithAttributes:fontAttributes];

	NSRange rangeOfClassName = [[attrString string] rangeOfString:@"CATextLayer"];

	[attrString addAttribute:(NSString *)kCTFontAttributeName
					   value:(__bridge id)courierFont
					   range:rangeOfClassName];
	[attrString addAttribute:(NSString *)kCTForegroundColorAttributeName
					   value:(id)[[NSColor redColor] CGColor]
					   range:rangeOfClassName];

	CFRelease(courierFont);

	self.string = attrString;
	self.wrapped = YES;
	CFRange fitRange;
	CGRect textDisplayRect = CGRectInset(self.bounds, 10.f, 10.f);
	CGSize recommendedSize = [self suggestSizeAndFitRange:&fitRange
									  forAttributedString:attrString
												usingSize:textDisplayRect.size];
	[self setValue:[NSValue valueWithSize:recommendedSize] forKeyPath:@"bounds.size"];
	self.position = AZCenterOfRect(self.superlayer.bounds);
	[attrString release];
}

@end
