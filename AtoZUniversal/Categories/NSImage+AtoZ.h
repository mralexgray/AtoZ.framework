
#import "AZSizer.h"
@import Quartz;

NSIMG* AZIMGNamed(NSS *constName);

APPKIT_EXTERN NSString  *const AZIMG_checkmark,       *const AZIMG_addressBook,     *const AZIMG_paperclip,
                        *const AZIMG_checkRound,      *const AZIMG_xCircle,         *const AZIMG_off,
                        *const AZIMG_on,              *const AZIMG_lightning,       *const AZIMG_floppy,
                        *const AZIMG_folder,          *const AZIMG_globe,           *const AZIMG_jewishHand,
                        *const AZIMG_calendar,        *const AZIMG_cylinder,        *const AZIMG_document,
                        *const AZIMG_textDocument,    *const AZIMG_blinkingPlus,    *const AZIMG_blinkingMinus,
                        *const AZIMG_printer,         *const AZIMG_lock,            *const AZIMG_magnifyingGlass,
                        *const AZIMG_wavyDocument,    *const AZIMG_computerScreen,  *const AZIMG_foldedEdgeoc,
                        *const AZIMG_volume,          *const AZIMG_starFilled,      *const AZIMG_starEmpty,
                        *const AZIMG_textsymbol,      *const AZIMG_bold,            *const AZIMG_italic,
                        *const AZIMG_strikethrough,   *const AZIMG_trashcan,        *const AZIMG_tag,
                        *const AZIMG_envelope,        *const AZIMG_plus,            *const AZIMG_minus,
                        *const AZIMG_recycle,         *const AZIMG_umbrella,        *const AZIMG_XMark,
                        *const AZIMG_roundX,          *const AZIMG_roundCheck,      *const AZIMG_check,
                        *const AZIMG_safari,          *const AZIMG_pointer,         *const AZIMG_forbidden,
                        *const AZIMG_forbiddenLight,  *const AZIMG_atSymbol;

@protocol AZDynamicImages <NSO>
@optional
+ (NSIMG*) checkmark;       + (NSIMG*) addressBook;       + (NSIMG*) paperclip;
+ (NSIMG*) checkRound;      + (NSIMG*) xCircle;           + (NSIMG*) off;
+ (NSIMG*) on;              + (NSIMG*) lightning;         + (NSIMG*) floppy;
+ (NSIMG*) folder;          + (NSIMG*) globe;             + (NSIMG*) jewishHand;
+ (NSIMG*) calendar;        + (NSIMG*) cylinder;          + (NSIMG*) document;
+ (NSIMG*) textDocument;    + (NSIMG*) blinkingPlus;      + (NSIMG*) blinkingMinus;
+ (NSIMG*) printer;         + (NSIMG*) lock;              + (NSIMG*) magnifyingGlass;
+ (NSIMG*) wavyDocument;    + (NSIMG*) computerScreen;    + (NSIMG*) foldedEdgeoc;
+ (NSIMG*) volume;          + (NSIMG*) starFilled;        + (NSIMG*) starEMpty;
+ (NSIMG*) textsymbol;      + (NSIMG*) bold;              + (NSIMG*) italic;
+ (NSIMG*) strikethrough;   + (NSIMG*) trashcan;          + (NSIMG*) tag;
+ (NSIMG*) envelope;        + (NSIMG*) plus;              + (NSIMG*) minus;
+ (NSIMG*) recycle;         + (NSIMG*) umbrella;          + (NSIMG*) XMark;
+ (NSIMG*) roundX;          + (NSIMG*) roundCheck;        + (NSIMG*) check;
+ (NSIMG*) safari;          + (NSIMG*) pointer;           + (NSIMG*) forbidden;
+ (NSIMG*) forbiddenLight;  + (NSIMG*) atSymbol;
@end


_IFCE AZImageCache : NSCache	+ (AZImageCache*) sharedCache;

