/**
 
 \category  NSColor(NUExtensions)
 
 \brief     Adds a number of facilities to NSArray for a more functional style
 of programming. Additional properties make some statements more
 obvious.
 
 \author    Eric Methot
 \date      2012-04-10
 
 \copyright Copyright 2011 NUascent Sàrl. All rights reserved.
 
 */

#import <AppKit/AppKit.h>
#import <QuartzCore/QuartzCore.h>


@interface NSColor (NUExtensions)

/// Returns a CGColor based on the CGColorRef.
+ (NSColor*) colorWithCGColor:(CGColorRef) color;

/// Returns an equivalent CGColorRef for this NSColor.
/// Note that a given NSColor will always return the same CGColorRef.
- (CGColorRef) CGColor;

/// Returns the color with its brightness, in the HSBA model, offset by a certain amount.
/// Note that the brightness is clamped between 0 and 1.
- (NSColor*) colorWithBrightnessOffset:(CGFloat)offset;

/// Returns the color with its brightness, in the HSBA model, multiplied by a certain amount.
/// Note that the brightness is clamped between 0 and 1.
- (NSColor*) colorWithBrightnessMultiplier:(CGFloat)factor;

@end
