
//  NSImage+AtoZ.h
//  AtoZ

//  Created by Alex Gray on 7/2/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.


#import <Cocoa/Cocoa.h>
#import "AtoZ.h"
//#import "AtoZUmbrella.h"
//#import "AtoZFunctions.h"
//#import "AZFile.h"


static inline int get_bit(unsigned char *arr, unsigned long bit_num);
CGImageRef 		  CreateCGImageFromData( NSData* data );
float 			  distance( NSPoint aPoint ); // Just one function to declare...

typedef enum {
	AGImageResizeCrop,
	AGImageResizeCropStart,
	AGImageResizeCropEnd,
	AGImageResizeScale
} 	AGImageResizingMethod;


@class AZFile;
@interface NSImage (AtoZ)

@property (readonly, strong) NSC *color;
@property (readonly, strong) NSA *colors;

+ (NSA*) frameworkImageNames;
+ (NSA*) frameworkImagePaths;
+ (NSA*) frameworkImages;
+ (NSA*) systemImages;
+ (NSIMG*) screenShot;
+ (NSA*) systemIcons;
- (NSIMG*) coloredWithColor:(NSC*)inColor composite:(NSCompositingOperation)comp;
+ (NSA*) icoNSCedWithColor:(NSC*)color;
+ (NSA*) icons;
+ (NSA*) picolStrings;
+ (NSA*) iconStrings;
+ (NSIMG*) randomIcon;
+ (NSA*) randomImages:(NSUI)number;

+ (NSIMG*) forFile:(AZFile*)file;

+ (void) drawInQuadrants:(NSA*)images inRect:(NSRect)frame;

+ (NSIMG*)reflectedImage:(NSIMG*)sourceImage amountReflected:(float)fraction;

//- (NSIMG*) maskedByColor:(NSC *)color;
- (NSIMG*) scaledToMax:(CGFloat)f;

	// creates a copy of the current image while maintaining
	// proportions. also centers image, if necessary

- (NSSize)proportionalSizeForTargetSize:(NSSize)aSize;

- (NSIMG*)imageByScalingProportionallyToSize:(NSSize)aSize;

- (NSIMG*)imageByScalingProportionallyToSize:(NSSize)targetSize
                                       flipped:(BOOL)isFlipped;

- (NSIMG*)imageByScalingProportionallyToSize:(NSSize)targetSize
                                       flipped:(BOOL)isFlipped
                                      addFrame:(BOOL)shouldAddFrame
                                     addShadow:(BOOL)shouldAddShadow;

- (NSIMG*)imageByScalingProportionallyToSize:(NSSize)targetSize
                                       flipped:(BOOL)isFlipped
                                      addFrame:(BOOL)shouldAddFrame
                                     addShadow:(BOOL)shouldAddShadow
                                      addSheen:(BOOL)shouldAddSheen;

- (NSIMG*)imageByFillingVisibleAlphaWithColor:(NSC*)fillColor;
- (NSIMG*)imageByConvertingToBlackAndWhite;
- (NSIMG*) maskWithColor:(NSC*)c;

+ (NSIMG*) createImageFromSubView:(NSView*) view	rect:(NSRect)rect;
+ (NSIMG*) createImageFromView:	(NSView*) view;

- (NSIMG*) scaleImageToFillSize:	(NSSize) targetSize;
- (NSIMG*) coloredWithColor:	  	(NSC*) inColor;
- (NSIMG*) coloredWithColor:		(NSC*) inColor	composite:(NSCompositingOperation)comp;


+ (NSIMG*) az_imageNamed:	  (NSS*) name;
+ (NSIMG*) imageWithFileName: (NSS*) fileName inBundle:(NSB*)aBundle;
+ (NSIMG*) imageWithFileName: (NSS*) fileName inBundleForClass:(Class) aClass;



+ (NSIMG*)swatchWithColor:(NSC *)color size:(NSSize)size;
+ (NSIMG*)swatchWithGradientColor:(NSC *)color size:(NSSize)size;