AZPROP(Text,cacheDirectory);

+ _Void_  	  cacheImage:(NSIMG*)image;
- _Pict_ 		 imageForKey:(NSS*)key;
- _Void_  	    setImage:(NSIMG*)image forKey:(NSS*)key;
- _Void_ removeAllObjects;													//  builklt-in method

_FINI

_S _I _SInt              get_bit ( _UChr carr, _ULng bit_num);
CGImageRef CreateCGImageFromData (    _Data data );
CGF                     distance (    _Cord aPnt );				// Just one function to declare...

typedef void(^NSImageDrawer)(void);

typedef void(^LockedFocusWithFrame)(NSR dRect);

@interface NSImage (AtoZDrawBlock)

+ (NSIMG*) imageWithSize:(NSSZ)size drawnUsingBlock:(NSImageDrawer)drawBlock;
+ (NSIMG*)  imageInFrame:(NSR)frame withBlock:(LockedFocusWithFrame)drawBlockwithFrame;	@end // (AtoZDrawBlock)

#define NSIMGNAMED(x) [NSIMG imageNamed:NSStrigify(x)] /*! [NSImage imageNamed:@"document"] */


@class AZFile;

@interface NSImage (AtoZ) <ClassKeyGet, AZDynamicImages>

@prop_RO _Data PNGRepresentation;

+ (NSIMG*) imageWithBitmapRep:(NSBIR*)rep;

+ (NSIMG*) gravatarForEmail:(NSS*)e;

+ (NSIMG *)imageFromPDF:(PDFDocument *)doc
                   page:(NSUI)page
                   size:(NSSZ)size
                  named:(NSS *)name;
+(INST)missing;

//+ objectForKeyedSubscript: k;
//@property (NATOM) CGF width, height;
@prop_RO NSAS *attributedString;

+ (NSIMG*) isometricShelfInRect:(NSR)rect;
+ (NSIMG*) imageFromLockedFocusSize:(NSSZ)sz lock:(NSIMG*(^)(NSIMG*))block;
- (NSIMG*) lockFocusBlockOut:(NSIMG*(^)(NSIMG*))block;
-   (void) lockFocusBlock:(void(^)(NSIMG*))block;
+ (NSIMG*) faviconForDomain:(NSS*)domainAsString;
+ (NSIMG*) imageWithData:(NSData*)data;
-   (NSS*)   saveToWeb;

+ (NSIMG*) glowingSphereImageWithScaleFactor:(CGF)scale coreColor:(NSC*)core glowColor:(NSC*)glow;

//+ (NSIMG*) imageFromURL:(NSS*)url;
+ (NSIMG*) randomWebImage;

+ (void) random:(void(^)(NSImage*))display;
+ (void) loadImage:(NSURL*)url andDisplay:(void(^)(NSImage* i))b;

//+ (NSIMG*) randomFunny; needs mrgray.com

+ (NSA*) randomWebImages:(NSUI)ct;
+ (NSIMG*) googleImage:(NSS*)query;

//+ (NSA*) googleImages:(NSS*)query ct:(NSUI)ct;
+ (NSIMG*) googleImages:(NSS*)query ct:(NSUI)ct eachBlock:(void(^)(NSIMG*results))block;

+ (NSIMG*) randomFunnyImage;
	
+ (NSIMG*) blackBadgeForRect:(NSR)frame;
+ (NSIMG*) badgeForRect:(NSR)frame withColor:(NSC*)color;
+ (NSIMG*) badgeForRect:(NSR)frame withColor:(NSC*)color stroked:(NSC*) stroke;
+ (NSIMG*) badgeForRect:(NSR)frame withColor:(NSC*)color stroked:(NSC*) stroke  withString:(NSS*)string;
+ (NSIMG*) badgeForRect:(NSR)frame withColor:(NSC*)color stroked:(NSC*) stroke	  withString:(NSS*)string orDrawBlock:(void(^)(NSR))drawBlock;

