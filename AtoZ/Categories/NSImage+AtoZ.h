
//  NSImage+AtoZ.h
//  AtoZ

//  Created by Alex Gray on 7/2/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
#import <Cocoa/Cocoa.h>
#import "AtoZ.h"


static inline int get_bit(unsigned char *arr, unsigned long bit_num);
CGImageRef 		  CreateCGImageFromData( NSData* data );
float 			  distance( NSPoint aPoint ); // Just one function to declare...

typedef enum {
	AGImageResizeCrop,
	AGImageResizeCropStart,
	AGImageResizeCropEnd,
	AGImageResizeScale
} 	AGImageResizingMethod;



@interface NSImage (Merge)

/*!
 @brief	Returns an image constructed by tiling a given array
 of images side-by-side or top-to-bottom.

 @param	spacingX  Spacing which will be applied horizontally between
 images, and at the left and right borders.
 @param	spacingY  Spacing which will be applied vertitally between
 images, and at the bottom and top borders.
 @param	vertically  YES to tile the given images from top
 to bottom, starting with the first image in the array at the top.
 NO to tile the given images from left to right, starting with
 the first image in the array at the left.	*/

+ (NSImage*)contactSheetWith:(NSArray*)images inFrame:(NSR)rect columns:(NSUI)cols;

+ (NSImage*)contactSheetWith:(NSArray*)images sized:(NSSZ)size spaced:(NSSZ)spacing columns:(NSUI)cols;
+ (NSImage*)contactSheetWith:(NSArray*)images sized:(NSSZ)size spaced:(NSSZ)spacing columns:(NSUI)cols withName:(BOOL)name;

+ (NSImage*)imageByTilingImages:(NSArray*)images
					   spacingX:(CGFloat)spacingY
					   spacingY:(CGFloat)spacingY
					 vertically:(BOOL)vertically ;

- (NSImage*)imageBorderedWithInset:(CGFloat)inset ;

- (NSImage*)imageBorderedWithOutset:(CGFloat)outset ;

@end

extern NSData *PNGRepresentation(NSIMG *image);

@class AZFile;
@interface NSImage (AtoZ)

- (void) lockFocusBlock:(void(^)(NSIMG*))block;

- (NSIMG*) lockFocusBlockOut:(NSIMG*(^)(NSIMG*))block;

+ (NSIMG*)faviconForDomain:(NSS*)domainAsString;

+ (NSIMG*)imageWithData:(NSData*)data;

- (NSS*) saveToWeb;

+ (NSImage*)glowingSphereImageWithScaleFactor:(CGFloat)scale coreColor:(NSC*)core glowColor:(NSC*)glow;

//@property (readonly, strong) NSC *color;
//@property (readonly, strong) NSA *colors;

+ (NSIMG*)swizzledImageNamed:(NSString *)name;

+ (NSIMG*) imageFromURL:(NSS*)url;

+ (NSIMG*) blackBadgeForRect:(NSR)frame;
+ (NSIMG*) badgeForRect:(NSR)frame withColor:(NSC*)color;
+ (NSIMG*) badgeForRect:(NSR)frame withColor:(NSC*)color      stroked:(NSC*) stroke;
+ (NSIMG*) badgeForRect:(NSR)frame withColor:(NSC*)color      stroked:(NSC*) stroke
								  withString:(NSS*)string;


+ (NSIMG*) badgeForRect:(NSR)frame withColor:(NSC*)color      stroked:(NSC*) stroke
								  withString:(NSS*)string orDrawBlock:(void(^)(NSR))drawBlock;

+ (NSA*) randomImages:(NSUI)number;
+ (NSA*) systemImages;
+ (NSIMG*) screenShot;

//+ (NSA*) iconsTintedWith:(NSC*)color;
+ (NSA*) icons;
+ (NSA*) systemIcons;

+ (NSIMG*)monoIconNamed:(NSS*)name;
+ (NSIMG*)randomMonoIcon;
+ (NSA*) monoIcons;

+ (NSIMG*) randomIcon;
+ (NSIMG*) forFile:(AZFile*)file;

