//
//  NSImage-Tint.m
//  ImageTinter
//
//  Created by Mikael Hallendal on 2009-10-11.
//  Copyright 2009 Mikael Hallendal. All rights reserved.
//

//#import "NSArray+Reversing.h"

//#import "NSImage+Transform.h"

#import "NSImage-Tint.h"


@implementation NSImage (Transform)

- (NSImage*)imageRotatedByDegrees:(CGFloat)degrees {
	// Calculate the bounds for the rotated image
	// We do this by affine-transforming the bounds rectangle
	NSRect imageBounds = {NSZeroPoint, [self size]};
	NSBezierPath* boundsPath = [NSBezierPath bezierPathWithRect:imageBounds];
	NSAffineTransform* transform = [NSAffineTransform transform];
	[transform rotateByDegrees:degrees];
	[boundsPath transformUsingAffineTransform:transform];
	NSRect rotatedBounds = {NSZeroPoint, [boundsPath bounds].size};
	NSImage* rotatedImage = [[[NSImage alloc] initWithSize:rotatedBounds.size] autorelease];

	// Center the image within the rotated bounds
	imageBounds.origin.x = NSMidX(rotatedBounds) - (NSWidth(imageBounds) / 2);
	imageBounds.origin.y = NSMidY(rotatedBounds) - (NSHeight(imageBounds) / 2);

	// Start a new transform, to transform the image
	transform = [NSAffineTransform transform];

	// Move coordinate system to the center
	// (since we want to rotate around the center)
	[transform translateXBy:+(NSWidth(rotatedBounds) / 2)
						yBy:+(NSHeight(rotatedBounds) / 2)];
	// Do the rotation
	[transform rotateByDegrees:degrees];
	// Move coordinate system back to normal (bottom, left)
	[transform translateXBy:-(NSWidth(rotatedBounds) / 2)
						yBy:-(NSHeight(rotatedBounds) / 2)];

	// Draw the original image, rotated, into the new image
	// Note: This "drawing" is done off-screen.
	[rotatedImage lockFocus];
	[transform concat];
	[self drawInRect:imageBounds fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0] ;
	[rotatedImage unlockFocus];

	return rotatedImage;
}

@end


@implementation NSImage (ImageMerge)


+ (NSImage*)imageByTilingImages:(NSA*)images
					   spacingX:(CGFloat)spacingX
					   spacingY:(CGFloat)spacingY
					 vertically:(BOOL)vertically {
	CGFloat mergedWidth = 0.0 ;
	CGFloat mergedHeight = 0.0 ;
	if (vertically) {
		images = [images reversed];
	}
	for (NSImage* image in images) {
		NSSize size = [image size];
		if (vertically) {
			mergedWidth = MAX(mergedWidth, size.width) ;
			mergedHeight += size.height ;
			mergedHeight += spacingY ;
		}
		else {
			mergedWidth += size.width ;
			mergedWidth += spacingX ;
			mergedHeight = MAX(mergedHeight, size.height) ;
		}
	}
	// Add the outer margins for the single-image dimension
	// (The multi-image dimension has already had it added in the loop)
	if (vertically) {
		// Add left and right margins
		mergedWidth += 2 * spacingX ;
	}
	else {
		// Add top and bottom margins
		mergedHeight += 2 * spacingY ;
	}
	NSSize mergedSize = NSMakeSize(mergedWidth, mergedHeight) ;

	NSImage* mergedImage = [[NSImage alloc] initWithSize:mergedSize] ;
	[mergedImage lockFocus] ;

	// Draw the images into the mergedImage
	CGFloat x = spacingX ;
	CGFloat y = spacingY ;
	for (NSImage* image in images) {
		[image drawAtPoint:NSMakePoint(x, y)
				  fromRect:NSZeroRect
				 operation:NSCompositeSourceOver
				  fraction:1.0] ;
		if (vertically) {
			y += [image size].height ;
			y += spacingY ;
		}
		else {
			x += [image size].width ;
			x += spacingX ;
		}
	}

	[mergedImage unlockFocus] ;

	return [mergedImage autorelease] ;
}

- (NSImage*)imageBorderedWithInset:(CGFloat)inset {
	NSImage* image = [[NSImage alloc] initWithSize:[self size]] ;

	[image lockFocus] ;

	[self drawAtPoint:NSZeroPoint
			 fromRect:NSZeroRect
			operation:NSCompositeCopy
			 fraction:1.0] ;

	NSBezierPath* path = [NSBezierPath bezierPath] ;

	//[[NSColor colorWithCalibratedWhite:0.0 alpha:0.7] set] ;
	[[NSColor grayColor] setStroke] ;
	[path setLineWidth:inset] ;

	// Start at left
	[path moveToPoint:NSMakePoint(inset/2, inset/2)] ;

	// Move to the right
	[path relativeLineToPoint:NSMakePoint(self.size.width - (2.5)*inset, 0)] ;

	// Move up
	[path relativeLineToPoint:NSMakePoint(0, self.size.height - inset)] ;

	// Move left
	[path relativeLineToPoint:NSMakePoint(-self.size.width + (2.5)*inset, 0)] ;

	// Finish
	[path closePath] ;
	[path stroke] ;

	[image unlockFocus] ;

	return [image autorelease] ;
}

