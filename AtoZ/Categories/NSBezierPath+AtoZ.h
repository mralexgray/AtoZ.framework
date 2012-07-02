//
//  GTMNSBezierPath+CGPath.h
//
//

#import <Cocoa/Cocoa.h>

@interface NSAffineTransform (UKShearing)
-(void)	shearXBy: (CGFloat)xFraction yBy: (CGFloat)yFraction;
@end

typedef enum _OSCornerTypes
{
	OSTopLeftCorner = 1,
	OSBottomLeftCorner = 2,
	OSTopRightCorner = 4,
	OSBottomRightCorner = 8
} OSCornerType;

@interface NSBezierPath (AG)


- (void)fillGradientFrom:(NSColor*)inStartColor to:(NSColor*)inEndColor angle:(float)inAngle;

+ (NSBezierPath *)bezierPathWithLeftRoundedRect:(NSRect)rect radius:(CGFloat)radius;
+ (NSBezierPath *)bezierPathWithRightRoundedRect:(NSRect)rect radius:(CGFloat)radius;

- (NSArray *)dashPattern;
- (void)setDashPattern:(NSArray *)newPattern;

- (NSRect)nonEmptyBounds;

- (NSPoint)associatedPointForElementAtIndex:(NSUInteger)anIndex;


+ (NSBezierPath *)bezierPathWithRoundedRect:(NSRect)aRect cornerRadius:(CGFloat)radius;
+ (NSBezierPath *)bezierPathWithRoundedRect:(NSRect)aRect cornerRadius:(CGFloat)radius inCorners:(OSCornerType)corners;
- (CGPathRef)quartzPath;


+ (NSBezierPath *)bezierPathWithCGPath:(CGPathRef)pathRef;
- (CGPathRef)cgPath;
///  Extract a CGPathRef from a NSBezierPath.
//  Args: 
//  Returns:
//    Converted autoreleased CGPathRef. 
//    nil if failure.

- (NSBezierPath *)pathWithStrokeWidth:(CGFloat)strokeWidth;

- (void)fillWithInnerShadow:(NSShadow *)shadow;
- (void)drawBlurWithColor:(NSColor *)color radius:(CGFloat)radius;

- (void)strokeInside;
- (void)strokeInsideWithinRect:(NSRect)clipRect;




@end

