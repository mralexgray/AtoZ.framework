//
//  NSShadow+AtoZ.m
//  AtoZ
//
//  Created by Alex Gray on 7/7/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "NSShadow+AtoZ.h"

@implementation NSShadow (AtoZ)

- initWithColor:(NSColor *)color offset:(NSSize)offset blurRadius:(CGFloat)blur
{
self = [self init];

if (self != nil) {
	self.shadowColor = color;
	self.shadowOffset = offset;
	self.shadowBlurRadius = blur;
}

return self;
}

+ (NSShadow*)shadowWithOffset:(NSSize)offset blurRadius:(CGFloat)radius color:(NSColor *)shadowColor {
	NSShadow *aShadow = self.new;
	[aShadow setShadowOffset:offset];
	[aShadow setShadowBlurRadius:radius];
	[aShadow setShadowColor:shadowColor];
	return aShadow;
}

+ (void)setShadowWithOffset:(NSSize)offset blurRadius:(CGFloat)radius color:(NSColor *)shadowColor
{
	NSShadow *aShadow = [self shadowWithOffset:offset blurRadius:radius color:shadowColor];
	[aShadow set];
}

+ (void)clearShadow
{
	NSShadow *aShadow = self.new;
	[aShadow set];
}
@end


@implementation NSShadow (ADBShadowExtensions)

+ shadow
{
    return self.new;
}

+ shadowWithBlurRadius: (CGFloat)blurRadius
                     offset: (NSSize)offset
{
    NSShadow *theShadow = self.new;
    theShadow.shadowBlurRadius = blurRadius;
    theShadow.shadowOffset = offset;
    return theShadow;
}

+ shadowWithBlurRadius: (CGFloat)blurRadius
                     offset: (NSSize)offset
                      color: (NSColor *)color
{
    NSShadow *theShadow = self.new;
    theShadow.shadowBlurRadius = blurRadius;
    theShadow.shadowOffset = offset;
    theShadow.shadowColor = color;
    return theShadow;
}

- (NSRect) insetRectForShadow: (NSRect)origRect flipped: (BOOL)flipped
{
    CGFloat radius  = self.shadowBlurRadius;
    NSSize offset   = self.shadowOffset;
    
    if (flipped)
        offset.height = -offset.height;
    
    NSRect insetRect = NSInsetRect(origRect, radius, radius);
    //FIXME: this is not totally correct, after offsetting we need to clip to the original rectangle.
    //But that raises questions about how we should deal with aspect ratios.
    insetRect = NSOffsetRect(insetRect, -offset.width, -offset.height);
    
    return insetRect;
}

- (NSRect) expandedRectForShadow: (NSRect)origRect flipped: (BOOL)flipped
{
    NSRect shadowRect = [self shadowedRect: origRect flipped: flipped];
    return NSUnionRect(origRect, shadowRect);
}

- (NSRect) shadowedRect: (NSRect)origRect flipped: (BOOL)flipped
{
    CGFloat radius  = self.shadowBlurRadius;
    NSSize offset   = self.shadowOffset;
    
    if (flipped)
        offset.height = -offset.height;
    
    NSRect shadowRect = NSInsetRect(origRect, -radius, -radius);
    return NSOffsetRect(shadowRect, offset.width, offset.height);
}

- (NSRect) rectToCastShadow: (NSRect)origRect flipped: (BOOL)flipped
{
    CGFloat radius  = self.shadowBlurRadius;
    NSSize offset   = self.shadowOffset;
    
    if (flipped)
        offset.height = -offset.height;
    
    NSRect shadowRect = NSInsetRect(origRect, radius, radius);
    return NSOffsetRect(shadowRect, -offset.width, -offset.height);
}

- (NSRect) rectToCastInnerShadow: (NSRect)origRect flipped: (BOOL)flipped
{
    CGFloat radius  = self.shadowBlurRadius;
    NSSize offset   = self.shadowOffset;
    
    if (flipped)
        offset.height = -offset.height;
    
    NSRect shadowRect = NSInsetRect(origRect, -radius, -radius);
    return NSOffsetRect(shadowRect, -offset.width, -offset.height);
}

@end