+ (NSIMG*) screenShot;
//+ (NSA*) iconsTintedWith:(NSC*)color;
+ (NSA*) icons;
+ (NSA*) systemIcons;
+ (NSA*) randomImages:(NSUI)count;
+ (NSA*) systemImages;

//+ (NSIMG*) monoIconNamed:(NSS*)name;
+ (NSIMG*) randomMonoIcon;
+ (NSA*)   monoIcons;
+ (NSA*)   namedMonoIcons;
+ (NSIMG*) randomIcon;
+ (NSIMG*) forFile:(AZFile*)file;

- (NSIMG*) initWithSize:(NSSZ)size named:(NSS*)name;
+ (NSIMG*) imageWithSize:(NSSZ)size named:(NSS*)name;

- (NSIMG*) initWithFile:(NSS*)file named:(NSS*)name;
+ (NSIMG*) imageWithFile:(NSS*)file named:(NSS*)name;

+ (INST) withFile:x;

+ (NSIMG*) systemIconNamed:(NSS*)name;
+ (NSIMG*) frameworkImageNamed:(NSS*)string;
+ (NSA*) frameworkImageNames;
+ (NSA*) frameworkImagePaths;
+ (NSA*) frameworkImages;
+ (NSA*) picolStrings;
//+ (NSA*) iconStrings;

- (NSIMG*) named:(NSS*)name;
- (NSIMG*) scaledToMax:(CGF)f;
- (void) draw;
- (void) drawAtPoint:(NSP)point inRect:(NSR)rect;
- (void) drawAtPoint:(NSP)point;
- (CAL*) imageLayerForRect:(NSR)rect;
- (void) drawinQuadrant: (QUAD)quad inRect:(NSR)rect;
+ (void) drawInQuadrants:	  (NSA*)images inRect:(NSR)frame;

+ (NSIMG*) imagesInQuadrants:(NSA*)images inRect:(NSR)frame;
- (NSIMG*) reflected:(float)amountFraction;
+ (NSIMG*) reflectedImage:(NSIMG*)sourceImage amountReflected:(float)fraction;

- (NSIMG*) coloredWithColor:	  	(NSC*) inColor;
- (NSIMG*) coloredWithColor:		(NSC*) inColor	composite:(NSCompositingOperation)comp;
+ (NSIMG*) az_imageNamed:	  (NSS*) name;
+ (NSIMG*) imageWithFileName: (NSS*) fileName inBundle:(NSB*)aBundle;
+ (NSIMG*) imageWithFileName: (NSS*) fileName inBundleForClass:(Class) aClass;

+ (NSIMG *)swatchWithColors:(NSA*)cs size:(NSSZ)z oriented:(AZO)o;
+ (NSIMG*) swatchWithColor:			(NSC*)color size:(NSSize)size;
+ (NSIMG*) swatchWithGradientColor: (NSC*)color size:(NSSize)size;

- (NSIMG*) resizeWhenScaledImage;
+ (NSIMG*) prettyGradientImage;  // Generates a 256 by 256 pixel image with a complicated gradient in it.

@prop_RO NSC * quantized;
@prop_RO NSBIR * quantizerRepresentation;

- (NSA*)   quantize;

+ (NSIMG*) desktopImage;
- (void) openInPreview;

@prop_RO NSS * asTempFile,

/*! htmlEncodedImg  a full, HTML tagged,base 64 image..  ready to be appended.

@code   [script eval:$(@"var img = $(\"%@\").appendTo($(\"body\"));",
        [NSIMG.randomMonoIcon scaledToMax:30].htmlEncodedImg)];

@return <img style="width:30 px; height:30 px;" src="data:image/png;base64,iVBORw0\...CYII=">
*/
  * htmlEncodedImg,

/*! dataURL  the literal url, i you just want that...
@return data:image/png;base64,iVBORw0KGgoAAAAN...JRU5ErkJggg==
*/
  * dataURL;
