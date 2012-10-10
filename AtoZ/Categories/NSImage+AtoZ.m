
//  NSImage+AtoZ.m
//  AtoZ

//  Created by Alex Gray on 7/2/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.


#import "NSImage+AtoZ.h"
#import <AppKit/AppKit.h>
#import <Quartz/Quartz.h>
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>
#import <QuickLook/QuickLook.h>
#import "AtoZ.h"



@implementation  CIFilter (Subscript)
- (id)objectForKeyedSubscript:(NSString *)key
{
	return [self valueForKey:key];
}

- (void)setObject:(id)object forKeyedSubscript:(NSString *)key
{
	if (IsEmpty(object)) [self setValue:@"" forKey:key];
	else [self setValue:object forKey:key];
}

@end


// Just one function to declare...
float distance(NSPoint aPoint);

enum pixelComponents { red, green, blue, alpha };

NSSize gradientSize = {256.0, 256.0};

float distance(NSPoint aPoint)  // Stole this from some guy named Pythagoras..  Returns the distance of aPoint from the origin.
{
	return sqrt(aPoint.x * aPoint.x + aPoint.y *aPoint.y);
}

static void BitmapReleaseCallback( void* info, const void* data, size_t size ) {
	id bir = (__bridge_transfer NSBitmapImageRep*)info;
	//	DLog(@"%@", bir);
}

@interface DummyClass : NSObject
@end
@implementation DummyClass 
@end


@implementation CIFilter (WithDefaults)

+ (CIFilter*) filterWithDefaultsNamed: (NSString*) name {

	CIFilter *cc = [CIFilter filterWithName:name];
	[cc setDefaults];  return cc;
}

@end



@implementation NSImage (AtoZ)

+ (NSArray*) frameworkImageNames
{
	return [[NSImage frameworkImagePaths]mapSelector:@selector(lastPathComponent)];
}


+ (NSImage*)screenShot {
	return [[NSImage alloc]initWithCGImage:CGWindowListCreateImage(CGRectInfinite, kCGWindowListOptionOnScreenOnly, kCGNullWindowID, kCGWindowImageDefault) size:AZScreenSize()];
}


+ (NSArray*) frameworkImagePaths {
	return (NSArray*)LogAndReturn( [NSArray arrayWithArrays:@[
			   [AZFWORKBUNDLE pathsForResourcesOfType:@"pdf" inDirectory:@""],
			   [AZFWORKBUNDLE pathsForResourcesOfType:@"png" inDirectory:@""],
			   [AZFWORKBUNDLE pathsForResourcesOfType:@"icns" inDirectory:@""]]]);

}
+ (NSArray*) frameworkImages;{
	//; error:nil] filter:^BOOL(id object) { return [(NSString*)object contains:@".icn"] ? YES : NO;
	//	return [f arrayUsingBlock:^id(id obj) {	return [base stringByAppendingPathComponent:obj]; }];
	return [[[[self class]frameworkImagePaths] arrayUsingBlock:^id(id obj) { return [[NSIMG alloc]initWithContentsOfFile:obj];
											}] filter:^BOOL(id object) { return [object isKindOfClass:[NSIMG class]]; }];
}

+(NSArray*) systemIcons{	static NSArray *_systemIcons;
	return _systemIcons = _systemIcons != nil
	? _systemIcons // This will only be true the first time the method is called...
	: (NSArray*)^{
		NSString *base = @"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/";
		return[[[[AZFILEMANAGER contentsOfDirectoryAtPath:base error:nil] filter:^BOOL(id object) {
			return [(NSString*)object contains:@".icn"] ? YES : NO;
		}] arrayUsingBlock:^id(id obj) {
			return [[NSImage alloc] initWithContentsOfFile:[base stringByAppendingPathComponent:(NSString*)obj]];
		}]
			   filter:^BOOL(id object) {
				   return [object isKindOfClass:[NSImage class]] ? YES : NO;
			   }];
	}();
}

	//+ (NSArray*) iconStrings {

	//	NSBundle *aBundle = [NSBundle bundleForClass: [DummyClass class]];
	//	return [aBundle pathsForResourcesOfType:@"pdf" inDirectory:@"picol"];
	//	NSLog(@"%@", imagePaths);
	//}

+(NSImage*) randomIcon {
	NSString *ia = [[self class]picolStrings].randomElement;
	return [NSImage imageInFrameworkWithFileName:ia];
		//	NSLog(@"rando: %@", i);
		//	return i;
}

+ (NSArray*) iconsColoredWithColor:(NSColor*)color;
{
}

+ (NSArray*) icons {

	NSString *picol = [[AtoZ resources] stringByAppendingPathComponent:@"picol/"];
	return [[NSFileManager filesInFolder:picol] map:^id(id obj) {
		return [[NSImage alloc]initWithContentsOfFile:[picol stringByAppendingPathComponent:obj]];
	}];

		//	return  [[[self class] picolStrings] map:^id(id obj) {
		//		NSImage *i = [NSImage imageInFrameworkWithFileName:obj];
		//		NSLog(@"loading %@  aka %@", [obj lastPathComponent], i);
		//		return i;
		//	}];
		//	 filter:^BOOL(id obj) {	return obj ? YES:  NO;	}];
	
}



+ (NSImage*) forFile:(AZFile*)file;
{
	NSSize theSize = AZSizeFromDimension(512);
	return [AZWORKSPACE iconForFile:file.path] 	? [[AZWORKSPACE iconForFile:file.path]imageScaledToFitSize:theSize]
												: [NSImage imageInFrameworkWithFileName:@"missing.png"];
}

+ (NSArray*) randomImages:(NSUI)number{
	NSArray *images = [NSArray arrayWithArrays:@[[NSImage icons], [NSImage systemIcons], [NSImage frameworkImages]]];
	return [images.shuffeled randomSubarrayWithSize:number];

}

+ (void) drawInQuadrants:(NSArray*)images inRect:(NSRect)frame {  __block int indy = 1;
	[images do:^(id obj){ [(NSImage*)obj drawInRect: alignRectInRect(AZRectFromDim(frame.size.width/2),frame,indy)]; indy++;  }];
}

+ (NSImage *)reflectedImage:(NSImage *)sourceImage amountReflected:(float)fraction
{
	NSImage *reflection = [[NSImage alloc]initWithSize:sourceImage.size];
	[reflection setFlipped:NO];
	NSRect reflectionRect = (NSRect)	{0, 0,
									sourceImage.size.width,
									sourceImage.size.height*fraction};
	[reflection lockFocus];
	CTGradient *fade = [CTGradient gradientWithBeginningColor:
     						[NSColor colorWithCalibratedWhite:1.0 alpha:0.5]
											      endingColor:[NSColor clearColor]];
	[fade fillRect:reflectionRect angle:90.0];
	[sourceImage drawAtPoint:(NSPoint){0,0}
					fromRect:reflectionRect
				   operation:NSCompositeSourceIn
					fraction:1.0];
	[reflection unlockFocus];
	return reflection;
}



- (NSSize)proportionalSizeForTargetSize:(NSSize)targetSize
{
    NSSize imageSize = [self size];
    float width  = imageSize.width;
    float height = imageSize.height;

    float targetWidth  = targetSize.width;
    float targetHeight = targetSize.height;

		// scaleFactor will be the fraction that we'll
		// use to adjust the size. For example, if we shrink
		// an image by half, scaleFactor will be 0.5. the
		// scaledWidth and scaledHeight will be the original,
		// multiplied by the scaleFactor.
		//
		// IMPORTANT: the "targetHeight" is the size of the space
		// we're drawing into. The "scaledHeight" is the height that
		// the image actually is drawn at, once we take into
		// account the idea of maintaining proportions

    float scaleFactor  = 0.0;
    float scaledWidth  = targetWidth;
    float scaledHeight = targetHeight;

		// since not all images are square, we want to scale
		// proportionately. To do this, we find the longest
		// edge and use that as a guide.

    if ( NSEqualSizes( imageSize, targetSize ) == NO )
    {
			// use the longeset edge as a guide. if the
			// image is wider than tall, we'll figure out
			// the scale factor by dividing it by the
			// intended width. Otherwise, we'll use the
			// height.

        float widthFactor;
        float heightFactor;

		widthFactor  = targetWidth / width;
		heightFactor = targetHeight / height;

        if ( widthFactor < heightFactor )
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;

			// ex: 500 * 0.5 = 250 (newWidth)

        scaledWidth  = width  * scaleFactor;
        scaledHeight = height * scaleFactor;
    }

	return NSMakeSize(scaledWidth,scaledHeight);
}

- (NSImage*)imageByScalingProportionallyToSize:(NSSize)targetSize
{
    return [self imageByScalingProportionallyToSize:targetSize
                                            flipped:NO];
}

- (NSImage*)imageByScalingProportionallyToSize:(NSSize)targetSize
                                       flipped:(BOOL)isFlipped
{
    return [self imageByScalingProportionallyToSize:targetSize
                                            flipped:isFlipped
                                           addFrame:NO
                                          addShadow:NO];
}

- (NSImage*)imageByScalingProportionallyToSize:(NSSize)targetSize
                                       flipped:(BOOL)isFlipped
                                      addFrame:(BOOL)shouldAddFrame
                                     addShadow:(BOOL)shouldAddShadow
{
    return [self imageByScalingProportionallyToSize:targetSize
                                            flipped:isFlipped
                                           addFrame:NO
                                          addShadow:NO
                                           addSheen:YES];
}

