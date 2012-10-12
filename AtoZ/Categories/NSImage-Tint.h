//
//  NSImage-Tint.h
//  ImageTinter
//
//  Created by Mikael Hallendal on 2009-10-11.
//  Copyright 2009 Mikael Hallendal. All rights reserved.
//

#import <Cocoa/Cocoa.h>

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