+ (NSIMG*) svg2png:(NSString*)inFile out:(NSString*)optionalOutFile;
/*! ∂i!!(.3)/Volumes/2T/ServiceData/AtoZ.framework/screenshots/AtoZ.Categories.NSImage+AtoZ.openQuantizedSwatch.pngƒi*/

- (void) 	  openQuantizedSwatch;
- (NSIMG*) generateQuantizedSwatch;
+ (void)   openQuantizeChartFor:(NSA*)images;

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

- (NSIMG*) inverted;
- (NSImage *)blackWhite;

- (NSIMG*) maskWithColor:(NSC*)c;

+ (NSIMG*) createImageFromSubView:(NSView*) view	rect:(NSRect)rect;
+ (NSIMG*) createImageFromView:	(NSView*) view;

//NOTE BROKEN
- (NSIMG*) scaleImageToFillSize:	(NSSize) targetSize; //
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
- (NSBitmapImageRep*) bitmapBy:(CGF)x y:(CGF)y;
- (CGImageRef) 	cgImage;
- (NSIMG*)imageRotatedByDegrees:(CGF)degrees;
//- (NSIMG*)imageByScalingProportionallyToSize:(NSSize)targetSize;
- (NSIMG*)	imageByScalingProportionallyToSize:(NSSize) targetSize background:(NSC*) bk;


// Borrowed from Matt Legend Gemmell   A category on NSImage allowing you to get an image containing  a Quick Look preview of the file at a given path. You can specify the size,   and whether the preview should be rendered as an icon (i.e. with a document border,   drop-shadow, page-curl and file type/extension label superimposed).  If Quick Look can’t generate a preview for the specified file, You’ll be given the file’s Finder icon instead  (which is how the Quick Look panel itself behaves in Leopard).
+ (NSIMG*)imageWithPreviewOfFileAtPath:(NSS*)path  ofSize:(NSSize)size asIcon:(BOOL)icon;

- (NSIMG*)	imageToFitSize:(NSSize)size method:(AGImageResizingMethod)resizeMethod;
- (NSIMG*)	imageCroppedToFitSize:(NSSize)size;
- (NSIMG*)	imageScaledToFitSize:(NSSize)size;   // PREFERRED RESIZING METHOD

- (NSImageRep*) largestRepresentation;
- (NSSize) 		sizeLargestRepresentation;
- (NSImageRep*) smallestRepresentation;
- (NSSize)		sizeSmallestRepresentation;

- (NSIMG*)rotated:(int)angle;
- (NSRect) proportionalRectForTargetRect:(NSRect)targetRect;
- (CIImage *)toCIImage;

- (NSIMG*) imageByRemovingTransparentAreasWithFinalRect: (NSRect*)outBox;
//+ (NSIMG*) fromSVG:(NSS*)documentName withAlpha:(BOOL)hasAlpha;
//+ (NSIMG*)imageFromCGImageRef:(CGImageRef)image;

- (NSIMG*) addReflection:(CGF)percentage;

- (NSIMG*) etched;
- (NSIMG*) alpha:(CGF)fraction;
- _Void_ drawEtchedInRect:(NSRect)rect;
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
- (BOOL)saveImage:(NSS*)path 
		 fileName:(NSS*)name 
		 fileType:(NSBitmapImageFileType)type;

- (BOOL)saveAs:(NSS*)path;
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
- _IsIt_ createRepresentationOfSize:(NSSize)newSize;
- _IsIt_ shrinkToSize:(NSSize)newSize;
- _IsIt_ createIconRepresentations;
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
- (id)objectForKeyedSubscript:(NSS*)key;
- _Void_ setObject: object forKeyedSubscript:(NSS*)key;
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
+ thumbnailImageWithContentsOfURL:(NSURL *)url width:(CGF)width;

@end