- (NSImage*)imageByScalingProportionallyToSize:(NSSize)targetSize
                                       flipped:(BOOL)isFlipped
                                      addFrame:(BOOL)shouldAddFrame
                                     addShadow:(BOOL)shouldAddShadow
                                      addSheen:(BOOL)shouldAddSheen
{
    NSImage* sourceImage = self;

	NSImageRep* rep = [sourceImage bestRepresentationForSize:targetSize];
	NSInteger pixelsWide = [rep pixelsWide];
	NSInteger pixelsHigh = [rep pixelsHigh];
	[sourceImage setSize:NSMakeSize(pixelsWide,pixelsHigh)];

    NSImage* newImage = nil;
    if ([sourceImage isValid] == NO) return nil;

		// settings for shadow
    float shadowRadius = 4.0;
    NSSize shadowTargetSize = targetSize;
    if ( shouldAddShadow )
    {
        shadowTargetSize.width  -= (shadowRadius * 2);
        shadowTargetSize.height -= (shadowRadius * 2);
    }

    NSSize imageSize = [sourceImage size];
    float width  = imageSize.width;
    float height = imageSize.height;

    float targetWidth  = targetSize.width;
    float targetHeight = targetSize.height;

		// scaleFactor will be the fraction that we'll
		// use to adjust the size. For example, if we shrink
		// an image by half, scaleFactor will be 0.5. the
		// scaledWidth and scaledHeight will be the original,
		// multiplied by the scaleFactor.
		//
		// IMPORTANT: the "targetHeight" is the size of the space
		// we're drawing into. The "scaledHeight" is the height that
		// the image actually is drawn at, once we take into
		// account the idea of maintaining proportions

    float scaleFactor  = 0.0;
    float scaledWidth  = targetWidth;
    float scaledHeight = targetHeight;

    NSPoint thumbnailPoint = NSMakePoint(0,0);

		// since not all images are square, we want to scale
		// proportionately. To do this, we find the longest
		// edge and use that as a guide.

    if ( NSEqualSizes( imageSize, targetSize ) == NO )
    {
			// use the longeset edge as a guide. if the
			// image is wider than tall, we'll figure out
			// the scale factor by dividing it by the
			// intended width. Otherwise, we'll use the
			// height.

        float widthFactor;
        float heightFactor;

        if ( shouldAddShadow ) {
            widthFactor  = shadowTargetSize.width / width;
            heightFactor = shadowTargetSize.height / height;
        } else {
            widthFactor  = targetWidth / width;
            heightFactor = targetHeight / height;
        }

        if ( widthFactor < heightFactor )
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;

			// ex: 500 * 0.5 = 250 (newWidth)

        scaledWidth  = width  * scaleFactor;
        scaledHeight = height * scaleFactor;

			// center the thumbnail in the frame. if
			// wider than tall, we need to adjust the
			// vertical drawing point (y axis)

        if ( widthFactor < heightFactor )
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;

        else if ( widthFactor > heightFactor )
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;

    }

		// create a new image to draw into
    newImage = [[NSImage alloc] initWithSize:targetSize];
    [newImage setCacheMode:NSImageCacheNever];
    [newImage setFlipped:isFlipped];

		// once focus is locked, all drawing goes into this NSImage instance
		// directly, not to the screen. It also receives its own graphics
		// context.
		//
		// Also, keep in mind that we're doing this in a background thread.
		// You only want to draw to the screen in the main thread, but
		// drawing to an offscreen image is (apparently) okay.

    [newImage lockFocus];

	[[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];

        // create the properly-scaled rect
	NSRect thumbnailRect;
	thumbnailRect.origin = thumbnailPoint;
	thumbnailRect.size.width = scaledWidth;
	thumbnailRect.size.height = scaledHeight;

        // add shadow below the image?
	if ( shouldAddShadow )
	{
            // we need to adjust the y coordinate to make sure
            // the image ends up in the right place in a flipped
            // coordinate system.
		if ( isFlipped && height > width )
			thumbnailRect.origin.y += (shadowRadius * 2);

            // draw the shadow where the image will be
		NSShadow* shadow = [[NSShadow alloc] init];
		[shadow setShadowColor:[NSColor colorWithCalibratedWhite:0.0 alpha:0.5]];
		if (isFlipped)
			[shadow setShadowOffset:NSMakeSize(shadowRadius,shadowRadius)];
		else
			[shadow setShadowOffset:NSMakeSize(shadowRadius,-shadowRadius)];
		[shadow setShadowBlurRadius:shadowRadius];
		[NSGraphicsContext saveGraphicsState];
		[shadow set];
		[[NSColor whiteColor] set];
		[NSBezierPath fillRect:thumbnailRect];
		[NSGraphicsContext restoreGraphicsState];
		[shadow release];
	}

        // draw the actual image
	[sourceImage drawInRect: thumbnailRect
				   fromRect: NSZeroRect
				  operation: NSCompositeSourceOver
				   fraction: 1.0];

        // add a frame above the image content?
	if ( shouldAddFrame )
	{
            // draw the larger internal frame
		NSRect insetFrameRect = NSInsetRect(thumbnailRect,3,3);
		NSBezierPath* insetFrame = [NSBezierPath bezierPathWithRect:insetFrameRect];
		[insetFrame setLineWidth:6.0];
		[[NSColor whiteColor] set];
		[insetFrame stroke];

            // draw the external bounding frame with no anti-aliasing
		[[NSColor colorWithCalibratedWhite:0.60 alpha:1.0] set];
		NSBezierPath* outsetFrame = [NSBezierPath bezierPathWithRect:thumbnailRect];
		[NSGraphicsContext saveGraphicsState];
		[[NSGraphicsContext currentContext] setShouldAntialias:NO];
		[outsetFrame setLineWidth:1.0];
		[outsetFrame stroke];
		[NSGraphicsContext restoreGraphicsState];
	}

	if ( shouldAddSheen )
	{
		NSRect sheenRect = NSInsetRect(thumbnailRect,7,7);
		CGFloat originalHeight = sheenRect.size.height;
		sheenRect.size.height = originalHeight * 0.75;
		sheenRect.origin.y += originalHeight * 0.25;

		NSBezierPath* sheenPath = [NSBezierPath bezierPath];
		NSPoint point1 = NSMakePoint ( sheenRect.origin.x + sheenRect.size.width, sheenRect.origin.y + sheenRect.size.height );
		NSPoint point2 = NSMakePoint ( sheenRect.origin.x, sheenRect.origin.y + sheenRect.size.height );
		NSPoint point3 = NSMakePoint ( sheenRect.origin.x, sheenRect.origin.y );

		NSPoint controlPoint1 = point2;
		NSPoint controlPoint2 = point1;

			//[sheenPath moveToPoint:point1];
		[sheenPath moveToPoint:point1];
		[sheenPath lineToPoint:point2];
		[sheenPath lineToPoint:point3];
		[sheenPath curveToPoint:point1 controlPoint1:controlPoint1 controlPoint2:controlPoint2];

		NSGradient* gradient = [[NSGradient alloc] initWithColorsAndLocations:
								[NSColor colorWithCalibratedWhite:1.0 alpha:0.60], 0.00,
								[NSColor colorWithCalibratedWhite:1.0 alpha:0.40], 0.15,
								[NSColor colorWithCalibratedWhite:1.0 alpha:0.20], 0.28,
								[NSColor colorWithCalibratedWhite:1.0 alpha:0.01], 0.85, nil];

		[gradient drawInBezierPath:sheenPath angle:285.0];
		[gradient release];

	}

    [newImage unlockFocus];
    return [newImage autorelease];
}

- (NSImage*)imageByFillingVisibleAlphaWithColor:(NSColor*)fillColor
{
		// convert source image to CIImage
    NSData* sourceImageData = [self TIFFRepresentation];
    CIImage* imageToFill = [CIImage imageWithData:sourceImageData];

		// create CIFalseColor filter
    CIColor* color = [[CIColor alloc] initWithColor:fillColor];
    CIFilter* filter = [CIFilter filterWithName:@"CIFalseColor"];
    [filter setValue:imageToFill forKey:@"inputImage"];
    [filter setValue:color forKey:@"inputColor0"];
    [filter setValue:color forKey:@"inputColor1"];

		// get resulting image and add as a NSCIImageRep
    CIImage* compositedImage = [filter valueForKey:@"outputImage"];
    NSImage* finalImage = [[NSImage alloc] initWithSize:self.size];
    NSCIImageRep* ciImageRep = [NSCIImageRep imageRepWithCIImage:compositedImage];
    [finalImage addRepresentation:ciImageRep];

    return finalImage;
}

- (NSImage*)imageByConvertingToBlackAndWhite
{
		// convert source image to CIImage
    NSData* sourceImageData = [self TIFFRepresentation];
    CIImage* imageToFill = [CIImage imageWithData:sourceImageData];

		// create CIColorMonochrome filter
    CIColor* color = [[CIColor alloc] initWithColor:[NSColor whiteColor]];
    CIFilter* filter = [CIFilter filterWithName:@"CIColorMonochrome"];
    [filter setValue:imageToFill forKey:@"inputImage"];
    [filter setValue:color forKey:@"inputColor"];
    [filter setValue:@1.0f forKey:@"inputIntensity"];

		// get resulting image and add as a NSCIImageRep
    CIImage* compositedImage = [filter valueForKey:@"outputImage"];
    NSImage* finalImage = [[NSImage alloc] initWithSize:self.size];
    NSCIImageRep* ciImageRep = [NSCIImageRep imageRepWithCIImage:compositedImage];
    [finalImage addRepresentation:ciImageRep];

    return finalImage;
}



// this creates an image from the entire 'visible' rectangle of a view
// for offscreen views this is the entire view
+ (NSImage *)createImageFromView:(NSView *)view {
	NSRect rect = [view bounds];
	return [self createImageFromSubView:view rect:rect];
}

	// this creates an image from a subset of the view's visible rectangle
+ (NSImage *)createImageFromSubView:(NSView *)view rect:(NSRect)rect{
		// first get teh properly setup bitmap for this view
	NSBitmapImageRep *imageRep = [view bitmapImageRepForCachingDisplayInRect:rect];
		// now use that bitmap to store the desired view rectangle as bits
	[view cacheDisplayInRect:rect toBitmapImageRep:imageRep];
		// jam that bitrep into an image and return it
	NSImage *image = [[[NSImage alloc] initWithSize:rect.size] autorelease];
	[image addRepresentation:imageRep];
	return image;
}


- (NSImage*) maskWithColor:(NSColor*)c {

	NSImage* badgeImage = [[NSImage alloc] initWithSize:self.size];
//	[NSGraphicsContext saveGraphicsState];
	[badgeImage lockFocus];
//	NSShadow *theShadow = [[NSShadow alloc] init];
//	[theShadow setShadowOffset: NSMakeSize(0,10)];
//	[theShadow setShadowBlurRadius:10];
//	[theShadow setShadowColor:[[NSColor blackColor] colorWithAlphaComponent:.9]];
//	[theShadow set];
//	[badgeImage compositeToPoint:NSZeroPoint operation:NSCompositeSourceOver];
//	[NSGraphicsContext restoreGraphicsState];
	[c set];
	NSRectFill(AZMakeRectFromSize(self.size));
//	[self drawAtPoint:NSZeroPoint fromRect:NSZeroRect operation:NSCompositeDestinationAtop fraction:1];
	[badgeImage unlockFocus];
	return badgeImage;
}

- (NSImage *)scaleImageToFillSize:(NSSize)targetSize
{
	NSSize sourceSize = self.size;
	NSRect sourceRect, destinationRect; sourceRect = destinationRect = NSZeroRect;
	sourceRect = sourceSize.height > sourceSize.width
	?	AZMakeRect((NSPoint){ 0.0,	round((sourceSize.height - sourceSize.width) / 2)}, sourceSize)
	:	AZMakeRect((NSPoint){ round((sourceSize.width - sourceSize.height) / 2), 0.0},sourceSize);

	destinationRect.size = targetSize;
	NSImage *final = [[NSImage alloc] initWithSize:targetSize];
	[final setSize:targetSize];
	[final lockFocus];
	[[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationLow];
	[final drawInRect:destinationRect fromRect:sourceRect operation:NSCompositeSourceOver fraction:1.0];
	[final unlockFocus];
	return final;
}


- (NSImage*)  coloredWithColor:(NSColor*)inColor {
	return [self coloredWithColor:inColor composite:NSCompositeDestinationIn];
}
- (NSImage*)  coloredWithColor:(NSColor*)inColor composite:(NSCompositingOperation)comp{
	static CGFloat kGradientShadowLevel = 0.25;
	static CGFloat kGradientAngle = 270.0;
	if ( inColor ) {
		BOOL avoidGradient = NO;// ( [self state] == NSOnState );
		NSRect targetRect = NSMakeRect(0,0,self.size.width, self.size.height);		
		NSImage *target = [[NSImage alloc] initWithSize:self.size];
		NSGradient *gradient = ( avoidGradient ? nil : [[NSGradient alloc] initWithStartingColor:inColor.brighter endingColor:[inColor.darker shadowWithLevel:kGradientShadowLevel]] );
		[target lockFocus];
		if ( avoidGradient ) { [inColor set]; NSRectFill(targetRect); }
		else [gradient drawInRect:targetRect angle:kGradientAngle];
		[self drawInRect:targetRect fromRect:NSZeroRect operation:comp fraction:1.0];
		[target unlockFocus];
		return target;
	}
	else return self;
}

+ (id) imageWithFileName:(NSString *)fileName inBundle:(NSBundle *)aBundle {
	NSImage *img = nil;
	if (aBundle != nil) {
		NSString *imagePath;
		if ((imagePath = [aBundle pathForResource: fileName ofType:nil]) != nil) {
			img = [[NSImage alloc] initWithContentsOfFile: imagePath];
		}
	}
	return img;
}

+ (id) imageWithFileName:(NSString *) fileName inBundleForClass:(Class) aClass {
	return [self imageWithFileName: fileName inBundle: [NSBundle bundleForClass: aClass]];
}

+ (id)frameworkImageNamed:(NSString *)name {
	NSImage *image = [NSImage imageNamed:name]
				   ? [NSImage imageNamed:name]
				   : [[NSImage alloc] initWithContentsOfFile:
					  [AZFWORKBUNDLE pathForImageResource:name]];
	image.name = image ? name : nil;
	return image ? image : nil;
}



+ (id) imageInFrameworkWithFileName:(NSString *) fileName {	
	NSBundle *aBundle = [NSBundle bundleForClass: [DummyClass class]];
	return [self imageWithFileName: fileName inBundle: aBundle];
}

+ (NSImage*)swatchWithColor:(NSColor*)color size:(NSSize)size
{
    NSImage *image = [[NSImage alloc] initWithSize:size];
    [image lockFocus];
    [color drawSwatchInRect:NSMakeRect(0, 0, size.width, size.height)];
    [image unlockFocus];
	return image;
}

+ (NSImage *)swatchWithGradientColor:(NSColor *)color size:(NSSize)size {
	NSImage *image = [[NSImage alloc] initWithSize:size];
    [image lockFocus];
	NSGradient * fade = [[NSGradient alloc] initWithStartingColor:color.brighter endingColor:color.darker.darker];
    [fade drawInRect:NSMakeRect(0, 0, size.width, size.height) angle:270];
	[image unlockFocus];
	return image;
}

- (NSImage*) resizeWhenScaledImage {

	[self setScalesWhenResized:YES];
	return self;
}


+ (NSImage *) prettyGradientImage
{
	NSImage 
    *newImage = [[self alloc] initWithSize:gradientSize];  // In this case, the pixel dimensions match the image size.
	
	int
    pixelsWide = gradientSize.width,
    pixelsHigh = gradientSize.height;    
    
	NSBitmapImageRep *bitmapRep = 
    [[NSBitmapImageRep alloc] 
	 initWithBitmapDataPlanes: nil  // Nil pointer makes the kit allocate the pixel buffer for us.
	 pixelsWide: pixelsWide  // The compiler will convert these to integers, but I just wanted to  make it quite explicit
	 pixelsHigh: pixelsHigh //
	 bitsPerSample: 8
	 samplesPerPixel: 4  // Four samples, that is: RGBA
	 hasAlpha: YES
	 isPlanar: NO  // The math can be simpler with planar images, but performance suffers..
	 colorSpaceName: NSCalibratedRGBColorSpace  // A calibrated color space gets us ColorSync for free.
	 bytesPerRow: 0     // Passing zero means "you figure it out."
	 bitsPerPixel: 32];  // This must agree with bitsPerSample and samplesPerPixel.
	
	unsigned char 
    *imageBytes = [bitmapRep bitmapData];  // -bitmapData returns a void*, not an NSData object ;-)
	
	int row = pixelsHigh;
	
	while(row--)
    {
		int col = pixelsWide;
		while(col--) 
		{
			int 
			pixelIndex = 4 * (row * pixelsWide + col);
			imageBytes[pixelIndex + red] = rint(fmod(distance(NSMakePoint(col/1.5,(255-row)/1.5)),255.0));  //red
			imageBytes[pixelIndex + green] = rint(fmod(distance(NSMakePoint(col/1.5, row/1.5)),255.0));  // green
			imageBytes[pixelIndex + blue] = rint(fmod(distance(NSMakePoint((255-col)/1.5,(255-row)/1.5)),255.0));  // blue
			imageBytes[pixelIndex + alpha] = 255;  // Not doing anything tricky with the Alpha value here...
		}
    }
	[newImage addRepresentation:bitmapRep];
	return newImage;
}

- (NSArray*) quantize {
		[NSGraphicsContext saveGraphicsState];
//	NSImage *quantized = self.copy;
	[self setSize:NSMakeSize(32, 32)];
	//	[anImage setSize:NSMakeSize(32, 32)];
//    NSSize size = [self size];
//    NSRect iconRect = NSMakeRect(0, 0, size.width, size.height);
//    [self lockFocus];
	NSBitmapImageRep *imageRep = [self bitmap];
//    NSBitmapImageRep *imageRep = [[NSBitmapImageRep alloc] initWithFocusedViewRect:iconRect];
//    [self unlockFocus];
	//	[nSImage imageNamed:NSImageNameHomeTemplate
	//	NSImage *image = [[NSImage alloc] initWithData:[rep representationUsingType:NSPNGFileType properties:nil]];
	//	NSBitmapImageRep *imageRep = (NSBitmapImageRep*)[[image representations] objectAtIndex:0];
	//	NSImage *resizedIcon = [[NSImage alloc] initWithIconRef:[self]];
	//	[resizedIcon lockFocus];
	//	[self drawInRect:resizedBounds fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0];
	//	[resizedIcon unlockFocus];
	
	//	NSBitmapImageRep* imageRep = [[resizedIcon representations] objectAtIndex:0]; 
	//	NSBitmapImageRep *imageRep = nil;
	//	if (![firstRep isKindOfClass:[NSBitmapImageRep class]])	{
	//		NSRect resizedBounds = NSMakeRect(0,0,32,32);
	//		[self lockFocus];	
	//		[self drawInRect:resizedBounds fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0];
	//		imageRep = [NSBitmapImageRep imageRepWithData:[self TIFFRepresentation]];
	//		[self unlockFocus];
	//	} else imageRep = (NSBitmapImageRep *) firstRep;
	
	
	//	NSBitmapImageRep *imageRep = (NSBitmapImageRep *)[self smallestRepresentation];
	[imageRep bitmapImageRepByConvertingToColorSpace:
	 [NSColorSpace deviceRGBColorSpace]	renderingIntent:NSColorRenderingIntentDefault];
	NSMutableArray *catcher =  [NSMutableArray array];
	NSBag *satchel = [NSBag bag];
	NSInteger width 	= 	[imageRep pixelsWide];
	NSInteger height 	= 	[imageRep pixelsHigh];
	for (NSInteger i = 0; i < width; i++) {
		for (NSInteger j = 0; j < height; j++) {
			//	[self setColor:AGColorFromNSColor([imageRep colorAtX:i y:j])
			NSColor *thisPx = [imageRep colorAtX:i y:j];
			if ( ! [thisPx alphaComponent] == 0.) [satchel add:thisPx];
		}
	}
	int counter =( [[satchel objects]count] < 10 ? [[satchel objects]count] : 10 );
	for (int j = 0; j < counter; j++) {
		for (int s = 0; s < [satchel occurrencesOf:[satchel objects][j]]; s++)  
			[catcher addObject:[satchel objects][j]];
	}
	return catcher;
}

- (void)openQuantizedSwatch{
	[AZStopwatch named:@"openQuantizedSwatch" block:^{

		NSA* q = [self quantize];
		NSImage *u = [[NSImage alloc]initWithSize:AZSizeFromPoint((NSPoint){1024,512})];
		AZSizer *s = [AZSizer forQuantity:q.count inRect:AZRectFromDim(512)];
		[u lockFocus];
		[s.rects eachWithIndex:^(id obj, NSInteger idx) {
			[(NSColor*)q[idx] set];
			NSRectFill([obj rectValue]);
		}];
		[[self scaledToMax:512] drawAtPoint:(NSPoint){512,0} fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
		[u unlockFocus];
		NSS* p = $(@"/tmp/quantization.%@.png",[NSString newUniqueIdentifier]);
		[u saveAs:p];
		AZLOG(p);
		[AZWORKSPACE openFile:p withApplication:@"Preview"];

	}];
}

+ (NSImage*) desktopImage;
{
	return [[NSImage alloc] initWithContentsOfURL:[[AZFILEMANAGER contentsOfDirectoryAtURL:[NSURL fileURLWithPath:@"/Library/Desktop Pictures" isDirectory:YES] includingPropertiesForKeys:nil options:0 error:nil]randomElement]];
}


- (void) drawFloatingRightInFrame:(NSRect)aFrame {		NSRect r 	= aFrame;

	float max 	= (r.size.width > r.size.height ? r.size.height : r.size.width) * .8;
	self.size   =  r.size  = NSMakeSize( max, max );

	[self compositeToPoint: (NSPoint) {aFrame.size.width - (max*1.2), max*.1}
				  fromRect: NSZeroRect
				 operation: NSCompositeSourceOver];
}



// draws the passed image into the passed rect, centered and scaled appropriately.
// note that this method doesn't know anything about the current focus, so the focus must be locked outside this method
- (void)drawCenteredinRect:(NSRect)inRect operation:(NSCompositingOperation)op fraction:(float)delta
{
	NSRect srcRect = NSZeroRect;
	srcRect.size = [self size];
	
	// create a destination rect scaled to fit inside the frame
	NSRect drawnRect = srcRect;
	if (drawnRect.size.width > inRect.size.width)
	{
		drawnRect.size.height *= inRect.size.width/drawnRect.size.width;
		drawnRect.size.width = inRect.size.width;
	}
	
	if (drawnRect.size.height > inRect.size.height)
	{
		drawnRect.size.width *= inRect.size.height/drawnRect.size.height;
		drawnRect.size.height = inRect.size.height;
	}
	
	drawnRect.origin = inRect.origin;
	
	// center it in the frame
	drawnRect.origin.x += (inRect.size.width - drawnRect.size.width)/2;
	drawnRect.origin.y += (inRect.size.height - drawnRect.size.height)/2;
	
	[self drawInRect:drawnRect fromRect:srcRect operation:op fraction:delta];
}



- (NSImage *)tintedImage
{
	NSImage *tintImage = [[NSImage alloc] initWithSize:[self size]];
	
	[tintImage lockFocus];
	[[[NSColor blackColor] colorWithAlphaComponent:1] set];
	[[NSBezierPath bezierPathWithRect:(NSRect){NSZeroPoint, [self size]}] fill];
	[tintImage unlockFocus];
	
	NSImage *tintMaskImage = [[NSImage alloc] initWithSize:[self size]];
	[tintMaskImage lockFocus];
	[self compositeToPoint:NSZeroPoint operation:NSCompositeCopy];
	[tintImage compositeToPoint:NSZeroPoint operation:NSCompositeSourceIn];
	[tintMaskImage unlockFocus];
	
	NSImage *newImage = [[NSImage alloc] initWithSize:[self size]]; 
	[newImage lockFocus];
	[self dissolveToPoint:NSZeroPoint fraction:0.6];
	[tintMaskImage compositeToPoint:NSZeroPoint operation:NSCompositeDestinationAtop];
	[newImage unlockFocus];
	
	return newImage;
}


- (NSImage *) tintedWithColor:(NSColor *)tint 
{
	if (tint != nil) {
		NSSize size = [self size];
		NSRect bounds = { NSZeroPoint, size };
		NSImage *tintedImage = [[NSImage alloc] initWithSize:size];
		
		[tintedImage lockFocus];
		
		CIFilter *colorGenerator = [CIFilter filterWithName:@"CIConstantColorGenerator"];
		CIColor *color = [[CIColor alloc] initWithColor:tint];
		
		[colorGenerator setValue:color forKey:@"inputColor"];
		
		CIFilter *monochromeFilter = [CIFilter filterWithName:@"CIColorMonochrome"];
		CIImage *baseImage = [CIImage imageWithData:[self TIFFRepresentation]];
		
		[monochromeFilter setValue:baseImage forKey:@"inputImage"];             
		[monochromeFilter setValue:[CIColor colorWithRed:0.75 green:0.75 blue:0.75] forKey:@"inputColor"];
		[monochromeFilter setValue:@1.0f forKey:@"inputIntensity"];
		
		CIFilter *compositingFilter = [CIFilter filterWithName:@"CIMultiplyCompositing"];
		
		[compositingFilter setValue:[colorGenerator valueForKey:@"outputImage"] forKey:@"inputImage"];
		[compositingFilter setValue:[monochromeFilter valueForKey:@"outputImage"] forKey:@"inputBackgroundImage"];
		
		CIImage *outputImage = [compositingFilter valueForKey:@"outputImage"];
		
		[outputImage drawAtPoint:NSZeroPoint
						fromRect:bounds
					   operation:NSCompositeCopy
						fraction:1.0];
		
		[tintedImage unlockFocus];  
		
		return tintedImage;
	}
	else {
		return [self copy];
	}
}

- (NSImage *) filteredMonochromeEdge
{
		NSSize size = [self size];
		NSRect bounds = { NSZeroPoint, size };
		NSImage *tintedImage = [[NSImage alloc] initWithSize:size];
		CIImage *filterPreviewImage = [self  toCIImage];
		[tintedImage lockFocus];
		CIFilter *edgeWork = [CIFilter filterWithName:@"CIEdgeWork"
										keysAndValues:kCIInputImageKey,filterPreviewImage,
							  @"inputRadius",@4.6f,
							  nil];

		CIFilter *masktoalpha = [CIFilter filterWithName:@"CIMaskToAlpha"];
        [masktoalpha setValue:filterPreviewImage forKey:@"inputImage"];
        filterPreviewImage = [masktoalpha valueForKey:@"outputImage"];



		[filterPreviewImage drawAtPoint:NSZeroPoint
						fromRect:bounds
					   operation:NSCompositeCopy
						fraction:1.0];

		[tintedImage unlockFocus];

		return tintedImage;
//	}
//	else {
//		return [self copy];
//	}
}


- (NSBitmapImageRep*) bitmap {
	// returns a 32-bit bitmap rep of the receiver, whatever its original format. The image rep is not added to the image.
	NSSize size = [self size];
	int rowBytes = ((int)(ceil(size.width)) * 4 + 0x0000000F) & ~0x0000000F; // 16-byte aligned
	int bps=8, spp=4, bpp=bps*spp;
	
	// NOTE: These settings affect how pixels are converted to NSColors
	NSBitmapImageRep *imageRep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:nil
																		 pixelsWide:size.width
																		 pixelsHigh:size.height
																	  bitsPerSample:bps
																	samplesPerPixel:spp
																		   hasAlpha:YES
																		   isPlanar:NO
																	 colorSpaceName:NSCalibratedRGBColorSpace
																	   bitmapFormat:NSAlphaFirstBitmapFormat
																		bytesPerRow:rowBytes
																	   bitsPerPixel:bpp];
	
	if (!imageRep) return nil;
	
	NSGraphicsContext* imageContext = [NSGraphicsContext graphicsContextWithBitmapImageRep:imageRep];
	
	[NSGraphicsContext saveGraphicsState];
	[NSGraphicsContext setCurrentContext:imageContext];
	[self drawAtPoint:NSZeroPoint fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0];
	[NSGraphicsContext restoreGraphicsState];
	
	return imageRep;
}

- (CGImageRef) cgImage {
	NSBitmapImageRep*	bm = [self bitmap]; // data provider will release this
	int					rowBytes, width, height;
	
	rowBytes = [bm bytesPerRow];
	width = [bm pixelsWide];
	height = [bm pixelsHigh];
	
	CGDataProviderRef provider = CGDataProviderCreateWithData((__bridge void *)bm, [bm bitmapData], rowBytes * height, BitmapReleaseCallback );
	CGColorSpaceRef colorspace = CGColorSpaceCreateWithName( kCGColorSpaceGenericRGB );
	CGBitmapInfo	bitsInfo = kCGImageAlphaLast;
	
	//	CGImageRef img 
	return  CGImageCreate( width, height, 8, 32, rowBytes, colorspace, bitsInfo, provider, NULL, NO, kCGRenderingIntentDefault );
	
	//	CGDataProviderRelease( provider );
	//	CGColorSpaceRelease( colorspace );
	//	
	//	return img;
}


/*!
 @brief    Rotates an image around its center by a given
 angle in degrees and returns the new image.
 
 @details  The width and height of the returned image are,
 respectively, the height and width of the receiver.
 
 I have not yet tested this with a non-square image.
 */

- (NSImage*)imageRotatedByDegrees:(CGFloat)degrees {
	NSSize rotatedSize = NSMakeSize(self.size.height, self.size.width) ;
	NSImage* rotatedImage = [[NSImage alloc] initWithSize:rotatedSize] ;
	
    NSAffineTransform* transform = [NSAffineTransform transform] ;
	
    // In order to avoid clipping the image, translate
    // the coordinate system to its center
    [transform translateXBy:+self.size.width/2
                        yBy:+self.size.height/2] ;
    // then rotate
    [transform rotateByDegrees:degrees] ;
    // Then translate the origin system back to
    // the bottom left
    [transform translateXBy:-rotatedSize.width/2
                        yBy:-rotatedSize.height/2] ;
	
    [rotatedImage lockFocus] ;
    [transform concat] ;
    [self drawAtPoint:NSMakePoint(0,0)
             fromRect:NSZeroRect
            operation:NSCompositeCopy
             fraction:1.0] ;
    [rotatedImage unlockFocus] ;
	
    return rotatedImage;
}





- (NSImage*)imageByScalingProportionallyToSize:(NSSize)targetSize background:(NSColor*)bk
{
	NSImage* sourceImage = self;
	NSImage* newImage = nil;
	
	if ([sourceImage isValid])
	{
		NSSize imageSize = [self sizeLargestRepresentation];
		
		if (imageSize.width  <= targetSize.width &&
			imageSize.height <= targetSize.height)
		{
			[self setSize:imageSize];
			return self;
		}
		
		float scaleFactor  = 0.0;
		float scaledWidth  = targetSize.width;
		float scaledHeight = targetSize.height;
		
		float widthFactor  = targetSize.width / imageSize.width;
		float heightFactor = targetSize.height / imageSize.height;
		
		if ( widthFactor < heightFactor )
			scaleFactor = widthFactor;
		else
			scaleFactor = heightFactor;
		
		scaledWidth  = imageSize.width  * scaleFactor;
		scaledHeight = imageSize.height * scaleFactor;
		
		newImage = [[NSImage alloc] initWithSize:NSMakeSize(scaledWidth, scaledHeight)];
		
		NSRect thumbnailRect;
		thumbnailRect.origin      = NSMakePoint(0,0);
		thumbnailRect.size.width  = scaledWidth;
		thumbnailRect.size.height = scaledHeight;		
		
		[newImage lockFocus];
		[bk drawSwatchInRect:thumbnailRect];
		
		[[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
		
		[sourceImage drawInRect: thumbnailRect
					   fromRect: NSZeroRect
					  operation: NSCompositeSourceOver
					   fraction: 1.0];
		
		[newImage unlockFocus];		
	}
	
	return newImage;
}

/*- (NSImage*)imageByScalingProportionallyToSize:(NSSize)targetSize
{
	NSImage* sourceImage = self;
	NSImage* newImage = nil;
	
	if ([sourceImage isValid])
	{
		NSSize imageSize = [self sizeLargestRepresentation];
		
		if (imageSize.width  <= targetSize.width &&
			imageSize.height <= targetSize.height)
		{
			[self setSize:imageSize];
			return self;
		}
		
		float scaleFactor  = 0.0;
		float scaledWidth  = targetSize.width;
		float scaledHeight = targetSize.height;
		
		float widthFactor  = targetSize.width / imageSize.width;
		float heightFactor = targetSize.height / imageSize.height;
		
		if ( widthFactor < heightFactor )
			scaleFactor = widthFactor;
		else
			scaleFactor = heightFactor;
		
		scaledWidth  = imageSize.width  * scaleFactor;
		scaledHeight = imageSize.height * scaleFactor;
		
		newImage = [[NSImage alloc] initWithSize:NSMakeSize(scaledWidth, scaledHeight)];
		
		[newImage lockFocus];
		[[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
		
		NSRect thumbnailRect;
		thumbnailRect.origin      = NSMakePoint(0,0);
		thumbnailRect.size.width  = scaledWidth;
		thumbnailRect.size.height = scaledHeight;
		
		[sourceImage drawInRect: thumbnailRect
					   fromRect: NSZeroRect
					  operation: NSCompositeSourceOver
					   fraction: 1.0];
		
		[newImage unlockFocus];
	}
	
	return newImage;
}*/

- (void)drawInRect:(NSRect)dstRect operation:(NSCompositingOperation)op fraction:(float)delta method:(AGImageResizingMethod)resizeMethod
{
	float sourceWidth = [self sizeLargestRepresentation].width;
	float sourceHeight = [self sizeLargestRepresentation].height;
	float targetWidth = dstRect.size.width;
	float targetHeight = dstRect.size.height;
	BOOL cropping = !(resizeMethod == AGImageResizeScale);
	
	// Calculate aspect ratios
	float sourceRatio = sourceWidth / sourceHeight;
	float targetRatio = targetWidth / targetHeight;
	
	// Determine what side of the source image to use for proportional scaling
	BOOL scaleWidth = (sourceRatio <= targetRatio);
	// Deal with the case of just scaling proportionally to fit, without cropping
	scaleWidth = (cropping) ? scaleWidth : !scaleWidth;
	
	// Proportionally scale source image
	float scalingFactor, scaledWidth, scaledHeight;
	if (scaleWidth) {
		scalingFactor = 1.0 / sourceRatio;
		scaledWidth = targetWidth;
		scaledHeight = round(targetWidth * scalingFactor);
	} else {
		scalingFactor = sourceRatio;
		scaledWidth = round(targetHeight * scalingFactor);
		scaledHeight = targetHeight;
	}
	float scaleFactor = scaledHeight / sourceHeight;
	
	// Calculate compositing rectangles
	NSRect sourceRect;
	if (cropping) {
		float destX, destY;
		if (resizeMethod == AGImageResizeCrop) {
			// Crop center
			destX = round((scaledWidth - targetWidth) / 2.0);
			destY = round((scaledHeight - targetHeight) / 2.0);
		} else if (resizeMethod == AGImageResizeCropStart) {
			// Crop top or left (prefer top)
			if (scaleWidth) {
				// Crop top
				destX = round((scaledWidth - targetWidth) / 2.0);
				destY = round(scaledHeight - targetHeight);
			} else {
				// Crop left
				destX = 0.0;
				destY = round((scaledHeight - targetHeight) / 2.0);
			}
		} else if (resizeMethod == AGImageResizeCropEnd) {
			// Crop bottom or right
			if (scaleWidth) {
				// Crop bottom
				destX = 0.0;
				destY = 0.0;
			} else {
				// Crop right
				destX = round(scaledWidth - targetWidth);
				destY = round((scaledHeight - targetHeight) / 2.0);
			}
		}
		sourceRect = NSMakeRect(destX / scaleFactor, destY / scaleFactor, 
								targetWidth / scaleFactor, targetHeight / scaleFactor);
	} else {
		sourceRect = NSMakeRect(0, 0, sourceWidth, sourceHeight);
		dstRect.origin.x += (targetWidth - scaledWidth) / 2.0;
		dstRect.origin.y += (targetHeight - scaledHeight) / 2.0;
		dstRect.size.width = scaledWidth;
		dstRect.size.height = scaledHeight;
	}
	
	[self drawInRect:dstRect fromRect:sourceRect operation:op fraction:delta];
}

- (NSImage *)imageToFitSize:(NSSize)size method:(AGImageResizingMethod)resizeMethod
{
	NSImage *result = [[NSImage alloc] initWithSize:size];
	
	// Composite image appropriately
	[result lockFocus];
//	[[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
	[self drawInRect:NSMakeRect(0,0,size.width,size.height) operation:NSCompositeSourceOver fraction:1.0 method:resizeMethod];
	[result unlockFocus];
	
	return result;
}

- (NSImage *)imageCroppedToFitSize:(NSSize)size
{
	return [self imageToFitSize:size method:AGImageResizeCrop];
}

- (NSImage *)scaledToMax:(CGFloat)f {
	return [self imageScaledToFitSize: AZSizeFromDimension(f)];
}

- (NSImage *)imageScaledToFitSize:(NSSize)size
{
	[self setScalesWhenResized:YES];
	[self setSize: size];
	return self;
}

- (NSImageRep*)smallestRepresentation
{
	int area = 0;
	NSImageRep* smallest = nil;
	
	for (NSImageRep* rep in [self representations])
	{
		int a = [rep pixelsWide] * [rep pixelsHigh];
		if (a < area)
		{
			area = a;
			smallest = rep;
		}
	}
	return smallest;
}
- (NSSize)sizeSmallestRepresentation
{
	NSImageRep* rep = [self smallestRepresentation];
	if (rep)		
		return NSMakeSize([rep pixelsWide], [rep pixelsHigh]);
	else
		return [self size];
}


- (NSImageRep*)largestRepresentation
{
	int area = 0;
	NSImageRep* largest = nil;
	
	for (NSImageRep* rep in [self representations])
	{
		int a = [rep pixelsWide] * [rep pixelsHigh];
		if (a > area)
		{
			area = a;
			largest = rep;
		}
	}
	return largest;
}

- (NSSize)sizeLargestRepresentation
{
	NSImageRep* rep = [self largestRepresentation];
	if (rep)		
		return NSMakeSize([rep pixelsWide], [rep pixelsHigh]);
	else
		return [self size];
}

- (NSImage*)rotated:(int)angle
/*{
if (angle == 0 || ![self isValid])
return self;

NSSize beforeSize = [self size];

NSSize afterSize = (angle == 90 || angle == -90) ? NSMakeSize(beforeSize.height, beforeSize.width) : beforeSize;

NSAffineTransform* trans = [NSAffineTransform transform];
[trans translateXBy:afterSize.width * 0.5 yBy:afterSize.height * 0.5];
[trans rotateByDegrees:angle];
[trans translateXBy:-beforeSize.width * 0.5 yBy:-beforeSize.height * 0.5];

NSImage* newImage = [[NSImage alloc] initWithSize:afterSize];

[newImage lockFocus];

[trans set];
[self drawAtPoint:NSZeroPoint fromRect:NSMakeRect(0, 0, beforeSize.width, beforeSize.height) operation:NSCompositeSourceOver fraction:1.0];

[newImage unlockFocus];

return [newImage autorelease];	
}*/
{
	if (angle != 90 && angle != 270)	return self;
	
	NSImage *existingImage = self;		NSSize existingSize;
	
	/**  Get the size of the original image in its raw bitmap format.  The bestRepresentationForDevice: nil tells the NSImage to just give us the raw image instead of it's wacky DPI-translated version.   */
	//	 NSBitmapImageRep = [existingImage bitmap];

	existingSize.width = 	[[existingImage bestRepresentationForRect:AZMakeRectFromSize(existingSize)
														      context:[NSGraphicsContext currentContext] hints:nil] pixelsWide];
	existingSize.height = [[existingImage bestRepresentationForRect:AZMakeRectFromSize(existingSize)
															  context:[NSGraphicsContext currentContext] hints:nil] pixelsHigh];
	NSSize newSize = NSMakeSize(existingSize.height, existingSize.width);
	NSImage *rotatedImage = [[NSImage alloc] initWithSize:newSize];
	[rotatedImage lockFocus];
	
	/**
	 * Apply the following transformations:
	 *
	 * - bring the rotation point to the centre of the image instead of
	 *   the default lower, left corner (0,0).
	 * - rotate it by 90 degrees, either clock or counter clockwise.
	 * - re-translate the rotated image back down to the lower left corner
	 *   so that it appears in the right place.
	 */
	NSAffineTransform *rotateTF = [NSAffineTransform transform];
	NSPoint centerPoint = NSMakePoint(newSize.width / 2, newSize.height / 2);
	
	[rotateTF translateXBy: centerPoint.x yBy: centerPoint.y];
	[rotateTF rotateByDegrees: angle];
	[rotateTF translateXBy: -centerPoint.y yBy: -centerPoint.x];
	[rotateTF concat];
	
	/**
	 * We have to get the image representation to do its drawing directly,
	 * because otherwise the stupid NSImage DPI thingie bites us in the butt
	 * again.
	 */
	NSRect r1 = NSMakeRect(0, 0, newSize.height, newSize.width);
	[existingImage bestRepresentationForRect:r1 context:nil hints:nil];// drawInRect: r1];
	
	[rotatedImage unlockFocus];
	
	return rotatedImage;
}

- (NSRect) proportionalRectForTargetRect:(NSRect)targetRect {
	// if the sizes are the same, we're already done.
	if ( NSEqualSizes(self.size, targetRect.size) ) return targetRect;
	NSSize imageSize = self.size; CGFloat soureWidth = imageSize.width; CGFloat sourceHeight = imageSize.height;
	// figure out the difference in size for each side, and use
	// the larger adjustment for both edges (maintains aspect ratio).
	CGFloat widthAdjust = targetRect.size.width / soureWidth; 
	CGFloat heightAdjust = targetRect.size.height / sourceHeight; CGFloat scaleFactor = 1.0;
	if ( widthAdjust < heightAdjust )		scaleFactor = widthAdjust;
	else								scaleFactor = heightAdjust;
	// resize both edges by the same amount.
	CGFloat finalWidth = soureWidth * scaleFactor;
	CGFloat finalHeight = sourceHeight * scaleFactor;
	NSSize finalSize = NSMakeSize ( finalWidth, finalHeight );
	// actual rect we'll use for the image. 
	NSRect finalRect;
	finalRect.size = finalSize;
	// use the same base origin as the target rect, but adjust for the resized image.
	finalRect.origin = targetRect.origin;
	finalRect.origin.x += (targetRect.size.width - finalWidth) * 0.5;
	finalRect.origin.y += (targetRect.size.height - finalHeight) * 0.5;
	// return exact coordinates for a sharp image.
	return NSIntegralRect ( finalRect );
	
}

- (CIImage *)toCIImage
{
	NSBitmapImageRep *bitmapimagerep = [self bitmap];
	CIImage *im = [[CIImage alloc]	initWithBitmapImageRep:bitmapimagerep];
	return im;
}


-(NSImage*)	imageByRemovingTransparentAreasWithFinalRect: (NSRect*)outBox
{
	NSRect		oldRect = NSZeroRect;
	oldRect.size = [self size];
	*outBox = oldRect;
	
	[self lockFocus];
	
	// Cut off any empty rows at the bottom:
	for( int y = 0; y < oldRect.size.height; y++ )
	{
		for( int x = 0; x < oldRect.size.width; x++ )
		{
			NSColor*	theCol = NSReadPixel( NSMakePoint( x, y ) );
			if( [theCol alphaComponent] > 0.01 )
				goto bottomDone;
		}
		
		outBox->origin.y += 1;
		outBox->size.height -= 1;
	}
	
bottomDone:
	// Cut off any empty rows at the top:
	for( int y = oldRect.size.height -1; y >= 0; y-- )
	{
		for( int x = 0; x < oldRect.size.width; x++ )
		{
			NSColor*	theCol = NSReadPixel( NSMakePoint( x, y ) );
			if( [theCol alphaComponent] > 0.01 )
				goto topDone;
		}
		
		outBox->size.height -= 1;
	}
	
topDone:
	// Cut off any empty rows at the left:
	for( int x = 0; x < oldRect.size.width; x++ )
	{
		for( int y = 0; y < oldRect.size.height; y++ )
		{
			NSColor*	theCol = NSReadPixel( NSMakePoint( x, y ) );
			if( [theCol alphaComponent] > 0.01 )
				goto leftDone;
		}
		
		outBox->origin.x += 1;
		outBox->size.width -= 1;
	}
	
leftDone:
	// Cut off any empty rows at the right:
	for( int x = oldRect.size.width -1; x >= 0; x-- )
	{
		for( int y = 0; y < oldRect.size.height; y++ )
		{
			NSColor*	theCol = NSReadPixel( NSMakePoint( x, y ) );
			if( [theCol alphaComponent] > 0.01 )
				goto rightDone;
		}
		
		outBox->size.width -= 1;
	}
	
rightDone:
	[self unlockFocus];
	
	// Now create new image with that subsection:
	NSImage*	returnImg = [[NSImage alloc] initWithSize: outBox->size];
	NSRect		destBox = *outBox;
	destBox.origin = NSZeroPoint;
	
	[returnImg lockFocus];
	[self drawInRect: destBox fromRect: *outBox operation: NSCompositeCopy fraction: 1.0];
	[[NSColor redColor] set];
	[NSBezierPath strokeRect: destBox];
	[returnImg unlockFocus];
	
	return returnImg;
}

//+(NSImage *) fromSVG:(NSString *)documentName withAlpha:(BOOL)hasAlpha {
//	
//	SVGDocument *document = [SVGDocument documentNamed:documentName];
//	NSBitmapImageRep *rep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL
//																	pixelsWide:document.width
//																	pixelsHigh:document.height
//																 bitsPerSample:8
//															   samplesPerPixel:3
//																	  hasAlpha:hasAlpha
//																	  isPlanar:NO
//																colorSpaceName:NSCalibratedRGBColorSpace
//																   bytesPerRow:4 * document.width
//																  bitsPerPixel:32];
//	
//	CGContextRef context = [[NSGraphicsContext graphicsContextWithBitmapImageRep:rep] graphicsPort];
//	//	if (!hasAlpha) 
//	CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 1.0f); // white background
//	CGContextFillRect(context, CGRectMake(0.0f, 0.0f, document.width, document.height));
//	CGContextScaleCTM(context, 1.0f, -1.0f); // flip
//	CGContextTranslateCTM(context, 0.0f, -document.height);
//	[[document layerTree] renderInContext:context];
//	CGImageRef image = CGBitmapContextCreateImage(context);
//	NSBitmapImageRep *rendering = [[NSBitmapImageRep alloc] initWithCGImage:image];
//	CGImageRelease(image);
//	NSImage * rendered = [[NSImage alloc] initWithSize:[rendering size]];
//	[rendered setScalesWhenResized:YES];
//	[rendered addRepresentation: rendering];
//	return rendered;
//}

+ (NSArray*) systemImages {
	static NSArray *_systemImages;
	return _systemImages = _systemImages != nil
					     ? _systemImages // This will only be true the first time the method is called...
						 : @[
				  [NSImage imageNamed:NSImageNameQuickLookTemplate],
				  [NSImage imageNamed:NSImageNameBluetoothTemplate], 
				  [NSImage imageNamed:NSImageNameIChatTheaterTemplate], 
				  [NSImage imageNamed:NSImageNameSlideshowTemplate], 
				  [NSImage imageNamed:NSImageNameActionTemplate],
				  [NSImage imageNamed:NSImageNameSmartBadgeTemplate], 
				  [NSImage imageNamed:NSImageNameIconViewTemplate], 
				  [NSImage imageNamed:NSImageNameListViewTemplate], 
				  [NSImage imageNamed:NSImageNameColumnViewTemplate], 
				  [NSImage imageNamed:NSImageNameFlowViewTemplate], 
				  [NSImage imageNamed:NSImageNamePathTemplate], 
				  [NSImage imageNamed:NSImageNameInvalidDataFreestandingTemplate], 
				  [NSImage imageNamed:NSImageNameLockLockedTemplate], 
				  [NSImage imageNamed:NSImageNameLockUnlockedTemplate], 
				  [NSImage imageNamed:NSImageNameGoRightTemplate],
				  [NSImage imageNamed:NSImageNameGoLeftTemplate],
				  [NSImage imageNamed:NSImageNameRightFacingTriangleTemplate], 
				  [NSImage imageNamed:NSImageNameLeftFacingTriangleTemplate], 
				  [NSImage imageNamed:NSImageNameAddTemplate], 
				  [NSImage imageNamed:NSImageNameRemoveTemplate], 
				  [NSImage imageNamed:NSImageNameRevealFreestandingTemplate], 
				  [NSImage imageNamed:NSImageNameFollowLinkFreestandingTemplate], 
				  [NSImage imageNamed:NSImageNameEnterFullScreenTemplate], 
				  [NSImage imageNamed:NSImageNameExitFullScreenTemplate], 
				  [NSImage imageNamed:NSImageNameStopProgressTemplate], 
				  [NSImage imageNamed:NSImageNameStopProgressFreestandingTemplate], 
				  [NSImage imageNamed:NSImageNameRefreshTemplate], 
				  [NSImage imageNamed:NSImageNameRefreshFreestandingTemplate], 
				  [NSImage imageNamed:NSImageNameBonjour], 
				  [NSImage imageNamed:NSImageNameComputer], 
				  [NSImage imageNamed:NSImageNameFolderBurnable], 
				  [NSImage imageNamed:NSImageNameFolderSmart], 
				  [NSImage imageNamed:NSImageNameFolder], 
				  [NSImage imageNamed:NSImageNameNetwork], 
				  [NSImage imageNamed:NSImageNameDotMac], 
				  [NSImage imageNamed:NSImageNameMobileMe], 
				  [NSImage imageNamed:NSImageNameMultipleDocuments], 
				  [NSImage imageNamed:NSImageNameUserAccounts], 
				  [NSImage imageNamed:NSImageNamePreferencesGeneral], 
				  [NSImage imageNamed:NSImageNameAdvanced], 
				  [NSImage imageNamed:NSImageNameInfo], 
				  [NSImage imageNamed:NSImageNameFontPanel], 
				  [NSImage imageNamed:NSImageNameColorPanel], 
				  [NSImage imageNamed:NSImageNameUser], 
				  [NSImage imageNamed:NSImageNameUserGroup], 
				  [NSImage imageNamed:NSImageNameEveryone],
				  [NSImage imageNamed:NSImageNameUserGuest], 
				  [NSImage imageNamed:NSImageNameMenuOnStateTemplate], 
				  [NSImage imageNamed:NSImageNameMenuMixedStateTemplate], 
				  [NSImage imageNamed:NSImageNameApplicationIcon], 
				  [NSImage imageNamed:NSImageNameTrashEmpty], 
				  [NSImage imageNamed:NSImageNameTrashFull], 
				  [NSImage imageNamed:NSImageNameHomeTemplate], 
				  [NSImage imageNamed:NSImageNameBookmarksTemplate], 
				  [NSImage imageNamed:NSImageNameCaution], 
				  [NSImage imageNamed:NSImageNameStatusAvailable], 
				  [NSImage imageNamed:NSImageNameStatusPartiallyAvailable], 
				  [NSImage imageNamed:NSImageNameStatusUnavailable], 
				  [NSImage imageNamed:NSImageNameStatusNone]
								  ];
	
}

- (NSImage*) addReflection:(CGFloat)percentage
{
	NSAssert(percentage > 0 && percentage <= 1.0, @"Please use percentage between 0 and 1");
	CGRect offscreenFrame = CGRectMake(0, 0, self.size.width, self.size.height*(1.0+percentage));
	NSBitmapImageRep * offscreen = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL
																		   pixelsWide:offscreenFrame.size.width
																		   pixelsHigh:offscreenFrame.size.height
																		bitsPerSample:8
																	  samplesPerPixel:4 
																			 hasAlpha:YES
																			 isPlanar:NO 
																	   colorSpaceName:NSDeviceRGBColorSpace
																		 bitmapFormat:0
																		  bytesPerRow:offscreenFrame.size.width * 4
																		 bitsPerPixel:32];
	
	[NSGraphicsContext saveGraphicsState];
	[NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithBitmapImageRep:offscreen]];
	
	[[NSColor clearColor] set];
	NSRectFill(offscreenFrame);
	
	NSGradient * fade = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:1.0 alpha:0.2] endingColor:[NSColor clearColor]];
	CGRect fadeFrame = CGRectMake(0, 0, self.size.width, offscreen.size.height - self.size.height);
	[fade drawInRect:fadeFrame angle:270.0];	
	
    NSAffineTransform* transform = [NSAffineTransform transform];
    [transform translateXBy:0.0 yBy:fadeFrame.size.height];
    [transform scaleXBy:1.0 yBy:-1.0];
    [transform concat];
	
	// Draw the image over the gradient -> becomes reflection
	[self drawAtPoint:NSMakePoint(0, 0) fromRect:CGRectMake(0, 0, self.size.width, self.size.height) operation:NSCompositeSourceIn fraction:1.0];
	
	[transform invert];
	[transform concat];
	
	// Draw the original image
	[self drawAtPoint:CGPointMake(0, offscreenFrame.size.height - self.size.height) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
	
	[NSGraphicsContext restoreGraphicsState];
	
	NSImage * imageWithReflection = [[NSImage alloc] initWithSize:offscreenFrame.size];
	[imageWithReflection addRepresentation:offscreen];
	
	return imageWithReflection;
}


//+ (NSImage*)imageFromCGImageRef:(CGImageRef)image {
//	NSImage* newImage = nil;
////#if MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5
//	NSBitmapImageRep*    newRep = [[NSBitmapImageRep alloc]initWithCGImage:image];
//	NSSize imageSize;
//	// Get the image dimensions.
//	imageSize.height = CGImageGetHeight(image);
//	imageSize.width = CGImageGetWidth(image);
//	newImage = [[NSImage alloc] initWithSize:imageSize];
//	[newImage addRepresentation:newRep];
////#else
////	NSRect imageRect = NSMakeRect(0.0, 0.0, 0.0, 0.0);
////	CGContextRef imageContext = nil;
////	// Get the image dimensions.
////	imageRect.size.height = CGImageGetHeight(image);
////	imageRect.size.width = CGImageGetWidth(image);
////	// Create a new image to receive the Quartz image data.
////	newImage = [[NSImage alloc] initWithSize:imageRect.size];
////	[newImage lockFocus];
////	// Get the Quartz context and draw.
////	imageContext = (CGContextRef)[[NSGraphicsContext currentContext]graphicsPort];
////	CGContextDrawImage(imageContext, *(CGRect*)&imageRect, image);
////	[newImage unlockFocus];
////#endif
//	return newImage;
//}

- (void)drawEtchedInRect:(NSRect)rect
{
    NSSize size = rect.size;
    CGFloat dropShadowOffsetY = size.width <= 64.0 ? -1.0 : -2.0;
    CGFloat innerShadowBlurRadius = size.width <= 32.0 ? 1.0 : 4.0;
	
    CGContextRef c = [[NSGraphicsContext currentContext] graphicsPort];
	
    //save the current graphics state
    CGContextSaveGState(c);
	
    //Create mask image:
    NSRect maskRect = rect;
    CGImageRef maskImage = [self CGImageForProposedRect:&maskRect context:[NSGraphicsContext currentContext] hints:nil];
	
    //Draw image and white drop shadow:
    CGContextSetShadowWithColor(c, CGSizeMake(0, dropShadowOffsetY), 0, CGColorGetConstantColor(kCGColorWhite));
    [self drawInRect:maskRect fromRect:NSMakeRect(0, 0, self.size.width, self.size.height) operation:NSCompositeSourceOver fraction:1.0];
	
    //Clip drawing to mask:
    CGContextClipToMask(c, NSRectToCGRect(maskRect), maskImage);
	
    //Draw gradient:
    NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithDeviceWhite:0.5 alpha:1.0]
														 endingColor:[NSColor colorWithDeviceWhite:0.25 alpha:1.0]];
    [gradient drawInRect:maskRect angle:90.0];
    CGContextSetShadowWithColor(c, CGSizeMake(0, -1), innerShadowBlurRadius, CGColorGetConstantColor(kCGColorBlack));
	
    //Draw inner shadow with inverted mask:
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef maskContext = CGBitmapContextCreate(NULL, CGImageGetWidth(maskImage), CGImageGetHeight(maskImage), 8, CGImageGetWidth(maskImage) * 4, colorSpace, kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(maskContext, kCGBlendModeXOR);
    CGContextDrawImage(maskContext, maskRect, maskImage);
    CGContextSetRGBFillColor(maskContext, 1.0, 1.0, 1.0, 1.0);
    CGContextFillRect(maskContext, maskRect);
    CGImageRef invertedMaskImage = CGBitmapContextCreateImage(maskContext);
    CGContextDrawImage(c, maskRect, invertedMaskImage);
    CGImageRelease(invertedMaskImage);
    CGContextRelease(maskContext);
	
    //restore the graphics state
    CGContextRestoreGState(c);
}