- (NSIMG*) initWithSize:(NSSZ)size named:(NSS*)name;
+ (NSIMG*) imageWithSize:(NSSZ)size named:(NSS*)name;
- (NSIMG*) initWithFile:(NSS*)file named:(NSS*)name;
+ (NSIMG*) imageWithFile:(NSS*)file named:(NSS*)name;


+ (NSIMG*) systemIconNamed:(NSS*)name;
+ (NSIMG*) frameworkImageNamed:(NSS*)string;
+ (NSA*) frameworkImageNames;
+ (NSA*) frameworkImagePaths;
+ (NSA*) frameworkImages;

+ (NSA*) picolStrings;
//+ (NSA*) iconStrings;

- (NSIMG*) scaledToMax:(CGFloat)f;
- (void) draw;
- (void) drawAtPoint:(NSP)point inRect:(NSR)rect;
- (void) drawAtPoint:(NSP)point;
- (CAL*) imageLayerForRect:(NSR)rect;
- (void) drawinQuadrant: (QUAD)quad inRect:(NSR)rect;
+ (void) drawInQuadrants:(NSA*)images inRect:(NSRect)frame;
+ (NSIMG*) imagesInQuadrants:(NSA*)images inRect:(NSR)frame;

- (NSImage *) reflected:(float)amountFraction;
+ (NSIMG*) reflectedImage:(NSIMG*)sourceImage amountReflected:(float)fraction;

- (NSIMG*) coloredWithColor:	  	(NSC*) inColor;
- (NSIMG*) coloredWithColor:		(NSC*) inColor	composite:(NSCompositingOperation)comp;
+ (NSIMG*) az_imageNamed:	  (NSS*) name;
+ (NSIMG*) imageWithFileName: (NSS*) fileName inBundle:(NSB*)aBundle;
+ (NSIMG*) imageWithFileName: (NSS*) fileName inBundleForClass:(Class) aClass;

+ (NSIMG*) swatchWithColor:			(NSC*)color size:(NSSize)size;
+ (NSIMG*) swatchWithGradientColor: (NSC*)color size:(NSSize)size;

- (NSIMG*) resizeWhenScaledImage;
+ (NSIMG*) prettyGradientImage;  // Generates a 256 by 256 pixel image with a complicated gradient in it.
- (NSA*) quantize;
+ (NSIMG*) desktopImage;
- (void) openInPreview;
- (NSS*) asTempFile;

+ (NSIMG*) svg2png:(NSString*)inFile out:(NSString*)optionalOutFile;
- (void) openQuantizedSwatch;
- (NSIMG*) generateQuantizedSwatch;
+ (void) openQuantizeChartFor:(NSA*)images;

//- (NSIMG*) maskedByColor:(NSC *)color;

	// creates a copy of the current image while maintaining
	// proportions. also centers image, if necessary

- (NSSize)proportionalSizeForTargetSize:(NSSize)aSize;
- (NSIMG*)imageByScalingProportionallyToSize:(NSSize)aSize;
- (NSIMG*)imageByScalingProportionallyToSize:(NSSize)targetSize	 flipped:(BOOL)isFlipped;
- (NSIMG*)imageByScalingProportionallyToSize:(NSSize)targetSize	 flipped:(BOOL)isFlipped
									addFrame:(BOOL)shouldAddFrame addShadow:(BOOL)shouldAddShadow;
- (NSIMG*)imageByScalingProportionallyToSize:(NSSize)targetSize	 flipped:(BOOL)isFlipped
									addFrame:(BOOL)shouldAddFrame addShadow:(BOOL)shouldAddShadow
																   addSheen:(BOOL)shouldAddSheen;
- (NSIMG*) imageByFillingVisibleAlphaWithColor:(NSC*)fillColor;
- (NSIMG*) imageByConvertingToBlackAndWhite;
- (NSIMG*) maskWithColor:(NSC*)c;

+ (NSIMG*) createImageFromSubView:(NSView*) view	rect:(NSRect)rect;
+ (NSIMG*) createImageFromView:	(NSView*) view;

