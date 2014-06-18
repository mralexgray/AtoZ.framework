
#import "AtoZUmbrella.h"

@interface NSShadow (AtoZ)
+ (NSShadow*)shadowWithOffset:(NSSize)offset blurRadius:(CGFloat)radius color:(NSColor *)shadowColor ;
- (id)initWithColor:(NSColor *)color offset:(NSSize)offset blurRadius:(CGFloat)blur;
+ (void)setShadowWithOffset:(NSSize)offset blurRadius:(CGFloat)radius
					  color:(NSColor *)shadowColor;
+ (void)clearShadow;
@end


@interface NSShadow (ADBShadowExtensions)

//Returns an autoreleased shadow initialized with the default settings
//(0 radius, 0 offset, 33% opaque black).
+ (id) shadow;

//Returns an autoreleased shadow initialized with the specified radius and offset,
//and the default color (33% opaque black).
+ (id) shadowWithBlurRadius: (CGFloat)blurRadius
                     offset: (NSSize)offset;

//Returns an autoreleased shadow initialized with the specified radius, offset and colour.
+ (id) shadowWithBlurRadius: (CGFloat)blurRadius
                     offset: (NSSize)offset
                      color: (NSColor *)color;

//Returns the specified rect, inset to accomodate the shadow's offset and blur radius.
//Intended for draw operations where one has a fixed draw region (the original rect)
//and needs to scale an object so that its shadow will fit inside that region without clipping.
- (NSRect) insetRectForShadow: (NSRect)origRect flipped: (BOOL)flipped;

//Returns the specified rect, expanded to accomodate the shadow's offset and blur radius.
//Intended for draw operations where one has a target size and position to draw an object at,
//and needs the total region that will be drawn including the shadow.
- (NSRect) expandedRectForShadow: (NSRect)origRect flipped: (BOOL)flipped;

//Returns the area that will be filled if the specified rect cast this shadow.
//If flipped is YES, the offset rect will be calculated as if it will be used
//in a flipped coordinate system.
- (NSRect) shadowedRect: (NSRect)origRect flipped: (BOOL)flipped;

//The inverse of the above: returns the rect that would be needed to produce
//a shadow in the specified area.
- (NSRect) rectToCastShadow: (NSRect)origRect flipped: (BOOL)flipped;

//The rectangle needed to draw an inner shadow in the specified area.
- (NSRect) rectToCastInnerShadow: (NSRect)origRect flipped: (BOOL)flipped;

@end
