//
//  NSImage-Tint.h
//  ImageTinter
//
//  Created by Mikael Hallendal on 2009-10-11.
//  Copyright 2009 Mikael Hallendal. All rights reserved.
//

#import <Cocoa/Cocoa.h>

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