/*
 This category provides methods for dealing with flipped images. These should draw images correctly regardless of
 whether the current context or the current image are flipped. Unless you know what you are doing, these should be used
 in lieu of the normal  NSImage drawing/compositing methods.

 For more details, check out the related blog post at http://www.noodlesoft.com/blog/2009/02/02/understanding-flipped-coordinate-systems/
 */
/**
@interface NSImage (NoodleExtensions)
	!	@method	drawAdjustedAtPoint:fromRect:operation:fraction:
 	@abstract	Draws all or part of the image at the specified point in the current coordinate system. Unlike other methods in NSImage, this will orient the image properly in flipped coordinate systems.
 	@param		point The location in the current coordinate system at which to draw the image.
 	@param		srcRect The source rectangle specifying the portion of the image you want to draw. The coordinates of this rectangle are specified in the image's own coordinate system. If you pass in NSZeroRect, the entire image is drawn.
 	@param		op The compositing operation to use when drawing the image. See the NSCompositingOperation constants.
 	@param		delta The opacity of the image, specified as a value from 0.0 to 1.0. Specifying a value of 0.0 draws the image as fully transparent while a value of 1.0 draws the image as fully opaque. Values greater than 1.0 are interpreted as 1.0.
 	@discussion The image content is drawn at its current resolution and is not scaled unless the CTM of the current coordinate system itself contains a scaling factor. The image is otherwise positioned and oriented using the current coordinate system, except that it takes the flipped status into account, drawing right-side-up in a such a case.
	Unlike the compositeToPoint:fromRect:operation: and compositeToPoint:fromRect:operation:fraction: methods, this method checks the rectangle you pass to the srcRect parameter and makes sure it does not lie outside the image bounds.

- _Void_ drawAdjustedAtPoint:(NSPoint)aPoint fromRect:(NSRect)srcRect operation:(NSCompositingOperation)op fraction:(CGF)delta;

	!	@method	drawAdjustedInRect:fromRect:operation:fraction:
 	@abstract	Draws all or part of the image in the specified rectangle in the current coordinate system. Unlike other methods in NSImage, this will orient the image properly in flipped coordinate systems.
 	@param		dstRect The rectangle in which to draw the image, specified in the current coordinate system.
 	@param		srcRect The source rectangle specifying the portion of the image you want to draw. The coordinates of this rectangle must be specified using the image's own coordinate system. If you pass in NSZeroRect, the entire image is drawn.
 	@param		op The compositing operation to use when drawing the image. See the NSCompositingOperation constants.
 	@param		delta The opacity of the image, specified as a value from 0.0 to 1.0. Specifying a value of 0.0 draws the image as fully transparent while a value of 1.0 draws the image as fully opaque. Values greater than 1.0 are interpreted as 1.0.
 	@discussion If the srcRect and dstRect rectangles have different sizes, the source portion of the image is scaled to fit the specified destination rectangle. The image is otherwise positioned and oriented using the current coordinate system, except that it takes the flipped status into account, drawing right-side-up in a such a case.
 	Unlike the compositeToPoint:fromRect:operation: and compositeToPoint:fromRect:operation:fraction: methods, this method checks the rectangle you pass to the srcRect parameter and makes sure it does not lie outside the image bounds.
- _Void_ drawAdjustedInRect:(NSRect)dstRect fromRect:(NSRect)srcRect operation:(NSCompositingOperation)op fraction:(CGF)delta;

!	@method	unflippedImage
 	@abstract	Returns a version of the receiver but unflipped.
 	@discussion This does not actually flip the image but returns an image with the same orientation but with an unflipped coordinate system internally (isFlipped returns NO). If the image is already unflipped, this method returns self.	
- (NSImage *)unflippedImage;
@end

*/
@interface NSGraphicsContext (AtoZ)
+ (void) addNoiseToContext;
@end


@interface NSImage (ADBImageEffects)


//Returns the relative anchor point (from {0.0, 0.0} to {1.0, 1.0})
//that's equivalent to the specified image alignment constant.
+ (NSPoint) anchorForImageAlignment: (NSImageAlignment)alignment;

