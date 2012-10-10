//
//  AZLayer.m
//  AtoZ
//
//  Created by Alex Gray on 10/8/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "AZLayer.h"

@implementation AZLayer
@synthesize orient, front, back, iconL, labelL, index, string, image, stringToDraw, font, flipped, hovered, selected;

+ (id)defaultValueForKey:(NSString *)key	{

	return 	[key isEqualToString:@"masksToBounds"	] ? @YES
		:	[key isEqualToString:@"doubleSided"		] ? @NO
		: 	[super defaultValueForKey:key];
}

/*
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {

	if ([layer.name contains:@"back"] ) {
		NSBezierPath*  k = [NSBezierPath bezierPathWithRect:[self bounds]];
		NSColor*	main = (NSColor*)[_object valueForKey:@"color"];
		[k fillGradientFrom:main.muchDarker to:main.brighter angle:270];// to:[(NSColor*)
	}else {

		NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString: desc.firstLetter attributes:@{ NSFontAttributeName: [NSFont fontWithName:@"Ubuntu Mono Bold" size:190],
															  NSForegroundColorAttributeName :WHITE} ];
			[theStyle setLineSpacing:12];
			NSTextView *atv = [[NSTextView alloc]initWithFrame:NSInsetRect([self bounds],3,3)];
			[atv setDefaultParagraphStyle:theStyle];
			[atv setBackgroundColor:CLEAR];
			[[atv textStorage] setForegroundColor:BLACK];
			[[atv textStorage] setAttributedString:string];
		[NSShadow setShadowWithOffset:AZSizeFromDimension(3) blurRadius:10 color:c.contrastingForegroundColor];
		[string drawAtPoint:NSMakePoint(10,8)]; main.contrastingForegroundColor
		NSLog(@"didnt dfraw in context");
	}
	[NSGraphicsContext restoreGraphicsState];

}
	NSImage* i = [_object valueForKey:@"image"];
	[i drawInRect:[self bounds] fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
	drawRepresentation:[i bestRepresentationForSize:AZSizeFromDimension(256)] inRect:[self bounds]];
	drawCenteredinRect:[self bounds] operation:NSCompositeSourceOver fraction:1];
	CGContextAddPath(ctx, [k quartzPath]);   CGContextFillPath(ctx);
	NSBezierPath *k = [NSBezierPath bezierPathWithRect:[self bounds]];
	[self.object valueForKey:@"color"] brighter] angle:270];
	[NSGraphicsContext restoreGraphicsState];

- (void) setImage:(NSImage*)image
 {
 if (_iconL) 			[_iconL removeFromSuperlayer];
 //	_image 					= [image imageScaledToFitSize:AZSizeFromDimension(256)];
 self.iconL 				= ReturnImageLayer(	self, image.copy, 1);//kCALayerNotSizable
 //	_iconL.contentsGravity	= kCAGravityResizeAspect;
 //	[_iconL addConstraintsSuperSizeScaled:.4];
 }
*/
@end
