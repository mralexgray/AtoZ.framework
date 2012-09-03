
//  NSImage+AtoZ.h
//  AtoZ

//  Created by Alex Gray on 7/2/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.


#import <Cocoa/Cocoa.h>

static inline int get_bit(unsigned char *arr, unsigned long bit_num)
{
	return ( arr[(bit_num/8)] & (1 << (bit_num%8)) );
}



typedef enum {
    AGImageResizeCrop,
    AGImageResizeCropStart,
    AGImageResizeCropEnd,
    AGImageResizeScale
} AGImageResizingMethod;

@interface NSImage (AtoZ)

- (NSImage*) maskWithColor:(NSColor*)c;

- (NSImage *)scaleImageToFillSize:(NSSize)targetSize;
- (NSImage*)  coloredWithColor:(NSColor*)inColor;
- (NSImage*)  coloredWithColor:(NSColor*)inColor composite:(NSCompositingOperation)comp;


+ (id) imageWithFileName:(NSString *)fileName inBundle:(NSBundle *)aBundle;
+ (id) imageWithFileName:(NSString *) fileName inBundleForClass:(Class) aClass;
+ (id) imageInFrameworkWithFileName:(NSString *) fileName;



+ (NSImage *)swatchWithColor:(NSColor *)color size:(NSSize)size;
+ (NSImage *)swatchWithGradientColor:(NSColor *)color size:(NSSize)size;

- (NSImage*) resizeWhenScaledImage;
+ (NSImage *) prettyGradientImage;  // Generates a 256 by 256 pixel image with a complicated gradient in it.
- (NSArray*) quantize;

// draws the passed image into the passed rect, centered and scaled appropriately.
// note that this method doesn't know anything about the current focus, so the focus must be locked outside this method
- (void)drawCenteredinRect:(NSRect)inRect operation:(NSCompositingOperation)op fraction:(float)delta;

- (NSImage *) filteredMonochromeEdge;

//- (NSImage *)tintedImage;
- (NSImage *) tintedWithColor:(NSColor *)tint ;
- (NSBitmapImageRep*) bitmap;
- (CGImageRef) cgImage;
//- (NSImage*)imageRotatedByDegrees:(CGFloat)degrees;


- (NSImage*)imageByScalingProportionallyToSize:(NSSize)targetSize;
- (NSImage*)imageByScalingProportionallyToSize:(NSSize)targetSize background:(NSColor*)bk;

- (void)drawInRect:(NSRect)dstRect operation:(NSCompositingOperation)op fraction:(float)delta method:(AGImageResizingMethod)resizeMethod;
- (NSImage*)imageToFitSize:(NSSize)size method:(AGImageResizingMethod)resizeMethod;
- (NSImage*)imageCroppedToFitSize:(NSSize)size;
- (NSImage*)imageScaledToFitSize:(NSSize)size;

- (NSImageRep*)largestRepresentation; 
- (NSSize)sizeLargestRepresentation;
- (NSImageRep*)smallestRepresentation;
- (NSSize)sizeSmallestRepresentation;

- (NSImage*)rotated:(int)angle;
- (NSRect) proportionalRectForTargetRect:(NSRect)targetRect;
- (CIImage *)toCIImage;

- (NSImage*) imageByRemovingTransparentAreasWithFinalRect: (NSRect*)outBox;
//+ (NSImage*) fromSVG:(NSString *)documentName withAlpha:(BOOL)hasAlpha;
//+ (NSImage*)imageFromCGImageRef:(CGImageRef)image;

- (NSImage*) addReflection:(CGFloat)percentage;

+ (NSArray*) systemImages;
- (void)drawEtchedInRect:(NSRect)rect;


- (NSImage *) maskedWithColor:(NSColor *)color;

/*!
 @method     
 @abstract   converting a CGImageRef to NSImage
 @discussion 
 */
+ (NSImage*)imageFromCGImageRef:(CGImageRef)image;

/*!    @abstract   converting a NSImage to CGImageRef */
- (CGImageRef)cgImageRef;

// Borrowed from Matt Legend Gemmell   A category on NSImage allowing you to get an image containing  a Quick Look preview of the file at a given path. You can specify the size,   and whether the preview should be rendered as an icon (i.e. with a document border,   drop-shadow, page-curl and file type/extension label superimposed).  If Quick Look can’t generate a preview for the specified file, You’ll be given the file’s Finder icon instead  (which is how the Quick Look panel itself behaves in Leopard).
+ (NSImage *)imageWithPreviewOfFileAtPath:(NSString *)path 
								   ofSize:(NSSize)size 
								   asIcon:(BOOL)icon;

