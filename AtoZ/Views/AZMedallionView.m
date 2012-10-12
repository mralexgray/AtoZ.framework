//
//  AZMedallionView.m
//  AtoZ
//
//  Created by Alex Gray on 9/9/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "AZMedallionView.h"
#import "AtoZ.h"

@implementation AZMedallionView
#pragma mark - Properties

//@synthesize image, borderColor, borderWidth, shadowColor, shadowOffset, shadowBlur;

- (void)setImage:(NSImage *)aImage	{	_image = aImage;  [self setNeedsDisplay:YES];	}
- (void)setBorderColor:(UIColor *)aBorderColor{ _borderColor = aBorderColor; [self setNeedsDisplay:YES]; }
- (void)setBorderWidth:(CGFloat)aBorderWidth	{	_borderWidth = aBorderWidth;	[self setNeedsDisplay:YES]; }
- (void)setShadowColor:(NSColor *)aShadowColor{       _shadowColor = aShadowColor; [self setNeedsDisplay:YES]; }
- (void)setShadowOffset:(CGSize)aShadowOffset	{   _shadowOffset = aShadowOffset; [self setNeedsDisplay:YES]; }

- (void)setShadowBlur:(CGFloat)aShadowBlur { _shadowBlur = aShadowBlur;  [self setNeedsDisplay:YES]; }
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
	    self.alphaGradient = NULL;
		self.borderColor = [NSColor whiteColor];
		self.borderWidth = 5.f;
		self.shadowColor = [NSColor colorWithDeviceRed:0.25f green:0.25f blue:0.25f alpha:.85f];
		self.shadowOffset = CGSizeMake(3, 2);
		self.shadowBlur = 3.f;
		self.backgroundColor = [NSColor randomColor];
//		return [self initWithFrame:CGRectMake(0, 0, 128.f, 128.f)];
	}
    return self;
}

#pragma mark - Drawing

- (CGGradientRef)alphaGradient
{
    if (NULL == _alphaGradient) {
        CGFloat colors[6] = {1.f, 0.75f, 1.f, 0.f, 0.f, 0.f};
        CGFloat colorStops[3] = {1.f, 0.35f, 0.f};
        CGColorSpaceRef grayColorSpace = CGColorSpaceCreateDeviceGray();
        _alphaGradient = CGGradientCreateWithColorComponents(grayColorSpace, colors, colorStops, 3);
        CGColorSpaceRelease(grayColorSpace);
	}
    return _alphaGradient;
}

- (void)drawRect:(CGRect)rect
{
		// Image rect
    CGRect imageRect = CGRectMake((self.borderWidth),
                                  (self.borderWidth) ,
                                  rect.size.width - (self.borderWidth * 2),
                                  rect.size.height - (self.borderWidth * 2));

		// Start working with the mask
    CGColorSpaceRef maskColorSpaceRef = CGColorSpaceCreateDeviceGray();
    CGContextRef mainMaskContextRef = CGBitmapContextCreate(NULL,
															rect.size.width,
															rect.size.height,
															8,
															rect.size.width,
															maskColorSpaceRef,
															0);
    CGContextRef shineMaskContextRef = CGBitmapContextCreate(NULL,
                                                             rect.size.width,
                                                             rect.size.height,
                                                             8,
                                                             rect.size.width,
                                                             maskColorSpaceRef,
                                                             0);
    CGColorSpaceRelease(maskColorSpaceRef);
    CGContextSetFillColorWithColor(mainMaskContextRef, [UIColor blackColor].CGColor);
    CGContextSetFillColorWithColor(shineMaskContextRef, [UIColor blackColor].CGColor);
    CGContextFillRect(mainMaskContextRef, rect);
    CGContextFillRect(shineMaskContextRef, rect);
    CGContextSetFillColorWithColor(mainMaskContextRef, [UIColor whiteColor].CGColor);
    CGContextSetFillColorWithColor(shineMaskContextRef, [UIColor whiteColor].CGColor);

		// Create main mask shape
    CGContextMoveToPoint(mainMaskContextRef, 0, 0);
    CGContextAddEllipseInRect(mainMaskContextRef, imageRect);
    CGContextFillPath(mainMaskContextRef);
		// Create shine mask shape
    CGContextTranslateCTM(shineMaskContextRef, -(rect.size.width / 4), rect.size.height / 4 * 3);
    CGContextRotateCTM(shineMaskContextRef, -45.f);
    CGContextMoveToPoint(shineMaskContextRef, 0, 0);
    CGContextFillRect(shineMaskContextRef, CGRectMake(0,
                                                      0,
                                                      rect.size.width / 8 * 5,
                                                      rect.size.height));

    CGImageRef mainMaskImageRef = CGBitmapContextCreateImage(mainMaskContextRef);
    CGImageRef shineMaskImageRef = CGBitmapContextCreateImage(shineMaskContextRef);
    CGContextRelease(mainMaskContextRef);
    CGContextRelease(shineMaskContextRef);
		// Done with mask context
    CGContextRef contextRef =	[[NSGraphicsContext currentContext]graphicsPort];
//; UIGraphicsGetCurrentContext();
    CGContextSaveGState(contextRef);

    CGImageRef imageRef = CGImageCreateWithMask([_image cgImage], mainMaskImageRef);

    CGContextTranslateCTM(contextRef, 0, rect.size.height);
    CGContextScaleCTM(contextRef, 1.0, -1.0);

    CGContextSaveGState(contextRef);

		// Draw image
    CGContextDrawImage(contextRef, rect, imageRef);

    CGContextRestoreGState(contextRef);
    CGContextSaveGState(contextRef);

		// Clip to shine's mask
    CGContextClipToMask(contextRef, self.bounds, mainMaskImageRef);
    CGContextClipToMask(contextRef, self.bounds, shineMaskImageRef);
    CGContextSetBlendMode(contextRef, kCGBlendModeLighten);
    CGContextDrawLinearGradient(contextRef, [self alphaGradient], CGPointMake(0, 0), CGPointMake(0, self.bounds.size.height), 0);

    CGImageRelease(mainMaskImageRef);
    CGImageRelease(shineMaskImageRef);
    CGImageRelease(imageRef);
		// Done with image

    CGContextRestoreGState(contextRef);

    CGContextSetLineWidth(contextRef, self.borderWidth);
    CGContextSetStrokeColorWithColor(contextRef, self.borderColor.CGColor);
    CGContextMoveToPoint(contextRef, 0, 0);
    CGContextAddEllipseInRect(contextRef, imageRect);
		// Drop shadow
    CGContextSetShadowWithColor(contextRef,
                                self.shadowOffset,
                                self.shadowBlur,
                                self.shadowColor.CGColor);
    CGContextStrokePath(contextRef);
    CGContextRestoreGState(contextRef);
}

@end
