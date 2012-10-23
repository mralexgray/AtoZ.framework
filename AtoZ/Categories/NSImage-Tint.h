//
//  NSImage-Tint.h
//  ImageTinter
//
//  Created by Mikael Hallendal on 2009-10-11.
//  Copyright 2009 Mikael Hallendal. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@interface NSImage (Transform)

/*!
 @brief    Rotates an image around its center by a given
 angle in degrees and returns the new image.

 @details  The width and height of the returned image are,
 respectively, the height and width of the receiver.

 I have not yet tested this with a non-square image.

 Consider another way to draw images rotated:

 CGContextRotateCTM(UIGraphicsGetCurrentContext(), M_PI / 2.0);
 [img drawAtPoint...];
 --
 David Duncan
 Apple DTS Animation and Printing
 */
- (NSImage*)imageRotatedByDegrees:(CGFloat)degrees ;

@end


@interface NSImage (Merge)

/*!
 @brief    Returns an image constructed by tiling a given array
 of images side-by-side or top-to-bottom.

 @param    spacingX  Spacing which will be applied horizontally between
 images, and at the left and right borders.
 @param    spacingY  Spacing which will be applied vertitally between
 images, and at the bottom and top borders.
 @param    vertically  YES to tile the given images from top
 to bottom, starting with the first image in the array at the top.
 NO to tile the given images from left to right, starting with
 the first image in the array at the left.
 */
+ (NSImage*)imageByTilingImages:(NSArray*)images
					   spacingX:(CGFloat)spacingY
					   spacingY:(CGFloat)spacingY
					 vertically:(BOOL)vertically ;

- (NSImage*)imageBorderedWithInset:(CGFloat)inset ;

- (NSImage*)imageBorderedWithOutset:(CGFloat)outset ;

@end


// Helper method for creating unique image identifiers
#define BBlockImageIdentifier(fmt, ...) [NSString stringWithFormat:(@"%@%@" fmt), \
NSStringFromClass([self class]), NSStringFromSelector(_cmd), ##__VA_ARGS__]

@interface NSImage(BBlock)

/** Returns a `NSImage` rendered with the drawing code in the block.
 This method does not cache the image object. */
+ (NSImage *)imageForSize:(NSSize)size withDrawingBlock:(void(^)())drawingBlock;

/** Returns a cached `NSImage` rendered with the drawing code in the block.
 The `NSImage` is cached in an `NSCache` with the identifier provided. */
+ (NSImage *)imageWithIdentifier:(NSString *)identifier forSize:(NSSize)size andDrawingBlock:(void(^)())drawingBlock;

@end

@interface NSImage (Tint)

// Matrix should be a "flattened" 3x3 matrix (m11, m12, m13, m21, m22, m23, m31, m32, m33)
// The matrix will be multiplied with the RGB values 1x3 matrix to calculate the tinted RGB values

// That means the new values will be calculated as follows:
// newRed = m11 * oldRed + m12 * oldGreen + m13 * oldBlue
// newGreen = m21 * oldRed + m22 * oldGreen + m23 * oldBlue
// newBlue = m31 * oldRed + m32 * oldGreen + m33 * oldBlue

- (NSImage *)tintWithMatrix:(const CGFloat *)matrix;

- (NSImage *)grayscaleImage;
- (NSImage *)sepiaImage;
- (NSImage *)bluetoneImage;

@end
