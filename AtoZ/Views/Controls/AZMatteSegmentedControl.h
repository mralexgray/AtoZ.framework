//
//  AZMatteSegmentedControl.h
//  Ingredients
//
//  Created by Alex Gordon on 27/02/2010.
//  Written in 2010 by Fileability.
//



@interface AZMatteSegmentedControl : NSSegmentedControl {

}

+ (NSBezierPath *)roundedBezierInRect:(NSRect)rect radius:(float)radius hasLeft:(BOOL)hasLeft hasRight:(BOOL)hasRight;

@end