CGContextRef MyCreateBitmapContext (int pixelsWide, int pixelsHigh)
{
	CGContextRef myContext = NULL;
	CGColorSpaceRef myColorSpace;
	void *bitmapData;
	int bitmapByteCount;
	int bitmapBytesPerRow;
	
	bitmapBytesPerRow = (pixelsWide * 4);
	bitmapByteCount = (bitmapBytesPerRow * pixelsHigh);
	
	myColorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericGray);
	
	bitmapData = malloc(bitmapByteCount);
	
	if (bitmapData == NULL) {
		fprintf(stderr, "Memory not Allocated");
		return NULL;
	}
	
	myContext = CGBitmapContextCreate(bitmapData,
									  pixelsWide,
									  pixelsHigh,
									  8,
									  bitmapBytesPerRow,
									  myColorSpace,
									  kCGImageAlphaNone);
	if (myContext == NULL) {
		free(bitmapData);
		fprintf(stderr, "myContext not created");
		return NULL;
	}
	
	CGColorSpaceRelease(myColorSpace);
	
	return myContext;
}

- (NSImage *)maskedWithColor:(NSColor *)color
{
	NSImage *image = self;
	CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextRef c = MyCreateBitmapContext(image.size.width, image.size.height);
 	[image drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
 	CGContextSetFillColorWithColor(c, [color CGColor]);
	CGContextSetBlendMode(c, kCGBlendModeSourceAtop);
	CGContextFillRect(c, rect);
    CGImageRef ciImage =  CGBitmapContextCreateImage(c);
    CGContextDrawImage(c, rect, ciImage);
	NSImage *newImage= [[NSImage alloc] initWithCGImage:ciImage size:image.size];
	CGContextRelease(c);
    CGImageRelease(ciImage);
    return newImage;
}

#pragma mark CGImage to NSImage and vice versa

+ (NSImage*)imageFromCGImageRef:(CGImageRef)image {
	// #if MAC_OS_X_VERSION_MIN_REQUIRED > MAC_OS_X_VERSION_10_5
	// This is 10.6 only
    NSImage *newImage = [[NSImage alloc] initWithCGImage:image 
													size:NSZeroSize]; 
	
    return newImage;
}

- (CGImageRef)cgImageRef {
	NSData *imageData = [self TIFFRepresentation];
    CGImageRef imageRef;
    
	if(imageData) {
		// #if MAC_OS_X_VERSION_MIN_REQUIRED > MAC_OS_X_VERSION_10_5  THIS MEANS 10.6
		imageRef = [self CGImageForProposedRect:NULL context:nil hints:nil]; //10.6
		return imageRef;
	}
	
	// original approach
	//if (imageData) {
	
	//CGImageSourceRef imageSource = CGImageSourceCreateWithData((CFDataRef)imageData, NULL);
	//imageRef = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
	//CFRelease(imageSource);
	
	// [(id)aCGImageRef autorelease];
	// Be carefull when you mix CFType memory management, and obj-c memory management. 
	// It works well when you do not use GC, but may become problematic if you do not take special care with GC code.
	// If I'm not wrong, it should be something like this:
	// [NSMakeCollectable(aCGImageRef) autorelease]
	
	// bad: memory leak
	//return imageRef;
	
	// good: no memory leak
	//[NSMakeCollectable(imageRef) autorelease];
	//return imageRef;
	//}
	
	return NULL;
}



#pragma mark Quicklook Preview

+ (NSImage *)imageWithPreviewOfFileAtPath:(NSString *)path ofSize:(NSSize)size asIcon:(BOOL)icon {
	NSURL *fileURL = [NSURL fileURLWithPath:path];
    if (!path || !fileURL) return nil;
    NSDictionary *dict = @{(NSString *)kQLThumbnailOptionIconModeKey: @(icon)};
    CGImageRef ref = QLThumbnailImageCreate(kCFAllocatorDefault, 
                                            (__bridge CFURLRef)fileURL, 
                                            CGSizeMake(size.width, size.height),
                                            (__bridge CFDictionaryRef)dict);
    
    if (ref != NULL) {
        // Take advantage of NSBitmapImageRep's -initWithCGImage: initializer, new in Leopard,
        // which is a lot more efficient than copying pixel data into a brand new NSImage.
        // Thanks to Troy Stephens @ Apple for pointing this new method out to me.
        NSBitmapImageRep *bitmapImageRep = [[NSBitmapImageRep alloc] initWithCGImage:ref];
        NSImage *newImage = nil;
        if (bitmapImageRep) {
            newImage = [[NSImage alloc] initWithSize:[bitmapImageRep size]];
            [newImage addRepresentation:bitmapImageRep];
            if (newImage) {				CFRelease(ref);
                return newImage;
            }
        }
        CFRelease(ref);
    } else {
        // If we couldn't get a Quick Look preview, fall back on the file's Finder icon.
        NSImage *icon = [[NSWorkspace sharedWorkspace] iconForFile:path];
        if (icon) {
            [icon setSize:size];
        }
        return icon;
    }
	
    return nil;
}



#pragma mark Resizing Image


+ (NSImage *)resizedImage:(NSImage *)sourceImage 
				  newSize:(NSSize)size 
		  lockAspectRatio:(BOOL)lock // pass YES if you want to lock aspect ratio
   lockAspectRatioByWidth:(BOOL)flag // pass YES to lock aspect ratio by width or passing NO to lock by height
{
	NSSize oldSize = [sourceImage size];
	CGFloat ratio = oldSize.width / oldSize.height;
	// if new size is equal to or larger than the original image, we won't resize it
	if (size.height >= oldSize.height || size.width >= oldSize.width) 
		return sourceImage;
	
	if (lock) {
		if (flag)
			size.height = size.width / ratio;
		else
			size.width = size.height * ratio;
	}
	
	NSImage *resizedImage = [[NSImage alloc] initWithSize:size];
	[[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
	[resizedImage lockFocus];
	
	[sourceImage drawInRect:NSMakeRect(0.0, 0.0, size.width, size.height) 
				   fromRect:NSMakeRect(0.0, 0.0, [sourceImage size].width, [sourceImage size].height) 
				  operation:NSCompositeSourceOver fraction:1.0];
	
	[resizedImage unlockFocus];
	
	return resizedImage;
}



#pragma mark Cropping Image

- (NSImage *)croppedImage:(CGRect)bounds
{
	[self lockFocus];
    CGImageRef imageRef = CGImageCreateWithImageInRect([self cgImageRef], bounds);
	NSImage *croppedImage = [NSImage imageFromCGImageRef:imageRef];
    CGImageRelease(imageRef);
	[self unlockFocus];
    return croppedImage;
}



#pragma mark Save Image

- (BOOL)saveImage:(NSString *)path fileName:(NSString *)name fileType:(NSBitmapImageFileType)type
{	
	// deal with the file type and assign the filename suffix by the file type
	NSString *suffix;
	NSString *filename = [NSString stringWithString:name];;
	switch (type) {
		case NSTIFFFileType:
			suffix = @".tiff";
			if (![name hasSuffix:suffix]) 
				filename = [name stringByAppendingString:suffix];
			break;
		case NSBMPFileType:
			suffix = @".bmp";
			if (![name hasSuffix:suffix]) 
				filename = [name stringByAppendingString:suffix];
			break;
		case NSGIFFileType:
			suffix = @".gif";
			if (![name hasSuffix:suffix]) 
				filename = [name stringByAppendingString:suffix];
			break;
		case NSJPEGFileType:
			suffix = @".jpg";
			if (![name hasSuffix:suffix]) 
				filename = [name stringByAppendingString:suffix];
			break;
		case NSPNGFileType:
			suffix = @".png";
			if (![name hasSuffix:suffix]) 
				filename = [name stringByAppendingString:suffix];
			break;
		case NSJPEG2000FileType:
			suffix = @".jp2";
			if (![name hasSuffix:suffix]) 
				filename = [name stringByAppendingString:suffix];
			break;
		default:
			break;
	}
	
	NSString *destination = [path stringByAppendingPathComponent:filename];
	NSBitmapImageRep *bmpImageRep = [[NSBitmapImageRep alloc] initWithData:[self TIFFRepresentation]];
	NSData *data = [bmpImageRep representationUsingType:type properties:nil];
	
	return [data writeToFile:destination atomically:NO];
}


- (BOOL)saveAs:(NSString *)path{	
	NSBitmapImageRep *bmpImageRep = [[NSBitmapImageRep alloc] initWithData:[self TIFFRepresentation]];
	NSData *data = [bmpImageRep representationUsingType:NSPNGFileType properties:nil];
	return [data writeToFile:path atomically:YES];
}

- (NSImage *)scaleToFillSize:(NSSize)targetSize {
	NSSize sourceSize = self.size;	
	NSRect sourceRect = NSZeroRect;
	if (sourceSize.height > sourceSize.width) {
		sourceRect = NSMakeRect(0.0, 
								round((sourceSize.height - sourceSize.width) / 2), 
								sourceSize.width, 
								sourceSize.width);
	}
	else {
		sourceRect = NSMakeRect(round((sourceSize.width - sourceSize.height) / 2), 
								0.0, 
								sourceSize.height, 
								sourceSize.height);
	}
	NSRect destinationRect = NSZeroRect;
	destinationRect.size = targetSize;
	NSImage *final = [[NSImage alloc] initWithSize:targetSize];
	[final lockFocus];
	[[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
	[self drawInRect:destinationRect fromRect:sourceRect operation:NSCompositeSourceOver fraction:1.0];
	[final unlockFocus];
	return final;
}


@end


@implementation CIImage (ToNSImage)
//While we're at it, let's get the conversion back to NSImage out of the way. Here's a similar category method on CIImage. Well, two actually: one that assumes you want the whole extent of the image; the other to grab just a particular rectangle:

- (NSImage *)toNSImageFromRect:(CGRect)r
{
	NSImage *image;
	NSCIImageRep *ir;
	ir = [NSCIImageRep imageRepWithCIImage:self];
	image = [[NSImage alloc] initWithSize: NSMakeSize(r.size.width, r.size.height)];
	[image addRepresentation:ir];
	return image;
}

- (NSImage *)toNSImage
{
	
	return [self toNSImageFromRect:[self extent]];
	
}


- (CIImage *)rotateDegrees:(float)aDegrees
{
	CIImage *im = self;
	if (aDegrees > 0.0 && aDegrees < 360.0)
	{
		CIFilter *f
		= [CIFilter filterWithName:@"CIAffineTransform"];
		NSAffineTransform *t = [NSAffineTransform transform];
		[t rotateByDegrees:aDegrees];
		[f setValue:t forKey:@"inputTransform"];
		[f setValue:im forKey:@"inputImage"];
		im = [f valueForKey:@"outputImage"];
		
		CGRect extent = [im extent];
		f = [CIFilter filterWithName:@"CIAffineTransform"];
		t = [NSAffineTransform transform];
		[t translateXBy:-extent.origin.x
					yBy:-extent.origin.y];
		[f setValue:t forKey:@"inputTransform"];
		[f setValue:im forKey:@"inputImage"];
		im = [f valueForKey:@"outputImage"];
	}
	return im;
}


@end


@implementation NSImage (CGImageConversion)

- (NSBitmapImageRep*) bitmap {
	// returns a 32-bit bitmap rep of the receiver, whatever its original format. The image rep is not added to the image.
	NSSize size = [self size];
	int rowBytes = ((int)(ceil(size.width)) * 4 + 0x0000000F) & ~0x0000000F; // 16-byte aligned
	int bps=8, spp=4, bpp=bps*spp;
	
	// NOTE: These settings affect how pixels are converted to NSColors
	NSBitmapImageRep *imageRep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:nil
																		 pixelsWide:size.width
																		 pixelsHigh:size.height
																	  bitsPerSample:bps
																	samplesPerPixel:spp
																		   hasAlpha:YES
																		   isPlanar:NO
																	 colorSpaceName:NSCalibratedRGBColorSpace
																	   bitmapFormat:NSAlphaFirstBitmapFormat
																		bytesPerRow:rowBytes
																	   bitsPerPixel:bpp];
	
	if (!imageRep) return nil;
	
	NSGraphicsContext* imageContext = [NSGraphicsContext graphicsContextWithBitmapImageRep:imageRep];
	
	[NSGraphicsContext saveGraphicsState];
	[NSGraphicsContext setCurrentContext:imageContext];
	[self drawAtPoint:NSZeroPoint fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0];
	[NSGraphicsContext restoreGraphicsState];
	
	return imageRep;
}

- (CGImageRef) cgImage {
	NSBitmapImageRep*	bm = [self bitmap]; // data provider will release this
	int					rowBytes, width, height;
	
	rowBytes = [bm bytesPerRow];
	width = [bm pixelsWide];
	height = [bm pixelsHigh];
	
	CGDataProviderRef provider = CGDataProviderCreateWithData((__bridge void *)bm, [bm bitmapData], rowBytes * height, BitmapReleaseCallback );
	CGColorSpaceRef colorspace = CGColorSpaceCreateWithName( kCGColorSpaceGenericRGB );
	CGBitmapInfo	bitsInfo = kCGImageAlphaLast;
	
	CGImageRef img = CGImageCreate( width, height, 8, 32, rowBytes, colorspace, bitsInfo, provider, NULL, NO, kCGRenderingIntentDefault );
	
	CGDataProviderRelease( provider );
	CGColorSpaceRelease( colorspace );
	
	return img;
}

@end

@implementation NSImage (AtoZScaling)

- (NSImage *)imageByAdjustingHue:(float)hue {
	return self;
}
- (NSImage *)imageByAdjustingHue:(float)hue saturation:(float)saturation {
	return self; 	
}
- (NSSize) adjustSizeToDrawAtSize:(NSSize)theSize {
	NSImageRep *bestRep = [self bestRepresentationForSize:theSize];
	[self setSize:[bestRep size]];
	return [bestRep size];
}
- (NSImageRep *)bestRepresentationForSize:(NSSize)theSize {
	NSImageRep *bestRep = [self representationOfSize:theSize];
	//[self setCacheMode:NSImageCacheNever];
	if (bestRep) {
		
		//	QSLog(@"getRep? %f", theSize.width);
		return bestRep;
		
	} else {
		//	QSLog(@"getRex? %f", theSize.width);
	}
	NSArray *reps = [self representations];
	// if (theSize.width == theSize.height) { 
	// ***warning   * handle other sizes
	float repDistance = 65536.0;  
	// ***warning   * this is totally not the highest, but hey...
	NSImageRep *thisRep;
	float thisDistance;
	int i;
	for (i = 0; i<(int) [reps count]; i++) {
		thisRep = reps[i];
		thisDistance = MIN(theSize.width-[thisRep size] .width, theSize.height-[thisRep size] .height);  
		
		if (repDistance<0 && thisDistance>0) continue;
		if (ABS(thisDistance) <ABS(repDistance) || (thisDistance<0 && repDistance>0)) {
			repDistance = thisDistance;
			bestRep = thisRep;
		}
	}
	///QSLog(@"   Rex? %@", bestRep);
	return bestRep = bestRep ? bestRep : [self bestRepresentationForRect:AZMakeRectFromSize(theSize) context:[NSGraphicsContext currentContext] hints:nil];		//   QSLog(@"unable to find reps %@", reps);
	return nil;
}

- (NSImageRep *)representationOfSize:(NSSize)theSize {
	NSArray *reps = [self representations];
	int i;
	for (i = 0; i<(int) [reps count]; i++)
		if (NSEqualSizes([(NSBitmapImageRep*)reps[i] size] , theSize) )
			return reps[i];
	return nil;
}

- (BOOL)createIconRepresentations {
	[self setFlipped:NO];
	
	//[self createRepresentationOfSize:NSMakeSize(128, 128)];
	[self createRepresentationOfSize:NSMakeSize(32, 32)];
	[self createRepresentationOfSize:NSMakeSize(16, 16)];
	[self setScalesWhenResized:NO];
	return YES;
}


- (BOOL)createRepresentationOfSize:(NSSize)newSize { 
	// ***warning   * !? should this be done on the main thread?
	//
	
	if ([self representationOfSize:newSize]) return NO;
	
	
	
	NSBitmapImageRep *bestRep = (NSBitmapImageRep *)[self bestRepresentationForSize:newSize];
	if ([bestRep respondsToSelector:@selector(CGImage)]) {
		CGImageRef imageRef = [bestRep CGImage];
		
		CGColorSpaceRef cspace        = CGColorSpaceCreateDeviceRGB();    
		CGContextRef    smallContext        = CGBitmapContextCreate(NULL,
																	newSize.width,
																	newSize.height,
																	8,            // bits per component
																	newSize.width * 4, // bytes per pixel
																	cspace,
																	kCGBitmapByteOrder32Host | kCGImageAlphaPremultipliedLast);
		CFRelease(cspace);
		
		if (!smallContext) return NO;
		
		NSRect drawRect = fitRectInRect(rectFromSize([bestRep size]), rectFromSize(newSize), NO);
		
        CGContextDrawImage(smallContext, NSRectToCGRect(drawRect), imageRef);
		
		CGImageRef smallImage = CGBitmapContextCreateImage(smallContext);
		if (smallImage) {
			NSBitmapImageRep *cgRep = [[NSBitmapImageRep alloc] initWithCGImage:smallImage];
			[self addRepresentation:cgRep];      
		}
		CGImageRelease(smallImage);
		CGContextRelease(smallContext);
		
		return YES;
	}
	
	
	
	//
	//  {
	//    NSDate *date = [NSDate date];
	//    NSData *data = [(NSBitmapImageRep *)bestRep TIFFRepresentation];
	//    
	//    CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)data);  
	//    CGImageSourceRef isrc = CGImageSourceCreateWithDataProvider (provider, NULL);
	//    CGDataProviderRelease( provider );
	//    
	//    NSDictionary* thumbOpts = [NSDictionary dictionaryWithObjectsAndKeys:
	//                               (id)kCFBooleanTrue, (id)kCGImageSourceCreateThumbnailWithTransform,
	//                               (id)kCFBooleanTrue, (id)kCGImageSourceCreateThumbnailFromImageIfAbsent,
	//                               [NSNumber numberWithInt:newSize.width], (id)kCGImageSourceThumbnailMaxPixelSize,
	//                               nil];
	//    CGImageRef thumbnail = CGImageSourceCreateThumbnailAtIndex (isrc, 0, (CFDictionaryRef)thumbOpts);
	//    if (isrc) CFRelease(isrc);
	//    
	//    NSBitmapImageRep *cgRep = [[[NSBitmapImageRep alloc] initWithCGImage:thumbnail] autorelease];
	//    CGImageRelease(thumbnail);
	//    NSLog(@"time1 %f", -[date timeIntervalSinceNow]);
	//  }
	//
	//  
	//
	//  
	//  {
	//    NSDate *date = [NSDate date];
	//    NSImage* scaledImage = [[[NSImage alloc] initWithSize:newSize] autorelease];
	//    [scaledImage lockFocus];
	//    NSGraphicsContext *graphicsContext = [NSGraphicsContext currentContext];
	//    [graphicsContext setImageInterpolation:NSImageInterpolationHigh];
	//    [graphicsContext setShouldAntialias:YES];
	//    NSRect drawRect = fitRectInRect(rectFromSize([bestRep size]), rectFromSize(newSize), NO);
	//    [bestRep drawInRect:drawRect];
	//    NSBitmapImageRep* nsRep = [[[NSBitmapImageRep alloc] initWithFocusedViewRect:NSMakeRect(0, 0, newSize.width, newSize.height)] autorelease];
	//    [scaledImage unlockFocus];
	//    
	//    NSLog(@"time3 %f", -[date timeIntervalSinceNow]);
	//  }
	//  [self addRepresentation:rep];
	
	return YES;
	
	
	
	//  
	//  
	//  [self addRepresentation:iconRep];
	//  return YES;
}

- (void)removeRepresentationsLargerThanSize:(NSSize)size {
	NSEnumerator *e = [[self representations] reverseObjectEnumerator];
	NSImageRep *thisRep;
	while((thisRep = [e nextObject]) ) {
		if ([thisRep size] .width>size.width && [thisRep size] .height>size.height)
			[self removeRepresentation:thisRep];
	} 	
}

- (NSImage *)duplicateOfSize:(NSSize)newSize {
	NSImage *dup = [self copy];
	[dup shrinkToSize:newSize];
	[dup setFlipped:NO];
	return dup;
}

- (BOOL)shrinkToSize:(NSSize)newSize {
	[self createRepresentationOfSize:newSize];
	[self setSize:newSize];
	[self removeRepresentationsLargerThanSize:newSize];
	return YES;
}



@end

@implementation  NSImage (AtoZTrim)
- (NSRect) usedRect {
	
	
	NSData* tiffData = [self TIFFRepresentation];
	NSBitmapImageRep *bitmap = [[NSBitmapImageRep alloc] initWithData:tiffData];
	
	
	if (![bitmap hasAlpha]) return NSMakeRect(0, 0, [bitmap size] .height, [bitmap size] .width);
	
	int minX = [bitmap pixelsWide];
	int minY = [bitmap pixelsHigh];
	int maxX = 0;
	int maxY = 0;
	
	
	int i, j;
	unsigned char* pixels = [bitmap bitmapData];
	
	//int alpha;
	for(i = 0; i<[bitmap pixelsWide]; i++) {
		for (j = 0; j<[bitmap pixelsHigh]; j++) {
			//alpha = *(pixels + i*[bitmap pixelsWide] *[bitmap samplesPerPixel] + j*[bitmapsamplesPerPixel] + 3);
			if (*(pixels + j*[bitmap pixelsWide] *[bitmap samplesPerPixel] + i*[bitmap samplesPerPixel] + 3) ) { //This pixel is not transparent! Readjust bounds.
																												 //QSLog(@"Pixel Occupied: (%d, %d) ", i, j);
				minX = MIN(minX, i);
				maxX = MAX(maxX, i);
				minY = MIN(minY, j);
				maxY = MAX(maxY, j);
			}
			
		}
	}
	//  [`bitmap release];
	//flip y!!
	//QSLog(@"%d, %d, %d, %d", minX, minY, maxX, maxY);
	return NSMakeRect(minX, [bitmap pixelsHigh] -maxY-1, maxX-minX+1, maxY-minY+1);
}

- (NSImage *)scaleImageToSize:(NSSize)newSize trim:(BOOL)trim expand:(BOOL)expand scaleUp:(BOOL)scaleUp {
	NSRect sourceRect = (trim?[self usedRect] :rectFromSize([self size]) );
	NSRect drawRect = (scaleUp || NSHeight(sourceRect) >newSize.height || NSWidth(sourceRect)>newSize.width ? sizeRectInRect(sourceRect, rectFromSize(newSize), expand) : NSMakeRect(0, 0, NSWidth(sourceRect), NSHeight(sourceRect)));
	NSImage *tempImage = [[NSImage alloc] initWithSize:NSMakeSize(NSWidth(drawRect), NSHeight(drawRect) )];
	[tempImage lockFocus];
	{
		[[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
		[self drawInRect:drawRect fromRect:sourceRect operation:NSCompositeSourceOver fraction:1];
	}
	[tempImage unlockFocus];
	//QSLog(@"%@", tempImage);
	return [[NSImage alloc] initWithData:[tempImage TIFFRepresentation]]; //*** UGH! why do I have to do this to commit the changes?;
}
@end

@implementation NSImage (AtoZAverage)
- (NSColor *)averageColor {
	NSBitmapImageRep *rep = [self representations][0];
//	 filterOne:<#^BOOL(id object)block#>: (NSBitmapImageRep *)[self bestRepresentationForDevice:nil]; 	
	if (![rep isKindOfClass:[NSBitmapImageRep class]]) return nil;
	unsigned char *pixels = [rep bitmapData];
	
	int red = 0, blue = 0, green = 0; //, alpha = 0;
	int n = [rep size] .width*[rep size] .height;
	int i = 0;
	for (i = 0; i < n; i++) {
		//	pixels[(j*imageWidthInPixels+i) *bitsPerPixel+channel]
		//QSLog(@"%d %d %d %d", pixels[0] , pixels[1] , pixels[2] , pixels[3]);
		red += *pixels++;
		green += *pixels++;
		blue += *pixels++;
		//alpha += *pixels++;
	}
	
	//QSLog(@"%d %f %d", blue, (float) blue/n/256, n);
	NSColor *color = [NSColor colorWithDeviceRed:(float) red/n/256 green:(float)green/n/256 blue:(float)blue/n/256 alpha:1.0];
	//		QSLog(@"color %@", color);
	return color;
}



CGImageRef CopyImageAndAddAlphaChannel(CGImageRef sourceImage) {
	CGImageRef retVal = NULL;
	size_t width = CGImageGetWidth(sourceImage);
	size_t height = CGImageGetHeight(sourceImage);
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef offscreenContext = CGBitmapContextCreate(NULL, width, height, 
									8, 0, colorSpace, kCGImageAlphaPremultipliedFirst);
	if (offscreenContext != NULL) {
		CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), sourceImage);	
		retVal = CGBitmapContextCreateImage(offscreenContext);
		CGContextRelease(offscreenContext);
	}
	CGColorSpaceRelease(colorSpace);
	return retVal;
}

+ (NSImage*)maskImage:(NSImage *)image withMask:(NSImage *)maskImage {
	CGImageRef maskRef = [maskImage cgImageRef];
	CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
										CGImageGetHeight(maskRef),
										CGImageGetBitsPerComponent(maskRef),
										CGImageGetBitsPerPixel(maskRef),
										CGImageGetBytesPerRow(maskRef),
										CGImageGetDataProvider(maskRef), NULL, false);
	
	CGImageRef sourceImage = [image cgImageRef];
	CGImageRef imageWithAlpha = sourceImage;
	//add alpha channel for images that don't have one (ie GIF, JPEG, etc...)
	//this however has a computational cost
	if (CGImageGetAlphaInfo(sourceImage) == kCGImageAlphaNone) { 
		imageWithAlpha = CopyImageAndAddAlphaChannel(sourceImage);
	}
	
	CGImageRef masked = CGImageCreateWithMask(imageWithAlpha, mask);
	CGImageRelease(mask);
	
	//release imageWithAlpha if it was created by CopyImageAndAddAlphaChannel
	if (sourceImage != imageWithAlpha) {
		CGImageRelease(imageWithAlpha);
	}
	
	NSImage* retImage = [NSImage imageFromCGImageRef:masked];
	CGImageRelease(masked);

	return retImage;
}



@end



//#define LEOPARD 0x1050
//#define TIGER   0x1040

//@implementation NSBitmapImageRep (GrabWindow)

//+ (NSBitmapImageRep *)bitmapRepWithScreenShotInRect:(NSRect)cocoaRect
//{
//    NSImage *image = [NSImage imageWithScreenShotInRect: cocoaRect];
//    // convert it to a bitmap rep and return
////	return [NSBitmapIm/ageRep bitmapRepFromNSImage:
//	return [image bitmap];
//}


//@end

/*+ (NSArray*) picolStrings {		static NSArray *_picolSrtrings;
								if (_picolSrtrings == nil)	{ // This will only be true the first time the method is called...

_picolSrtrings = [@[@"xml_document.pdf", @"xml.pdf", @"zoom_in.pdf", @"zoom_out.pdf", @"website.pdf", @"video_edit.pdf", @"video_information.pdf", @"video_pause.pdf", @"video_remove.pdf", @"video_run.pdf", @"video_security.pdf", @"video_settings.pdf", @"video_stop.pdf", @"video_up.pdf", @"video.pdf", @"view.pdf", @"viewer_image.pdf", @"viewer_text.pdf", @"viewer_video.pdf", @"video_add.pdf", @"video_cancel.pdf", @"video_down.pdf", @"user_full_add.pdf", @"user_full_edit.pdf", @"user_full_information.pdf", @"user_full_remove.pdf", @"user_full_security.pdf", @"user_full_settings.pdf", @"user_full.pdf", @"user_half_add.pdf", @"user_half_edit.pdf", @"user_half_information.pdf", @"user_half_remove.pdf", @"user_half_security.pdf", @"user_half_settings.pdf", @"user_half.pdf", @"user_profile_edit.pdf", @"user_profile.pdf", @"video_accept.pdf", @"server_information.pdf", @"server_remove.pdf", @"server_run.pdf", @"server_security.pdf", @"server_settings.pdf", @"server_stop.pdf", @"server.pdf", @"settings.pdf", @"shopping_cart.pdf", @"sitemap.pdf", @"size_both_accept.pdf", @"size_both_add.pdf", @"size_both_cancel.pdf", @"size_both_edit.pdf", @"size_both_remove.pdf", @"size_both_security.pdf", @"size_both_settings.pdf", @"size_both.pdf", @"size_height_accept.pdf", @"size_height_add.pdf", @"size_height_cancel.pdf", @"size_height_edit.pdf", @"size_height_remove.pdf", @"size_height_security.pdf", @"size_height_settings.pdf", @"size_height.pdf", @"size_width_accept.pdf", @"size_width_add.pdf", @"size_width_cancel.pdf", @"size_width_edit.pdf", @"size_width_remove.pdf", @"size_width_security.pdf", @"size_width_settings.pdf", @"size_width.pdf", @"social_network.pdf", @"source_code.pdf", @"speaker_louder.pdf", @"speaker_off.pdf", @"speaker_silent.pdf", @"star_outline.pdf", @"star.pdf", @"statistics.pdf", @"synchronize.pdf", @"tab_add.pdf", @"tab_cancel.pdf", @"tab.pdf", @"target.pdf", @"terminal_computer.pdf", @"text_align_center.pdf", @"text_align_full.pdf", @"text_align_left.pdf", @"text_align_right.pdf", @"text_bold.pdf", @"text_italic.pdf", @"text_strikethrough.pdf", @"text.pdf", @"transportation_bus.pdf", @"transportation_car.pdf", @"transportation_plane.pdf", @"transportation_ship.pdf", @"transportation_train.pdf", @"trash_full.pdf", @"trash.pdf", @"upload_accept.pdf", @"upload_cancel.pdf", @"upload_pause.pdf", @"upload_run.pdf", @"upload_security.pdf", @"upload_settings.pdf", @"upload_stop.pdf", @"upload.pdf", @"user_close_add.pdf", @"user_close_edit.pdf", @"user_close_information.pdf", @"user_close_remove.pdf", @"user_close_security.pdf", @"user_close_settings.pdf", @"user_close.pdf", @"mailbox_incoming.pdf", @"mailbox_outgoing.pdf", @"mailbox_settings.pdf", @"mailbox.pdf", @"mainframe.pdf", @"mashup.pdf", @"mobile_phone.pdf", @"move.pdf", @"music_accept.pdf", @"music_add.pdf", @"music_cancel.pdf", @"music_edit.pdf", @"music_eject.pdf", @"music_information.pdf", @"music_pause.pdf", @"music_remove.pdf", @"music_run.pdf", @"music_security.pdf", @"music_settings.pdf", @"music_stop.pdf", @"music.pdf", @"network_intranet.pdf", @"network_protocol.pdf", @"network_sans_add.pdf", @"network_sans_edit.pdf", @"network_sans_remove.pdf", @"network_sans_security.pdf", @"network_sans.pdf", @"network_wireless_add.pdf", @"network_wireless_edit.pdf", @"network_wireless_security.pdf", @"network_wireless.pdf", @"news.pdf", @"notes_accept.pdf", @"notes_add.pdf", @"notes_cancel.pdf", @"notes_down.pdf", @"notes_edit.pdf", @"notes_remove.pdf", @"notes_settings.pdf", @"notes_up.pdf", @"notes.pdf", @"ontology.pdf", @"owl_dl_document.pdf", @"owl_dl.pdf", @"owl_full_document.pdf", @"owl_full.pdf", @"owl_lite_document.pdf", @"owl_lite.pdf", @"paragraph.pdf", @"paste.pdf", @"path.pdf", @"pda.pdf", @"phone_home.pdf", @"phone_off.pdf", @"phone_on.pdf", @"plus.pdf", @"printer_add.pdf", @"printer_cancel.pdf", @"printer_information.pdf", @"printer_pause.pdf", @"printer_remove.pdf", @"printer_run.pdf", @"printer_settings.pdf", @"printer_stop.pdf", @"printer.pdf", @"questionmark.pdf", @"rdf_document.pdf", @"rdf.pdf", @"recent_changes.pdf", @"refresh.pdf", @"relevance.pdf", @"remix.pdf", @"satellite_ground.pdf", @"satellite.pdf", @"screen_4to3.pdf", @"screen_16to9.pdf", @"script.pdf", @"search.pdf", @"security_closed.pdf", @"security_open.pdf", @"semantic_web.pdf", @"server_accept.pdf", @"server_add.pdf", @"server_cancel.pdf", @"server_edit.pdf", @"server_eject.pdf", @"edit.pdf", @"equal.pdf", @"filepath.pdf", @"filter_settings.pdf", @"filter.pdf", @"firewall_pause.pdf", @"firewall_run.pdf", @"firewall_settings.pdf", @"firewall_stop.pdf", @"firewall.pdf", @"flash_off.pdf", @"flash.pdf", @"floppy_disk.pdf", @"folder_downloads.pdf", @"folder_image.pdf", @"folder_music.pdf", @"folder_sans_accept.pdf", @"folder_sans_add.pdf", @"folder_sans_cancel.pdf", @"folder_sans_down.pdf", @"folder_sans_edit.pdf", @"folder_sans_information.pdf", @"folder_sans_remove.pdf", @"folder_sans_run.pdf", @"folder_sans_security.pdf", @"folder_sans_settings.pdf", @"folder_sans_up.pdf", @"folder_sans.pdf", @"folder_text.pdf", @"folder_video.pdf", @"fullscreen_cancel.pdf", @"fullscreen.pdf", @"globe.pdf", @"group_full_add.pdf", @"group_full_edit.pdf", @"group_full_remove.pdf", @"group_full_security.pdf", @"group_full.pdf", @"group_half_add.pdf", @"group_half_edit.pdf", @"group_half_remove.pdf", @"group_half_security.pdf", @"group_half.pdf", @"harddisk_sans_eject.pdf", @"harddisk_sans_security.pdf", @"harddisk_sans_settings.pdf", @"harddisk_sans.pdf", @"hierarchy.pdf", @"home.pdf", @"image_accept.pdf", @"image_add.pdf", @"image_cancel.pdf", @"image_edit.pdf", @"image_pause.pdf", @"image_remove.pdf", @"image_run.pdf", @"image_security.pdf", @"image_settings.pdf", @"image.pdf", @"imprint.pdf", @"information.pdf", @"internet.pdf", @"keyboard.pdf", @"label_add.pdf", @"label_edit.pdf", @"label_remove.pdf", @"label_security.pdf", @"label.pdf", @"light_off.pdf", @"light.pdf", @"link_add.pdf", @"link_edit.pdf", @"link_remove.pdf", @"link.pdf", @"list_numbered.pdf", @"list.pdf", @"mail_accept.pdf", @"mail_add.pdf", @"mail_cancel.pdf", @"mail_edit.pdf", @"mail_fwd.pdf", @"mail_remove.pdf", @"mail_run.pdf", @"mail_security.pdf", @"mail.pdf", @"mailbox_down.pdf", @"mailbox_eject.pdf", @"document_sans_run.pdf", @"document_sans_security.pdf", @"document_sans_settings.pdf", @"document_sans_up.pdf", @"document_sans.pdf", @"document_text_accept.pdf", @"document_text_add.pdf", @"document_text_cancel.pdf", @"document_text_down.pdf", @"document_text_edit.pdf", @"document_text_information.pdf", @"document_text_remove.pdf", @"document_text_run.pdf", @"document_text_security.pdf", @"document_text_settings.pdf", @"document_text_up.pdf", @"document_text.pdf", @"document_video_accept.pdf", @"document_video_add.pdf", @"document_video_cancel.pdf", @"document_video_down.pdf", @"document_video_edit.pdf", @"document_video_information.pdf", @"document_video_remove.pdf", @"document_video_run.pdf", @"document_video_security.pdf", @"document_video_settings.pdf", @"document_video_up.pdf", @"document_video.pdf", @"donate.pdf", @"download_accept.pdf", @"download_cancel.pdf", @"download_information.pdf", @"download_pause.pdf", @"download_run.pdf", @"download_security.pdf", @"download_settings.pdf", @"download_stop.pdf", @"download.pdf", @"dropbox.pdf", @"document_sans_down.pdf", @"document_sans_edit.pdf", @"document_sans_information.pdf", @"document_sans_remove.pdf", @"document_image_add.pdf", @"document_image_cancel.pdf", @"document_image_down.pdf", @"document_image_edit.pdf", @"document_image_information.pdf", @"document_image_remove.pdf", @"document_image_run.pdf", @"document_image_security.pdf", @"document_image_settings.pdf", @"document_image_up.pdf", @"document_image.pdf", @"document_music_accept.pdf", @"document_music_add.pdf", @"document_music_cancel.pdf", @"document_music_down.pdf", @"document_music_edit.pdf", @"document_music_information.pdf", @"document_music_remove.pdf", @"document_music_run.pdf", @"document_music_security.pdf", @"document_music_settings.pdf", @"document_music_up.pdf", @"document_music.pdf", @"document_sans_accept.pdf", @"document_sans_add.pdf", @"document_sans_cancel.pdf", @"category_edit.pdf", @"category_remove.pdf", @"category_settings.pdf", @"category.pdf", @"cd_eject.pdf", @"cd_pause.pdf", @"cd_run.pdf", @"cd_security.pdf", @"cd_stop.pdf", @"cd_write.pdf", @"cd.pdf", @"chat_pause.pdf", @"chat_run.pdf", @"chat_security.pdf", @"chat_settings.pdf", @"chat_stop.pdf", @"chat.pdf", @"clock_mini.pdf", @"clock.pdf", @"combine.pdf", @"comment_accept.pdf", @"comment_add.pdf", @"comment_cancel.pdf", @"comment_edit.pdf", @"comment_remove.pdf", @"comment_settings.pdf", @"comment.pdf", @"computer_accept.pdf", @"computer_add.pdf", @"computer_cancel.pdf", @"computer_remove.pdf", @"computer_settings.pdf", @"computer.pdf", @"controls_chapter_next.pdf", @"controls_chapter_previous.pdf", @"controls_eject.pdf", @"controls_fast_forward.pdf", @"controls_pause.pdf", @"controls_play_back.pdf", @"controls_play.pdf", @"controls_rewind.pdf", @"controls_stop.pdf", @"cooler.pdf", @"copy.pdf", @"cut.pdf", @"data_privacy.pdf", @"database_add.pdf", @"database_edit.pdf", @"database_information.pdf", @"database_remove.pdf", @"database_run.pdf", @"database_security.pdf", @"database.pdf", @"document_image_accept.pdf", @"book_audio_pause.pdf", @"book_audio_remove.pdf", @"book_audio_run.pdf", @"book_audio_security.pdf", @"book_audio_settings.pdf", @"book_audio_stop.pdf", @"book_audio.pdf", @"book_image_add.pdf", @"book_image_information.pdf", @"book_image_pause.pdf", @"book_image_remove.pdf", @"book_image_run.pdf", @"book_image_security.pdf", @"book_image_settings.pdf", @"book_image_stop.pdf", @"book_image.pdf", @"book_sans_add.pdf", @"book_sans_down.pdf", @"book_sans_information.pdf", @"book_sans_remove.pdf", @"book_sans_run.pdf", @"book_sans_security.pdf", @"book_sans_up.pdf", @"book_sans.pdf", @"book_text_add.pdf", @"book_text_down.pdf", @"book_text_information.pdf", @"book_text_remove.pdf", @"book_text_run.pdf", @"book_text_security.pdf", @"book_text_settings.pdf", @"book_text_stop.pdf", @"book_text_up.pdf", @"book_text.pdf", @"bookmark_settings.pdf", @"bookmark.pdf", @"brightness_brighten.pdf", @"brightness_darken.pdf", @"browser_window_add.pdf", @"browser_window_cancel.pdf", @"browser_window_remove.pdf", @"browser_window_security.pdf", @"browser_window_settings.pdf", @"browser_window.pdf", @"buy.pdf", @"calculator.pdf", @"calendar.pdf", @"cancel.pdf", @"category_add.pdf", @"accept.pdf", @"adressbook.pdf", @"agent.pdf", @"api.pdf", @"application.pdf", @"arrow_full_down.pdf", @"arrow_full_left.pdf", @"arrow_full_lowerleft.pdf", @"arrow_full_lowerright.pdf", @"arrow_full_right.pdf", @"arrow_full_up.pdf", @"arrow_full_upperleft.pdf", @"arrow_full_upperright.pdf", @"arrow_sans_down.pdf", @"arrow_sans_left.pdf", @"arrow_sans_lowerleft.pdf", @"arrow_sans_lowerright.pdf", @"arrow_sans_right.pdf", @"arrow_sans_up.pdf", @"arrow_sans_upperleft.pdf", @"arrow_sans_upperright.pdf", @"attachment_add.pdf", @"attachment_down.pdf", @"attachment.pdf", @"avatar_edit.pdf", @"avatar_information.pdf", @"avatar.pdf", @"backup_pause.pdf", @"backup_run.pdf", @"backup_settings.pdf", @"backup_stop.pdf", @"backup.pdf", @"badge_accept.pdf", @"badge_cancel.pdf", @"badge_down.pdf", @"badge_edit.pdf", @"badge_eject.pdf", @"badge_information.pdf", @"badge_minus.pdf", @"badge_pause.pdf", @"badge_plus.pdf", @"badge_run.pdf", @"badge_security.pdf", @"badge_settings.pdf", @"badge_stop.pdf", @"badge_up.pdf", @"battery_1.pdf", @"battery_2.pdf", @"battery_3.pdf", @"battery_4.pdf", @"battery_empty.pdf", @"battery_full.pdf", @"battery_plugged.pdf", @"book_audio_add.pdf", @"book_audio_eject.pdf", @"book_audio_information.pdf"]
		arrayUsingBlock:^id(id obj) {
			return  $(@"/picol/%@",obj);
		}];
	}
	return _picolSrtrings;
}
@end
*/

@implementation NSImage (GrabWindow)
/*
+ (NSImage *) captureScreenImageWithFrame: (NSRect) frame
{
    // Fetch a graphics port of the screen

    CGrafPtr screenPort = CreateNewPort ();
    Rect screenRect;
    GetPortBounds (screenPort, &screenRect);

    // Make a temporary window as a receptacle

    NSWindow *grabWindow = [[NSWindow alloc] initWithContentRect: frame
													   styleMask: NSBorderlessWindowMask
														 backing: NSBackingStoreRetained
														   defer: NO
														  screen: nil];
    CGrafPtr windowPort = GetWindowPort ([grabWindow windowRef]);
    Rect windowRect;
    GetPortBounds (windowPort, &windowRect);
    SetPort (windowPort);

    // Copy the screen to the temporary window

    CopyBits (GetPortBitMapForCopyBits(screenPort),
              GetPortBitMapForCopyBits(windowPort),
              &screenRect,
              &windowRect,
              srcCopy,
              NULL);

    // Get the contents of the temporary window into an NSImage

    NSView *grabContentView = [grabWindow contentView];

    [grabContentView lockFocus];
    NSBitmapImageRep *screenRep;
    screenRep = [[NSBitmapImageRep alloc] initWithFocusedViewRect: frame];
    [grabContentView unlockFocus];

    NSImage *screenImage = [[NSImage alloc] initWithSize: frame.size];
    [screenImage addRepresentation: screenRep];

    // Clean up
    [grabWindow close];
    DisposePort(screenPort);

    return (screenImage);

} // captureScreenImageWithFrame

+ (NSImage *)screenShotWithinRect:(NSRect)rect
{
	NSWindow *window = [[NSWindow alloc] initWithContentRect:rect styleMask:NSBorderlessWindowMask
										   backing:NSBackingStoreNonretained defer:NO];
	[window setBackgroundColor:[NSColor clearColor]];
	[window setLevel:NSScreenSaverWindowLevel + 1];
	[window setHasShadow:NO];
	[window setAlphaValue:0.0];
	[window orderFront:self];
	[window setContentView:[[NSView alloc] initWithFrame:rect]];
	[[window contentView] lockFocus];
	NSBitmapImageRep *rep = [[NSBitmapImageRep alloc] initWithFocusedViewRect:[[window contentView] bounds]];
	[[window contentView] unlockFocus];
	[window orderOut:self];
	[window close];

	NSImage *image = [[ NSImage alloc] initWithData:[rep TIFFRepresentation]];
//	[[ NSImage alloc] initWithSize:[rep size]];
//	[image addRepresentation:rep];

	return image;
}
*/
/*
+ (NSImage*)imageWithBitmapRep: (NSBitmapImageRep*)rep {
    NSImage *image = nil;
    if(!rep) return image;

    image = [[NSImage alloc] init];
    [image addRepresentation: rep];

    return image;// autorelease];
}

+ (NSImage*)imageWithCGContextCaptureWindow: (int)wid {

    // get window bounds
    CGRect windowRect;
    CGSGetWindowBounds(_CGSDefaultConnection(), wid, &windowRect);
    windowRect.origin = CGPointZero;

    // create an NSImage fo the window, cutting off the titlebar
    NSImage *image = [[NSImage alloc] initWithSize: NSMakeSize(windowRect.size.width, windowRect.size.height - 22)];
    [image lockFocus];  // lock focus on the image for drawing

    // copy the contents of the window to the graphic context
    CGContextCopyWindowCaptureContentsToRect([[NSGraphicsContext currentContext] graphicsPort],
                                             windowRect,
                                             _CGSDefaultConnection(),
                                             wid,
                                             0);
    [image unlockFocus];
    return image;// autorelease];
}

+ (NSImage *)imageWithScreenShotInRect:(NSRect)cocoaRect {
	PicHandle picHandle;
	GDHandle mainDevice;
	Rect rect;

	// Convert NSRect to Rect
	SetRect(&rect, NSMinX(cocoaRect), NSMinY(cocoaRect), NSMaxX(cocoaRect), NSMaxY(cocoaRect));

	// Get the main screen. No multiple screen support here.
	mainDevice = GetMainDevice();

	// Capture the screen into the PicHandle.
	picHandle = OpenPicture(&rect);
	CopyBits((BitMap *)*(**mainDevice).gdPMap, (BitMap *)*(**mainDevice).gdPMap,
			 &rect, &rect, srcCopy, 0l);
	ClosePicture();

	// Convert the PicHandle into an NSImage
	// First lock the PicHandle so it doesn't move in memory while we copy
	HLock((Handle)picHandle);

	NSImageRep *pictImageRep = [NSPICTImageRep imageRepWithData:[NSData dataWithBytes:(*picHandle)
																			   length:GetHandleSize((Handle)picHandle)]];
	HUnlock((Handle)picHandle);

	// We can release the PicHandle now that we're done with it
	KillPicture(picHandle);

	// Create an image with the PICT representation
	NSImage *image = [[NSImage alloc] initWithSize: [pictImageRep size]];
	[image addRepresentation: pictImageRep];
    return image;// autorelease];
}
*/


+ (NSImage* ) imageBelowWindow: (NSWindow *) window {

    // Get the CGWindowID of supplied window
	CGWindowID windowID = [window windowNumber];

	// Get window's rect in flipped screen coordinates
	CGRect windowRect = NSRectToCGRect( [window frame] );
	windowRect.origin.y = NSMaxY([[window screen] frame]) - NSMaxY([window frame]);

	// Get a composite image of all the windows beneath your window
	CGImageRef capturedImage = CGWindowListCreateImage( windowRect, kCGWindowListOptionOnScreenBelowWindow, windowID, kCGWindowImageDefault );

	// The rest is as in the previous example...
	if(CGImageGetWidth(capturedImage) <= 1) {
		CGImageRelease(capturedImage);
		return nil;
	}

	// Create a bitmap rep from the window and convert to NSImage...
//	NSBitmapImageRep *bitmapRep = [[[NSBitmapImageRep] alloc] initWithCGImage: capturedImage];
	NSImage *image = [NSImage imageFromCGImageRef:capturedImage ];// [NSImage]alloc] init];
//	[image addRepresentation: bitmapRep];
	CGImageRelease(capturedImage);

	return image;
}
@end


	// from http://developer.apple.com/technotes/tn2005/tn2143.html

CGImageRef CreateCGImageFromData(NSData* data)
{
    CGImageRef        imageRef = NULL;
    CGImageSourceRef  sourceRef;

    sourceRef = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    if(sourceRef) {
        imageRef = CGImageSourceCreateImageAtIndex(sourceRef, 0, NULL);
        CFRelease(sourceRef);
    }

    return imageRef;
}

//	CIFilter *matrix = (CIPerspectiveMatrix){  w*.1, h*.8,	 w*.7, h , w*.1, 0,	 w*.7, h/2};
//	[someNSImage addPerspectiveMatrix: matrix];

@implementation NSImage (Matrix)
- (NSImage*) addPerspectiveMatrix:(CIPerspectiveMatrix)matrix { //8PointMatrix

	CIImage* cImg = [self toCIImage];//  [[CIImage alloc] initWithCGImage: screenie];
	CIFilter *filter = [CIFilter filterWithName: @"CIPerspectiveTransform"];
	[filter setDefaults];
	[filter setValue:cImg forKey: @"inputImage"];  //    CGImageRelease(screenie);
	filter [ @"inputTopLeft" ] 	  = [CIVector vectorWithX:matrix.tlX  Y:matrix.tlY];
	filter [ @"inputTopRight" ]   = [CIVector vectorWithX:matrix.trX  Y:matrix.trY];
	filter [ @"inputBottomLeft" ] = [CIVector vectorWithX:matrix.blX Y: matrix.blY];
	filter [ @"inputBottomRight"] = [CIVector vectorWithX:matrix.brX Y: matrix.brY];
	return  [[filter valueForKey: @"outputImage"]toNSImage];
}
@end