- (NSIMG*) resizeWhenScaledImage;
+ (NSIMG*) prettyGradientImage;  // Generates a 256 by 256 pixel image with a complicated gradient in it.
- (NSA*) quantize;
+ (NSIMG*) desktopImage;
- (void)openQuantizedSwatch;


- (void) drawFloatingRightInFrame:(NSRect)aFrame;  //ACG FLOATIAMGE


// draws the passed image into the passed rect, centered and scaled appropriately.
// note that this method doesn't know anything about the current focus, so the focus must be locked outside this method
- (void) drawCenteredinRect:(NSRect) inRect operation:(NSCompositingOperation)op fraction:(float)delta;
- (void) drawInRect:(NSRect)dstRect operation:(NSCompositingOperation)op
			fraction:(float)delta       method:(AGImageResizingMethod)resizeMethod;

- (NSIMG*) 	filteredMonochromeEdge;

- (NSIMG*)tintedImage;
- (NSIMG*) 	tintedWithColor:(NSC*) tint ;
- (NSBitmapImageRep*) bitmap;
- (CGImageRef) 	cgImage;
- (NSIMG*)imageRotatedByDegrees:(CGFloat)degrees;
//- (NSIMG*)imageByScalingProportionallyToSize:(NSSize)targetSize;
- (NSIMG*)	imageByScalingProportionallyToSize:(NSSize) targetSize background:(NSC*) bk;

- (NSIMG*)	imageToFitSize:(NSSize)size method:(AGImageResizingMethod)resizeMethod;
- (NSIMG*)	imageCroppedToFitSize:(NSSize)size;
- (NSIMG*)	imageScaledToFitSize:(NSSize)size;

- (NSImageRep*) largestRepresentation;
- (NSSize) 		sizeLargestRepresentation;
- (NSImageRep*) smallestRepresentation;
- (NSSize)		sizeSmallestRepresentation;

- (NSIMG*)rotated:(int)angle;
- (NSRect) proportionalRectForTargetRect:(NSRect)targetRect;
- (CIImage *)toCIImage;

- (NSIMG*) imageByRemovingTransparentAreasWithFinalRect: (NSRect*)outBox;
//+ (NSIMG*) fromSVG:(NSString *)documentName withAlpha:(BOOL)hasAlpha;
//+ (NSIMG*)imageFromCGImageRef:(CGImageRef)image;

- (NSIMG*) addReflection:(CGFloat)percentage;

- (void)drawEtchedInRect:(NSRect)rect;


- (NSIMG*) maskedWithColor:(NSC *)color;

/*!
 @method     
 @abstract   converting a CGImageRef to NSImage
 @discussion 
 */
+ (NSIMG*)imageFromCGImageRef:(CGImageRef)image;

/*!    @abstract   converting a NSImage to CGImageRef */
- (CGImageRef)cgImageRef;

// Borrowed from Matt Legend Gemmell   A category on NSImage allowing you to get an image containing  a Quick Look preview of the file at a given path. You can specify the size,   and whether the preview should be rendered as an icon (i.e. with a document border,   drop-shadow, page-curl and file type/extension label superimposed).  If Quick Look can’t generate a preview for the specified file, You’ll be given the file’s Finder icon instead  (which is how the Quick Look panel itself behaves in Leopard).
+ (NSIMG*)imageWithPreviewOfFileAtPath:(NSString *)path 
								   ofSize:(NSSize)size 
								   asIcon:(BOOL)icon;

/*!    @abstract   converting the input NSImage to a new size */
+ (NSIMG*)resizedImage:(NSIMG*)sourceImage 
				  newSize:(NSSize)size 
		  lockAspectRatio:(BOOL)lock // pass YES if you want to lock aspect ratio
   lockAspectRatioByWidth:(BOOL)flag; // pass YES to lock aspect ratio by width or passing NO to lock by height

/*!    @abstract   returning an cropped NSIMG*/
- (NSIMG*)croppedImage:(CGRect)bounds;