- (NSIMG*) scaleImageToFillSize:	(NSSize) targetSize;
- (void) drawFloatingRightInFrame:(NSRect)aFrame;  //ACG FLOATIAMGE
// draws the passed image into the passed rect, centered and scaled appropriately.
// note that this method doesn't know anything about the current focus, so the focus must be locked outside this method
- (void) drawCenteredinRect:(NSRect) inRect operation:(NSCompositingOperation)op fraction:(float)delta;
- (void) drawInRect:(NSRect)dstRect operation:(NSCompositingOperation)op
			fraction:(float)delta	   method:(AGImageResizingMethod)resizeMethod;

- (NSIMG*) 	filteredMonochromeEdge;

- (NSIMG*)tintedImage;
- (NSIMG*) 	tintedWithColor:(NSC*) tint ;
- (NSBitmapImageRep*) bitmap;
- (CGImageRef) 	cgImage;
- (NSIMG*)imageRotatedByDegrees:(CGFloat)degrees;
//- (NSIMG*)imageByScalingProportionallyToSize:(NSSize)targetSize;
- (NSIMG*)	imageByScalingProportionallyToSize:(NSSize) targetSize background:(NSC*) bk;


// Borrowed from Matt Legend Gemmell   A category on NSImage allowing you to get an image containing  a Quick Look preview of the file at a given path. You can specify the size,   and whether the preview should be rendered as an icon (i.e. with a document border,   drop-shadow, page-curl and file type/extension label superimposed).  If Quick Look can’t generate a preview for the specified file, You’ll be given the file’s Finder icon instead  (which is how the Quick Look panel itself behaves in Leopard).
+ (NSIMG*)imageWithPreviewOfFileAtPath:(NSString *)path  ofSize:(NSSize)size asIcon:(BOOL)icon;

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

- (NSIMG*) etched;
- (NSIMG*) alpha:(CGF)fraction;
- (void)drawEtchedInRect:(NSRect)rect;
- (NSIMG*) maskedWithColor:(NSC *)color;

/*!
 @method	 
 @abstract   converting a CGImageRef to NSImage	*/
+ (NSIMG*)imageFromCGImageRef:(CGImageRef)image;
- (CGImageRef)cgImageRef;


/*!	@abstract   converting the input NSImage to a new size */
+ (NSIMG*)resizedImage:(NSIMG*)sourceImage 
				  newSize:(NSSize)size 
		  lockAspectRatio:(BOOL)lock // pass YES if you want to lock aspect ratio
   lockAspectRatioByWidth:(BOOL)flag; // pass YES to lock aspect ratio by width or passing NO to lock by height

/*!	@abstract   returning an cropped NSIMG*/
- (NSIMG*)croppedImage:(CGRect)bounds;

/*!	@abstract   save image to disk*/
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
- (NSIMG*) imageByAdjustingHue:(float)hue;
- (NSIMG*) imageByAdjustingHue:(float)hue saturation:(float)saturation;
- (NSImageRep*) representationOfSize:(NSSize)theSize;
- (NSImageRep*) bestRepresentationForSize:(NSSize)theSize;
- (BOOL) createRepresentationOfSize:(NSSize)newSize;
- (BOOL) shrinkToSize:(NSSize)newSize;
- (BOOL) createIconRepresentations;
- (void) removeRepresentationsLargerThanSize:(NSSize)size;
//- (BOOL)shrinkToSize:(NSSize)newSize;
- (NSIMG*)duplicateOfSize:(NSSize)newSize;
@end

@interface NSImage (AtoZTrim)
- (NSRect) usedRect;
- (NSIMG*) scaleImageToSize:(NSSize)newSize trim:(BOOL)trim expand:(BOOL)expand scaleUp:(BOOL)scaleUp;
@end

@interface NSImage (AtoZAverage)
-(NSC*) averageColor;
+ (NSIMG*) maskImage:(NSIMG*)image withMask:(NSIMG*)maskImage;
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


@interface NSImageView (AtoZ)
+(NSIV*)imageViewWithImage:(NSIMG*)img ;
+(void) addImageViewWithImage:(NSIMG*)img toView:(NSV*)v;
@end

/*	Abstract: A category on NSImage to create a thumbnail sized NSImage from an image URL.
 	Version: 1.0 */

@interface NSImage (ImageThumbnailExtensions)

