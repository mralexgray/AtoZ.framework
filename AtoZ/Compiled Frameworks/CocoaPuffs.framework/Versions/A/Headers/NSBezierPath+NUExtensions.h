
#import <AppKit/AppKit.h>

enum {
    NURectTop = 1,
    NURectRight = 2,
    NURectBottom = 4, 
    NURectLeft = 8
};



@interface NSBezierPath (NUExtensions)


/**
 
 \brief     Creates a NSBezierPath from the sides of a rectangle.
            
 \param     in rect    the base rectangle.
 
 \param     in sides   which side to include. Should use a sum of NURectTop, 
                       NURectRight, NURectBottom and NURectLeft).
 
 \param     in flipped indicates whether the coordinate system is flipped or not.
 
 \return    a NSBezierPath with only the selected sides.
 
 */
+ (NSBezierPath*) bezierPathWithRect:(CGRect)rect andSides:(int)sides flipped:(BOOL)isFlipped;

@end