/*!    @abstract   converting the input NSImage to a new size */
+ (NSImage *)resizedImage:(NSImage *)sourceImage 
				  newSize:(NSSize)size 
		  lockAspectRatio:(BOOL)lock // pass YES if you want to lock aspect ratio
   lockAspectRatioByWidth:(BOOL)flag; // pass YES to lock aspect ratio by width or passing NO to lock by height

/*!    @abstract   returning an cropped NSImage */
- (NSImage *)croppedImage:(CGRect)bounds;



/*!    @abstract   save image to disk*/
- (BOOL)saveImage:(NSString *)path 
		 fileName:(NSString *)name 
		 fileType:(NSBitmapImageFileType)type;

- (BOOL)saveAs:(NSString *)path;
- (NSImage *)scaleToFillSize:(NSSize)targetSize;
@end

@interface CIImage (ToNSImage)

- (NSImage *) toNSImageFromRect:(CGRect)r;
- (NSImage *) toNSImage;
- (CIImage *) rotateDegrees:(float)aDegrees;

@end

@interface NSImage (CGImageConversion)

- (NSBitmapImageRep*) bitmap;
- (CGImageRef) cgImage;

@end

@interface NSImage (Scaling)


- (NSImage *)imageByAdjustingHue:(float)hue;
- (NSImage *)imageByAdjustingHue:(float)hue saturation:(float)saturation;
- (NSImageRep *)representationOfSize:(NSSize)theSize;
- (NSImageRep *)bestRepresentationForSize:(NSSize)theSize;
- (BOOL)createRepresentationOfSize:(NSSize)newSize;
- (BOOL)shrinkToSize:(NSSize)newSize;
- (BOOL)createIconRepresentations;
- (void)removeRepresentationsLargerThanSize:(NSSize)size;
//- (BOOL)shrinkToSize:(NSSize)newSize;
- (NSImage *)duplicateOfSize:(NSSize)newSize;
@end

@interface NSImage (Trim)
-(NSRect)usedRect;
- (NSImage *)scaleImageToSize:(NSSize)newSize trim:(BOOL)trim expand:(BOOL)expand scaleUp:(BOOL)scaleUp;
@end

@interface NSImage (Average)
-(NSColor *)averageColor;
+ (NSImage*)maskImage:(NSImage *)image withMask:(NSImage *)maskImage;
@end

@interface NSImage (Icons)
+ (NSArray*) icons;
+ (NSArray*) picolStrings;
+ (NSArray*) iconStrings;
+ (NSImage*) randomIcon;

@end


@interface NSImage (GrabWindow)
//+ (NSImage *) captureScreenImageWithFrame: (NSRect) frame;

//+ (NSImage *)screenShotWithinRect:(NSRect)rect;

/*
//+ (NSImage*)imageWithWindow:(int)wid;
//+ (NSImage*)imageWithRect: (NSRect)rect inWindow:(int)wid;
+ (NSImage*)imageWithCGContextCaptureWindow: (int)wid;
+ (NSImage*)imageWithBitmapRep: (NSBitmapImageRep*)rep;
+ (NSImage *)imageWithScreenShotInRect:(NSRect)rect;
@end

@interface NSBitmapImageRep (GrabWindow)
//+ (NSBitmapImageRep*)correctBitmap: (NSBitmapImageRep*)rep;
//+ (NSBitmapImageRep*)bitmapRepFromNSImage:(NSImage*)image;
//+ (NSBitmapImageRep*)bitmapRepWithWindow:(int)wid;
//+ (NSBitmapImageRep*)bitmapRepWithRect: (NSRect)rect inWindow:(int)wid;
+ (NSBitmapImageRep*)bitmapRepWithScreenShotInRect:(NSRect)rect;
*/

+ (NSImage* ) imageBelowWindow: (NSWindow *) window ;
@end

/* utility category on NSImage used for converting
 NSImage to jfif data.  */
@interface NSImage (JFIFConversionUtils)
/* returns jpeg file interchange format encoded data for an NSImage regardless of the
 original NSImage encoding format.  compressionVlue is between 0 and 1.
 values 0.6 thru 0.7 are fine for most purposes.  */
- (NSData *)JFIFData:(float) compressionValue;
@end