/* 	Create an NSImage from with the contents of the url of the specified width.
 	The height of the resulting NSImage maintains the proportions in source.
 	NSImage loads image data from files lazily.
 	This method forces the file to be read to create a small sized version.
 	This can be a useful thing to do as a background operation.	*/
+ (id)thumbnailImageWithContentsOfURL:(NSURL *)url width:(CGFloat)width;

@end

/*
 This category provides methods for dealing with flipped images. These should draw images correctly regardless of
 whether the current context or the current image are flipped. Unless you know what you are doing, these should be used
 in lieu of the normal  NSImage drawing/compositing methods.

 For more details, check out the related blog post at http://www.noodlesoft.com/blog/2009/02/02/understanding-flipped-coordinate-systems/
 */

@interface NSImage (NoodleExtensions)

/*!	@method	drawAdjustedAtPoint:fromRect:operation:fraction:
 	@abstract	Draws all or part of the image at the specified point in the current coordinate system. Unlike other methods in NSImage, this will orient the image properly in flipped coordinate systems.
 	@param		point The location in the current coordinate system at which to draw the image.
 	@param		srcRect The source rectangle specifying the portion of the image you want to draw. The coordinates of this rectangle are specified in the image's own coordinate system. If you pass in NSZeroRect, the entire image is drawn.
 	@param	    op The compositing operation to use when drawing the image. See the NSCompositingOperation constants.
 	@param		delta The opacity of the image, specified as a value from 0.0 to 1.0. Specifying a value of 0.0 draws the image as fully transparent while a value of 1.0 draws the image as fully opaque. Values greater than 1.0 are interpreted as 1.0.
 	@discussion The image content is drawn at its current resolution and is not scaled unless the CTM of the current coordinate system itself contains a scaling factor. The image is otherwise positioned and oriented using the current coordinate system, except that it takes the flipped status into account, drawing right-side-up in a such a case.
	Unlike the compositeToPoint:fromRect:operation: and compositeToPoint:fromRect:operation:fraction: methods, this method checks the rectangle you pass to the srcRect parameter and makes sure it does not lie outside the image bounds.	*/
- (void)drawAdjustedAtPoint:(NSPoint)aPoint fromRect:(NSRect)srcRect operation:(NSCompositingOperation)op fraction:(CGFloat)delta;

/*!	@method	drawAdjustedInRect:fromRect:operation:fraction:
 	@abstract	Draws all or part of the image in the specified rectangle in the current coordinate system. Unlike other methods in NSImage, this will orient the image properly in flipped coordinate systems.
 	@param		dstRect The rectangle in which to draw the image, specified in the current coordinate system.
 	@param		srcRect The source rectangle specifying the portion of the image you want to draw. The coordinates of this rectangle must be specified using the image's own coordinate system. If you pass in NSZeroRect, the entire image is drawn.
 	@param		op The compositing operation to use when drawing the image. See the NSCompositingOperation constants.
 	@param		delta The opacity of the image, specified as a value from 0.0 to 1.0. Specifying a value of 0.0 draws the image as fully transparent while a value of 1.0 draws the image as fully opaque. Values greater than 1.0 are interpreted as 1.0.
 	@discussion If the srcRect and dstRect rectangles have different sizes, the source portion of the image is scaled to fit the specified destination rectangle. The image is otherwise positioned and oriented using the current coordinate system, except that it takes the flipped status into account, drawing right-side-up in a such a case.
 	Unlike the compositeToPoint:fromRect:operation: and compositeToPoint:fromRect:operation:fraction: methods, this method checks the rectangle you pass to the srcRect parameter and makes sure it does not lie outside the image bounds.	*/
- (void)drawAdjustedInRect:(NSRect)dstRect fromRect:(NSRect)srcRect operation:(NSCompositingOperation)op fraction:(CGFloat)delta;

/*!	@method	unflippedImage
 	@abstract	Returns a version of the receiver but unflipped.
 	@discussion This does not actually flip the image but returns an image with the same orientation but with an unflipped coordinate system internally (isFlipped returns NO). If the image is already unflipped, this method returns self.	*/
- (NSImage *)unflippedImage;
@end