/*!    @abstract   save image to disk*/
- (BOOL)saveImage:(NSString *)path 
		 fileName:(NSString *)name 
		 fileType:(NSBitmapImageFileType)type;

- (BOOL)saveAs:(NSString *)path;
- (NSIMG*)scaleToFillSize:(NSSize)targetSize;
@end

@interface CIImage (ToNSImage)

- (NSIMG*) toNSImageFromRect:(CGRect)r;
- (NSIMG*) toNSImage;
- (CIImage *) rotateDegrees:(float)aDegrees;

@end

@interface NSImage (CGImageConversion)

- (NSBitmapImageRep*) bitmap;
- (CGImageRef) cgImage;

@end

@interface NSImage (AtoZScaling)


- (NSIMG*)imageByAdjustingHue:(float)hue;
- (NSIMG*)imageByAdjustingHue:(float)hue saturation:(float)saturation;
- (NSImageRep *)representationOfSize:(NSSize)theSize;
- (NSImageRep *)bestRepresentationForSize:(NSSize)theSize;
- (BOOL)createRepresentationOfSize:(NSSize)newSize;
- (BOOL)shrinkToSize:(NSSize)newSize;
- (BOOL)createIconRepresentations;
- (void)removeRepresentationsLargerThanSize:(NSSize)size;
//- (BOOL)shrinkToSize:(NSSize)newSize;
- (NSIMG*)duplicateOfSize:(NSSize)newSize;
@end

@interface NSImage (AtoZTrim)
-(NSRect)usedRect;
- (NSIMG*)scaleImageToSize:(NSSize)newSize trim:(BOOL)trim expand:(BOOL)expand scaleUp:(BOOL)scaleUp;
@end

@interface NSImage (AtoZAverage)
-(NSC *)averageColor;
+ (NSIMG*)maskImage:(NSIMG*)image withMask:(NSIMG*)maskImage;
@end
@interface NSImage (Matrix)
- (NSIMG*) addPerspectiveMatrix:(CIPerspectiveMatrix)matrix; //8PointMatrix
@end

@interface NSImage (GrabWindow)
//+ (NSIMG*) captureScreenImageWithFrame: (NSRect) frame;

//+ (NSIMG*)screenShotWithinRect:(NSRect)rect;

/*
//+ (NSIMG*)imageWithWindow:(int)wid;
//+ (NSIMG*)imageWithRect: (NSRect)rect inWindow:(int)wid;
+ (NSIMG*)imageWithCGContextCaptureWindow: (int)wid;
+ (NSIMG*)imageWithBitmapRep: (NSBitmapImageRep*)rep;
+ (NSIMG*)imageWithScreenShotInRect:(NSRect)rect;
@end

@interface NSBitmapImageRep (GrabWindow)
//+ (NSBitmapImageRep*)correctBitmap: (NSBitmapImageRep*)rep;
//+ (NSBitmapImageRep*)bitmapRepFromNSImage:(NSIMG*)image;
//+ (NSBitmapImageRep*)bitmapRepWithWindow:(int)wid;
//+ (NSBitmapImageRep*)bitmapRepWithRect: (NSRect)rect inWindow:(int)wid;
+ (NSBitmapImageRep*)bitmapRepWithScreenShotInRect:(NSRect)rect;
*/

+ (NSIMG* ) imageBelowWindow: (NSWindow *) window ;

@end

/* utility category on NSImage used for converting
 NSImage to jfif data.  */
@interface NSImage (JFIFConversionUtils)
/* returns jpeg file interchange format encoded data for an NSImage regardless of the
 original NSImage encoding format.  compressionVlue is between 0 and 1.
 values 0.6 thru 0.7 are fine for most purposes.  */
- (NSData *)JFIFData:(float) compressionValue;
@end

@interface CIFilter (Subscript)
- (id)objectForKeyedSubscript:(NSString *)key;
- (void)setObject:(id)object forKeyedSubscript:(NSString *)key;
@end
@interface CIFilter (WithDefaults)
+ (CIFilter*) filterWithDefaultsNamed: (NSString*) name;
@end