//Returns a rect suitable for drawing this image into,
//given the specified alignment and scaling mode. Intended
//for NSCell/NSControl subclasses.
- (NSRect) imageRectAlignedInRect: (NSRect)outerRect
                        alignment: (NSImageAlignment)alignment
                          scaling: (NSImageScaling)scaling;

//Returns a new version of the image filled with the specified color at the
//specified size, using the current image's alpha channel. The resulting image
//will be a bitmap.
//Pass NSZeroSize as the size to use the size of the original image.
//Intended for use with black-and-transparent template images,
//although it will work with any image.
- (NSImage *) imageFilledWithColor: (NSColor *)color atSize: (NSSize)targetSize;

//Returns a new version of the image masked by the specified image, at the
//specified size. The resulting image will be a bitmap.
- (NSImage *) imageMaskedByImage: (NSImage *)mask atSize: (NSSize)targetSize;

//Draw a template image filled with the specified gradient and rendered
//with the specified inner and drop shadows.
- (void) drawInRect: (NSRect)drawRect
       withGradient: (NSGradient *)fillGradient
         dropShadow: (NSShadow *)dropShadow
        innerShadow: (NSShadow *)innerShadow
     respectFlipped: (BOOL)respectContextIsFlipped;

@end

typedef enum {
	IMAGE_POSITION_LEFT = 0,
	IMAGE_POSITION_RIGHT,
	IMAGE_POSITION_LOWER_LEFT,
	IMAGE_POSITION_LOWER_RIGHT
} IMAGE_POSITION;


@interface NSImage (AIImageDrawingAdditions)

- _Void_ tileInRect:(NSRect)rect;
- (NSImage *)imageByScalingToSize:(NSSize)size;
//- (NSImage *)imageByScalingToSize:(NSSize)size DPI:(CGFloat)dpi;
- (NSImage *)imageByFadingToFraction:(CGFloat)delta;
- (NSImage *)imageByScalingToSize:(NSSize)size fraction:(CGFloat)delta;
- (NSImage *)imageByScalingForMenuItem;
- (NSImage *)imageByScalingToSize:(NSSize)size fraction:(CGFloat)delta flipImage:(BOOL)flipImage proportionally:(BOOL)proportionally allowAnimation:(BOOL)allowAnimation;
- (NSImage *)imageByFittingInSize:(NSSize)size;
- (NSImage *)imageByFittingInSize:(NSSize)size fraction:(CGFloat)delta flipImage:(BOOL)flipImage proportionally:(BOOL)proportionally allowAnimation:(BOOL)allowAnimation;
- (NSRect)drawRoundedInRect:(NSRect)rect radius:(CGFloat)radius;
- (NSRect)drawRoundedInRect:(NSRect)rect fraction:(CGFloat)inFraction radius:(CGFloat)radius;
- (NSRect)drawRoundedInRect:(NSRect)rect atSize:(NSSize)size position:(IMAGE_POSITION)position fraction:(CGFloat)inFraction radius:(CGFloat)radius;
- (NSRect)drawInRect:(NSRect)rect atSize:(NSSize)size position:(IMAGE_POSITION)position fraction:(CGFloat)inFraction;
- (NSRect)rectForDrawingInRect:(NSRect)rect atSize:(NSSize)size position:(IMAGE_POSITION)position;

@end


typedef enum {
	AIUnknownFileType = -9999,
	AITIFFFileType = NSTIFFFileType,
    AIBMPFileType = NSBMPFileType,
    AIGIFFileType = NSGIFFileType,
    AIJPEGFileType = NSJPEGFileType,
    AIPNGFileType = NSPNGFileType,
    AIJPEG2000FileType = NSJPEG2000FileType
} AIBitmapImageFileType;


@interface NSImage (AIImageAdditions)

