#import "AtoZ.h"
#import "AtoZUmbrella.h"
#import "AtoZFunctions.h"
#import "NSObject+AtoZ.h"
#import "CALayer+AtoZ.h"

@implementation CALayerNoHit			- (BOOL)containsPoint:(CGP)p    {	return FALSE;	}	@end
@implementation CAShapeLayerNoHit	- (BOOL)containsPoint:(CGP)p    {	return FALSE;	}	@end
@implementation CATextLayerNoHit		- (BOOL)containsPoint:(CGP)p    {	return FALSE;	}	@end			//  OR
#warning Needs Test Case
@implementation CALayer (NoHit)	@dynamic noHit;
- (void)setNoHit:(BOOL)noHit	{  BLOCKIFY(bSelf, self);  BOOL overriden = [self hasAssociatedValueForKey:@"noHit"];
	objc_setAssociatedObject(self,(__bridge const void*)@"noHit",@(noHit),OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	if (!noHit || overriden) return
	[self az_overrideSelector:@selector(containsPoint:) withBlock:(__bridge void*)^BOOL(id _self,NSP p) {
		if (bSelf.noHit) return NO;	SEL sel 	= @selector(containsPoint:);
		BOOL(*superIMP)(id,SEL,NSP) 				= [_self az_superForSelector:sel];		return superIMP(_self, sel, p);
	}];
}
- (BOOL)noHit	    				{
	id booool = objc_getAssociatedObject(self,(__bridge const void *)@"noHit");
	return booool ? [booool boolValue]	: NO;
}
@end
@implementation CALayer (WasClicked)
- (void) layerWasClicked:(CAL *)layer	{
//	[layer toggleBoolForKey:@"clicked"]; [layer setNeedsDisplay];
}
- (void)wasClicked	{
//	[self toggleBoolForKey:@"clicked"];  [self setNeedsDisplay];
}
@end

CATransform3D CA3DxRotation(float x) {
	return CATransform3DMakeRotation(x * M_PI / 180.0, 1.0, 0, 0);
}
CATransform3D CA3DyRotation(float y) {
	return CATransform3DMakeRotation(y * M_PI / 180.0, 0.0, 1.0, 0);
}
CATransform3D CA3DzRotation(float z) {
	return CATransform3DMakeRotation(z * M_PI / 180.0, 0.0, 0, 1.0);
}
CATransform3D CA3DTransform3DConcat(CAT3D xRotation, CAT3D yRotation) {
	return CATransform3DConcat(xRotation, yRotation);
}
CATransform3D CA3DxyZRotation(CAT3D xYRotation, CAT3D zRotation) {
	return CATransform3DConcat(xYRotation, zRotation);
}
//CATransform3D CAT3DConcatenatedTransformation(CAT3D xyZRotation, CAT3D transformation ) {	return CATransform3DConcat(xyZRotation, transformation);	}	CATransform3D concatenatedTransformation = CATransform3DConcat(xRotation, transformation);
@implementation CAShapeLayer (Lassos)
- (void)redrawPath	   {
	CAL *selected = [self valueForKey:@"mommy"];
	CGRect shapeRect = selected.bounds;
	shapeRect.size.width -= 4;
	shapeRect.size.height -= 4;
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathAddRect(path, NULL, shapeRect);
	[self setPath:path];
	CGPathRelease(path);
	[self.superlayer setNeedsDisplay];
}
@end
/*
 struct CATransform3D	 {	CGF m11, m12, m13, m14;
 CGF m21, m22, m23, m24;
 CGF m31, m32, m33, m34;
 CGF m41, m42, m43, m44; };	typedef struct CATransform3D CATransform3D;
 @property CATransform3D  transform,
 sublayerTransform;
 @property CGPoint	 anchorPoint;
 @property CGF	 anchorPointZ;
 ***  CATransform3D Matrix Operations ***
 CATransform3D CATransform3DMakeTranslation ( CGF tx,         CGF ty,     CGF tz	);
 CATransform3D CATransform3DMakeScale (	CGF sx,	  CGF sy,	CGF sz	);
 CATransform3D CATransform3DMakeRotation (	CGF angle,      CGF x,      CGF y,      CGF z	);
 CATransform3D CATransform3DTranslate (	CATransform3D t,    CGF tx,     CGF ty,     CGF tz	);
 CATransform3D CATransform3DScale (		CATransform3D t,    CGF sx,     CGF sy,     CGF sz	);
 CATransform3D CATransform3DRotate (		CATransform3D t,    CGF angle,	CGF x,	CGF y,	CGF z	);
 CATransform3D CATransform3DConcat (		CATransform3D a,    CATransform3D b	);
 CATransform3D CATransform3DInvert (		CATransform3D t	);
 ***  Scale the layer along the x-axis ***
 [layer setValue:[NSNumber numberWithFloat:1.5] forKeyPath:@"transform.scale.x"];
 ***  Same result as above ***
 CGSize biggerX = CGSizeMake(1.5, 1.);
 [layer setValue:[NSValue valueWithCGSize:biggerX] forKeyPath:@"transform.scale"];
 // Makes this function run when the app loads
 //__attribute__((constructor))	static void InitQuartzUtils()	{ }
 */
/*	File: QuartzUtils.m  Abstract: Assorted CoreGraphics / Core Animation utility functions.	*/
void prepareContext(CGContextRef ctx) {
	NSGraphicsContext *nsGraphicsContext = [NSGraphicsContext graphicsContextWithGraphicsPort:ctx flipped:NO];
	[NSGraphicsContext saveGraphicsState]; [NSGraphicsContext setCurrentContext:nsGraphicsContext];
}
void applyPerspective   ( CAL *layer ) {
	CATransform3D perspectiveTransform = CATransform3DIdentity;
	perspectiveTransform.m34 = 1.0 / -850;
	layer.sublayerTransform = perspectiveTransform;
}
static CGColorRef CreateDeviceGrayColor(CGF w, CGF a) {
	CGColorSpaceRef gray = CGColorSpaceCreateDeviceGray();
	CGF comps[] = {w, a};
	CGColorRef color = CGColorCreate(gray, comps);
	CGColorSpaceRelease(gray);
	return color;
}
static CGColorRef CreateDeviceRGBColor  (CGF r, CGF g, CGF b, CGF a) {
	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
	CGF comps[] = {r, g, b, a};
	CGColorRef color = CGColorCreate(rgb, comps);
	CGColorSpaceRelease(rgb);
	return color;
}
void ChangeSuperlayer   ( CAL *layer, CAL *newSuperlayer, int index ) {
	// Disable actions, else the layer will move to the wrong place and then back!
	[CATransaction flush];
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue
	  forKey:kCATransactionDisableActions];
	CGPoint pos = [newSuperlayer convertPoint:layer.position
		  fromLayer:layer.superlayer];
	[layer removeFromSuperlayer];
	if ( index >= 0 ) [newSuperlayer insertSublayer:layer atIndex:index];
	else [newSuperlayer addSublayer:layer];
	layer.position = pos;
	[CATransaction commit];
}
void RemoveImmediately  ( CAL *layer ) {
	[CATransaction immediately:^{   [layer removeFromSuperlayer]; }];
}
void RemoveSublayers	 	( CAL *host  ) {
	[host sublayersBlockSkippingSelf: ^(CAL *layer) {        [layer removeFromSuperlayer]; }];
}
CAL * AddBloom	     		( CAL *layer ) {
	// create the filter and set its default values
	CIFilter *filter = [CIFilter filterWithName:@"CIBloom"];
	[filter setDefaults];
	[filter setValue:@(5.0) forKey:@"inputRadius"];
	// name the filter so we can use the keypath to animate the inputIntensity attribute of the filter
	[filter setName:@"pulseFilter"];
	// set the filter to the selection layer's filters
	layer.filters  = layer.filters ? [NSArray arrayWithArrays:@[layer.filters, @[filter]]]
	: @[filter];
	return layer;
}
CAL * AddShadow	    	( CAL *layer ) {
	AZLOG(layer.debugDescription);
	CGF base = NSEqualRects(layer.bounds, NSZeroRect) ? 50 : layer.boundsWidth;
	layer.shadowOffset	   = (CGSize) {.1 * base, -.1 * base };
	layer.shadowRadius	   = .2 * base;
	layer.shadowColor	    = cgBLACK;
	layer.shadowOpacity     = .8;
	return layer;
}
CAL * AddPulsatingBloom ( CAL *layer ) {
	AddBloom(layer);
	// create the animation that will handle the pulsing.
	CABasicAnimation *pulseAnimation = [CABasicAnimation animation];
	// the attribute we want to animate is the inputIntensity	of the pulseFilter
	pulseAnimation.keyPath	       = @"filters.pulseFilter.inputIntensity";
	// we want it to animate from the value 0 to 1
	pulseAnimation.fromValue	     = @(0.0);
	pulseAnimation.toValue	       = @(4.5);
	// over a one second duration, and run an infinite number of times
	pulseAnimation.duration	   = 1.0;
	pulseAnimation.repeatCount	   = HUGE_VALF;
	// we want it to fade on, and fade off, so it needs to automatically autoreverse.. this causes the intensity	input to go from 0 to 1 to 0
	pulseAnimation.autoreverses     = YES;
	// use a timing curve of easy in, easy out..
	pulseAnimation.timingFunction   = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	// add the animation to the selection layer. This causes it to begin animating. We'll use pulseAnimation as the animation key name
	[layer addAnimation:pulseAnimation forKey:@"pulseAnimation"];
	return layer;
}
CAL * NewLayerWithFrame ( NSR rect  ) {
	CAL *layer	 = [[CALayer alloc] init];
	layer.frame	       = rect;
	layer.bounds	 = AZMakeRectFromSize(rect.size);
	layer.position	       = AZCenterOfRect(rect);
	layer.layoutManager	  = AZLAYOUTMGR;
	layer.autoresizingMask  = kCALayerWidthSizable | kCALayerHeightSizable;
	layer.contentsGravity   = kCAGravityResizeAspect;
	layer.backgroundColor   = cgCLEARCOLOR;
	return layer;
}
CAL * NewLayerInLayer	( CAL *superlayer ) {
	CAL *layer	 = NewLayerWithFrame(nanRectCheck(superlayer.frame));
	layer.delegate	       = superlayer;
	[superlayer addSublayer:layer];
	[layer addConstraintsSuperSize];
	return layer;
}
CATXTL * AddLabel	  		( CAL *superlayer, NSS *text) {
	NSFont *font = [NSFont fontWithName:@"UbuntuTitling-Bold" size:29];
	return AddTextLayer(superlayer, text, font, kCALayerWidthSizable);
}
CATXTL * AddLabelLayer  ( CAL *superlayer, NSS *text, NSF *font ) {
	return AddTextLayer(superlayer, text, font, kCALayerWidthSizable);
}
CATXTL * AddTextLayer	( CAL *superlayer, NSS *text, NSF *font, enum CAAutoresizingMask align ) {
	CATXTL *label = [[CATXTL alloc] init];
	[label setValue:@(YES) forKey:@"label"];
	label.string = text;
	label.font = (__bridge CGFontRef)font;
	label.fontSize = font.pointSize;
	//	CGColorRef sup = superlayer.backgroundColor;
	label.foregroundColor =  kBlackColor;
	// sup ? sup :
	//	NSString *mode;
	//	if( align & kCALayerWidthSizable )	mode = @"center";
	//	else if( align & kCALayerMinXMargin )   mode = @"right";
	//	else			mode = @"left";
	//	align |= kCALayerWidthSizable;
	//	label.alignmentMode = mode;
	//	CGF inset   = superlayer.borderWidth + 3;
	CGRect bounds  = nanRectCheck(superlayer.bounds);     // CGRectInset(superlayer.bounds, inset, inset));
				//	CGF height  = font.ascender;
				//	CGF y       = bounds.origin.y;
				//	if	( align & kCALayerHeightSizable )	y += (bounds.size.height-height)/2.0;
				//	else if	( align & kCALayerMinYMargin    )	y += bounds.size.height - height;
				//		  align &= ~kCALayerHeightSizable;
	label.bounds    = bounds;    // nanRectCheck(  CGRectMake(0, font.descender, bounds.size.width, height - font.descender));
	label.position  = nanPointCheck(AZCenterOfRect(superlayer.bounds));    //CGPointMake(bounds.origin.x,y+font.descender));
				  //	label.anchorPoint = (CGPoint) { .5,.5 };
				  //	label.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;// align;
	[superlayer addSublayer:label];
	return label;
}
CAL * AddImageLayer	   ( CAL *superlayer, NSIMG *image, CGF scale) {
	//	u.contentsCenter = AZCenterRectOnRect(superlayer.bounds, new); , scale), superlayer.frame);
	CAL *u = ReturnImageLayer(superlayer, image, scale);
	[superlayer addSublayer:u];
	[superlayer layoutIfNeeded];
	return u;
}
CAL * ReturnImageLayer   ( CAL *superlayer, NSIMG *image, CGF scale) {
	CAL *label	 = NewLayerWithFrame(superlayer.frame);
	NSSize old	= superlayer.frame.size;
	image.size	= (NSSize) {old.width *scale, old.height *scale};
	label.contentsGravity   = kCAGravityCenter;
	label.contentsRect	   = AZMakeRectFromSize(old);
	label.contents	       = image;
	[label setValue:@(YES) forKey:@"image"];
	//	label.layoutManager     = [CAConstraintLayoutManager layoutManager];
	//	[label addConstraintsSuperSizeScaled:scale];
	return label;
}
CGImageRef CreateCGImageFromFile        ( NSS *path ) {
	CGImageRef image = NULL;
	CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:path];
	CGDataProviderRef provider = CGDataProviderCreateWithURL(url);
	if ( provider ) {
	image = CGImageCreateWithPNGDataProvider(provider, NULL, NO, kCGRenderingIntentDefault);
	if (!image) {
		//		NSLog(@"INFO: Cannot load image as PNG file %@ (ptr size=%u)",path,sizeof(void*));
		//fall back to JPEG
		image = CGImageCreateWithJPEGDataProvider(provider, NULL, NO, kCGRenderingIntentDefault);
	}
	CFRelease(provider);
	}
	return image;
}
CGImageRef GetCGImageNamed	( NSS *name ) {
	// For efficiency, loaded images are cached in a dictionary by name.
	static NSMutableDictionary *sMap;
	if ( !sMap ) sMap = [NSMutableDictionary dictionary];
	CGImageRef image = [(NSImage *)[NSImage imageNamed:sMap[name]] cgImage];
	if ( !image ) {
	// Hasn't been cached yet, so load it:
	NSString *path;
	if ( [name hasPrefix:@"/"] ) path = name;
	else {
		path = [[NSBundle mainBundle] pathForResource:name ofType:nil];
		NSCAssert1(path, @"Couldn't find bundle image resource '%@'", name);
	}
	image = CreateCGImageFromFile(path);
	NSCAssert1(image, @"Failed to load image from %@", path);
	sMap[name] = (__bridge id)image;
	}
	return image;
}
CGColorRef GetCGPatternNamed	 ( NSS *name ) {	// can be resource name or abs. path
				  // For efficiency, loaded patterns are cached in a dictionary by name.
	static NSMutableDictionary *sMap;
	if ( !sMap ) sMap = [NSMutableDictionary dictionary];
	CGColorRef pattern = [NSColor colorWithPatternImage:sMap[name]].CGColor;
	if ( !pattern ) {
	pattern = CreatePatternColor( GetCGImageNamed(name) );
	sMap[name] = (__bridge id)pattern;
	}
	return pattern;
}
CGF GetPixelAlpha	( CGImageRef image, CGSZ imageSize, CGP pt ) {
	// Trivial reject:
	if ( pt.x < 0 || pt.x >= imageSize.width || pt.y < 0 || pt.y >= imageSize.height ) return 0.0;
	// sTinyContext is a 1x1 CGBitmapContext whose pixmap stores only alpha.
	static UInt8 sPixel[1];
	static CGContextRef sTinyContext;
	if ( !sTinyContext ) {
	sTinyContext = CGBitmapContextCreate(sPixel, 1, 1,
			 8, 1,	     // bpp, rowBytes
			 NULL,
			 kCGImageAlphaOnly);
	CGContextSetBlendMode(sTinyContext, kCGBlendModeCopy);
	}
	// Draw the image into sTinyContext, positioned so the desired point is at
	// (0,0), then examine the alpha value in the pixmap:
	CGContextDrawImage(sTinyContext,
		 CGRectMake(-pt.x, -pt.y, imageSize.width, imageSize.height),
		 image);
	return sPixel[0] / 255.0;
}
#pragma mark - PATTERNS:
static void drawPatternImage	 ( void *info, CGContextRef ctx) {
	CGImageRef image = (CGImageRef)info;
	CGContextDrawImage(ctx,
		 CGRectMake(0, 0, CGImageGetWidth(image), CGImageGetHeight(image)),
		 image);
}       // callback for CreateImagePattern.
static void releasePatternImage ( void *info ) {
	CGImageRelease( (CGImageRef)info );
} // callback for CreateImagePattern.
CGPatternRef CreateImagePattern ( CGImageRef image ) {
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
CGColorRef CreatePatternColor	( CGImageRef image ) {
	CGPatternRef pattern = CreateImagePattern(image);
	CGColorSpaceRef space = CGColorSpaceCreatePattern(NULL);
	CGF components[1] = {1.0};
	CGColorRef color = CGColorCreateWithPattern(space, pattern, components);
	CGColorSpaceRelease(space);
	CGPatternRelease(pattern);
	return color;
}
extern CATransform3D CATransform3DMake(CGF m11, CGF m12, CGF m13, CGF m14,
	   CGF m21, CGF m22, CGF m23, CGF m24,
	   CGF m31, CGF m32, CGF m33, CGF m34,
	   CGF m41, CGF m42, CGF m43, CGF m44) {
	CATransform3D t;
	t.m11 = m11; t.m12 = m12; t.m13 = m13; t.m14 = m14;
	t.m21 = m21; t.m22 = m22; t.m23 = m23; t.m24 = m24;
	t.m31 = m31; t.m32 = m32; t.m33 = m33; t.m34 = m34;
	t.m41 = m41; t.m42 = m42; t.m43 = m43; t.m44 = m44;
	return t;
}
@implementation CALayer (VariadicConstraints)
/*
 CATXTL* AddTextLayer( CAL*superlayer,	NSString *text, NSFont* font,	enum CAAutoresizingMask align ) {
 CATXTL *label     = [[CATXTL alloc] init];
 label.foregroundColor = kBlackColor;
 label.string        = text;
 label.font          = (__bridge CGFontRef)font;
 label.fontSize      = font.pointSize;
 NSString *mode	    = align & kCALayerWidthSizable  ? @"center"
 : align & kCALayerMinXMargin    ? @"right"	: @"left";
 align |= kCALayerWidthSizable;
 label.alignmentMode = mode;
 CGF inset       = superlayer.borderWidth + 3;
 CGRect bounds       = CGRectInset(superlayer.bounds, inset, inset);
 CGF height      = font.ascender;
 CGF y	= bounds.origin.y;
 y	       += align & kCALayerHeightSizable	? ((bounds.size.height-height) / 2.0)
 : align & kCALayerMinYMargin    ? bounds.size.height - height : 0;
 align &= ~kCALayerHeightSizable;
 label.bounds        = (CGRect) { 0, font.descender, bounds.size.width, height - font.descender };
 label.position      = (CGPoint) { bounds.origin.x, y+font.descender };
 label.anchorPoint   = (CGPoint) { 0, 0 };
 label.autoresizingMask = align;
 [superlayer addSublayer: label];
 return label;
 }
 NSString *mode;
 if( align & kCALayerWidthSizable )
 mode = @"center";
 else if( align & kCALayerMinXMargin )
 mode = @"right";
 else
 mode = @"left";
 align |= kCALayerWidthSizable;
 label.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
 CGF inset = superlayer.borderWidth + 3;
 CGRect bounds = AZScaleRect(superlayer.bounds, scale);//(superlayer.bounds, inset, inset);
 CGF height = font.ascender;
 CGF y = bounds.origin.y;
 if( align & kCALayerHeightSizable )
 y += (bounds.size.height-height)/2.0;
 else if( align & kCALayerMinYMargin )
 y += bounds.size.height - height;
 align &= ~kCALayerHeightSizable;
 label.bounds = CGRectMake(0, font.descender,
 bounds.size.width, height - font.descender);
 CGPointMake(bounds.origin.x,y+font.descender);
 label.anchorPoint = CGPointMake(.5,.5);
 label.autoresizingMask = align;
 CGImageRef GetCGImageFromPasteboard( NSPasteboard *pb )	{
 CGImageSourceRef src = NULL;
 NSArray *paths = [pb propertyListForType: NSFilenamesPboardType];
 if( paths.count==1 ) {
 // If a file is being dragged, read it:
 CFURLRef url = (CFURLRef) [NSURL fileURLWithPath: [paths objectAtIndex: 0]];
 src = CGImageSourceCreateWithURL(url, NULL);
 } else {
 // Else look for an image type:
 NSString *type = [pb availableTypeFromArray: [NSImage imageUnfilteredPasteboardTypes]];
 if( type ) {
 NSData *data = [pb dataForType: type];
 src = CGImageSourceCreateWithData((CFDataRef)data, NULL);
 }
 }
 if(src) {
 CGImageRef image = CGImageSourceCreateImageAtIndex(src, 0, NULL);
 CFRelease(src);
 return image;
 } else
 return NULL;
 }
 */
/*	- (void) appendObjects:(id) firstObject, ...	{
 id eachObject;
 va_list argumentList;
 if (firstObject) // The first argument isn't part of the varargs list,
 {	// so we'll handle it separately.
 [self addObject: firstObject];
 va_start(argumentList, firstObject); // Start scanning for arguments after firstObject.
 while (eachObject = va_arg(argumentList, id)) // As many times as we can get an argument of type "id"
 [self addObject: eachObject]; // that isn't nil, add it to self's contents.
 va_end(argumentList);
 }
 }	EXAMPLE OF VARIAIDIC	*/
- (void)addConstraintsSuperSizeScaled:(CGF)scale       {
	[self addConstraintsSuperSize];
	[self addConstraint:AZConstRelSuperScaleOff(kCAConstraintWidth, scale, 0)];
	[self addConstraint:AZConstRelSuperScaleOff(kCAConstraintHeight, scale, 0)];
}
- (void)addConstraintsSuperSize	 {
	[self _ensureSuperHasLayoutManager];
	self.constraints =      @[      AZConstRelSuper(kCAConstraintHeight),
		  AZConstRelSuper(kCAConstraintWidth),
		  AZConstRelSuper(kCAConstraintMidX),
		  AZConstRelSuper(kCAConstraintMidY)	 ];
}
- (void)_ensureSuperHasLayoutManager	       {
	if (!self.superlayer.layoutManager) self.superlayer.layoutManager = [[CAConstraintLayoutManager alloc]init];
}
- (void)addConstraints:(NSA *)constraints	{
	[self _ensureSuperHasLayoutManager];
	[constraints do :^(id obj) {	  [self addConstraint:obj];       }];
}
- (void)addConstraintsRelSuperOr:(NSN *)nilAttributeList, ...{ // This method takes a nil-terminated list of objects.
	va_list args;
	va_start(args, nilAttributeList);
	NSNumber *value;
	id arg = nil;
	while ( (value = va_arg( args, NSNumber * )) )
	while ((arg = va_arg(args, id))) {
		/// Do your thing with arg here
	}
	va_end(args);
}
- (void)addConstraintObjects:(CAConstraint *)first, ...{
	azva_list_to_nsarray(first, constraints);
	LOGCOLORS(@"Adding ", @(constraints.count), @" constraints to layer with name:", self.name, PINK, ORANGE, nil);
	[constraints each:^(id obj) { [self addConstraint:obj]; }];
}
- (void)addConstraintsRelSuper:(CAConstraintAttribute)first, ...{ /* REQUIRES NSNotFound termination */
	va_list args;   va_start(args, first);
	for (NSUInteger arg = first; arg != NSNotFound; arg = va_arg(args, NSUInteger)) {
	[self addConstraint:AZConstRelSuper(arg)];
	}
	va_end(args);
}
@end
@implementation NSObject (bSelf)
- (void)blockSelf:(bSelf)block {
	declareBlockSafeAs(self, bSelf); block(bSelf);
}
- (void)triggerKVO:(NSS*)k block:(bSelf)blk {
	[self willChangeValueForKey:k]; [self blockSelf:^(__typeof(self)_self){ blk(_self); }]; [self didChangeValueForKey:k];
}
@end
#define KVOTRIGGER(x) [ willChangeValueForKey : x][bSelf setValue : y forKey : x];  [bSelf didChangeValueForKey:x]; })
static char ORIENT_IDENTIFIER, ROOT_IDENTIFIER, TEXT_IDENTIFIER;
#define kCALayerLabel @"CALayerLabel"
@implementation CALayer (AtoZ)

@dynamic hostView, siblings, siblingIndex, siblingIndexMax, selected, hovered, backgroundNSColor;
@dynamic sublayerMouseOverBlock, sublayersRecursive;

- (void) disableActionsForKeys:(NSA*)ks {	self.actions = [self.actions dictionaryWithValue:AZNULL forKeys:ks]; }
- (void) addActionsForKeys:(NSD*)ks {  self.actions = [self.actions dictionaryByAddingEntriesFromDictionary:ks]; }

+ (void)load	    				{   //	NSLog(@"swizzling: @selector(addSublayer:)");

	[$ swizzleMethod:@selector(description) with:@selector(swizzleDescription) in:self.class];
}
			//	[$ swizzleMethod:@selector(addSublayer:) with:@selector(swizzleAddSublayer:) in:self.class];
			//	[$ swizzleMethod:@selector(actionForKey:) with:@selector(swizzleActionForKey:) in:self.class];
			//	[$ swizzleMethod:@selector(hitTest:) with:@selector(swizzleHitTest:) in:CAL.class];
//	[$ swizzleMethod:@selector(needsDisplayForKey:) with:@selector(swizzleNeedsDisplayForKey:) in:CAL.class];
	//	[$ swizzleClassMethod:@selector(defaultActionForKey:) with:@selector(swizzleDefaultActionForKey:) in:CAL.class];
//	[$ swizzleClassMethod:@selector(initWithLayer:) with:@selector(swizzleInitWithLayer:) in:CAL.class];
//}

- (NSS*) swizzleDescription {

	return $(@"%@ <%@> %@", AZCLSSTR, [[self superclasses]componentsJoinedByString:@" -> "], AZStringFromRect(self.frame));
}


static NSMD* needsDisplayKeysRef = nil;
+ (NSA*) needsDisplayForKeys {  return needsDisplayKeysRef[AZCLSSTR]; }


+ (BOOL) swizzleNeedsDisplayForKeyFromDict:(NSS*)k; {
	BOOL yeah = [(NSA*)needsDisplayKeysRef[NSStringFromClass(self.class)] containsObject:k];
	if (yeah) NSLog(@"my swizzled out self needs display for key: %@... (class: %@", k, AZCLSSTR);
	return yeah ?: [self.class swizzleNeedsDisplayForKeyFromDict:k];
}
+ (void) setNeedsDisplayForKeys:(NSA*)ks {	needsDisplayKeysRef = needsDisplayKeysRef ?: NSMD.new;
	!needsDisplayKeysRef[AZCLSSTR] || ![needsDisplayKeysRef[AZCLSSTR] isEqualToArray:ks] ? needsDisplayKeysRef[AZCLSSTR] = ks :nil;
	NSLog(@"current CALAYER needy key dict: %@", needsDisplayKeysRef);
	[$ swizzleClassMethod:@selector(needsDisplayForKey:) in:self.class with:@selector(swizzleNeedsDisplayForKeyFromDict:) in:self.class];
}


- (NSA*) siblings					{
	return [self.superlayer.sublayers arrayByRemovingObject:self];
}
- (NSUI) siblingIndex		  	{
	return MAX([self.superlayer.sublayers indexOfObject:self] + 1, 0);
}
- (NSUI) siblingIndexMax	  	{
	return MAX(self.superlayer.sublayers.count - 1, 0);
}
-  (ACT) swizzleActionForKey:	(NSS*)e {
	//	[self swizzleDidChangeValueForKey:k];
	//	id v = [self vFK:k];
	//	if ([v ISKINDA:NSA.class])
	//	v = $(@"array for Key: %@, ct:%ld", k, [v count]);	//	NSLog(@"swizzle didcvfk:%@  %@", k,v);
	objswitch(e)
	objcase(kCAOnOrderIn)
	NSLog(@"inside %@", e);
	while (self.superlayer == nil) sleep(1);
	[self willChangeValueForKey:@"siblings"];
	if ([self respondsToSelector:@selector(didMoveToSuperlayer)]) [self didMoveToSuperlayer];
	[self didChangeValueForKey:@"siblings"];
	return [CABasicAnimation animationWithKeyPath:@"opacity"];
	//	if ([self superlayer].sublayers.count > 1)
	//		[self.sublayers each:^(id obj) {
	//		[obj willChangeValueForKeys:@"siblings", @"siblingIndexMax", nil];
	//		[obj didChangeValueForKeys:@"siblings", @"siblingIndexMax", nil];
	//	}];
	endswitch
	return [self swizzleActionForKey:e] ? : [super actionForLayer:self forKey:e] ? : nil;
	//	objcase(@"sublayers")
	//	[self.sublayers makeObjectsPerformSelector:@selector(willChangeValueForKey:) withObject:@"siblings"];
	//	[self.sublayers makeObjectsPerformSelector:@selector(didChangeValueForKey:)  withObject:@"siblings"];
	//	return [self swizzleActionForKey:e];
	//	return [[self.class superclass] actionForKey:e];//didChangeValueForKey:k];
}
- (void) swizzleAddSublayer:	(CAL*)c {
	//	[self addKVOBlockForKeyPath:@"sublayers.@count" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld handler:^(NSS *keyPath, id object, NSD *change) {
	//	[self addObserver:cal keyPath:@"sublayers" options:0 block:^(MAKVONotification *notification) {
	//	AZLOGCMD;
	//	[self.sublayers each:^(id obj) { [obj willChangeValueForKeys:@[@"siblings", @"siblingIndex", @"siblingIndexMax"]]; }];
	[self swizzleAddSublayer:c];
	//	[self.sublayers each:^(id obj) { [obj didChangeValueForKeys:@[@"siblings", @"siblingIndex", @"siblingIndexMax"]]; }];
}
-   (id) swizzleHitTest:		 (NSP)p {
	//	id (^hit)(CAL*) = ^id(CAL*l) { return [l swizzleHitTest:[l convertPoint:p fromLayer:self]];
	//	NSA* hit = [self.sublayers reduce:@[].mutableCopy withBlock:^id(id sum, id obj) {
	//
	//	return
	//	}];
	//	if (!hit) return nil;
	//	return [hit firstObject];
	//	CGF top = [self.sublayers floatForKeyPath:@"@max.zPosition"];
	//
	//	LOG_EXPR(top);
	//	if (([[hit sortedWithKey:@"zPosition" ascending:NO].first floatForKey:@"zPosition"] < top) || (top == 0.0))
	//
	//	[CATRANNY immediately:^{
	//	    [hit setFloat:top+100 forKey:@"zPosition"];
	//		NSLog(@"Changed %@ zPos to %f",hit,  hit.zPos);
	//	}];
	//	return  hit;
}
/*	__block CAL* hit = [self hitTestSubs:p];
 __block CAL* try = hit;
 CGF(^top)(void) = ^CGF{ return  [self.superlayer.sublayers floatForKeyPath:@"@max.zPosition"]; };
 while (try && hit.zPosition < top() ){
 if ([hit respondsToSelector:@selector(count)]) {
 CGF top = [hit floatForKeyPath:@"@max.zPosition"];
 if (top != 0) hit = [hit objectWithValue:@(top) forKey:@"zPosition"];
 NSLog(@"sorted the hittest by zPosition... winnder %f", top);
 }
 if ([hit respondsToString:@"last"]) { hit = [hit last]; NSLog(@"giving the last hittest"); }
 //	NSLog(@"newZpos:%f", top);
 CABA *topper = [CABA animationWithKeyPath:@"zPosition" andDuration:1 andSet:hit];
 topper.toValue = @(top);
 topper.fromValue = @([hit presentationCALayer].zPosition);
 [CAAnimationDelegate delegate:topper forLayer:hit];
 [hit addAnimation:topper forKey:nil];
 //	[hit animate:@"zPosition" toInt:top  time:2 completion:^{
 if (hit && [hit respondsToString:@"selected"] && [hit respondsToString:@"setSelected:"]) {
 [hit setSelected:![hit boolForKey:@"selected"]];
 return hit;
 }
 }
 */
- (BOOL)swizzleNeedsDisplayForKey:(NSS*)k	   {
	return [@[@"selected", @"hovered", @"siblingIndex", @"backgroundNSColor"] containsObject : k]
	? :[self swizzleNeedsDisplayForKey:k];
}
- (id)swizzleInitWithLayer:(id)layer {
	if (self != [self swizzleInitWithLayer:layer]) return nil;
	[@[@"siblings", @"siblingIndex", @"siblingIndexMax", @"selected", @"hovered", @"backgroundNSColor"] each : ^(id obj) { id value;
	if ((value = [layer vFK:obj])) {
		[[@"swizzle set "withString : obj]log]; [self sV:value fK:obj];
	}
	}];
	return self;
}
/* + (ACT)swizzleDefaultActionForKey:(NSString *)key {
 return [@[@"selected", @"hovered", @"siblingIndex", @"backgroundNSColor"]containsObject:k]
 ?: [self swizzleNeedsDisplayForKey:k]; } */
//- (CAL*) hitEvent:(NSEvent*) forClass @dynamic permaPresentation;
- (CAL *)permaPresentation	  {
	if (!self.presentationLayer) NSLog(@"no presenta para: %@", self);
	return self.presentationLayer ? : self.modelCALayer ? : self;
}
- (void)setBackgroundNSColor:(NSC *)c   {
	self.bgC = c.CGColor;
}
- (NSC *)backgroundNSColor	{
	return self.bgC == NULL ? CLEAR : [NSC colorWithCGColor:self.bgC];
}
- (BOOL)selected	{
	return [[self associatedValueForKey:@"_selected" orSetTo:@NO policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC]boolValue];
}
- (void)setSelected:(BOOL)s	      {
	if (s == self.selected) return;
	[self willChangeValueForKey:@"selected"];
	//	[self triggerKVO:@"selected" block:^(NSO *bSelf) {
	[self setAssociatedValue:@(s) forKey:@"_selected" policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
	[self didChangeValueForKey:@"selected"];
	[self setNeedsDisplay];
	[self.loM setNeedsLayout];
}
- (BOOL)hovered	 {
	return [[self associatedValueForKey:@"_hovered" orSetTo:@NO policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC]boolValue];
}
- (void)setHovered:(BOOL)h	       {
	if (h == self.hovered) return;
	[self willChangeValueForKey:@"hovered"];
	//	[self triggerKVO:@"hovered" block:^(NSO *bSelf) { //willChangeValueForKey:@"hovered"];
	[self setAssociatedValue:@(h) forKey:@"_hovered" policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
	//	[self setValue:@(h) forKey:@"_hovered"];
	[self didChangeValueForKey:@"hovered"];
	[self setNeedsDisplay];
	[self.loM setNeedsLayout];
}
- (void)needsLayoutForKey:(NSS *)key    {
	[self addObserverForKeyPath:key task:^(id sender) { [sender setNeedsLayout]; }];
}
+ (id)layerWithFrame:(CGRect)frame	   { CAL* l = self.class.new;
//	NSAssert(self == [l class], $(@"made a layer:%@, but wrong class:%@ should be:%@", l, NSStringFromClass([l class]), NSStringFromClass(self)));

	if ([l respondsToSelector:@selector(setFrame:)]) [l setFrame:frame];
	return l;
}
- (id)initWithFrame:(CGRect)newFrame    {
	return self = [super init] ? self.frame = newFrame, self : nil;
}
- (id)scanSubsForClass:(Class )c	   {
	__block CALayer *thing = nil;
	[self.sublayers enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
	if ([obj isKindOfClass:c]) { thing = obj; *stop = YES;  }
	else if ([obj sublayers].count > 0) thing = [obj scanSubsForClass:c];
	}];
	return thing;
}
- (id)scanSubsForName:(NSString *)n	 {
	__block CALayer *thing = nil;
	[self.sublayers enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
	if ([[(CAL *)obj name] isEqualToString:n]) { thing = obj; *stop = YES;  }
	else if ([obj sublayers].count > 0) thing = [obj scanSubsForName:n];
	}];
	return thing;
}
//+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)theKey {
//	return [@[@"sublayers", @"siblings", @"siblingIndex", @"siblingIndexMax"]containsObject:theKey]
//	 ?: [super automaticallyNotifiesObserversForKey:theKey];
//}
//	return [@[@"siblingIndex", @"siblingIndexMax",@"siblings", @"sublayers"]containsObject:key] ?: [super automaticallyNotifiesObserversForKey:key];
//}
//	return [@[@"siblingIndex", @"siblingIndexMax",@"siblings"]containsObject:key] ?: [super automaticallyNotifiesObserversForKey:key];
//}
//+ (NSSet*) keyPathsForValuesAffectingSiblings { return NSSET(@"sublayers"); }  //@"superlayer.sublayers"); }
//+ (NSSet*) keyPathsForValuesAffectingSiblingIndex { return NSSET(@"siblings"); }  //@"superlayer.sublayers"); }
- (NSA *)sublayersAscending	  {
	return [self.sublayers sortedWithKey:@"frameX" ascending:YES];
}
- (void)setHostView:(NSV *)hostView     {
	[self setAssociatedValue:hostView forKey:@"hostView" policy:OBJC_ASSOCIATION_ASSIGN];
}
- (NSV *)hostView	{
	return [self associatedValueForKey:@"hostView"] ? : nil;
}
- (NSR)actuallyVisibleRect;	{
	return [self actuallyVisibleRectInView:nil];
}
- (NSR)actuallyVisibleRectInView:(NSV *)v;     {
	v = v ? : self.hostView ? : [[self.superlayers cw_mapArray:^id (id o) { return [o hostView]; }]
	  sortedWithKey:@"minDim" ascending:NO].first;
	NSR actual = NSIntersectionRect(self.visibleRect, AZRectFromSize([[v window] size]));
	//	NSLog(@"%@ vs %@ in %@ %@", AZString(self.visibleRect), AZString(actual), AZString(v.bounds), [v class]);
	return actual;
}
- (NSA *)visibleSublayers	 {
	NSA *i = [self.sublayers filter:^BOOL (id o) { return !CGRectIsEmpty([o actuallyVisibleRect]); }];
	//	NSLog(@"%ld/%ld subs Visible.", i.count, self.sublayers.count);
	return i;
}
- (CAL *)sublayerOfClass:(Class)k {
	return [self.sublayers filterOne:^BOOL (id object) {
	return [object ISKINDA:k];
	}];
}
- (NSA *)sublayersOfClass:(Class)k      {
	return [self.sublayers filter:^BOOL (id object) {
	return [object ISKINDA:k];
	}];
}
- (void)removeImmediately	{
	RemoveImmediately(self);
}
- (void)removeSublayers;	 { RemoveSublayers(self); }
- (CATXTL *)addTextLayer:(NSS *)text font:(NSFont *)font align:(enum CAAutoresizingMask)align {
	return AddTextLayer(self, text, font, align);
}
- (CAL *)addImageLayer:(NSIMG *)image scale:(CGF)scale    {
	return AddImageLayer( self, image, scale);
}
- (NSData *)dataKey:(NSS *)defaultNm {
	NSData *data = [self valueForKey:defaultNm];
	return [data isKindOfClass:objc_lookUpClass("NSData")] ? data : (NSData *)nil;
}
- (NSS *)strKey:(NSS *)defaultName {
	NSString *string = self[defaultName];
	return [string isKindOfClass:objc_lookUpClass("NSString")] ? string : (NSS *)nil;
}
- (NSA *)arrKey:(NSS *)defaultName {
	NSArray *array = self [defaultName];
	return [array isKindOfClass:objc_lookUpClass("NSArray")] ? array : (NSA *)nil;
}
- (NSD *)dicKey:(NSS *)defaultName       {
	NSDictionary *dictionary = self[defaultName];
	return [dictionary isKindOfClass:objc_lookUpClass("NSDictionary")] ? dictionary : (NSD *)nil;
}
- (BOOL)boolKey:(NSS *)defaultName {
	id object = self[defaultName];
	return [object isKindOfAnyClass:@[NSNumber.class, NSString.class]] ? [object boolValue] : NO;
}
- (NSI)iKey:(NSS *)defaultName       {
	id number = self[defaultName];
	return [number isKindOfClass:objc_lookUpClass("NSString")]
	? [(NSS *)number intValue]
	: [number isKindOfClass:objc_lookUpClass("NSNumber")]
	? [(NSN *)number intValue] : 0;
}
- (CGF)fKey:(NSS *)defaultName       {
	id number = self[defaultName];
	return [number isKindOfClass:objc_lookUpClass("NSString")]
	? [(NSS *)number floatValue]
	: [number isKindOfClass:objc_lookUpClass("NSNumber")]
	? [(NSN *)number floatValue] : 0.0;
}
- (CAL *)colored:(NSC *)color	  {
	self.bgC = [color CGColor];  return self;
}
- (CAL *)named:(NSS *)name	{
	self.name = name;  return self;
}
- (CAL *)withFrame:(NSR)frame	{
	self.frame = frame; return self;
}
- (CAL *)withConstraints:(NSA *)cnst {
	[self addConstraints:cnst]; return self;
}
- (CAL *)hitTestSubs:(CGPoint)point     {
	NSA *a = [self.sublayers filter:^BOOL (CAL *object) {
	return [object hitTest:point];
	}];
	return a.count ? [a sortedWithKey:@"zPosition" ascending:NO].first : nil;
}
- (id)copyLayer	      {
	//	id newOne = [self.class.alloc init];
	//	NSD* newD =
	//	NSLog(@"copying layer with props: %@", newD);
	//	return AZ_RETAIN
	id layer = CALayer.layer;  NSLog(@"copying layer: %@", self);
	//	[layer setPropertiesWithDictionary:	[[self.modelLayer properties] subdictionaryWithKeys:
	//		 [[[self.modelLayer propertyNames]filter:^BOOL(id object) {
	//			  return [self respondsToSelector:NSSelectorFromString(
	//			[@"set" withString:[(NSS*)object capitalizedString]])];
	//			}]allKeys]]];
	//	[[self.class propertyNames] each:^(id obj) {
	//	if ([layer respondsToSelector:[CAL setterForPropertyNamed:obj]] )
	//		[((CAL*)layer) setValue:(id)[((CAL*)self) valueForKey:obj] forKey:obj];
	//	}];
	BOOL copy = [self.name contains:@".copy."];
	if (copy) {
	NSI generation	       = [[self.name pathExtension] integerValue] + 1;
	((CAL *)layer).name      = [self.name stringByReplacingPathExtensionWithExtension:AZString(generation)];
	}
	else ((CAL *)layer).name	= [self.name withString:@".copy.1"];
	((CAL *)layer).frame	  = self.frame;
	((CAL *)layer).bgC	 = self.bgC;
	((CAL *)layer).borderColor       = self.borderColor;
	((CAL *)layer).borderWidth       = self.borderWidth;
	((CAL *)layer).constraints       = self.constraints;
	((CAL *)layer).arMASK	 = self.arMASK;
	((CAL *)layer).mask	= self.mask;
	((CAL *)layer).contents          = self.contents;

	return layer;
	//	}];// setPropertiesWithDictionary:newD];
	//	return newOne;
}
- (void)addSublayer:(CAL *)layer named:(NSS *)name       {
	layer.name = name; [self addSublayer:layer];
}
- (void)addSublayerImmediately:(CAL *)sub       {
	[CATransaction immediately:^{   [self addSublayer:sub]; }];
}
- (void)addSublayersImmediately:(NSA *)subArray {
	[CATransaction immediately:^{   [self addSublayers:subArray];   }];
}
- (void)insertSublayerImmediately:(CAL *)sub atIndex:(NSUI)idx {
	[CATransaction immediately:^{   [self insertSublayer:sub atIndex:idx];  }];
}
- (void)setValueImmediately:(id)v forKey:(id)key {
	[CATRANNY immediately:^{ [self setValue:v forKey:key];  }];
}
- (void)toggleSpin:(AZState)state     {
	AZState exist = [self unsignedIntegerForKey:@"spinState"];
	if (exist == state) return;
	if (state == AZOff || ( state == (AZState)NSNotFound && exist == AZOn)) {
	[self removeAllAnimations];
	}
	else {
	CABA *animation = [CABA animationWithKeyPath:@"transform.rotation"];
	animation.duration	   = 8.0;
	animation.repeatCount   = HUGE_VALF;
	animation.autoreverses  = NO;
	animation.fromValue	  = @0;
	animation.toValue	    = @(TWOPI);
	[self addAnimation:animation forKey:@"rotation"];
	}
	[self setUnsignedInteger:state forKey:@"spinState"];
}
- (void)moveToFront {
	[self removeFromSuperlayer];
	[self.superlayer addSublayer:self];
}
- (void)setValue:(id)value forKeyPath:(NSS *)keyPath
	  duration:(CFTimeInterval)duration delay:(CFTimeInterval)delay {
	[CATransaction immediately:^{
	[self setValue:value forKeyPath:keyPath];
	CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:keyPath];
	anim.duration = duration;
	anim.beginTime = CACurrentMediaTime() + delay;
	anim.fillMode = kCAFillModeBoth;
	anim.fromValue = [[self presentationLayer] valueForKey:keyPath];
	anim.toValue = value;
	[self addAnimation:anim forKey:keyPath];
	}];
}
@dynamic root, text, orient;