- (NSImage*)imageBorderedWithOutset:(CGFloat)outset {
	NSSize newSize = NSMakeSize([self size].width + 2*outset, [self size].height + 2*outset) ;
	NSImage* image = [[NSImage alloc] initWithSize:newSize] ;

	[image lockFocus] ;

	[self drawAtPoint:NSMakePoint(outset, outset)
			 fromRect:NSZeroRect
			operation:NSCompositeCopy
			 fraction:1.0] ;

	NSBezierPath* path = [NSBezierPath bezierPath] ;

	//[[NSColor colorWithCalibratedWhite:0.0 alpha:0.7] set] ;
	[[NSColor grayColor] setStroke] ;
	[path setLineWidth:2.0] ;

	// Start at left
	[path moveToPoint:NSMakePoint(1.0, 1.0)] ;

	// Move to the right
	[path relativeLineToPoint:NSMakePoint(newSize.width - 2.0, 0)] ;

	// Move up
	[path relativeLineToPoint:NSMakePoint(0, newSize.height - 2.0)] ;

	// Move left
	[path relativeLineToPoint:NSMakePoint(-newSize.width + 2.0, 0)] ;

	// Finish
	[path closePath] ;
	[path stroke] ;

	[image unlockFocus] ;

	return [image autorelease] ;
}

@end


@interface NSImage(BBlockPrivate)
+ (NSCache *)drawingCache;
@end

@implementation NSImage(BBlock)

+ (NSCache *)drawingCache{
	static NSCache *cache = nil;
	static dispatch_once_t predicate;
	dispatch_once(&predicate, ^{
		cache = [[NSCache alloc] init];
	});
	return cache;
}

+ (NSImage *)imageForSize:(NSSize)size withDrawingBlock:(void(^)())drawingBlock{
	if(size.width <= 0 || size.width <= 0){
		return nil;
	}

	NSImage *image = [[NSImage alloc] initWithSize:size];
	[image lockFocus];
	drawingBlock();
	[image unlockFocus];
#if !__has_feature(objc_arc)
	return [image autorelease];
#else
	return image;
#endif
}

+ (NSImage *)imageWithIdentifier:(NSString *)identifier forSize:(NSSize)size andDrawingBlock:(void(^)())drawingBlock{
	NSImage *image = [[[self class] drawingCache] objectForKey:identifier];
	if(image == nil){
		image = [[self class] imageForSize:size withDrawingBlock:drawingBlock];
		[[[self class] drawingCache] setObject:image forKey:identifier];
	}
	return image;
}

@end
CGFloat const TBITintMatrixGrayscale[] = {
	0.3, 0.59, 0.11,
	0.3, 0.59, 0.11,
	0.3, 0.59, 0.11
};

CGFloat const TBITintMatrixSepia[] = {
	0.393, 0.769, 0.189,
	0.349, 0.686, 0.168,
	0.272, 0.534, 0.131
};

CGFloat const TBITintMatrixBluetone[] = {
	0.272, 0.534, 0.131,
	0.349, 0.686, 0.168,
	0.393, 0.769, 0.189
};

void
tint_pixel_rgb (unsigned char *bitmapData, int red_index, const CGFloat *matrix)
{
	int green_index = red_index + 1;
	int blue_index = red_index + 2;
	
	CGFloat red = bitmapData[red_index];
	CGFloat green = bitmapData[green_index] ;
	CGFloat blue = bitmapData[blue_index];
	
	bitmapData[red_index] = MIN (red * matrix[0] + green * matrix[1] + blue * matrix[2], 255.0f); // red
	bitmapData[green_index] = MIN (red * matrix[3] + green * matrix[4] + blue * matrix[5], 255.0f); // green
	bitmapData[blue_index] = MIN (red * matrix[6] + green * matrix[7] + blue * matrix[8], 255.0f); // blue	
}

@implementation NSImage (Tint)

- (NSImage *)tintWithMatrix:(const CGFloat *)matrix;
{
	NSBitmapImageRep *bitmap = [[NSBitmapImageRep alloc] initWithData:[self TIFFRepresentation]];
	
	NSSize imageSize = [bitmap size];
	
	int pixels = imageSize.height * [bitmap bytesPerRow];
	unsigned char *bitmapData = [bitmap bitmapData];
	int samplesPerPixel = [bitmap samplesPerPixel];
	
	NSDate *start = [NSDate date];

#if __MAC_OS_X_VERSION_MIN_REQUIRED >= 1060 // libdispatch is only available on Mac OS X 10.6 or later.
	int stride = [bitmap bytesPerRow] / samplesPerPixel;
	dispatch_apply(pixels / samplesPerPixel / stride,
				   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
				   ^(size_t i){
					   size_t j = i * samplesPerPixel * stride;
					   size_t jStop = j + samplesPerPixel * stride;
					   
					   do {
						   tint_pixel_rgb(bitmapData, j, matrix);
						   
						   j += samplesPerPixel;
					   } while (j < jStop);
				   });
#else
	for (int i = 0; i < pixels; i = i + samplesPerPixel) {
		tint_pixel_rgb(bitmapData, i, matrix);
	}
#endif

	NSImage *image = [[NSImage alloc] initWithSize:[bitmap size]];
	[image addRepresentation:bitmap];
		
	NSTimeInterval elapsedSeconds = -[start timeIntervalSinceNow];
	NSLog(@"Elapsed time: %.2f ms", elapsedSeconds * 1000);
	
	return image;
}

- (NSImage *)grayscaleImage
{
	return [self tintWithMatrix:TBITintMatrixGrayscale];
}

- (NSImage *)sepiaImage
{
	return [self tintWithMatrix:TBITintMatrixSepia];
}

- (NSImage *)bluetoneImage
{
	return [self tintWithMatrix:TBITintMatrixBluetone];
}

@end
