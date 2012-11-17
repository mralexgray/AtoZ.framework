//
//  AZLayer.m
//  AtoZ
//
//  Created by Alex Gray on 10/8/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//
const NSString* zkeyP  = @"keyPath";
const NSString* zdurA  = @"duration";
const NSString* zfromV = @"fromValue";
const NSString* ztimeF = @"timingFunction";

#import "AZLayer.h"

@implementation AZLayer
- (id)initWithLayer:(id)layer	{	if(!(self = [super initWithLayer:layer])) return nil;
										[self setWithDictionary:[layer propertiesPlease]];
	return self;
}

+ (instancetype) layerAtIndex:(NSI)idx inRange:(RNG)rng unit:(CGF)unit
{
	AZLayer *z = [[self class]layer];	z.index = idx; 	z.range = rng;	z.unit  = unit;	 return z;
}


+ (id)defaultValueForKey:(NSString *)key
{
	static NSD* vals = nil;	vals = vals ?: @{ 	@"masksToBounds"	: @(YES),
												@"doubleSided"		: @(NO)		};

	return [vals.allKeys containsObject:key] ? vals[key] : [super defaultValueForKey:key];
}

-(id<CAAction>)actionForKey:(NSString *)event
{
	return [@[@"content", @"color"]containsObject:event] ? [self _makeAnimationForSomeKey:event]
													     : [super actionForKey:event];
}


+ (BOOL)needsDisplayForKey:(NSString *)key
{
	return [@[@"startAngle", @"endAngle"] containsObject:key] ?: [super needsDisplayForKey:key];
}

-(CABA*)_makeAnimationForSomeKey: (NSS*)key
{
	return [CABA propertyAnimation: @{	zkeyP	: key,
										zdurA 	: @3,
										zfromV	: self.permaPresentation[key],
										ztimeF 	: CAMEDIAEASEOUT}];

}


-(void)drawInContext:(CGContextRef)ctx {	}
/*
	// Create the path
	CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
	CGFloat radius = MIN(center.x, center.y);
	CGContextBeginPath(ctx);
	CGContextMoveToPoint(ctx, center.x, center.y);
	CGPoint p1 = CGPointMake(center.x + radius * cosf(self.startAngle), center.y + radius * sinf(self.startAngle));
	CGContextAddLineToPoint(ctx, p1.x, p1.y);
	int clockwise = self.startAngle > self.endAngle;
	CGContextAddArc(ctx, center.x, center.y, radius, self.startAngle, self.endAngle, clockwise);
	//	CGContextAddLineToPoint(ctx, center.x, center.y);
	CGContextClosePath(ctx);
	// Color it
	CGContextSetFillColorWithColor(ctx, self.fillColor.CGColor);
	CGContextSetStrokeColorWithColor(ctx, self.strokeColor.CGColor);
	CGContextSetLineWidth(ctx, self.strokeWidth);
	CGContextDrawPath(ctx, kCGPathFillStroke);
*/

@end


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