- (NSA*) sublayersRecursive { return [self.sublayers reduce:@[].mutableCopy withBlock:^id(id sum, id obj) {
			if (![obj sublayers].count) [sum addObject:obj]; else [sum addObjectsFromArray:[obj sublayersRecursive]];
			return sum;
	}];
}
- (NSW*) window {

	return [[NSW.allWindows vFKP:@"contentView.layer"] filterOne:^BOOL(id object) {
		return [[object sublayersRecursive] containsObject:self];
	}];
}

- (void) setSublayerMouseOverBlock:(void(^)(CAL*layer))block {  id monitor;

	[self.window setAcceptsMouseMovedEvents:YES]; __block CAL* hitLayer;
	if ((!block && (monitor =[self vFK:@"mouseOverBlock"])) || monitor ) [NSE removeMonitor:monitor];
	[self sV:monitor = [NSEVENTLOCALMASK:NSMouseMovedMask handler:^NSEvent *(NSEvent *e){
		CAL* l = [self hitTestSubs:[self convertPoint:e.locationInWindow fromLayer:nil]];
		if (l && l!=hitLayer) {  hitLayer = l;  block(hitLayer); }
		return e;
	}] fK:@"mouseOverBlock"];
}


- (void)setText:(CATXTL *)text	     {
	objc_setAssociatedObject(self, &TEXT_IDENTIFIER, text, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	self.text ? [self replaceSublayer:self.text with:text] : [self addSublayer:text];
	[self setNeedsLayout];  [self setNeedsDisplay];
}
- (CATXTL *)text	 {
	return (CATXTL *)objc_getAssociatedObject(self, &TEXT_IDENTIFIER);
}
- (void)setRoot:(CAL *)root	      {
	objc_setAssociatedObject(self, &ROOT_IDENTIFIER, root, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	self.root ? [self replaceSublayer:self.root with:root] : [self addSublayer:root];
	[self setNeedsLayout];  [self setNeedsDisplay];
}
- (CAL *)root	   {
	return (CAL *)objc_getAssociatedObject(self, &ROOT_IDENTIFIER);
}
- (void)setOrient:(AZPOS)orient	  {
	objc_setAssociatedObject(self, &ORIENT_IDENTIFIER, @(orient), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	if ( [self hasPropertyForKVCKey:@"anchorPoint"] ) {
	CGP newA = AZAnchorPointForPosition(orient);
	if ( !NSEqualPoints(newA, self.anchorPoint) ) [self setAnchorPoint:newA];
	}
	[self sublayersBlock:^(CAL *layer) {
	[layer setNeedsDisplay];
	[layer setNeedsLayout];
	}];
}
- (AZPOS)orient	 {
	return (AZPOS)[objc_getAssociatedObject(self, &ORIENT_IDENTIFIER) unsignedIntegerValue];
}
- (NSN *)addValues:(int)count, ...{
	va_list args;
	va_start(args, count);
	NSNumber *value;
	double retval;
	for ( int i = 0; i < count; i++ ) {
	value = va_arg(args, NSNumber *);
	retval += [value doubleValue];
	}
	va_end(args);
	return @(retval);
}
- (void)animateXThenYToFrame:(NSR)toRect duration:(NSUI)time  {
	//	NSRect max, min;
	//	max = AZIsRectRightOfRect(self.frame,toRect) ? self.frame : toRect;
	//	min = NSEqualRects(max, self.frame) ? toRect : self.frame;
	//	NSPOint dist = AZNormalizedDistanceToCenterOfRect(self.position,toRect);
	//	AZCenterDistanceOfRects(self.frame, ).x	//	self > AZCenterOfRect( toRect).x ? self.position :
	NSP interim     = (NSP) {AZCenterOfRect(toRect).x, self.position.y}; //AZPointOffsetX(self.position, );
	//	[CATransaction transactionWithLength:1 actions:^{
	//	[CATransaction transactionWithLength:1 actions:^{
	[self boolForKey:@"animating"] ? [CATransaction immediately:^{  self.position = self.position;  }] : nil;
	[self setBool:YES forKey:@"animating"];
	[CATransaction transactionWithLength:1 actions:^{
	[CATransaction setCompletionBlock:^(void) {
		[CATransaction transactionWithLength:1 actions:^{
		self.position = AZCenterOfRect( toRect);
		[CATransaction setCompletionBlock:^{
	[self setBool:NO forKey:@"animating"];
		}];
		}];
	}];
	self.position = interim;
	}];
}
/*
 + (NSA*)uncodableKeys {	return [self propertyNames];	}
 - (void)setWithCoder:(NSCoder *)coder{	[super setWithCoder:coder];[self autoEncodeWithCoder:coder];}
 - (void)encodeWithCoder:(NSCoder *)coder{	[super encodeWithCoder:coder];
 [self autoDecode:coder]; //encodeObject:ENCODE_VALUE(self.newProperty) forKey:@"uncodableProperty"];	}
 [[self.class uncodableKeys] each:^(NSS* key) {
 [self autoEncodeWithCoder:coder]  ;//]}= DECODE_VALUE([[coder decodeObjectForKey:@"uncodableProperty"];	}];
 }
 - (void)encodeWithCoder:(NSCoder *)coder	{	[super encodeWithCoder:coder];
 [coder encodeObject:ENCODE_VALUE(self.newProperty) forKey:@"uncodableProperty"];	}
 - (id)copyWithZone:(NSZone *)zone {  return [self.class.alloc initWithCoder:NSCoder.new];	}
 self.position = nanPointCheck(AZCenterOfRect(toRect));
 self.bounds =	AZMakeRectFromSize( nanSizeCheck( toRect.size ));
 }];
 CAAG *group = [CAAG animation];
 CABA *posX	= [CABA animationWithKeyPath:@"position.x"];
 CABA *posY  = [CABA animationWithKeyPath:@"position.y"];
 CABA *bndr	= [CABA animationWithKeyPath:@"bounds"];
 CGF baseTime = [self convertTime:CACurrentMediaTime() fromLayer:nil];
 //	anim.beginTime = baseTime + (delay * i++);
 group.animations    = [@[posX, posY, bndr] nmap:^id(CABA *obj, NSUInteger idx) {
 obj.removedOnC	= NO;
 obj.fillMode    = kCAFillModeForwards;
 obj.duration	= idx <= 1 ? (time / 2) : time;
 obj.beginTime	= idx == 0 || idx == 2  ? baseTime : (baseTime + (time / 2));
 NSP interim     = NSMakePoint( AZCenterOfRect(toRect).x, self.position.y);
 obj.fromValue   = idx == 0 ? AZVpoint( self.position )
 : idx == 1 ? AZVpoint( interim )
 :		 AZVrect( self.bounds );
 obj.toValue	= idx == 0 ? AZVpoint( interim )
 : idx == 1 ? AZVpoint( AZCenterOfRect(toRect) )
 :	 AZVrect ( AZMakeRectFromSize(toRect.size) );
 return obj;
 }];
 [self addAnimation:group forKey:nil];
 [CATransaction commit];
 */
- (void)blinkLayerWithColor:(NSC *)color	 {
	CABasicAnimation *blinkAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
	[blinkAnimation setDuration:0.2];
	[blinkAnimation setAutoreverses:YES];
	[blinkAnimation setFromValue:(id)self.backgroundColor];
	[blinkAnimation setToValue:(id)color.CGColor];
	[self addAnimation:blinkAnimation forKey:@"blink"];
}
- (CAL *)hitTestEvent:(NSE *)e inView:(NSV *)v	     {
	NSPoint mD = [NSScreen convertAndFlipEventPoint:e relativeToView:v];
	return [self hitTest:mD];
}
- (CAL *)hitTest:(NSP)p inView:(NSV *)v forClass:(Class)klass     {
	NSPoint pp =  [NSScreen convertAndFlipMousePointInView:v];
	CAL *layer = [self hitTest:pp];
	while (layer != nil && ![layer isKindOfClass:klass])
	layer = [layer superlayer];
	return layer;
}
//How to set the CATransform3DRotate along the x-axis for a specified height with perspective
- (void)addPerspectiveForVerticalOffset:(CGF)pixels	      {
	CGF totalHeight = self.bounds.size.height; //height is 30
	CGF heightToSetViewTo = 5;
	CGF rad = acosf( heightToSetViewTo / totalHeight);
	CATransform3D rT = CATransform3DIdentity;
	rT = CATransform3DRotate(rT, rad, 1.0f, 0.0f, 0.0f);
	self.transform = rT;
	CGF zDist = 1000;
	rT.m34 = 1.0f /  -zDist;
}
//@implementation  NSObject (LayerTools)
- (CAL *)selectionLayerForLayer:(CAL *)layer	      {
	CAL *aselectionLayer = [CALayer layer];
	//	selectionLayer.bounds = CGRectMake (0.0,0.0,width,height);
	aselectionLayer.borderWidth = 4.0;
	aselectionLayer.cornerRadius = layer.cornerRadius;
	aselectionLayer.borderColor = cgWHITE;
	CIFilter *filter = [CIFilter filterWithName:@"CIBloom"];
	[filter setDefaults];
	[filter setValue:@5.0f forKey:@"inputRadius"];
	[filter setName:@"pulseFilter"];
	[aselectionLayer setFilters:@[filter]];
	// The selectionLayer shows a subtle pulse as it is displayed. This section of the code create the pulse animation setting the filters.pulsefilter.inputintensity to range from 0 to 2. This will happen every second, autoreverse, and repeat forever
	CABasicAnimation *pulseAnimation = [CABasicAnimation animation];
	pulseAnimation.keyPath = @"filters.pulseFilter.inputIntensity";
	pulseAnimation.fromValue = @0.0f;
	pulseAnimation.toValue = @2.0f;
	pulseAnimation.duration = 1.0;
	pulseAnimation.repeatCount = HUGE_VALF;
	pulseAnimation.autoreverses = YES;
	pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:
		kCAMediaTimingFunctionEaseInEaseOut];
	[aselectionLayer addAnimation:pulseAnimation forKey:@"pulseAnimation"];
	NSArray *constraints = @[       AZConstRelSuper(kCAConstraintWidth),
		  AZConstRelSuper(kCAConstraintHeight),
		  AZConstRelSuper(kCAConstraintMidX),
		  AZConstRelSuper(kCAConstraintMidY)];
	aselectionLayer.constraints = constraints;
	//	// set the first item as selected
	//	[self changeSelectedIndex:0];
	//
	//	// finally, the selection layer is added to the root layer
	//	[rootLayer addSublayer:self.selectionLayer];
	return aselectionLayer;
}
- (void)toggleLasso:(BOOL)state	{	//:(CATransform3D)transform {
	if (state) {
	AZLOG($(@"TOGGLING LASSO ON for %@", self));
	[[[[self superlayers] filterOne:^BOOL (id object) {
		return [object[@"name"] isEqualToAnyOf:@[@"root", @"host"]];
	}] sublayers]each:^(id obj) {
		[obj sublayersBlockSkippingSelf:^(CAL *layer) {
		if ([layer.name isEqualToString:@"lasso"]) [layer removeFromSuperlayer];
		}];
	}];
	}
	else { CAShapeLayer *lasso = [self lassoLayerForLayer:self];
	lasso.name = @"lasso";  [self addSublayer:lasso]; }
	//	[self sublayersBlockSkippingSelf:^(CAL*layer) {
	//	[layer[@"name"] isEqualToString:@"lasso"
	//	}]
	//	BOOL isFlipped = [[self valueForKey:@"flipped"]boolValue];
	//	isFlipped ? [self flipBack] : [self flipOver];
	//	[self setValue:@(isFlipped =! isFlipped) forKey:@"flipped"];
}
- (id)lassoLayerForLayer:(CAL *)layer	  {
	//	NSLog(@"Clicked: %@", [[layer valueForKey:@"azfile"] propertiesPlease] );
	CAShapeLayerNoHit *shapeLayer = [CAShapeLayerNoHit layer];
	shapeLayer[@"mommy"]	 = layer;
	CGF dynnamicStroke	   = .05 * AZMaxDim(layer.bounds.size);
	CGF half	  = dynnamicStroke / 2;
	shapeLayer.bounds	 = NSInsetRect(layer.bounds, dynnamicStroke, dynnamicStroke);
	shapeLayer.autoresizingMask     = kCALayerWidthSizable | kCALayerHeightSizable;
	shapeLayer.constraints          = @[	 AZConstScaleOff( kCAConstraintMinX, @"superlayer", 1, half),
			//         AZConstScaleOff( kCAConstraintMaxX,@"superlayer", 1,2),
			AZConstScaleOff( kCAConstraintMinY, @"superlayer", 1, half),	  /*2),*/
			AZConstScaleOff( kCAConstraintMaxY, @"superlayer", 1, half),
			AZConstScaleOff( kCAConstraintWidth, @"superlayer", 1, -dynnamicStroke),
			AZConstScaleOff( kCAConstraintHeight, @"superlayer", 1, -dynnamicStroke),
			AZConstRelSuper(kCAConstraintMidX),
			AZConstRelSuper(kCAConstraintMidY) ];
	//	[shapeLayer setPosition:CGPointMake(.5,.5)];
	//	shapeRect.size.width -= dynnamicStroke;	shapeRect.size.height -= dynnamicStroke;
	shapeLayer.fillColor    = cgCLEARCOLOR;
	shapeLayer.strokeColor  = cgBLACK; // [[[layer valueForKey:@"azfile"]valueForKey:@"color"]CGColor];
	shapeLayer.lineWidth    = half;
	shapeLayer.lineJoin	  = kCALineJoinRound;
	shapeLayer.lineDashPattern = @[ @(20), @(20)];
	shapeLayer.path = [[NSBezierPath bezierPathWithRoundedRect:shapeLayer.bounds cornerRadius:layer.cornerRadius] quartzPath];
	shapeLayer.zPosition = 3300;
	CABasicAnimation *dashAnimation = [CABasicAnimation animationWithKeyPath:@"lineDashPhase"];
	[dashAnimation setValuesForKeysWithDictionary:@{        @"fromValue": @(0.0),    @"toValue": @(40.0),
				  @"duration": @(0.75), @"repeatCount": @(10000) }];
	[shapeLayer addAnimation:dashAnimation forKey:@"linePhase"];
	[shapeLayer needsDisplay];
	return shapeLayer;
}
- (CAT3D)makeTransformForAngle:(CGF)angle	       { // from:(CATransform3D)start{
	CATransform3D transform = self.transform; // = start;
		// the following two lines are the key to achieve the perspective effect
	CATransform3D persp = CATransform3DIdentity;
	persp.m34 = 1.0 / -500;
	transform = CATransform3DConcat(transform, persp);
	transform = CATransform3DRotate(transform, angle, 0.0, 1.0, 0.0);
	return transform;
}
- (id)objectForKeyedSubscript:(NSS *)key	      {
	return [self valueForKey:key] ? : nil;
}
- (void)setObject:(id)object forKeyedSubscript:(NSS *)key	    {
	if ( [self canSetValueForKey:key]) {
	if (isEmpty(object)) [self setValue:@"" forKey:key];
	else{
		[self setValue:object forKey:key];
		//		NSLog(@"setValue: %@ for layer's key: %@", object, key)
	}
	}
}
- (void)rotateAroundYAxis:(CGF)radians	  {
	[self vFK:@"animating"] ? ^{ return; } () : ^{ [self setValue:@(YES) forKey:@"animating"];
	[CATransaction transactionWithLength:1 easing:CAMEDIAEASY actions:^{
		self.sublayerTransform = CATransform3DMakeRotation(radians, 0, 1, 0);
	}]; } ();
}
- (void)setHostingLayerAnchorPoint:(CGP)point	      {
	CAL *topLayer = [self.superlayers lastObject];
	topLayer.anchorPoint = point;
	//	topLayer.frame = [layerView bounds];
}
- (void)animateCameraToPosition:(CGP)point	      {
	[self vFK:@"animating"] ? ^{ return; } () : ^{ [self setValue:@(YES) forKey:@"animating"];
	[CATransaction transactionWithLength:2 easing:CAMEDIAEASY actions:^{
		//	} setCompletionBlock:^ { // referencing mBeingAnimated creates a retain cycle as the block will retain self mBeingAnimated = NO; }];
		CGF cameraX = percent(point.x); //[cameraXField doubleValue]);
		CGF cameraY = percent(point.y); //[cameraYField doubleValue]);
		[self setHostingLayerAnchorPoint:(CGPoint) {cameraX, cameraY}];
	}];
	[self setValue:@(NO) forKey:@"animating"]; } ();
}
- (void)rotateBy45     {
	[self vFK:@"animating"] ? ^{ return; } () : ^{ [self setValue:@(YES) forKey:@"animating"];
	[self rotateAroundYAxis:M_PI_4];
	[self setValue:@(NO) forKey:@"animating"]; } ();
}
- (void)rotateBy90     {
	[self rotateAroundYAxis:M_PI_2];
}
- (void)animateToColor:(NSC *)color {
	[self animateToColor:color duration:2 withCallBack:NO];
}
- (void (^)(void))animateToColor:(NSColor *)color duration:(NSTI)interval withCallBack:(BOOL)itRezhuzhesTheColor {
	NSColor *saved = self.bgC == NULL ? CLEAR : [NSColor colorWithCGColor:self.bgC];
	NSString *key = [self isKindOfClass:[CAShapeLayer class]] ? @"fillColor" : @"backgroundColor";
	CABasicAnimation *anime = [CABasicAnimation animationWithKeyPath:key];
	anime.fromValue      = self.bgC == NULL ? (id)cgCLEARCOLOR : (id)self.bgC;
	anime.toValue	= (id)color.CGColor;
	anime.duration          = interval;
	anime.autoreverses      = NO;
	anime.fillMode          = kCAFillModeBoth; //kCAFillModeForwards;
	anime.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
	anime.removedOnCompletion = NO;
	[self addAnimation:anime forKey:@"color"];
	return itRezhuzhesTheColor ? ^{  [self animateToColor:saved duration:interval withCallBack:NO]; } : ^{};
}
/*
 - (CAShapeLayer*) lassoLayerForLayer:(CAL*)layer {
 NSLog(@"Clicked: %@", [[layer valueForKey:@"azfile"] propertiesPlease] );
 CAShapeLayer *shapeLayer = [CAShapeLayer layer];
 [shapeLayer setValue:layer forKey:@"mommy"];
 //	float total =   ( (2*contentLayer.bounds.size.width) + (2*contentLayer.bounds.size.height) - (( 8 - ((2 * pi) * contentLayer.cornerRadius))));
 CGRect shapeRect = layer.bounds;
 [shapeLayer setBounds:shapeRect];
 //	[shapeLayer setAutoresizingMask:kCALayerWidthSizable|kCALayerHeightSizable];
 NSArray *constraints = [NSArray arrayWithObjects:
 AZConstScaleOff( kCAConstraintMinX,@"superlayer", 1,2),
 AZConstScaleOff( kCAConstraintMaxX,@"superlayer", 1,2),
 AZConstScaleOff( kCAConstraintMinY,@"superlayer", 1,2),
 AZConstScaleOff( kCAConstraintMaxY,@"superlayer", 1,2),
 AZConstScaleOff( kCAConstraintWidth,@"superlayer", 1,-4),
 AZConstScaleOff( kCAConstraintHeight,@"superlayer", 1, -4),
 AZConst( kCAConstraintMidX,@"superlayer"),
 AZConst( kCAConstraintMidY,@"superlayer"),  nil];
 shapeLayer.constraints = constraints;
 //	[shapeLayer setPosition:CGPointMake(.5,.5)];
 [shapeLayer setFillColor:cgCLEARCOLOR];
 [shapeLayer setStrokeColor: [[[layer valueForKey:@"azfile"]valueForKey:@"color"]CGColor]];
 [shapeLayer setLineWidth:4];
 [shapeLayer setLineJoin:kCALineJoinRound];
 [shapeLayer setLineDashPattern:@[ @(10), @(5)]];
 //	 [NSArray arrayWithObjects:[NSNumber numberWithInt:10],
 //	  [NSNumber numberWithInt:5],
 //	  nil]];
 // Setup the path
 shapeRect.size.width -= 4;
 shapeRect.size.height -= 4;
 NSBezierPath *p = [NSBezierPath bezierPathWithRoundedRect:NSRectFromCGRect(shapeRect) cornerRadius:layer.cornerRadius];
 //	CGMutablePathRef path = CGPathCreateMutable();
 //	CGPathAddRect(path, NULL, shapeRect);
 //	[shapeLayer setPath:path];
 //	CGPathRelease(path);
 [shapeLayer setPath:[p quartzPath]];
 CABasicAnimation *dashAnimation = [CABasicAnimation animationWithKeyPath:@"lineDashPhase"];
 [dashAnimation setFromValue:[NSNumber numberWithFloat:0.0f]];
 [dashAnimation setToValue:[NSNumber numberWithFloat:15.0f]];
 [dashAnimation setDuration:0.75f];
 [dashAnimation setRepeatCount:10000];
 [shapeLayer addAnimation:dashAnimation forKey:@"linePhase"];
 //	float total = (((2* NSMaxX(contentLayer.frame)) + (2 * NSMaxY(box.frame)))/16);
 //	CABasicAnimation *dashAnimation = [CABasicAnimation animationWithKeyPath:@"lineDashPhase"];
 //	dashAnimation.fromValue     = $float(0.0f);	dashAnimation.toValue   = $float
 //	(total);
 //
 //	dashAnimation.duration	= 3;		dashAnimation.repeatCount = 10000;
 //	//	dashAnimation.beginTime = CACurrentMediaTime();// + 2;
 //	[shapeLayer addAnimation:dashAnimation forKey:@"linePhase"];
 //	shapeLayer.fillColor        = cgRED;
 //	shapeLayer.strokeColor	= cgBLACK;
 //	shapeLayer.lineJoin		= kCALineJoinMiter;
 //	shapeLayer.lineDashPattern  = $array( $int(total/8), $int(total/8));
 //
 //	//		srelectedBox.shapeLayer.lineDashPattern     = $array( $int(15), $int(45));
 //	shapeLayer.lineWidth = 5;
 //	[shapeLayer setPath:[[NSBezierPath bezierPathWithRoundedRect:contentLayer.bounds cornerRadius:contentLayer.cornerRadius ] quartzPath]];
 return shapeLayer;
 }


 CAAnimation * animation = [[CAAnimation animation] animationWithKeyPath:@"backgroundColor"];
 NSDictionary *dic = $map(	(id)[color1 CGColor],   @"fromValue",		 (id)[color2 CGColor],  @"toValue",
 $float(2.0),	  @"duration",	 YES,	@"removedOnCompletion",
 kCAFillModeForwards,     @"fillMode");
 [animation setValuesForKeysWithDictionary:dic];	[theLayer addAnimation:animation forKey:@"color"];
 + (CAShapeLayer*) lassoLayerForLayer:(CAL*)layer {
 //	NSLog(@"Clicked: %@", [[layer valueForKey:@"azfile"] propertiesPlease] );
 CAShapeLayer *shapeLayer = [CAShapeLayer layer];
 //	[shapeLayer setValue:layer forKey:@"mommy"];
 //	float total =   ( (2*contentLayer.bounds.size.width) + (2*contentLayer.bounds.size.height) - (( 8 - ((2 * pi) * contentLayer.cornerRadius))));
 CGRect shapeRect = layer.bounds;
 shapeLayer.frame = shapeRect;
 //	[shapeLayer setAutoresizingMask:kCALayerWidthSizable|kCALayerHeightSizable];
 NSArray *constraints = [NSArray arrayWithObjects:
 AZConstScaleOff( kCAConstraintMinX,@"superlayer", 1,2),
 AZConstScaleOff( kCAConstraintMaxX,@"superlayer", 1,2),
 AZConstScaleOff( kCAConstraintMinY,@"superlayer", 1,2),
 AZConstScaleOff( kCAConstraintMaxY,@"superlayer", 1,2),
 AZConstScaleOff( kCAConstraintWidth,@"superlayer", 1,-4),
 AZConstScaleOff( kCAConstraintHeight,@"superlayer", 1, -4),
 AZConst( kCAConstraintMidX,@"superlayer"),
 AZConst( kCAConstraintMidY,@"superlayer"),  nil];
 shapeLayer.constraints = constraints;
 [shapeLayer setFillColor:cgCLEARCOLOR];
 [shapeLayer setStrokeColor: [[[layer valueForKey:@"azfile"]valueForKey:@"color"]CGColor]];
 [shapeLayer setLineWidth:4];
 [shapeLayer setLineJoin:kCALineJoinRound];
 [shapeLayer setLineDashPattern:@[ @(10), @(5)]];
 // Setup the path
 shapeRect.size.width -= 4;
 shapeRect.size.height -= 4;
 //	CGMutablePathRef path = CGPathCreateMutable();
 //	CGPathAddRect(path, NULL, shapeRect);
 //	[shapeLayer setPath:path];
 //	CGPathRelease(path);
 [shapeLayer setPath:[[NSBezierPath bezierPathWithRoundedRect:shapeRect
 cornerRadius:layer.cornerRadius] quartzPath]];
 CABasicAnimation *dashAnimation = [CABasicAnimation animationWithKeyPath:@"lineDashPhase"];
 [dashAnimation setFromValue:@(0.0f)];
 [dashAnimation setToValue:@(15.0f)];
 [dashAnimation setDuration:0.75f];
 [dashAnimation setRepeatCount:10000];
 [shapeLayer addAnimation:dashAnimation forKey:@"linePhase"];
 //	float total = (((2* NSMaxX(contentLayer.frame)) + (2 * NSMaxY(box.frame)))/16);
 //	CABasicAnimation *dashAnimation = [CABasicAnimation animationWithKeyPath:@"lineDashPhase"];
 //	dashAnimation.fromValue     = $float(0.0f);	dashAnimation.toValue   = $float
 //	(total);
 //
 //	dashAnimation.duration	= 3;		dashAnimation.repeatCount = 10000;
 //	//	dashAnimation.beginTime = CACurrentMediaTime();// + 2;
 //	[shapeLayer addAnimation:dashAnimation forKey:@"linePhase"];
 //	shapeLayer.fillColor        = cgRED;
 //	shapeLayer.strokeColor	= cgBLACK;
 //	shapeLayer.lineJoin		= kCALineJoinMiter;
 //	shapeLayer.lineDashPattern  = $array( $int(total/8), $int(total/8));
 //
 //	//		srelectedBox.shapeLayer.lineDashPattern     = $array( $int(15), $int(45));
 //	shapeLayer.lineWidth = 5;
 //	[shapeLayer setPath:[[NSBezierPath bezierPathWithRoundedRect:contentLayer.bounds cornerRadius:contentLayer.cornerRadius ] quartzPath]];
 [layer addSublayer:shapeLayer];
 [shapeLayer addConstraintsSuperSize];
 return shapeLayer;
 }
 - (void) redrawPath {
 CAL*selected = [_lassoLayer valueForKey:@"mommy"];
 CGRect shapeRect = selected.bounds;
 shapeRect.size.width -= 4;
 shapeRect.size.height -= 4;
 CGMutablePathRef path = CGPathCreateMutable();
 CGPathAddRect(path, NULL, shapeRect);
 [_lassoLayer setPath:path];
 CGPathRelease(path);
 [_contentLayer setNeedsDisplay];
 }
 */
/*
 CATransform3D t =
 CATransform3DConcat(
 CATransform3DMakeRotation(x, 0, 1, 0),
 CATransform3DMakeRotation( y, 1, 0, 0));
 t        = [self hasPropertyForKVCKey:@"sublayerTransform"] ? CATransform3DConcat(self.sublayerTransform, t) : t;
 t.m34	= [self hasPropertyForKVCKey:@"sublayerTransform.m34"] ? self.sublayerTransform.m34 : 1.0 / -450;
 self.sublayerTransform = t;
 - (void)orientOnEvent: (NSEvent*)event;
 {
 CGPoint point = NSPointToCGPoint([self convertPoint:theEvent.locationInWindow fromView:nil]);
 draggedDuringThisClick = true;
 deltaX = (point.x - dragStart.x)/200;
 deltaY = - (point.y - dragStart.y)/200;
 [self orientWithX:(angleX+deltaX) andY:(angleY+deltaY)];
 */
- (void)orientWithPoint:(CGP)point      {
	[self orientWithX:point.x andY:point.y];
}
- (void)orientWithX:(CGF)x andY:(CGF)y  {
	CAT3D t = CATransform3DConcat(  CATransform3DMakeRotation(x, 0, 1, 0),  CATransform3DMakeRotation( y, 1, 0, 0) );
	t.m34	= 1.0 / -450;   self.sublayerTransform  = t;
}
- (void)setAnchorPoint:(CGP)anchor inView:(NSV *)v      {
	[self setAnchorPoint:anchor inRect:v.bounds];
}
- (void)setAnchorPointRelative:(CGP)anchor	 {
	[self setAnchorPoint:anchor inRect:self.bounds];
}
- (void)setAnchorPoint:(CGP)anchor inRect:(NSR)rect   {
	CGP newPoint = (CGP) {rect.size.width *anchor.x, rect.size.height *anchor.y };
	CGP oldPoint = (CGP) {rect.size.width *self.anchorPoint.x, rect.size.height *self.anchorPoint.y };
	//	newPoint = CGPo CGPointApplyAffineTransform(newPoint, self.transform); oldPoint = CGPointApplyAffineTransform(oldPoint, self.transform);
	CGP position = self.position;
	position.x -= oldPoint.x;       position.x += newPoint.x;
	position.y -= oldPoint.y;       position.y += newPoint.y;
	self.position	= position;
	self.anchorPoint        = anchor;
}
//- (void) flipHorizontally {	[self flipForward:YES vertically:NO atPosition:99]; }
//- (void) flipVertically;  {	[self flipForward:YES vertically:YES atPosition:99]; }
- (void)flipBackAtEdge:(AZPOS)position {
	[self flipForward:NO atPosition:position];
}
- (void)flipForwardAtEdge:(AZPOS)position {
	[self flipForward:YES atPosition:position];
}
- (void)toggleFlip  {
	BOOL isFlipped = [self boolForKey:@"flipped"];// defaultValue:NO];
	isFlipped ? [self flipBack] : [self flipOver];
	[self setBool:isFlipped = !isFlipped forKey:@"flipped"];
}
- (void)flipDown  {        //:(CATransform3D)transform {
	self.anchorPoint = CGPointMake(.5, 0);
	CATransform3D transform = CATransform3DIdentity;
	transform.m34 = 1.0 / 700.0;
	self.transform = CATransform3DRotate(transform, 180 * M_PI / 180, 1, 0, 0);
}
- (void)flipOver  {        //:(CATransform3D)transform {
	CATransform3D transform = CATransform3DIdentity;
	transform.m34 = 1.0 / 700.0;
	self.transform = CATransform3DRotate(transform, 180 * M_PI / 180, 1, 0, 0);
}
- (void)flipBack  {        //:(CATransform3D)transform {
	CATransform3D transform = CATransform3DIdentity;
	transform.m34 = 1.0 / 700.0;
	self.transform =  CATransform3DRotate(transform, 180 * M_PI / 180, -1, 0, 0);
}
+ (CATransform3D)flipAnimationPositioned:(AZPOS)pos {
	CGPoint dir = (CGPoint) {pos == AZPositionTop || pos == AZPositionBottom ? 1 : 0,
	pos == AZPositionTop || pos == AZPositionBottom ? 0 : 1 };
	return CATransform3DMakeRotation(DEG2RAD(180), dir.x, dir.y, 0.0f);
}
//	![self[@"flipped"] || ![self hasPropertyForKVCKey:@"orient"] ? ^{
////	[self setAnchorPointRelative:self.position];
//	[self setAnchorPoint:AZAnchorPointForPosition(pos)
//	  inRect:self.bounds];
////	CATransform3D orig = CATransform3DIsIdentity(self.transform) ? CATransform3DIdentity : self.transform;
//	self[@"savedTransform"] = AZV3d(self.transform);//AZV3d(orig);
//	self[@"flippedTransform"] = AZV3d([CAL flipAnimationPositioned:pos]);
//	self[@"flipped"] = @NO;
//	}():nil;
- (void)flipForward:(BOOL)forward atPosition:(AZPOS)pos duration:(NSTI)time   {
	CAT3D flip = [self flipForward:NO atPosition:pos];
	[self animate:@"transform" toTransform:flip time:time eased:CAMEDIAEASY completion:^{
	NSLog(@"flipped: %@", StringFromCATransform3D(flip));
	}];
}
- (CAT3D)flipForward:(BOOL)forward atPosition:(AZPOS)pos      {
	[self setAnchorPoint:AZAnchorPointForPosition(pos) inRect:self.frame];
	CATransform3D flip = forward ? CATransform3DIdentity
	: pos == AZPositionTop || pos == AZPositionBottom ? CA3DxRotation(90) : CA3DyRotation(90);
	flip.m34 = -1 / 700;
	return flip;
}
//	CATransform3D savedFlip = [self[@"flippedTransform"]CATransform3DValue];
//	CATransform3D now = self[@"flipped"] ? CATransform3DConcat(savedOrig, savedFlip) : savedOrig;
//	CATransform3D savedOrig = [self[@"savedTransform"]	CATransform3DValue];
//	CATransform3D savedFlip = [self[@"flippedTransform"]CATransform3DValue];
//	CATransform3D now = self[@"flipped"] ? CATransform3DConcat(savedOrig, savedFlip) : savedOrig;
//		self[@"flipped"] = [self[@"flipped"]boolValue] ? @NO :@YES;
//		self.transform = now;
//		[self lassoLayerForLayer:self];
#ifdef DEBUGTALKER
//	AZTALK($(@"Old: %.1f by %.1f and new is: %.1f by %.1f", self.anchorPoint.x, self.anchorPoint.y, new.x, new.y));
#endif
#ifdef DEBUGTALKER
//	AZTALK($(@"%@ flipped", newFlipState ? @"IS" : @"is NOT "));
#endif
- (void)setScale:(CGF)scale {
	[self setValue:[NSValue valueWithSize:NSSizeToCGSize((NSSize) {scale, scale})] forKeyPath:@"transform.scale"];
}
- (ReverseAnimationBlock)pulse  {
	CIFilter *filter = [CIFilter filterWithName:@"CIBloom"]; [filter setDefaults];
	[filter setValue:@5.0f forKey:@"inputRadius"];
	// name the filter so we can use the keypath to animate the inputIntensity attribute of the filter
	[filter setName:@"pulseFilter"];
	// set the filter to the selection layer's filters
	[self setFilters:@[filter]];
	// create the animation that will handle the pulsing.
	CABasicAnimation *pulseAnimation = [CABasicAnimation animation];
	// the attribute we want to animate is the inputIntensity of the pulseFilter
	pulseAnimation.keyPath = @"filters.pulseFilter.inputIntensity";
	// we want it to animate from the value 0 to 1
	pulseAnimation.fromValue = @0.0f;
	pulseAnimation.toValue = @1.5f;
	// over one a one second duration, and run an infinite number of times
	pulseAnimation.duration = 1.0;
	pulseAnimation.repeatCount = MAXFLOAT;
	// we want it to fade on, and fade off, so it needs to automatically autoreverse.. this causes the intensity input to go from 0 to 1 to 0
	pulseAnimation.autoreverses = YES;
	// use a timing curve of easy in, easy out..
	pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	// add the animation to the selection layer. This causes it to begin animating. We'll use pulseAnimation as the animation key name
	[self addAnimation:pulseAnimation forKey:@"pulseAnimation"];
	return ^{ [self removeAnimationForKey:@"pulseAnimation"]; };
}
- (void)addAnimations:(NSA *)anims forKeys:(NSA *)keys;   {
	[anims enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
	[self addAnimation:obj forKey:keys[idx]];
	}];
}
- (void)fadeIn  {
	//	CABasicAnimation *theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
	//	theAnimation.duration=3.5;		theAnimation.repeatCount=1;
	//	theAnimation.autoreverses=YES;	theAnimation.fromValue=@(1.0);
	//	theAnimation.toValue=@(0.0);
	//	[self addAnimation:theAnimation forKey:@"animateOpacity"];
	CABasicAnimation *theAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	theAnimation.duration =  [self animationKeys]
	? [[[self animationForKey:[self animationKeys].first] valueForKey:@"duration"]floatValue] : .5;
	theAnimation.repeatCount = 1;
	theAnimation.fillMode = kCAFillModeForwards;
	theAnimation.removedOnCompletion = NO;
	//	theAnimation.autoreverses=NO;
	theAnimation.fromValue = @(0.0);
	theAnimation.toValue = @(1.0);
	[self addAnimation:theAnimation forKey:@"animateOpacity"];
	//	disable
}
- (void)fadeOut {
	CABasicAnimation *theAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	theAnimation.duration =  [self animationKeys]
	? [[[self animationForKey:[self animationKeys].first] valueForKey:@"duration"]integerValue] : .5;
	theAnimation.repeatCount = 1;
	theAnimation.fillMode = kCAFillModeForwards; //kCAFillModeBoth;
		//  theAnimation.autoreverses=NO;
	theAnimation.removedOnCompletion = NO;
	theAnimation.fromValue = @(1.0);
	theAnimation.toValue = @(0.0);
	[self addAnimation:theAnimation forKey:@"animateOpacity"];
}
+ (instancetype)layerNamed:(NSS *)name;
{
	id a = [[self class] layer];
	a[@"name"] = name;
	return a;
}
+ (CAL *)withName:(NSString *)name inFrame:(NSRect)rect
		 colored:(NSColor *)color withBorder:(CGF)width colored:(NSColor *)borderColor;   {
	CAL *new		= [CALayer layer];
	if (name) new.name	= name;
	new.frame	= rect;
	new.position	= AZCenterOfRect(rect);
	new.borderWidth		= width;
	if (width) {
	new.borderWidth	   = width;
	new.borderColor	   = borderColor.CGColor;
	}
	if (color) new.backgroundColor = color.CGColor;
	new.contentsGravity     = kCAGravityResizeAspect;
	new.autoresizingMask    = kCALayerWidthSizable | kCALayerHeightSizable;
	return new;
}
- (CATransform3D)makeTransformForAngleX:(CGF)angle      {
	return [self makeTransformForAngle:angle from:CATransform3DIdentity];
}
- (CATransform3D)makeTransformForAngle:(CGF)angle from:(CATransform3D)start {
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
	// RESTORE if ([self isKindOfClass:[CATXTL class]]) return YES;
	CGImageRef image = (CGImageRef)[self.contents CGImage];
	if ( image ) {
	alpha = 1.0;	 //RESTORE GetPixelAlpha(image, self.bounds.size, p);
	}
	return alpha > 0.15;
}
- (CAL *)labelLayer {
	return [self sublayerWithName:kCALayerLabel];
}
- (id)sublayerWithName:(NSS *)name {
	return [self.sublayers filterOne:^BOOL (id object) {
	return [[object valueForKey:@"name"] isEqualToString:name];
	}];
	return nil;
}
- (CAL *)setLabelString:(NSS *)label {
	CATXTL *layer = (CATXTL *)[self sublayerWithName:kCALayerLabel];
	if (!label) {
	[layer removeFromSuperlayer]; return nil;
	}
	if (!layer) {
	layer = [CATXTL layer];	      layer.doubleSided = NO;
	layer.wrapped = TRUE;	     layer.fontSize = 14.0;
	layer.alignmentMode = kCAAlignmentCenter;
	layer.anchorPoint = CGPointZero;        layer.name = kCALayerLabel;
	[self addSublayer:layer];
	}
	layer.string = label;
	NSLog(@"created text layer %@", layer);
	layer.position = CGPointZero; //CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
	layer.autoresizingMask = kCALayerHeightSizable | kCALayerWidthSizable;
	layer.bounds = self.bounds;
	return layer;
}
- (CAL *)magnifier:(NSView *)view {
	CAL *lace = [[CALayer alloc]init];
	lace.frame = [view bounds];
	lace.borderWidth = 10; lace.borderColor = cgRANDOMCOLOR;
	CGContextRef context = NULL;         CGColorSpaceRef colorSpace;
	int bitmapByteCount;	      int bitmapBytesPerRow;
	int pixelsHigh = (int)[[view layer] bounds].size.height;
	int pixelsWide = (int)[[view layer] bounds].size.width;
	bitmapBytesPerRow   = (pixelsWide * 4);
	//	bitmapByteCount	 = (bitmapBytesPerRow * pixelsHigh);
	colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
	context = CGBitmapContextCreate (NULL, pixelsWide, pixelsHigh,  8, bitmapBytesPerRow,   colorSpace,     kCGImageAlphaPremultipliedLast);
	if (context == NULL) {
	NSLog(@"Failed to create context."); return nil;
	}
	CGColorSpaceRelease( colorSpace );
	[[[view layer] presentationLayer] renderInContext:context];
	//	[[[view layer] presentationLayer] recursivelyRenderInContext:context];
	lace.contents = [NSImage imageFromCGImageRef:CGBitmapContextCreateImage(context)];
	lace.contentsGravity = kCAGravityCenter;
	return lace;
	//	CGImageRef img =	NSBitmapImageRep *bitmap = [[NSBitmapImageRep alloc] initWithCGImage:img];	CFRelease(img);	return bitmap;
}
+ (CAL *)veilForView:(CAL *)view {
	int pixelsHigh = (int)[view bounds].size.height;
	int pixelsWide = (int)[view bounds].size.width;
	int bitmapBytesPerRow   = (pixelsWide * 4);
	int bitmapByteCount = (bitmapBytesPerRow * pixelsHigh);
	CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
	//	context = NULL;
	CGContextRef context = CGBitmapContextCreate (NULL, pixelsWide, pixelsHigh,
		 8,     bitmapBytesPerRow,
		 colorSpace, kCGImageAlphaNoneSkipLast);	//kCGImageAlphaNoneSkipLastkCGImageAlphaPremultipliedLast);
	if (context == NULL) {
	NSLog(@"Failed to create context.");    return nil;
	}
	CGColorSpaceRelease( colorSpace );
	[[view presentationLayer] renderInContext:context];
	CAL *layer = [CALayer layer];
	[layer setFrame:view.bounds];
	[layer setBackgroundColor:cgBLACK];
	if (view) [layer setDelegate:view];
	layer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
	layer.contents =  [NSImage imageFromCGImageRef:CGBitmapContextCreateImage(context)];
	//	.frame = [view bounds];
	layer.zPosition = 1000;
	return layer;
	//	CFBridgingRetain(//	NS)BitmapImageRep *bitmap = [[NSBitmapImageRep alloc] initWithCGImage:img];
	//	CFRelease(img);
	//	return bitmap;
}
//[Transpose Matrix][1]
- (CATransform3D)rectToQuad:(NSRect)rect quadTLX:(double)x1a quadTLY:(double)y1a quadTRX:(double)x2a quadTRY:(double)y2a quadBLX:(double)x3a quadBLY:(double)y3a quadBRX:(double)x4a quadBRY:(double)y4a        {
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
	double a = -H * (x2a * x3a * y14 + x2a * x4a * y31 - x1a * x4a * y32 + x1a * x3a * y42);
	double b = W * (x2a * x3a * y14 + x3a * x4a * y21 + x1a * x4a * y32 + x1a * x2a * y43);
	double c = H * X * (x2a * x3a * y14 + x2a * x4a * y31 - x1a * x4a * y32 + x1a * x3a * y42) - H * W * x1a * (x4a * y32 - x3a * y42 + x2a * y43) - W * Y * (x2a * x3a * y14 + x3a * x4a * y21 + x1a * x4a * y32 + x1a * x2a * y43);
	double d = H * (-x4a * y21 * y3a + x2a * y1a * y43 - x1a * y2a * y43 - x3a * y1a * y4a + x3a * y2a * y4a);
	double e = W * (x4a * y2a * y31 - x3a * y1a * y42 - x2a * y31 * y4a + x1a * y3a * y42);
	double f = -(W * (x4a * (Y * y2a * y31 + H * y1a * y32) - x3a * (H + Y) * y1a * y42 + H * x2a * y1a * y43 + x2a * Y * (y1a - y3a) * y4a + x1a * Y * y3a * (-y2a + y4a)) - H * X * (x4a * y21 * y3a - x2a * y1a * y43 + x3a * (y1a - y2a) * y4a + x1a * y2a * (-y3a + y4a)));
	double g = H * (x3a * y21 - x4a * y21 + (-x1a + x2a) * y43);
	double h = W * (-x2a * y31 + x4a * y31 + (x1a - x3a) * y42);
	double i = W * Y * (x2a * y31 - x4a * y31 - x1a * y42 + x3a * y42) + H * (X * (-(x3a * y21) + x4a * y21 + x1a * y43 - x2a * y43) + W * (-(x3a * y2a) + x4a * y2a + x2a * y3a - x4a * y3a - x2a * y4a + x3a * y4a));
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
//NSImage *image = // load a image
//CAL*layer = [CALayer layer];
//[layer setContents:image];
//[view setLayer:myLayer];
//[view setFrame:NSMakeRect(0, 0, image.size.width, image.size.height)];
//view.layer.transform = [self rectToQuad:view.frame quadTLX:0 quadTLY:0 quadTRX:image.size.width quadTRY:20 quadBLX:0 quadBLY:image.size.height quadBRX:image.size.width quadBRY:image.size.height + 90];
//[1]: http://codingincircles.com/2010/07/major-misunderstanding/
+ (CAL *)closeBoxLayer   {
	CAL *layer = [CALayer closeBoxLayerForLayer:nil];
	return layer;
}
+ (CAL *)closeBoxLayerForLayer:(CAL *)parentLayer;        {
	CAL *layer = [CALayer layer];
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
- (void)flipLayer:(CAL *)top withLayer:(CAL *)bottom      {
#define ANIMATION_DURATION_IN_SECONDS (1.0)
	// Hold the shift key to flip the window in slo-mo. It's really cool!
	CGF flipDuration = ANIMATION_DURATION_IN_SECONDS; // * (self.isDebugging || window.currentEvent.modifierFlags & NSShiftKeyMask ? 10.0 : 1.0);
	// The hidden layer is "in the back" and will be rotating forward. The visible layer is "in the front" and will be rotating backward
	CAL *hiddenLayer = bottom; //[frontView.isHidden ? frontView : backView layer];
	CAL *visibleLayer = top; // [frontView.isHidden ? backView : frontView layer];
	// Before we can "rotate" the window, we need to make the hidden view look like it's facing backward by rotating it pi radians (180 degrees). We make this its own transaction and supress animation, because this is already the assumed state
	[CATransaction begin]; {
	[CATransaction setValue:@YES forKey:kCATransactionDisableActions];
	[hiddenLayer setValue:@M_PI forKeyPath:@"transform.rotation.y"];
	//	if (self.isDebugging) // Shadows screw up corner finding
	//		[self _hideShadow:YES];
	}[CATransaction commit];
	// There's no way to know when we are halfway through the animation, so we have to use a timer. On a sufficiently fast machine (like a Mac) this is close enough. On something like an iPhone, this can cause minor drawing glitches
	//	[self performSelector:@selector(_swapViews) withObject:nil afterDelay:flipDuration / 2.0];
	// For debugging, sample every half-second
	//	if (self.isDebugging) {
	//	[debugger reset];
	//	NSUInteger frameIndex;
	//	for (frameIndex = 0; frameIndex < flipDuration; frameIndex++)
	//		[debugger performSelector:@selector(sample) withObject:nil afterDelay:(CGF)frameIndex / 2.0];
	// We want a sample right before the center frame, when the panel is still barely visible
	//	[debugger performSelector:@selector(sample) withObject:nil afterDelay:(CGF)flipDuration / 2.0 - 0.05];
	//	}
	// Both layers animate the same way, but in opposite directions (front to back versus back to front)
	[CATransaction begin]; {
	[hiddenLayer addAnimation:[self _flipAnimationWithDuration:flipDuration isFront:NO] forKey:@"flipGroup"];
	[visibleLayer addAnimation:[self _flipAnimationWithDuration:flipDuration isFront:YES] forKey:@"flipGroup"];
	}[CATransaction commit];
}
- (CAAnimationGroup *)_flipAnimationWithDuration:(CGF)duration isFront:(BOOL)isFront;   {
	// Rotating halfway (pi radians) around the Y axis gives the appearance of flipping
	CABasicAnimation *flipAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
	// The hidden view rotates from negative to make it look like it's in the back
#define LEFT_TO_RIGHT (isFront ? -M_PI : M_PI)
	//#define RIGHT_TO_LEFT (isFront ? M_PI : -M_PI)
	//	flipAnimation.toValue = [NSNumber numberWithDouble:[backView isHidden] ? LEFT_TO_RIGHT : RIGHT_TO_LEFT];
	// Shrinking the view makes it seem to move away from us, for a more natural effect
	CABasicAnimation * shrinkAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	//	shrinkAnimation.toValue = [NSNumber numberWithDouble:self.scale];
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
+ (CAGL *)gradientWithColor:(NSC *)c;     {
	CAGL *h	      = CAGL.layer;
	h.colors	     =  @[ (id)c.darker.CGColor, (id)c.CGColor, (id)c.brighter.CGColor];
	h.locations     = @[ @0, @.5, @1 ];
	return h;
}
//Metallic grey gradient background
+ (CAGradientLayer *)greyGradient {
	CAGradientLayer *headerLayer = CAGradientLayer.layer;
	return headerLayer.colors = @[(id)[NSC white: 0.15f a: 1.0f].CGColor,
		(id)[NSC white: 0.19f a: 1.0f].CGColor,
		(id)[NSC white: 0.20f a: 1.0f].CGColor,
		(id)[NSC white: 0.25f a: 1.0f].CGColor],
	headerLayer.locations = @[      $float(0),
		$float(.5),
		$float(.5),
		$float(1)], headerLayer;
}
- (NSString *)debugDescription   {
	return [NSString stringWithFormat:@"<%@ (%@) frame=%@ zAnchor=%1.1f>", NSStringFromClass([self class]),
		  self.name, NSStringFromRect(self.frame), self.zPosition];
}
- (void)debugAppendToLayerTree:(NSMutableString *)treeStr indention:(NSString *)indentStr {
	[treeStr appendFormat:@"%@%@\n", indentStr, self.debugDescription];
	for (CAL *aSub in self.sublayers) {
	[aSub debugAppendToLayerTree:treeStr indention:[indentStr stringByAppendingString:@"\t"]];
	}
}
- (NSString *)debugLayerTree     {
	NSMutableString *str = [NSMutableString string];
	[self debugAppendToLayerTree:str indention:@""];
	return str;
}
- (void)addSublayers:(NSA *)subLayers;  {
	[subLayers do :^(id obj) {       [self addSublayer:obj]; }];
}
// ---------------------------------------------------------------------------
// -generateGlowingSphereLayer
// ---------------------------------------------------------------------------
// create a new "sphere" layer and add it to the container layer
+ (CAL *)newGlowingSphereLayer   {
	// generate a random size scale for glowing sphere
	NSUInteger randomSizeInt	     = (random() % 200 + 50 );
	CGF sizeScale	= (CGF)randomSizeInt / 100.0;
	NSImage *compositeImage         = [NSImage glowingSphereImageWithScaleFactor:sizeScale coreColor:WHITE glowColor:RANDOMCOLOR];
	//	CGImageRef cgCompositeImage = [compositeImage cgImage];
	// generate a random opacity value with a minimum of 15%
	NSUInteger randomOpacityInt = (random() % 100 + 15 );
	CGF opacityScale = (CGF)randomOpacityInt / 100.0;
	CAL *sphereLayer	  = [CALayer layer];
	sphereLayer.name	  = @"glowingSphere";
	sphereLayer.bounds	  = CGRectMake ( 0, 0, 20, 20 );
	sphereLayer.contents	 = compositeImage;
	sphereLayer.contentsGravity      = kCAGravityCenter;
	//	sphereLayer.delegate		= self;
	sphereLayer.opacity	= opacityScale;
	return sphereLayer;
	// "movementPath" is a custom key for just this app
	//	[self.containerLayerForSpheres addSublayer:sphereLayer];
	//	[sphereLayer addAnimation:[self randomPathAnimation] forKey:@"movementPath"];
	//	CGImageRelease ( cgCompositeImage );
}
@end

@implementation CAGradientLayer (NSColors)
@dynamic nsColors;
- (void) setNsColors:(NSArray *)nsColors {
	self.colors = [nsColors cw_mapArray:^id(id object) { return (id)[object CGColor]; }];
}
- (NSArray*)nsColors { return [self.colors cw_mapArray:^id(id object) { return [NSC colorWithCGColor:(CGColorRef)object]; }]; }
@end

//	CALayer+LTKAdditions.m
//	LTKit	Copyright (c) 2012 Michael Potter	http://lucas.tiz.ma	lucas@tiz.ma
//#import <LTKit/LTKit.h> #import "CALayer+LTKAdditions.h"
#pragma mark External Definitions
NSTimeInterval const LTKDefaultTransitionDuration = 0.25;
#pragma mark - LTKAnimationDelegate Internal Class
@interface LTKAnimationDelegate : NSObject
@property (readwrite, nonatomic, copy) void (^ startBlock)();
@property (readwrite, nonatomic, copy) void (^ stopBlock)(BOOL finished);
@end
#pragma mark - Category Implementation
@implementation LTKAnimationDelegate
@synthesize startBlock;
@synthesize stopBlock;
#pragma mark - Protocol Implementations
#pragma mark - CAAnimation Methods (Informal)
- (void)animationDidStart:(CAAnimation *)animation      {
	if (self.startBlock != nil) {
	self.startBlock();
	}
}
- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)finished       {
	if (self.stopBlock != nil) {
	self.stopBlock(finished);
	}
}
@end
#import "extobjc_OSX/extobjc.h"
@implementation NSObject (AZStates)
//@synthesizeAssociation(NSObject, selected);
//@synthesizeAssociation(NSObject, hovered);
@end
@implementation CALayer (LTKAdditions)
- (CGPoint)frameOrigin	   {
	return self.frame.origin;
}
- (void)setFrameOrigin:(CGPoint)frameOrigin     {
	CGRect frame = self.frame;
	frame.origin = frameOrigin;
	self.frame = frame;
}
- (CGSize)frameSize	   {
	return self.frame.size;
}
- (void)setFrameSize:(CGSize)frameSize	       {
	CGRect frame = self.frame;
	frame.size = frameSize;
	self.frame = frame;
}
- (CGF)frameX	   {
	return self.frame.origin.x;
}
- (void)setFrameX:(CGF)frameX   {
	CGRect frame = self.frame;
	frame.origin.x = frameX;
	self.frame = frame;
}
- (CGF)frameY   {
	return self.frame.origin.y;
}
- (void)setFrameY:(CGF)frameY   {
	CGRect frame = self.frame;
	frame.origin.y = frameY;
	self.frame = frame;
}
- (CGF)frameWidth       {
	return self.frame.size.width;
}
- (void)setFrameWidth:(CGF)frameWidth   {
	CGRect frame = self.frame;
	frame.size.width = frameWidth;
	self.frame = frame;
}
- (CGF)frameHeight      {
	return self.frame.size.height;
}
- (void)setFrameHeight:(CGF)frameHeight {
	CGRect frame = self.frame;
	frame.size.height = frameHeight;
	self.frame = frame;
}
- (CGF)frameMinX        {
	return CGRectGetMinX(self.frame);
}
- (void)setFrameMinX:(CGF)frameMinX     {
	self.frameX = frameMinX;
}
- (CGF)frameMidX        {
	return CGRectGetMidX(self.frame);
}
- (void)setFrameMidX:(CGF)frameMidX     {
	self.frameX = (frameMidX - (self.frameWidth / 2.0f));
}
- (CGF)frameMaxX        {
	return CGRectGetMaxX(self.frame);
}
- (void)setFrameMaxX:(CGF)frameMaxX     {
	self.frameX = (frameMaxX - self.frameWidth);
}
- (CGF)frameMinY        {
	return CGRectGetMinY(self.frame);
}
- (void)setFrameMinY:(CGF)frameMinY     {
	self.frameY = frameMinY;
}
- (CGF)frameMidY        {
	return CGRectGetMidY(self.frame);
}
- (void)setFrameMidY:(CGF)frameMidY     {
	self.frameY = (frameMidY - (self.frameHeight / 2.0f));
}
- (CGF)frameMaxY        {
	return CGRectGetMaxY(self.frame);
}
- (void)setFrameMaxY:(CGF)frameMaxY     {
	self.frameY = (frameMaxY - self.frameHeight);
}
- (CGPoint)frameTopLeftPoint    {
	return CGPointMake(self.frameMinX, self.frameMinY);
}
- (void)setFrameTopLeftPoint:(CGPoint)frameTopLeftPoint {
	self.frameMinX = frameTopLeftPoint.x;
	self.frameMinY = frameTopLeftPoint.y;
}
- (CGPoint)frameTopMiddlePoint  {
	return CGPointMake(self.frameMidX, self.frameMinY);
}
- (void)setFrameTopMiddlePoint:(CGPoint)frameTopMiddlePoint     {
	self.frameMidX = frameTopMiddlePoint.x;
	self.frameMinY = frameTopMiddlePoint.y;
}
- (CGPoint)frameTopRightPoint   {
	return CGPointMake(self.frameMaxX, self.frameMinY);
}
- (void)setFrameTopRightPoint:(CGPoint)frameTopRightPoint       {
	self.frameMaxX = frameTopRightPoint.x;
	self.frameMinY = frameTopRightPoint.y;
}
- (CGPoint)frameMiddleRightPoint        {
	return CGPointMake(self.frameMaxX, self.frameMidY);
}
- (void)setFrameMiddleRightPoint:(CGPoint)frameMiddleRightPoint {
	self.frameMaxX = frameMiddleRightPoint.x;
	self.frameMidY = frameMiddleRightPoint.y;
}
- (CGPoint)frameBottomRightPoint        {
	return CGPointMake(self.frameMaxX, self.frameMaxY);
}
- (void)setFrameBottomRightPoint:(CGPoint)frameBottomRightPoint {
	self.frameMaxX = frameBottomRightPoint.x;
	self.frameMaxY = frameBottomRightPoint.y;
}
- (CGPoint)frameBottomMiddlePoint       {
	return CGPointMake(self.frameMidX, self.frameMaxY);
}
- (void)setFrameBottomMiddlePoint:(CGPoint)frameBottomMiddlePoint       {
	self.frameMidX = frameBottomMiddlePoint.x;
	self.frameMaxY = frameBottomMiddlePoint.y;
}
- (CGPoint)frameBottomLeftPoint {
	return CGPointMake(self.frameMinX, self.frameMaxY);
}
- (void)setFrameBottomLeftPoint:(CGPoint)frameBottomLeftPoint   {
	self.frameMinX = frameBottomLeftPoint.x;
	self.frameMaxY = frameBottomLeftPoint.y;
}
- (CGPoint)frameMiddleLeftPoint {
	return CGPointMake(self.frameMinX, self.frameMidY);
}
- (void)setFrameMiddleLeftPoint:(CGPoint)frameMiddleLeftPoint   {
	self.frameMinX = frameMiddleLeftPoint.x;
	self.frameMidY = frameMiddleLeftPoint.y;
}
- (CGPoint)boundsOrigin {
	return self.bounds.origin;
}
- (void)setBoundsOrigin:(CGPoint)boundsOrigin   {
	CGRect bounds = self.bounds;
	bounds.origin = boundsOrigin;
	self.bounds = bounds;
}
- (CGSize)boundsSize    {
	return self.bounds.size;
}
- (void)setBoundsSize:(CGSize)boundsSize        {
	CGRect bounds = self.bounds;
	bounds.size = boundsSize;
	self.bounds = bounds;
}
- (CGF)boundsX  {
	return self.bounds.origin.x;
}
- (void)setBoundsX:(CGF)boundsX {
	CGRect bounds = self.bounds;
	bounds.origin.x = boundsX;
	self.bounds = bounds;
}
- (CGF)boundsY  {
	return self.bounds.origin.y;
}
- (void)setBoundsY:(CGF)boundsY {
	CGRect bounds = self.bounds;
	bounds.origin.y = boundsY;
	self.bounds = bounds;
}
- (CGF)boundsWidth      {
	return self.bounds.size.width;
}
- (void)setBoundsWidth:(CGF)boundsWidth {
	CGRect bounds = self.bounds;
	bounds.size.width = boundsWidth;
	self.bounds = bounds;
}
- (CGF)boundsHeight     {
	return self.bounds.size.height;
}
- (void)setBoundsHeight:(CGF)boundsHeight       {
	CGRect bounds = self.bounds;
	bounds.size.height = boundsHeight;
	self.bounds = bounds;
}
- (CGF)boundsMinX       {
	return CGRectGetMinX(self.bounds);
}
- (void)setBoundsMinX:(CGF)boundsMinX   {
	self.boundsX = boundsMinX;
}
- (CGF)boundsMidX       {
	return CGRectGetMidX(self.bounds);
}
- (void)setBoundsMidX:(CGF)boundsMidX   {
	self.boundsX = (boundsMidX - (self.boundsWidth / 2.0f));
}
- (CGF)boundsMaxX       {
	return CGRectGetMaxX(self.bounds);
}
- (void)setBoundsMaxX:(CGF)boundsMaxX   {
	self.boundsX = (boundsMaxX - self.boundsWidth);
}
- (CGF)boundsMinY       {
	return CGRectGetMinY(self.bounds);
}
- (void)setBoundsMinY:(CGF)boundsMinY   {
	self.boundsY = boundsMinY;
}
- (CGF)boundsMidY       {
	return CGRectGetMidY(self.bounds);
}
- (void)setBoundsMidY:(CGF)boundsMidY   {
	self.boundsY = (boundsMidY - (self.boundsHeight / 2.0f));
}
- (CGF)boundsMaxY       {
	return CGRectGetMaxY(self.bounds);
}
- (void)setBoundsMaxY:(CGF)boundsMaxY   {
	self.boundsY = (boundsMaxY - self.boundsHeight);
}
- (CGPoint)boundsTopLeftPoint   {
	return CGPointMake(self.boundsMinX, self.boundsMinY);
}
- (void)setBoundsTopLeftPoint:(CGPoint)boundsTopLeftPoint       {
	self.boundsMinX = boundsTopLeftPoint.x;
	self.boundsMinY = boundsTopLeftPoint.y;
}
- (CGPoint)boundsTopMiddlePoint {
	return CGPointMake(self.boundsMidX, self.boundsMinY);
}
- (void)setBoundsTopMiddlePoint:(CGPoint)boundsTopMiddlePoint   {
	self.boundsMidX = boundsTopMiddlePoint.x;
	self.boundsMinY = boundsTopMiddlePoint.y;
}
- (CGPoint)boundsTopRightPoint  {
	return CGPointMake(self.boundsMaxX, self.boundsMinY);
}
- (void)setBoundsTopRightPoint:(CGPoint)boundsTopRightPoint     {
	self.boundsMaxX = boundsTopRightPoint.x;
	self.boundsMinY = boundsTopRightPoint.y;
}
- (CGPoint)boundsMiddleRightPoint       {
	return CGPointMake(self.boundsMaxX, self.boundsMidY);
}
- (void)setBoundsMiddleRightPoint:(CGPoint)boundsMiddleRightPoint       {
	self.boundsMaxX = boundsMiddleRightPoint.x;
	self.boundsMidY = boundsMiddleRightPoint.y;
}
- (CGPoint)boundsBottomRightPoint       {
	return CGPointMake(self.boundsMaxX, self.boundsMaxY);
}
- (void)setBoundsBottomRightPoint:(CGPoint)boundsBottomRightPoint       {
	self.boundsMaxX = boundsBottomRightPoint.x;
	self.boundsMaxY = boundsBottomRightPoint.y;
}
- (CGPoint)boundsBottomMiddlePoint      {
	return CGPointMake(self.boundsMidX, self.boundsMaxY);
}
- (void)setBoundsBottomMiddlePoint:(CGPoint)boundsBottomMiddlePoint     {
	self.boundsMidX = boundsBottomMiddlePoint.x;
	self.boundsMaxY = boundsBottomMiddlePoint.y;
}
- (CGPoint)boundsBottomLeftPoint        {
	return CGPointMake(self.boundsMinX, self.boundsMaxY);
}
- (void)setBoundsBottomLeftPoint:(CGPoint)boundsBottomLeftPoint {
	self.boundsMinX = boundsBottomLeftPoint.x;
	self.boundsMaxY = boundsBottomLeftPoint.y;
}
- (CGPoint)boundsMiddleLeftPoint        {
	return CGPointMake(self.boundsMinX, self.boundsMidY);
}
- (void)setBoundsMiddleLeftPoint:(CGPoint)boundsMiddleLeftPoint {
	self.boundsMinX = boundsMiddleLeftPoint.x;
	self.boundsMidY = boundsMiddleLeftPoint.y;
}
- (CGF)positionX        {
	return self.position.x;
}
- (void)setPositionX:(CGF)positionX     {
	self.position = CGPointMake(positionX, self.positionY);
}
- (CGF)positionY        {
	return self.position.y;
}
- (void)setPositionY:(CGF)positionY     {
	self.position = CGPointMake(self.positionX, positionY);
}
#pragma mark - CALayer (LTKAdditions) Methods
//- (id) initWithFrame:(CGRect)rect	      {
//
//	//from starlayer
//	if (!(self = [super init])) return nil;
//	self.root	= [CAL layer];
//	self.text	= [CAL layer];
//	self.root.delegate  = self;
//	self.root.frame     = rect;
//	self.root.arMASK    = CASIZEABLE;
//	self.root.NDOBC     = YES;
//	//	_star	= [CAL layer];
//	//	[@[_star, _text] do:^(CAL *obj){
//	//	obj.frame	= AZMakeRectFromSize(rect.size);
//	//	    obj.delegate	= self;
//	//	[obj setNeedsDisplay];
//	//	[_root addSublayer:obj];
//	//	}];
//	//	[self toggleSpin:AZOn];
//	[self addSublayer:self.root];
//	[self setNeedsDisplay];
//	return self;
//}
- (void)setAnchorPointAndPreserveCurrentFrame:(CGPoint)anchorPoint;     {
	CGPoint newPoint = CGPointMake((self.boundsWidth * anchorPoint.x), (self.boundsHeight * anchorPoint.y));
	CGPoint oldPoint = CGPointMake((self.boundsWidth * self.anchorPoint.x), (self.boundsHeight * self.anchorPoint.y));
	newPoint = CGPointApplyAffineTransform(newPoint, self.affineTransform);
	oldPoint = CGPointApplyAffineTransform(oldPoint, self.affineTransform);
	CGPoint position = self.position;
	position.x -= oldPoint.x;
	position.x += newPoint.x;
	position.y -= oldPoint.y;
	position.y += newPoint.y;
	self.position = position;
	self.anchorPoint = anchorPoint;
}
+ (CGF)smallestWidthInLayers:(NSA *)layers       {
	CGF smallestWidth = 0.0f;
	for (CAL * layer in layers) {
	if (layer.frameWidth < smallestWidth) {
		smallestWidth = layer.frameWidth;
	}
	}
	return smallestWidth;
}
+ (CGF)smallestHeightInLayers:(NSA *)layers      {
	CGF smallestHeight = 0.0f;
	for (CAL * layer in layers) {
	if (layer.frameHeight < smallestHeight) {
		smallestHeight = layer.frameHeight;
	}
	}
	return smallestHeight;
}
+ (CGF)largestWidthInLayers:(NSA *)layers        {
	CGF largestWidth = 0.0f;
	for (CAL * layer in layers) {
	if (layer.frameWidth > largestWidth) {
		largestWidth = layer.frameWidth;
	}
	}
	return largestWidth;
}
+ (CGF)largestHeightInLayers:(NSA *)layers       {
	CGF largestHeight = 0.0f;
	for (CAL * layer in layers) {
	if (layer.frameHeight > largestHeight) {
		largestHeight = layer.frameHeight;
	}
	}
	return largestHeight;
}
- (CAL *)presentationCALayer     {
	return (CAL *)[self presentationLayer];
}
- (CAL *)modelCALayer    {
	return (CAL *)[self modelLayer];
}
- (void)addDefaultFadeTransition        {
	[self addFadeTransitionWithDuration:LTKDefaultTransitionDuration];
}
- (void)addDefaultMoveInTransitionWithSubtype:(NSS *)subtype     {
	[self addMoveInTransitionWithSubtype:subtype duration:LTKDefaultTransitionDuration];
}
- (void)addDefaultPushTransitionWithSubtype:(NSS *)subtype       {
	[self addPushTransitionWithSubtype:subtype duration:LTKDefaultTransitionDuration];
}
- (void)addDefaultRevealTransitionWithSubtype:(NSS *)subtype     {
	[self addRevealTransitionWithSubtype:subtype duration:LTKDefaultTransitionDuration];
}
- (void)addFadeTransitionWithDuration:(NSTimeInterval)duration  {
	CATransition *transition = [CATransition animation];  // kCATransitionFade is the default type
	transition.duration = duration;
	[self addAnimation:transition forKey:kCATransition];
}
- (void)addMoveInTransitionWithSubtype:(NSS *)subtype duration:(NSTimeInterval)duration  {
	CATransition *transition = [CATransition animation];
	transition.type = kCATransitionMoveIn;
	transition.subtype = subtype;
	transition.duration = duration;
	[self addAnimation:transition forKey:kCATransition];
}
- (void)addPushTransitionWithSubtype:(NSS *)subtype duration:(NSTimeInterval)duration    {
	CATransition *transition = [CATransition animation];
	transition.type = kCATransitionPush;
	transition.subtype = subtype;
	transition.duration = duration;
	[self addAnimation:transition forKey:kCATransition];
}
- (void)addRevealTransitionWithSubtype:(NSS *)subtype duration:(NSTimeInterval)duration  {
	CATransition *transition = [CATransition animation];
	transition.type = kCATransitionReveal;
	transition.subtype = subtype;
	transition.duration = duration;
	[self addAnimation:transition forKey:kCATransition];
}
- (void)addAnimation:(CAAnimation *)animation   {
	[self addAnimation:animation forKey:nil];
}
- (void)addAnimation:(CAAnimation *)animation forKey:(NSS *)key withStopBlock:(void (^)(BOOL finished))stopBlock {
	[self addAnimation:animation forKey:key withStartBlock:nil stopBlock:stopBlock];
}
- (void)addAnimation:(CAAnimation *)animation forKey:(NSS *)key withStartBlock:(VoidBlock)startBlock stopBlock:(void (^)(BOOL finished))stopBlock        {
	LTKAnimationDelegate *animationDelegate = [LTKAnimationDelegate new];
	animationDelegate.startBlock = startBlock;
	animationDelegate.stopBlock = stopBlock;
	animation.delegate = animationDelegate;
	[self addAnimation:animation forKey:key];
}
- (void)replaceAnimationForKey:(NSS *)key withAnimation:(CAAnimation *)animation {
	[self removeAnimationForKey:key];
	[self addAnimation:animation forKey:key];
}
- (NSA *)keyedAnimations {
	NSMutableArray *keyedAnimations = [NSMutableArray array];
	for (NSString * animationKey in [self animationKeys]) {
	[keyedAnimations addObject:[self animationForKey:animationKey]];
	}
	return [keyedAnimations copy];
}
- (NSImage *)renderToImage      {
	return [self renderToImageWithContextSize:CGSizeZero contextTransform:CGAffineTransformIdentity];
}
- (NSImage *)renderToImageWithContextSize:(CGSize)contextSize   {
	return [self renderToImageWithContextSize:contextSize contextTransform:CGAffineTransformIdentity];
}
- (NSImage *)renderToImageWithContextSize:(CGSize)contextSize contextTransform:(CGAffineTransform)contextTransform      {
	int pixelsHigh	       = (int)self.boundsHeight;
	int pixelsWide	       = (int)self.boundsWidth;
	int bitmapBytesPerRow   = (pixelsWide * 4);
	int bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
	CGColorSpaceRef cSpc    = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
	CGContextRef ctx     = CGBitmapContextCreate (NULL, pixelsWide, pixelsHigh, 8,
		 bitmapBytesPerRow, cSpc, kCGImageAlphaPremultipliedLast);
	if (ctx == NULL) {
	NSLog(@"Failed to create context."); return nil;
	}
	CGColorSpaceRelease(cSpc);
	[[self presentationLayer] ? [self presentationLayer]:self renderInContext:ctx];
	CGImageRef img	       = CGBitmapContextCreateImage(ctx);
	return [[NSImage alloc]initWithCGImage:img size:contextSize];
}
- (void)enableDebugBordersRecursively:(BOOL)recursively {
	AZDebugLayer *l = [self scanSubsForClass:AZDebugLayer.class] ? : nil;
	if (!l) [self addSublayer:AZDebugLayer.new];
	if (recursively && self.sublayers.count) {
	for (CALayer * layer in self.sublayers) {
		[layer enableDebugBordersRecursively:recursively];
	}
	}
}
@end
@implementation CATXTL (AtoZ)
- (CTFontRef)newFontWithAttributes:(NSD *)attributes {
	CTFontDescriptorRef descriptor = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)attributes);
	CTFontRef font = CTFontCreateWithFontDescriptor(descriptor, 0, NULL);
	CFRelease(descriptor);
	return font;
}
- (CTFontRef)newCustomFontWithName:(NSS *)fontName ofType:(NSS *)type attributes:(NSD *)attributes {
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
		  usingSize:(CGSize)referenceSize       {
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
	CGF ascent, descent, leading;
	CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
	CGF lineHeight = ascent + descent + leading;
	suggestedSize.height += lineHeight / 2.f;
	//END HACK
	return suggestedSize;
}
- (void)setupAttributedTextLayerWithFont:(CTFontRef)font {
	NSDictionary *baseAttributes = @{(NSS *)kCTFontAttributeName : (__bridge id)font};
	NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self.string
				 attributes:baseAttributes];
	CFRelease(font);
	//Make the class name in the string Courier Bold and red
	NSDictionary *fontAttributes = @{(NSS *)kCTFontFamilyNameAttribute: @"Courier",
		(NSS *)kCTFontStyleNameAttribute: @"Bold",
		(NSS *)kCTFontSizeAttribute: @16.f};
	CTFontRef courierFont = [self newFontWithAttributes:fontAttributes];
	NSRange rangeOfClassName = [[attrString string] rangeOfString:@"CATXTL"];
	[attrString addAttribute:(NSS *)kCTFontAttributeName
		 value:(__bridge id)courierFont
		 range:rangeOfClassName];
	[attrString addAttribute:(NSS *)kCTForegroundColorAttributeName
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
@implementation CALayerNonAnimating
- (id<CAAction>)actionForKey:(NSS *)key; {
	// return nil to disable animations on this layer
	return nil;
}
@end
@implementation CAScrollLayer (CAScrollLayer_Extensions)

- (void)scrollBy:(CGPoint)inDelta       {
	const CGRect theVisibleRect = self.visibleRect;
	const CGPoint theNewScrollLocation = { .x = CGRectGetMinX(theVisibleRect) + inDelta.x, .y = CGRectGetMinY(theVisibleRect) + inDelta.y };
	[self scrollToPoint:theNewScrollLocation];
}
- (void)scrollCenterToPoint:(CGPoint)inPoint;   {
	const CGRect theBounds = self.bounds;
	const CGPoint theCenter = {
	.x = CGRectGetMidX(theBounds),
	.y = CGRectGetMidY(theBounds),
	};
	const CGPoint theNewPoint = {
	.x = inPoint.x - theCenter.x,
	.y = inPoint.y - theCenter.y,
	};
	[self scrollToPoint:theNewPoint];
}
@end
static const char *kRenderAsciiBlockKey = "-";
@implementation CALayer (MPPixelHitTesting)
- (void)setRenderASCIIBlock:(MPRenderASCIIBlock)block  {
	objc_setAssociatedObject(self, kRenderAsciiBlockKey, block, OBJC_ASSOCIATION_COPY);
}
- (MPRenderASCIIBlock)renderASCIIBlock {
	return objc_getAssociatedObject(self, kRenderAsciiBlockKey);
}
- (BOOL)pixelsIntersectWithRect:(CGRect)rect   {
	CGRect bounds = CGRectIntersection(self.pixelsHitTestRect, rect);
	// If our pixel bounds do not intersect with the rect then we have nothing to test!
	if (CGRectIsNull(bounds)) return NO;
	// For pretty ascii art uncomment this line
	MPRenderASCIIBlock renderBlock = self.renderASCIIBlock;
	if (renderBlock) bounds = self.pixelsHitTestRect;
	uint64_t width  = ceil(bounds.size.width);
	uint64_t height = ceil(bounds.size.height);
	uint64_t count  = width * height;
	uint64_t hit    = 0;
	// We render directly into our result if it takes only 1 byte.
	uint8_t *buf = (count == 1) ? &hit : calloc(count, 1);
	CGContextRef theMask = CGBitmapContextCreate(buf, width, height, 8, width, NULL, kCGImageAlphaOnly);
	if (theMask) {
	// Translate so that our bounds origin is at 0,0 in our buffer
	CGContextTranslateCTM(theMask, -bounds.origin.x, -bounds.origin.y);
	// By adding a blurry shadow we make it easier to click on little things
	CGContextSetShadow(theMask, CGSizeMake(0, 0.0f), 2.0f);
	// We can now render the presentatinLayer
	[self.presentationLayer renderInContext:theMask];
	// CAShapeLayers don't renderInContext so we need a workaround
	if ([self isKindOfClass:[CAShapeLayer class]]) [self renderShapeLayer:(CAShapeLayer *)self inContext:theMask];
	// Additional code for rendering the ascii art.
	// Requires the CocoaPuffs framework at https://github.com/macprog-guy/CocoaPuffs
	if (renderBlock) renderBlock([[NSData dataWithBytesNoCopy:buf length:count freeWhenDone:NO] asciiArtOfWidth:(int)width andHeight:(int)height]);
	// Check the more complicated case where we are looking at a larger rect
	if (count > 1) {
		for (int i = 0; i < count && !hit; i++) {
		hit += buf[i];
		}
		free(buf);
	}
	CGContextRelease(theMask);
	}
	return (hit != 0);
}
- (void)renderShapeLayer:(CAShapeLayer *)layer inContext:(CGContextRef)context  {
	if (layer.path) {
	// TODO: still incomplete. Should finish implementation.
	CGColorRef whiteColor = CGColorGetConstantColor(kCGColorWhite);
	CGColorRef clearColor = CGColorGetConstantColor(kCGColorClear);
	CGContextAddPath(context, layer.path);
	CGContextSetLineWidth(context, layer.lineWidth);
	CGLineCap cap = kCGLineCapButt;
	if ([layer.lineCap isEqualToString:kCALineCapRound]) cap = kCGLineCapRound;	// COV_NF_LINE
	else if ([layer.lineCap isEqualToString:kCALineCapSquare]) cap = kCGLineCapSquare;    // COV_NF_LINE
	CGLineJoin join = kCGLineJoinMiter;
	if ([layer.lineJoin isEqualToString:kCALineJoinBevel]) join = kCGLineJoinBevel;       // COV_NF_LINE
	else if ([layer.lineJoin isEqualToString:kCALineJoinRound]) join = kCGLineJoinRound;  // COV_NF_LINE
	CGContextSetLineCap(context, cap);
	CGContextSetLineJoin(context, join);
	if (layer.fillColor && !CGColorEqualToColor(layer.fillColor, clearColor)) {
		CGContextSetFillColorWithColor(context, whiteColor);
		CGContextFillPath(context);
	}
	if (layer.strokeColor && !CGColorEqualToColor(layer.strokeColor, clearColor)) {
		CGContextSetStrokeColorWithColor(context, whiteColor);
		CGContextStrokePath(context);
	}
	}
}
- (BOOL)pixelsHitTest:(CGPoint)p       {
	return [self pixelsIntersectWithRect:CGRectMake(p.x - 0.5, p.y - 0.5, 1, 1)];
}
- (CGRect)pixelsHitTestRect    {
	return CGRectInset(self.bounds, -3, -3);
}
@end