+ (NSImage *)imageNamed:(NSString *)name forClass:(Class)inClass;
+ (NSImage *)imageNamed:(NSString *)name forClass:(Class)inClass loadLazily:(BOOL)flag;

+ (NSImage *)imageForSSL;

+ (AIBitmapImageFileType)fileTypeOfData:(NSData *)inData;
+ (NSString *)extensionForBitmapImageFileType:(AIBitmapImageFileType)inFileType;

- (NSData *)JPEGRepresentation;
- (NSData *)JPEGRepresentationWithCompressionFactor:(float)compressionFactor;
/*!
 * @brief Obtain a JPEG representation which is sufficiently compressed to have a size <= a given size in bytes
 *
 * The image will be increasingly compressed until it fits within maxByteSize. The dimensions of the image are unchanged,
 * so for best quality results, the image should be sized (via -[NSImage(AIImageDrawingAdditions) imageByScalingToSize:])
 * before calling this method.
 *
 * @param maxByteSize The maximum size in bytes
 *
 * @result An NSData JPEG representation whose length is <= maxByteSize, or nil if one could not be made.
 */
- (NSData *)JPEGRepresentationWithMaximumByteSize:(NSUInteger)maxByteSize;
- (NSData *)PNGRepresentation;
- (NSData *)GIFRepresentation;
- (NSData *)BMPRepresentation;
- (NSData *)bestRepresentationByType;
- (NSBitmapImageRep *)largestBitmapImageRep;
- (NSData *)representationWithFileType:(NSBitmapImageFileType)fileType
					   maximumFileSize:(NSUInteger)maximumSize;

/*
 * Writes Application Extension Block and modifies Graphic Control Block for a GIF image
 */
- _Void_ writeGIFExtensionBlocksInData:(NSMutableData *)data forRepresenation:(NSBitmapImageRep *)bitmap;

/*
 * Properties for a GIF image
 */
- (NSDictionary *)GIFPropertiesForRepresentation:(NSBitmapImageRep *)bitmap;

@end

//Defined in AppKit.framework
@interface NSImageCell(NSPrivateAnimationSupport)
- (BOOL)_animates;
- (void)_setAnimates:(BOOL)fp8;
- (void)_startAnimation;
- (void)_stopAnimation;
- (void)_animationTimerCallback:fp8;
@end

@interface NSImage (QuickLook)
+ (NSImage *)imageWithPreviewOfFileAtPath:(NSS*)path ofSize:(NSSZ)size asIcon:(BOOL)asIcon;
@end

@interface NSImage (Base64Encoding)
extern NSString *kXML_Base64ReferenceAttribute;
/*!	@function	+dataWithBase64EncodedString:
	@discussion	This method returns an autoreleased NSImage object.  The NSImage object is initialized with the
				contents of the Base 64 encoded string.  This is a convenience function for
				-initWithBase64EncodedString:.
	@param	inBase64String	An NSString object that contains only Base 64 encoded data representation of an image.
	@result	The NSImage object.	*/
+ (NSIMG*)imageWithBase64EncodedString:(NSS*)inBase64String;
/*!	@function	-initWithBase64EncodedString:
	@discussion	The NSImage object is initialized with the contents of the Base 64 encoded string.
				This method returns self as a convenience.
	@param	inBase64String	An NSString object that contains only Base 64 encoded image data.
	@result	This method returns self.	*/
- initWithBase64EncodedString:(NSS*)inBase64String;
/*!	@function	-base64EncodingWithFileType:
	@discussion	This method returns a Base 64 encoded string representation of the NSImage object.
	@param	inFileType	The image is first converted to this file type, then encoded in Base 64.
	@result	The base 64 encoded image data string.	*/
- (NSS*)base64EncodingWithFileType:(NSBitmapImageFileType)inFileType;
@end

@interface NSImage(ASCII)
- (NSString *)asciiArtWithWidth:(NSInteger)width height:(NSInteger)height;
@end

